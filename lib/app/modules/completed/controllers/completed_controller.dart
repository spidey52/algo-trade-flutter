import 'package:algo_trade/app/data/models/future_trade.dart';
import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedController extends GetxController {
  final _apiService = TradesProvider();
  final completedTrades = <FutureTrade>[].obs;
  final count = 0.obs;

  final TextEditingController searchController = TextEditingController();
  final search = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompletedTrades();

    searchController.addListener(() {
      search.value = searchController.text;
    });

    ever(search, (_) => fetchCompletedTrades());

    // debounce(
    //   search,
    //   (_) => fetchCompletedTrades(),
    //   time: const Duration(milliseconds: 500),
    // );
  }

  fetchCompletedTrades() async {
    final response = await _apiService.get(
      kTradeList,
      query: {
        "status": "CLOSED",
        "market": "FUTURE",
        "limit": "1000",
        "symbol": search.value
      },
    );
    if (response.statusCode == 200) {
      final data = response.body['allTrades'];
      // final count = response.body['count'];
      count.value = response.body['total'];

      print(count.value);

      final trades =
          (data as List).map((e) => FutureTrade.fromJson(e)).toList();

      completedTrades.value = trades;
    }
  }
}
