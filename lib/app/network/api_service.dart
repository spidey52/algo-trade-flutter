import 'package:algo_trade/utils/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiService extends GetConnect {
  final box = GetStorage();

  get url => kApiUrl;

  Future<Response> fetchFutureOrders(String symbol) async {
    return await get("$url/orders/future", query: {
      "symbol": symbol,
    });
  }

  Future<Response> cancelOrder(List<String> orderId, String symbol) async {
    return await post("$url/orders/future/cancel", {
      "ids": orderId,
      "symbol": symbol,
    });
  }

  Future<Response> replaceAllSellOrders(String symbol) async {
    return await post("$url/orders/future/replace-all", {
      "symbol": symbol,
    });
  }

  Future<Response> fetchBalance() async {
    return await get("$url/binance/balance");
  }
}

class BinanceOrderResponse {
  List<BinanceOrder>? buy;
  List<BinanceOrder>? sell;

  BinanceOrderResponse({this.buy, this.sell});

  BinanceOrderResponse.fromJson(Map<String, dynamic> json) {
    if (json['buy'] != null) {
      buy = <BinanceOrder>[];
      json['buy'].forEach((v) {
        buy!.add(BinanceOrder.fromJson(v));
      });
    }
    if (json['sell'] != null) {
      sell = <BinanceOrder>[];
      json['sell'].forEach((v) {
        sell!.add(BinanceOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buy != null) {
      data['buy'] = buy!.map((v) => v.toJson()).toList();
    }
    if (sell != null) {
      data['sell'] = sell!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BinanceOrder {
  String? id;
  String? symbol;
  String? orderId;
  String? clientId;
  String? side;
  double? price;
  double? amount;

  BinanceOrder(
      {this.id,
      this.symbol,
      this.orderId,
      this.clientId,
      this.side,
      this.price,
      this.amount});

  BinanceOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    orderId = json['orderId'];
    clientId = json['clientId'];
    side = json['side'];
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : 0.0;
    amount =
        json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['symbol'] = symbol;
    data['orderId'] = orderId;
    data['clientId'] = clientId;
    data['side'] = side;
    data['price'] = price;
    data['amount'] = amount;
    return data;
  }
}
