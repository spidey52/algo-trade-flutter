import 'package:algo_trade/app/modules/completed/views/completed_view.dart';
import 'package:algo_trade/app/network/api_service.dart';
import 'package:algo_trade/main.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:algo_trade/widgets/order_chip.dart';
import 'package:algo_trade/widgets/ticker_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrdersView'),
        actions: [
          Obx(() => TickerSelector(
                value: true,
                selected: controller.search.value,
                onChanged: (val) {
                  controller.search.value = val;
                },
              )),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.changeIsBuy(true);
                    },
                    style: controller.isBuy.value == true
                        ? kActiveButtonStyle
                        : kInactiveButtonStyle,
                    child: const Text("BUY ORDERS"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // controller.changePage(e);
                      controller.changeIsBuy(false);
                    },
                    style: controller.isBuy.value == false
                        ? kActiveButtonStyle
                        : kInactiveButtonStyle,
                    child: const Text("SELL ORDERS"),
                  ),
                ],
              ),
            ),

            // SearchField(
            //   defaultValue: controller.search.value,
            //   onChanged: (val) {
            //     controller.search.value = val;
            //   },
            // ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'ORDER ITEMS ${controller.getOrders.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final symbol = controller.getOrders[0].symbol ?? "";
                        if (symbol == "") {
                          showToast("no orders for $symbol");
                          return;
                        }
                        await Get.dialog(
                          AlertDialog(
                            title: const Text("Cancel All Orders"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Are you sure you want to cancel all orders for $symbol?"),
                                Obx(
                                  () => controller.isBuy.value == true
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            const Text("create new orders?"),
                                            const SizedBox(width: 10),
                                            Switch(
                                              value: controller
                                                  .isCreateNewOrders.value,
                                              onChanged: (val) {
                                                controller.isCreateNewOrders
                                                    .value = val;
                                              },
                                            ),
                                          ],
                                        ),
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("cancel"),
                              ),
                              Obx(
                                () => TextButton(
                                  onPressed: controller.isCancelLoading.value
                                      ? null
                                      : () async {
                                          final orderIds = controller.getOrders
                                              .where((e) => e.amount != null)
                                              .map((e) => e.orderId ?? "")
                                              .toList();
                                          await controller.cancelOrder(
                                              orderIds, symbol);

                                          if (controller.isBuy.value == false &&
                                              controller.isCreateNewOrders
                                                      .value ==
                                                  true) {
                                            await controller
                                                .replaceAllSellOrders(symbol);
                                            // Get.to(() => const CompletedView());
                                          }

                                          Get.back();
                                        },
                                  child: Text(controller.isCancelLoading.value
                                      ? "Cancelling..."
                                      : "Confirm"),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        "CANCEL ALL",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                padEnds: false,
                controller: controller.pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (val) {
                  if (val == 1) {
                    controller.isBuy.value = false;
                  } else {
                    controller.isBuy.value = true;
                  }
                },
                children: [
                  OrderList(
                    controller: controller,
                  ),
                  OrderList(
                    controller: controller,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  const OrderList({
    super.key,
    required this.controller,
  });

  final OrdersController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchOrders();
      },
      child: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: controller.getOrders.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (context, index) {
                  return BinanceOrderItem(
                    order: controller.getOrders[index],
                    cancelOrder: controller.cancelOrder,
                    isCancelLoading: controller.isCancelLoading.value,
                  );
                },
              ),
      ),
    );
  }
}

class BinanceOrderItem extends StatelessWidget {
  const BinanceOrderItem({
    super.key,
    required this.order,
    required this.cancelOrder,
    required this.isCancelLoading,
  });

  final BinanceOrder order;
  final Future<void> Function(List<String> orderIds, String symbol) cancelOrder;
  final bool isCancelLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Get.defaultDialog(
          title: "Update Order",
          content: UpdateOrder(
            id: order.orderId ?? "",
            price: order.price ?? 0,
            quantity: order.amount ?? 0,
            side: order.side ?? "",
            symbol: order.symbol ?? "",
            type: "limit",
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            runSpacing: 10,
            children: [
              KeyValue(title: "Symbol", value: "${order.symbol}"),
              KeyValue(title: "Price", value: "${order.price}"),
              KeyValue(title: "Quantity", value: "${order.amount}"),
              KeyValue(title: "OrderID", value: "${order.orderId}"),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                  onTap: isCancelLoading
                      ? null
                      : () async {
                          if (order.orderId != null && order.symbol != null) {
                            await cancelOrder(
                                [order.orderId ?? ""], order.symbol ?? "");
                          } else {
                            showToast("Order id not found");
                          }
                        },
                  child: OrderChip(
                    str: isCancelLoading ? "Cancelling" : "Cancel Order",
                    color: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateOrder extends StatefulWidget {
  UpdateOrder({
    super.key,
    required this.id,
    required this.price,
    required this.quantity,
    required this.side,
    required this.symbol,
    required this.type,
  });

  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final num price;
  final num quantity;
  final String id;
  final String side;
  final String symbol;
  final String type;

  @override
  State<UpdateOrder> createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder> {
  @override
  void initState() {
    super.initState();

    widget.priceController.text = widget.price.toString();
    widget.quantityController.text = widget.quantity.toString();
  }

  Future<void> updateOrder() async {
    final price = widget.priceController.text;
    final quantity = widget.quantityController.text;

    if (price.isEmpty || quantity.isEmpty) {
      showToast("Price and Quantity cannot be empty");
      return;
    }

    try {
      final response =
          await ApiService().post("$kUpdateOrder/${widget.id}/update", {
        "price": price,
        "quantity": quantity,
        "side": widget.side,
        "symbol": widget.symbol,
        "type": widget.type,
      });

      if (response.statusCode == 200) {
        showToast("Order updated");
        Get.back();
        return;
      }

      print(response.body);
      handleApiError(response);
    } catch (e) {
      showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Update Order"),

        // TextField(
        //   controller: widget.priceController,
        //   decoration: const InputDecoration(
        //     labelText: "Price",
        //   ),
        // ),

        TickerTextField(
          controller: widget.priceController,
          label: "Price",
          keyboardType: TextInputType.number,
        ),

        TickerTextField(
          controller: widget.quantityController,
          label: "Quantity",
          keyboardType: TextInputType.number,
        ),

        ElevatedButton(
          onPressed: () async {
            await updateOrder();
          },
          child: const Text("Update"),
        )
      ],
    );
  }
}
