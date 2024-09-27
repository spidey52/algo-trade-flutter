import 'package:algo_trade/app/data/models/price_listener.dart';
import 'package:algo_trade/app/modules/grid-order/views/grid_order_view.dart';
import 'package:algo_trade/main.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:algo_trade/widgets/my_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../controllers/price_listener_controller.dart';

class PriceListenerView extends GetView<PriceListenerController> {
  const PriceListenerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Listener'),
        actions: [
          IconButton(
            onPressed: () async {
              final PriceListener result =
                  await Get.dialog(PriceListenerAddDialog());

              await controller.addPriceListener(result);
            },
            icon: Obx(
              () => Icon(
                controller.isCreating.value ? Icons.refresh : Icons.add,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchListeners();
          },
          child: ListView.builder(
            itemCount: controller.listenerList.length,
            itemBuilder: (context, index) {
              final listener = controller.listenerList[index];

              return GestureDetector(
                onLongPress: () async {
                  // toggle active, inactive
                  await controller.toggleListener(listener);
                },
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.25,
                    openThreshold: 0.2,
                    children: [
                      SlidableAction(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        padding: const EdgeInsets.all(12.0),
                        onPressed: (context) async {
                          await controller.deleteListener(listener);
                        },
                        icon: Icons.delete,
                      )
                    ],
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${listener.symbol} (${listener.price})",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: Colors.blue,
                                ),
                              ),
                              Icon(
                                Icons.radio_button_checked,
                                color: (listener.active ?? false)
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            spacing: 8,
                            children: [
                              MyChip(
                                label:
                                    "${(listener.payload?.buyPercent ?? 0).toStringAsFixed(2)} %",
                                color: kProfitColor,
                              ),
                              MyChip(
                                label:
                                    "${(listener.payload?.sellPercent ?? 0).toStringAsFixed(2)} %",
                                color: kLossColor,
                              ),
                              MyChip(
                                label: "${listener.expression}",
                                color: Colors.deepPurpleAccent,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // KeyValue(
                          //   title: "Max Buy",
                          //   titleStyle: titleStyle,
                          //   valueStyle: valueStyle,
                          //   value: "${ticker.maxPendingOrders}",
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class PriceListenerAddDialog extends StatefulWidget {
  PriceListenerAddDialog({
    Key? key,
  }) : super(key: key);

  final TextEditingController symbolController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController buyPercentController = TextEditingController();
  final TextEditingController sellPercentController = TextEditingController();

  @override
  State<PriceListenerAddDialog> createState() => _PriceListenerAddDialogState();
}

class _PriceListenerAddDialogState extends State<PriceListenerAddDialog> {
  PriceListener payload = PriceListener();

  String expression = "GTE";
  void setExpression(String? val) {
    if (val == null) return;
    showToast(val);
    setState(() {
      expression = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Add Price Listener"),
                TickerSelector(
                    selected: "",
                    onChanged: (val) {
                      widget.symbolController.text = val;
                      widget.priceController.text = "0.0";
                      widget.buyPercentController.text = "1.0";
                      widget.sellPercentController.text = "1.0";
                    })
              ]),
              const SizedBox(height: 10),
              OutlinedTextField(
                hint: "Symbol",
                controller: widget.symbolController,
              ),
              const SizedBox(height: 10),
              OutlinedTextField(
                hint: "Price",
                controller: widget.priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 10),
              OutlinedTextField(
                hint: "Buy Percent",
                controller: widget.buyPercentController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 10),
              OutlinedTextField(
                hint: "Sell Percent",
                controller: widget.sellPercentController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  RadioMenuButton(
                      style: const ButtonStyle(),
                      value: "GTE",
                      groupValue: expression,
                      onChanged: setExpression,
                      child: const Text("GTE")),
                  RadioMenuButton(
                    value: "LTE",
                    groupValue: expression,
                    onChanged: setExpression,
                    child: const Row(
                      children: [
                        Text("LTE"),
                      ],
                    ),
                  ),
                ],
              ),

              // OutlinedTextField(

              //   hint: "Expression",
              //   controller: widget.expressionController,
              // ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final PriceListener payload = PriceListener(
                    symbol: widget.symbolController.text,
                    price: double.parse(widget.priceController.text),
                    expression: expression,
                    event: "TICKER_EDIT",
                    payload: PriceListenerPayalod(
                      buyPercent:
                          double.parse(widget.buyPercentController.text),
                      sellPercent:
                          double.parse(widget.sellPercentController.text),
                    ),
                  );

                  Get.back(result: payload);
                },
                child: const Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
