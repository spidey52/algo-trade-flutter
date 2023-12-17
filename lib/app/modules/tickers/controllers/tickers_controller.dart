import 'package:algo_trade/app/data/models/ticker.dart';
import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class TickersController extends GetxController {
  final TradesProvider _apiService = TradesProvider();

  final RxList<BinanceTicker> tickers = <BinanceTicker>[].obs;
  final RxBool isLoading = false.obs;

  fetchTickers() async {
    isLoading.value = true;
    try {
      final response = await _apiService.get(kTickerList, query: {
        "future": 'true',
        "limit": '100',
      });

      if (response.statusCode != 200) {
        Fluttertoast.showToast(msg: response.body['message']);
      }

      tickers.value = (response.body as List)
          .map((e) => BinanceTicker.fromJson(e))
          .toList();
      Fluttertoast.showToast(msg: "Tickers loaded");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchTickers();
    super.onInit();
  }
}
