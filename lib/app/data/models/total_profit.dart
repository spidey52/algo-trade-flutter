class Profit {
  double? totalProfit = 0;
  double? todayProfit = 0;

  Profit({this.totalProfit, this.todayProfit});

  Profit.fromJson(Map<String, dynamic> json) {
    // totalProfit = json['totalProfit'] ?? 0;
    // todayProfit = json['todayProfit'] ?? 0;

    totalProfit = double.parse(json['totalProfit'].toString());
    todayProfit = double.parse(json['todayProfit'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalProfit'] = totalProfit;
    data['todayProfit'] = todayProfit;
    return data;
  }
}
