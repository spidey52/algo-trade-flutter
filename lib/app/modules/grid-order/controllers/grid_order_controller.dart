import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/main.dart';
import 'package:algo_trade/utils/constants.dart';

class GridOrderController extends GetxController {
  // final box = GetStorage();

  final TradesProvider _apiService = TradesProvider();
  final PriceController tickerController = Get.find<PriceController>();

  final isLoading = false.obs;
  final market = 'FUTURE'.obs;
  final side = 'BUY'.obs;

  final selectedSymbol = "".obs;

  final TextEditingController symbolController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();

  final symbol = "".obs;
  final price = "".obs;
  final quantity = "".obs;
  final count = "".obs;
  final percentage = "".obs;
  final skipOne = false.obs;

  @override
  void onInit() {
    super.onInit();

    ever(selectedSymbol, (callback) {
      if (callback == "ALL") return;
      symbolController.text = callback;

      final ticker = tickerController.getTicker(callback);
      priceController.text = ticker.price.toString();

      quantityController.text = ticker.amount.toString();
      countController.text = ticker.maxPendingOrders.toString();
      percentageController.text = ticker.buyPercent.toString();
      priceController.text = ticker.price.toString();
    });

    symbolController.addListener(() {
      symbol.value = symbolController.text;
    });

    priceController.addListener(() {
      price.value = priceController.text;
    });
    quantityController.addListener(() {
      quantity.value = quantityController.text;
    });
    countController.addListener(() {
      count.value = countController.text;
    });
    percentageController.addListener(() {
      percentage.value = percentageController.text;
    });
  }

  void resetForm() {
    symbolController.text = "";
    priceController.text = "";
    quantityController.text = "";
    countController.text = "";
    percentageController.text = "";

    symbol.value = "";
    price.value = "";
    quantity.value = "";
    count.value = "";
    percentage.value = "";
  }

  void submitRequest() async {
    if (symbol.isEmpty || price.isEmpty || quantity.isEmpty || count.isEmpty) {
      Get.snackbar(
        "Error",
        "fields cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    final body = {
      "symbol": symbol.value,
      "initialPrice": price.value,
      "skipOne": skipOne.value,
      "amount": quantity.value,
      "side": side.value,
      "count": count.value,
      "percent": percentage.value,
      "isFuture": market.value == 'FUTURE',
    };

    final response = await _apiService.post(
      kGridOrder,
      body,
    );

    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(msg: "order placed");
      resetForm();
    } else {
      Fluttertoast.showToast(
          msg: response.body['message'] ?? "something went wrong");
    }
  }

  // fillAutoSuggestions() {}
}
