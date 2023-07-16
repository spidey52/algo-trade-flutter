import 'package:algo_trade/app/modules/completed/views/completed_view.dart';
import 'package:algo_trade/app/network/api_service.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:algo_trade/widgets/my_chip.dart';
import 'package:algo_trade/widgets/search.dart';
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
        centerTitle: true,
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
            SearchField(
              defaultValue: controller.search.value,
              onChanged: (val) {
                controller.search.value = val;
              },
            ),
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
    return Card(
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
                child: MyChip(
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
    );
  }
}
