import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddTickerController extends GetxController {
  final TradesProvider _apiService = TradesProvider();

  TextEditingController symbolController = TextEditingController();
  TextEditingController buyPercentController = TextEditingController();
  TextEditingController sellPercentController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  RxBool loopEnabled = false.obs;

  RxBool isLoading = false.obs;

  onLoopEnabledChanged(bool value) {
    loopEnabled.value = value;
  }

  Future<void> saveTicker() async {
    try {
      isLoading.value = true;
      Response response = await _apiService.post("$kTickerList/future", {
        "symbol": symbolController.text,
        "buyPercent": buyPercentController.text,
        "sellPercent": sellPercentController.text,
        "amount": amountController.text,
        "loopEnabled": loopEnabled.value,
      });

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Ticker added successfully",
        );
        Get.back();
      } else {
        Fluttertoast.showToast(
          msg: response.body.toString(),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
