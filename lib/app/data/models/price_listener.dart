class PriceListener {
  String? sId;
  String? symbol;
  num? price;
  bool? active;
  String? expression;
  String? event;
  PriceListenerPayalod? payload;
  String? createdAt;
  String? updatedAt;

  PriceListener({
    this.sId,
    this.symbol,
    this.price,
    this.active,
    this.expression,
    this.event,
    this.payload,
    this.createdAt,
    this.updatedAt,
  });

  PriceListener.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    symbol = json['symbol'];
    price = json['price'];
    active = json['active'];
    expression = json['expression'];
    event = json['event'];
    payload = json['payload'] != null
        ? PriceListenerPayalod.fromJson(json['payload'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['symbol'] = symbol;
    data['price'] = price;
    data['active'] = active;
    data['expression'] = expression;
    data['event'] = event;
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PriceListenerPayalod {
  num? buyPercent;
  num? sellPercent;
  bool? oomp;

  PriceListenerPayalod({this.buyPercent, this.sellPercent, this.oomp});

  PriceListenerPayalod.fromJson(Map<String, dynamic> json) {
    buyPercent = json['buyPercent'];
    sellPercent = json['sellPercent'];
    oomp = json['oomp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['buyPercent'] = buyPercent;
    data['sellPercent'] = sellPercent;
    data['oomp'] = oomp;
    return data;
  }
}
