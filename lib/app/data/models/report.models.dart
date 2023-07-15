class ReportResponse {
  double? totalProfit;
  double? totalInvested;
  int? totalTrades;
  List<ReportSymbol>? symbols;
  String? date;

  ReportResponse(
      {this.totalProfit,
      this.totalInvested,
      this.totalTrades,
      this.symbols,
      this.date});

  ReportResponse.fromJson(Map<String, dynamic> json) {
    totalProfit = json['totalProfit'] != null
        ? double.tryParse(json['totalProfit'].toString()) ?? 0.0
        : 0.0;
    totalInvested = json['totalInvested'] != null
        ? double.tryParse(json['totalInvested'].toString()) ?? 0.0
        : 0.0;
    totalTrades = json['totalTrades'];
    if (json['symbols'] != null) {
      symbols = <ReportSymbol>[];
      json['symbols'].forEach((v) {
        symbols!.add(ReportSymbol.fromJson(v));
      });
    }
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalProfit'] = totalProfit;
    data['totalInvested'] = totalInvested;
    data['totalTrades'] = totalTrades;
    if (symbols != null) {
      data['symbols'] = symbols!.map((v) => v.toJson()).toList();
    }
    data['date'] = date;
    return data;
  }
}

class ReportSymbol {
  String? symbol;
  double? profit;
  int? count;
  double? invested;

  ReportSymbol({this.symbol, this.profit, this.count, this.invested});

  ReportSymbol.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    profit = json['profit'] != null
        ? double.tryParse(json['profit'].toString()) ?? 0.0
        : 0.0;
    count = json['count'];
    invested = json['invested'] != null
        ? double.tryParse(json['invested'].toString()) ?? 0.0
        : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['profit'] = profit;
    data['count'] = count;
    data['invested'] = invested;
    return data;
  }
}
