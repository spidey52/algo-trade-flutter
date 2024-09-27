import 'dart:async';

import 'package:algo_trade/app/data/models/binance_stream.dart';
import 'package:algo_trade/app/data/models/dashboard_card.dart';
import 'package:algo_trade/app/data/models/future_trade.dart';
import 'package:algo_trade/app/data/models/trade.dart';
import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/app/routes/app_pages.dart';
import 'package:algo_trade/main.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final wsUrl = Uri.parse('wss://stream.binance.com:9443/ws/!miniTicker@arr');

class HomeController extends GetxController {
  final box = GetStorage();
  final count = 0.obs;
  final isLoading = false.obs;
  final market = 'FUTURE'.obs;

  final dashboardCard = DashboardCard().obs;
  final tickerStreamMap = <String, BinanceStream>{}.obs;

  // profit view
  final profitLoading = false.obs;

  // pie chart view
  final pieLoading = false.obs;
  final pieData = <ProfitReportBySymbol>[].obs;

  final trades = <Trade>[].obs;

  final priceController = Get.find<PriceController>();

  final TextEditingController searchController = TextEditingController();
  final search = "".obs;

  late TradesProvider tradesProvider;

  Future<void> uploadFcmToken() async {
    try {
      await tradesProvider.post(kFcmTokenUrl, {
        "token": firebaseToken,
      });
      Fluttertoast.showToast(msg: "token uploaded");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> fetchData() async {
    await fetchTrades();
    await fetchDashboardCard();
    await fetchProfitBySymbol();
    await priceController.fetchTickers();
  }

  @override
  void onInit() {
    super.onInit();

    tradesProvider = TradesProvider();
    uploadFcmToken();

    fetchData();

    ever(priceController.tickerStreamMap, (callback) {
      tickerStreamMap.value = callback;

      for (var element in trades) {
        if (tickerStreamMap.containsKey(element.symbol)) {
          element.ltp = tickerStreamMap[element.symbol]?.price;
        }
      }

      sortTradeByProfit();

      // print("tickerStreamMap: $tickerStreamMap");
    });

    ever(search, (callback) => fetchTrades());
    ever(count, (callback) {
      if (count.value == 0) fetchData();
    });
  }

  void sortTradeByProfit() {
    trades.sort((a, b) {
      if (a.ltp == null || b.ltp == null) {
        return 0;
      }

      final aProfit = ((a.ltp ?? 0) - (a.buyPrice)) * (a.quantity);
      final bProfit = ((b.ltp ?? 0) - (b.buyPrice)) * (b.quantity);

      return bProfit.compareTo(aProfit);
    });
  }

  void logout() {
    box.remove(kTokenKey);
    Get.offNamed(Routes.LOGIN);
  }

  Future<void> fetchTrades() async {
    Response response = await tradesProvider.get(kTradeList, query: {
      "market": market.value,
      "symbol": search.value,
      "limit": "1000",
      "status": "OPEN"
    });
    if (response.statusCode == 200) {
      var tradeBody = response.body['allTrades'] as List;

      if (market.value == "FUTURE") {
        trades.value = tradeBody
            .map((e) => FutureTrade.fromJson(e))
            .map(
              (e) => Trade(
                buyPrice: e.buyPrice ?? 0,
                quantity: e.quantity ?? 0,
                symbol: e.symbol,
                buyTime: e.buyTime,
                sellPrice: e.sellPrice ?? 0,
                sellTime: e.sellTime,
                ltp: tickerStreamMap[e.symbol]?.price ?? 0,
              ),
            )

            // .map((e) => Trade())
            .toList();

        sortTradeByProfit();
      } else {
        trades.value = tradeBody.map((e) => Trade.fromJson(e)).toList();
      }
    }
  }

  Future<void> fetchDashboardCard() async {
    try {
      profitLoading.value = true;
      Response response =
          await tradesProvider.getCall(kReportCard, market.value);
      if (response.statusCode != 200) {
        return;
      }

      DashboardCard data = DashboardCard.fromJson(response.body);
      dashboardCard.value = data;
    } catch (e) {
      showToast(e.toString());
    } finally {
      profitLoading.value = false;
    }
  }

  fetchProfitBySymbol() async {
    try {
      pieLoading.value = true;
      Response response =
          await tradesProvider.get("$kReportProfit/future/symbol");
      if (response.statusCode != 200) {
        return;
      }

      pieData.value = (response.body as List)
          .map((e) => ProfitReportBySymbol.fromJson(e))
          .toList();

      pieData.sort((a, b) => b.profit!.compareTo(a.profit!));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      pieLoading.value = false;
    }
  }

  get mappedPieData {
    Map<String, double> data = {};

    for (var element in pieData) {
      data[element.symbol ?? ""] = element.profit ?? 0;
    }
    return data;
  }

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  void toggleMarket() {
    if (market.value == 'FUTURE') {
      market.value = "SPOT";
    } else {
      market.value = "FUTURE";
    }
  }

  void increment() => count.value++;
}

class ProfitReportBySymbol {
  String? symbol;
  double? profit;

  ProfitReportBySymbol({this.symbol, this.profit});

  ProfitReportBySymbol.fromJson(Map<String, dynamic> json) {
    symbol = json['_id'];
    // profit = json['profit'];

    profit = json['profit'] != null
        ? double.tryParse(json['profit'].toString()) ?? 0.0
        : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['profit'] = profit;
    return data;
  }
}
