class BinanceTicker {
  String? sId;
  String? symbol;
  String? createdAt;
  String? updatedAt;
  int? iV;
  double? buyPercent;
  bool? loopEnabled;
  double? sellPercent;
  double? precision;

  BinanceTicker(
      {this.sId,
      this.symbol,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.buyPercent,
      this.loopEnabled,
      this.sellPercent,
      this.precision});

  BinanceTicker.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    symbol = json['symbol'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    buyPercent =
        json['buyPercent'] != null ? json['buyPercent'].toDouble() : 0.0;
    loopEnabled = json['loopEnabled'];
    sellPercent =
        json['sellPercent'] != null ? json['sellPercent'].toDouble() : 0.0;
    precision = json['precision'] != null ? json['precision'].toDouble() : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['symbol'] = symbol;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['buyPercent'] = buyPercent;
    data['loopEnabled'] = loopEnabled;
    data['sellPercent'] = sellPercent;
    data['precision'] = precision;
    return data;
  }
}
