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
      ),
      body: Obx(
        () => TickerForm(
          symbolController: controller.symbolController,
          buyPercentController: controller.buyPercentController,
          sellPercentController: controller.sellPercentController,
          amountController: controller.amountController,
          isLoading: controller.isLoading.value,
          loopEnabled: controller.loopEnabled.value,
          onLoopEnabledChanged: controller.onLoopEnabledChanged,
          onSave: controller.saveTicker,
        ),
      ),
    );
  }
}
