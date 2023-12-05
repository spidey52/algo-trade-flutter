class DashboardCard {
  List<CardResult>? result;
  List<Reports>? reports;

  DashboardCard({this.result, this.reports});

  DashboardCard.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <CardResult>[];
      json['result'].forEach((v) {
        result!.add(CardResult.fromJson(v));
      });
    }
    if (json['reports'] != null) {
      reports = <Reports>[];
      json['reports'].forEach((v) {
        reports!.add(Reports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    if (reports != null) {
      data['reports'] = reports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CardResult {
  String? title;
  double? profit;

  CardResult({this.title, this.profit});

  CardResult.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    profit = json['profit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['profit'] = profit;
    return data;
  }
}

class Reports {
  double? today;
  double? yesterday;
  double? lastSevenDays;
  double? currentMonth;
  double? total;

  Reports(
      {this.today,
      this.yesterday,
      this.lastSevenDays,
      this.currentMonth,
      this.total});

  Reports.fromJson(Map<String, dynamic> json) {
    today = json['today'];
    yesterday = json['yesterday'];
    lastSevenDays = json['LastSevenDays'];
    currentMonth = json['currentMonth'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['today'] = today;
    data['yesterday'] = yesterday;
    data['LastSevenDays'] = lastSevenDays;
    data['currentMonth'] = currentMonth;
    data['total'] = total;
    return data;
  }
}
