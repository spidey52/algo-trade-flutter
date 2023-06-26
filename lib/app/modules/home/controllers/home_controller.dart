import 'dart:convert';

import 'package:algo_trade/app/data/models/binance_stream.dart';
import 'package:algo_trade/app/data/models/future_trade.dart';
import 'package:algo_trade/app/data/models/total_profit.dart';
import 'package:algo_trade/app/data/models/trade.dart';
import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/app/routes/app_pages.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final wsUrl = Uri.parse('wss://stream.binance.com:9443/ws/!miniTicker@arr');

class HomeController extends GetxController {
  final box = GetStorage();

  final count = 3.obs;
  final isLoading = false.obs;
  final market = 'FUTURE'.obs;

  // profit view
  final profitLoading = false.obs;
  final todayProfit = '0'.obs;
  final totalProfit = '0'.obs;

  final trades = <Trade>[].obs;

  final tickers = <String>[].obs;

  final tickerStreamMap = <String, BinanceStream>{}.obs;

  final TextEditingController searchController = TextEditingController();
  final search = "".obs;

  late WebSocketChannel channel;
  late TradesProvider tradesProvider;

  void useStreamData(result) {
    for (var element in result) {
      String key = element.symbol ?? "";
      if (key == "") continue;
      var previous = tickerStreamMap[key];
      if (previous != null) {
        element.prevPrice = previous.price;
      }

      tickerStreamMap[key] = element;
    }
    trades.sort((a, b) {
      final astream = tickerStreamMap[a.symbol];
      final bstream = tickerStreamMap[b.symbol];

      if (astream == null || bstream == null) return 0;

      final acp = a.buyPrice * a.quantity;
      final bcp = b.buyPrice * b.quantity;

      final asp = a.quantity * astream.price;
      final bsp = b.quantity * bstream.price;

      final aprofit = asp - acp;
      final bprofit = bsp - bcp;

      final aprofitPercent = (aprofit / acp) * 100;
      final bprofirPercent = (bprofit / bcp) * 100;

      return bprofirPercent.compareTo(aprofitPercent);
    });
  }

  void reconnect() async {
    try {
      Fluttertoast.showToast(msg: "Socket Reconnecting");
      await channel.sink.close();

      channel = WebSocketChannel.connect(wsUrl);
      Fluttertoast.showToast(msg: "Socket reconnected");

      channel.stream.listen(
        (event) {
          var streamjson = jsonDecode(event) as List;
          final result = streamjson
              .where((e) => tickers.contains(e['s']))
              .map((e) => BinanceStream.fromJson(e))
              .toList();

          useStreamData(result);
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();

    ever(market, (_) {
      fetchProfit();
      fetchTrades();
    });

    // socketConnection() {
    //   Fluttertoast.showToast(msg: "Socket Connected");
    //   channel = WebSocketChannel.connect(wsUrl);
    //   return channel;
    // }

    tradesProvider = TradesProvider();

    channel = WebSocketChannel.connect(wsUrl);

    channel.stream.listen(
      (event) {
        var streamjson = jsonDecode(event) as List;
        final result = streamjson
            .where((e) => tickers.contains(e['s']))
            .map((e) => BinanceStream.fromJson(e))
            .toList();

        useStreamData(result);
      },
    );

    fetchTrades();
    fetchProfit();
    fetchTickers();

    searchController.addListener(() {
      search.value = searchController.text;
    });

    debounce(
      search,
      (callback) => {fetchTrades()},
      time: const Duration(milliseconds: 300),
    );
  }

  void logout() {
    box.remove(kTokenKey);
    Get.offNamed(Routes.LOGIN);
  }

  void fetchTrades() async {
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
            .map((e) => Trade(
                  buyPrice: e.buyPrice ?? 0,
                  sellPrice: e.sellPrice,
                  symbol: e.symbol,
                  quantity: e.quantity ?? 0,
                ))
            .toList();
      } else {
        trades.value = tradeBody.map((e) => Trade.fromJson(e)).toList();
      }
    }
  }

  void fetchTickers() async {
    try {
      Response response =
          await tradesProvider.getCall(kTickerList, market.value);
      if (response.statusCode == 200) {
        var tickerBody = response.body as List;
        tickers.value = tickerBody.map((e) => e['symbol'].toString()).toList();
      }
    } catch (e) {
      //
    }
  }

  void fetchProfit() async {
    try {
      profitLoading.value = true;
      Response response = await tradesProvider.getCall(kProfit, market.value);
      if (response.statusCode != 200) {
        return;
      }
      Profit data = Profit.fromJson(response.body);

      todayProfit.value = data.todayProfit!.toStringAsFixed(2);
      totalProfit.value = data.totalProfit!.toStringAsFixed(2);
    } catch (e) {
      // print(e.toString());
    } finally {
      profitLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close(1);
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
