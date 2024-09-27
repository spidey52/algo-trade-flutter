class FutureTrade {
  String? sId;
  String? orderId;
  String? symbol;
  num? quantity;
  num? buyPrice;
  String? buyTime;
  String? createdAt;
  String? updatedAt;
  int? iV;
  num? sellPrice;
  String? sellTime;
  String? user;

  FutureTrade(
      {this.sId,
      this.orderId,
      this.symbol,
      this.quantity,
      this.buyPrice,
      this.buyTime,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.sellPrice,
      this.sellTime,
      this.user});

  FutureTrade.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderId = json['orderId'];
    symbol = json['symbol'];
    quantity = json['quantity']?.toDouble();
    buyPrice = json['buyPrice']?.toDouble();
    buyTime = json['buyTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sellPrice = json['sellPrice']?.toDouble();
    sellTime = json['sellTime'];
    user = json['user'];
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
    data['__v'] = iV;
    data['sellPrice'] = sellPrice;
    data['sellTime'] = sellTime;
    data['user'] = user;
    return data;
  }
}
