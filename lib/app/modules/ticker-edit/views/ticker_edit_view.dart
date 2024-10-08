import 'package:algo_trade/utils/constants.dart';
import 'package:algo_trade/widgets/ticker_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ticker_edit_controller.dart';

class TickerEditView extends GetView<TickerEditController> {
  const TickerEditView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Ticker'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Get.dialog<bool>(AlertDialog(
                title: const Text("Delete Ticker"),
                content:
                    const Text("Are you sure you want to delete this ticker?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      showToast("Ticker deletion is not supported yet");
                      Get.back(result: true);
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ));
            },
            icon: const Icon(Icons.delete),
            color: Colors.red,
          ),
        ],
      ),
      body: Obx(
        () => TickerForm(
          symbolController: controller.symbolController,
          buyPercentController: controller.buyPercentController,
          sellPercentController: controller.sellPercentController,
          amountController: controller.amountController,
          openOrdersController: controller.openOrdersController,
          isLoading: controller.isLoading.value,
          strategy: controller.strategy.value,
          loopEnabled: controller.loopEnabled.value,
          robEnabled: controller.robEnabled.value,
          rosEnabled: controller.rosEnabled.value,
          onStrategyChanged: controller.onStrategyChanged,
          onLoopEnabledChanged: controller.onLoopEnabledChanged,
          onRobEnabledChanged: controller.onRobEnabledChanged,
          onRosEnabledChanged: controller.onRosEnabledChanged,
          onSave: controller.saveTicker,
        ),
      ),
    );
  }
}
