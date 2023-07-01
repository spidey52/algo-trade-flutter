import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GridOrderController extends GetxController {
  final box = GetStorage();

  final TradesProvider _apiService = TradesProvider();

  final isLoading = false.obs;
  final market = 'FUTURE'.obs;
  final side = 'BUY'.obs;

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

  final autoSuggestions = <GridOrderSuggestion>[].obs;

  final callCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    ever(autoSuggestions, (callback) {
      box.write(
        'autoSuggestions',
        autoSuggestions.map((e) => e.toJson()).toList(),
      );
    });

    debounce(symbol, (callback) => fillAutoSuggestions(),
        time: 100.milliseconds);

    List<dynamic> suggestions = box.read('autoSuggestions') ?? [];

    autoSuggestions.value =
        suggestions.map((e) => GridOrderSuggestion.fromJson(e)).toList();

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
    submit();

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

    print(response.statusCode == 200);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(msg: "order placed");
      resetForm();
    } else {
      Fluttertoast.showToast(
          msg: response.body['message'] ?? "something went wrong");
    }
  }

  fillAutoSuggestions() {
    int idx =
        autoSuggestions.indexWhere((element) => element.symbol == symbol.value);
    if (idx == -1) return;

    GridOrderSuggestion suggestion = autoSuggestions[idx];

    priceController.text = suggestion.price;
    quantityController.text = suggestion.quantity;
    countController.text = suggestion.count;
    percentageController.text = suggestion.percentage;
  }

  void submit() {
    GridOrderSuggestion suggestion = GridOrderSuggestion(
      symbol: symbol.value,
      price: price.value,
      quantity: quantity.value,
      count: count.value,
      percentage: percentage.value,
    );

    int index =
        autoSuggestions.indexWhere((element) => element.symbol == symbol.value);

    if (index != -1) {
      autoSuggestions.removeAt(index);
    }

    autoSuggestions.insert(0, suggestion);
  }
}

class GridOrderSuggestion {
  final String symbol;
  final String price;
  final String quantity;
  final String count;
  final String percentage;

  GridOrderSuggestion({
    required this.symbol,
    required this.price,
    required this.quantity,
    required this.count,
    required this.percentage,
  });

  factory GridOrderSuggestion.fromJson(Map<String, dynamic> json) {
    return GridOrderSuggestion(
      symbol: json['symbol'],
      price: json['price'],
      quantity: json['quantity'],
      count: json['count'],
      percentage: json['percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'price': price,
      'quantity': quantity,
      'count': count,
      'percentage': percentage,
    };
  }
}
