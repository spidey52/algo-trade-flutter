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
          loopEnabled: controller.loopEnabled.value,
          openOrdersController: controller.openOrdersController,
          onLoopEnabledChanged: controller.onLoopEnabledChanged,
          onSave: controller.saveTicker,
        ),
      ),
    );
  }
}
