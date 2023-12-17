class GroupedPendingTrade {
  String? symbol;
  List<Trades>? trades;
  double? avgBuyPrice;
  double? totalQty;
  double? investment;
  int? tradeCount;

  GroupedPendingTrade(
      {this.symbol,
      this.trades,
      this.avgBuyPrice,
      this.totalQty,
      this.tradeCount,
      this.investment});

  GroupedPendingTrade.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    if (json['trades'] != null) {
      trades = <Trades>[];
      json['trades'].forEach((v) {
        trades!.add(Trades.fromJson(v));
      });
    }
    // avgBuyPrice =

    tradeCount = json['tradeCount'];

    if (json['avgBuyPrice'] != null) {
      avgBuyPrice = json['avgBuyPrice']?.toDouble();
    }

    if (json['totalQty'] != null) {
      totalQty = json['totalQty']?.toDouble();
    }

    if (json['investment'] != null) {
      investment = json['investment']?.toDouble();
    }

    // if (json['avgBuyPrice'] != null) {
    //   avgBuyPrice = double.tryParse(json['avgBuyPrice'].toString());
    // }

    // if (json['totalQty'] != null) {
    //   totalQty = double.tryParse(json['totalQty'].toString());
    // }

    // if (json['investment'] != null) {
    //   investment = double.tryParse(json['investment'].toString());
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    if (trades != null) {
      data['trades'] = trades!.map((v) => v.toJson()).toList();
    }
    data['avgBuyPrice'] = avgBuyPrice;
    data['totalQty'] = totalQty;
    data['investment'] = investment;
    return data;
  }
}

class Trades {
  String? sId;
  String? orderId;
  String? symbol;
  double? quantity;
  double? buyPrice;
  String? buyTime;
  String? createdAt;
  String? updatedAt;

  Trades({
    this.sId,
    this.orderId,
    this.symbol,
    this.quantity,
    this.buyPrice,
    this.buyTime,
    this.createdAt,
    this.updatedAt,
  });

  Trades.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderId = json['orderId'];
    symbol = json['symbol'];
    // quantity = json['quantity'];

    if (json['quantity'] != null) {
      quantity = json['quantity']?.toDouble();
    }

    if (json['buyPrice'] != null) {
      buyPrice = json['buyPrice']?.toDouble();
    }

    buyTime = json['buyTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['orderId'] = orderId;
    data['symbol'] = symbol;
    data['quantity'] = quantity;
    data['buyPrice'] = buyPrice;
    data['buyTime'] = buyTime;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
