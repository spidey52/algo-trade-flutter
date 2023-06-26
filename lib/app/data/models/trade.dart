class Trade {
  String? sId;
  String? user;
  String? symbol;
  double buyPrice = 0;
  double quantity = 0;
  bool? reorder;
  int? buyTime;
  // String? createdAt;
  // String? updatedAt;
  int? iV;
  double? sellPrice;
  int? sellTime;

  Trade(
      {this.sId,
      this.user,
      this.symbol,
      this.buyPrice = 0,
      this.quantity = 0,
      this.reorder,
      this.buyTime,
      // this.createdAt,
      // this.updatedAt,
      this.iV,
      this.sellPrice,
      this.sellTime});

  Trade.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    symbol = json['symbol'];
    buyPrice = json['buyPrice']?.toDouble() ?? 0;
    quantity = json['quantity']?.toDouble() ?? 0;
    reorder = json['reorder'];
    buyTime = json['buyTime'];
    // createdAt = json['createdAt'];
    // updatedAt = json['updatedAt'];
    iV = json['__v'];
    sellPrice = json['sellPrice']?.toDouble();
    sellTime = json['sellTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['symbol'] = symbol;
    data['buyPrice'] = buyPrice;
    data['quantity'] = quantity;
    data['reorder'] = reorder;
    data['buyTime'] = buyTime;
    // data['createdAt'] = createdAt;
    // data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['sellPrice'] = sellPrice ?? 0.0;
    data['sellTime'] = sellTime ?? 0;
    return data;
  }

  @override
  String toString() {
    return "buyprice: $buyPrice sellPrice: $sellPrice symbol: $symbol";
  }
}
