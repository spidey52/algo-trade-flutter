import 'package:algo_trade/app/data/models/ticker.dart';
import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TickerEditController extends GetxController {
  late BinanceTicker _binanceTicker;

  final TradesProvider _apiService = TradesProvider();

  TextEditingController symbolController = TextEditingController();
  TextEditingController buyPercentController = TextEditingController();
  TextEditingController sellPercentController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController openOrdersController = TextEditingController();

  RxString strategy = "AUTO_ORDER".obs; // "GRID_ORDER".obs;

  RxBool loopEnabled = false.obs;
  RxBool robEnabled = false.obs;
  RxBool rosEnabled = false.obs;

  RxBool isLoading = false.obs;

  onLoopEnabledChanged(bool value) {
    loopEnabled.value = value;
  }

  onRobEnabledChanged(bool value) {
    robEnabled.value = value;
  }

  onRosEnabledChanged(bool value) {
    rosEnabled.value = value;
  }

  onStrategyChanged(String value) {
    strategy.value = value;
  }

  Future<void> saveTicker() async {
    isLoading.value = true;

    try {
      Response response = await _apiService.patch(
        "$kTickerList/future/${_binanceTicker.sId}",
        {
          "symbol": symbolController.text,
          "buyPercent": buyPercentController.text,
          "sellPercent": sellPercentController.text,
          "amount": amountController.text,
          "loopEnabled": loopEnabled.value,
          "oomp": loopEnabled.value,
          "rob": robEnabled.value,
          "ros": rosEnabled.value,
          "strategy": strategy.value,
          "maxPendingOrders": openOrdersController.text,
        },
      );

      if (response.statusCode == 200) {
        showToast("Ticker updated");
        Get.back();
      } else {
        showToast(response.body['message']);
      }
    } catch (e) {
      showToast(e.toString());
    }

    isLoading.value = false;
  }

  @override
  void onInit() {
    if (Get.arguments != null) {
      _binanceTicker = Get.arguments as BinanceTicker;
      symbolController.text = _binanceTicker.symbol ?? "";
      buyPercentController.text = _binanceTicker.buyPercent.toString();
      sellPercentController.text = _binanceTicker.sellPercent.toString();
      amountController.text = _binanceTicker.amount.toString();
      openOrdersController.text = _binanceTicker.maxPendingOrders.toString();
      loopEnabled.value = _binanceTicker.oomp ?? false;

      strategy.value = _binanceTicker.strategy ?? "AUTO_TRADE";

      robEnabled.value = _binanceTicker.rob ?? false;
      rosEnabled.value = _binanceTicker.ros ?? false;
    }

    super.onInit();
  }
}
