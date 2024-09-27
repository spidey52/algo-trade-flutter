class Trade {
  String? sId;
  String? user;
  String? symbol;
  num buyPrice = 0;
  num quantity = 0;
  bool? reorder;
  String? buyTime;
  String? createdAt;
  String? updatedAt;
  num sellPrice = 0.0;
  String? sellTime;
  num? ltp;

  Trade({
    this.sId,
    this.user,
    this.symbol,
    this.buyPrice = 0,
    this.quantity = 0,
    this.reorder,
    this.buyTime,
    // this.createdAt,
    // this.updatedAt,
    this.sellPrice = 0.0,
    this.ltp,
    this.sellTime,
  });

  Trade.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    symbol = json['symbol'];
    buyPrice = json['buyPrice']?.toDouble() ?? 0;
    quantity = json['quantity']?.toDouble() ?? 0;
    reorder = json['reorder'];
    buyTime = json['buyTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sellPrice = json['sellPrice']?.toDouble() ?? 0.0;
    sellTime = json['sellTime'];
    ltp = json['ltp'];
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
    data['sellPrice'] = sellPrice;
    data['sellTime'] = sellTime ?? 0;
    return data;
  }

  @override
  String toString() {
    return "buyprice: $buyPrice sellPrice: $sellPrice symbol: $symbol";
  }
}
