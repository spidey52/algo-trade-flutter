class BinanceStream {
  String? symbol;
  double price = 0;
  double prevPrice = 0;
  String? o;
  String? h;
  String? l;

  BinanceStream({
    this.symbol,
    this.price = 0,
    this.o,
    this.h,
    this.l,
    this.prevPrice = 0,
  });

  BinanceStream.fromJson(Map<String, dynamic> json) {
    symbol = json['s'];
    price = double.tryParse(json['c']) ?? 0;
    prevPrice = double.tryParse(json['c']) ?? 0;
    o = json['o'];
    h = json['h'];
    l = json['l'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['s'] = symbol;
    data['c'] = price;
    data['o'] = o;
    data['h'] = h;
    data['l'] = l;
    return data;
  }

  @override
  String toString() {
    return "$symbol $price";
  }
}
