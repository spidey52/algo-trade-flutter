import 'package:algo_trade/widgets/ticker_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_ticker_controller.dart';

class AddTickerView extends GetView<AddTickerController> {
  const AddTickerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddTickerView'),
        centerTitle: true,
      ),
      body: Obx(
        () => TickerForm(
          symbolController: controller.symbolController,
          buyPercentController: controller.buyPercentController,
          sellPercentController: controller.sellPercentController,
          amountController: controller.amountController,
          isLoading: controller.isLoading.value,
          strategy: controller.strategy.value,
          onStrategyChanged: controller.onStrategyChanged,
          loopEnabled: controller.loopEnabled.value,
          robEnabled: controller.robEnabled.value,
          rosEnabled: controller.rosEnabled.value,
          openOrdersController: controller.openOrdersController,
          onLoopEnabledChanged: controller.onLoopEnabledChanged,
          onRobEnabledChanged: controller.onRobEnabledChanged,
          onRosEnabledChanged: controller.onRosEnabledChanged,
          onSave: controller.saveTicker,
        ),
      ),
    );
  }
}
