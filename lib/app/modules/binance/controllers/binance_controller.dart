import 'dart:async';

import 'package:algo_trade/app/data/models/binance_balance.dart';
import 'package:algo_trade/app/network/api_service.dart';
import 'package:algo_trade/main.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:get/get.dart';

class BinanceController extends GetxController {
  final apiProvider = ApiService();
  final priceController = Get.find<PriceController>();

  final balance = BinanceBalance().obs;
  Timer? timer;

  @override
  void onInit() {
    fetchBalance();
    super.onInit();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchBalance();
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  Future<void> reload() async {
    await fetchBalance();
  }

  Future<void> fetchBalance() async {
    try {
      final response = await apiProvider.fetchBalance();
      // print(response.body);

      if (response.statusCode == 200) {
        final data = response.body;
        final result = BinanceBalance.fromJson(data);
        balance.value = result;
      } else {
        handleApiError(response);
      }
    } catch (e) {
      showToast(e.toString());
    }
  }
}
