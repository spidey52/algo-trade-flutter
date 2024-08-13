import 'dart:async';

import 'package:get/get.dart';

import 'package:algo_trade/app/data/models/grouped_pending.dart';
import 'package:algo_trade/app/network/api_service.dart';
import 'package:algo_trade/main.dart';
import 'package:algo_trade/utils/constants.dart';

class GroupedPendingTradesController extends GetxController {
  final apiProvider = ApiService();
  final priceController = Get.find<PriceController>();

  final RxList<GroupedPendingTrade> groupedPendingTrades =
      <GroupedPendingTrade>[].obs;

  final RxBool isLoading = false.obs;

  Future<void> fetchGroupedPendingTrades() async {
    isLoading.value = true;

    final response = await apiProvider.fetchGroupedPendingTrades();
    if (response.statusCode == 200) {
      groupedPendingTrades.value = (response.body['result'] as List)
          .map((e) => GroupedPendingTrade.fromJson(e))
          .toList();
    } else {
      handleApiError(response);
    }

    isLoading.value = false;
  }

  double get pnl {
    double pnl = 0;
    for (var trade in groupedPendingTrades) {
      final currentPrice = priceController.tickerStreamMap[trade.symbol]?.price;
      if (currentPrice == null) continue;
      final avgPrice = trade.avgBuyPrice ?? 0;
      final qty = trade.totalQty ?? 0;

      pnl += (currentPrice - avgPrice) * qty;
    }
    return pnl;
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroupedPendingTrades();
  }
}
