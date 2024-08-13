import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:algo_trade/app/data/models/report.models.dart';
import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/utils/constants.dart';

class ReportPageController extends GetxController {
  final TradesProvider tradesProvider = TradesProvider();

  final RxList<ReportResponse> reportResponse = <ReportResponse>[].obs;
  final daysCount = 0.obs;

  final RxString frequency = 'daily'.obs;
  final RxList<String> frequencies = ['daily', 'monthly', 'yearly'].obs;

  RxInt count = 0.obs;

  @override
  void onInit() {
    fetchReports();

    ever(reportResponse, (callback) {
      final first = DateTime.parse(reportResponse.first.date ?? "");
      final last = DateTime.parse(reportResponse.last.date ?? "");

      final totalDays = first.difference(last);
      daysCount.value = totalDays.inDays;
    });

    ever(frequency, (callback) {
      fetchReports();
    });

    super.onInit();
  }

  fetchReports() async {
    try {
      final response =
          await tradesProvider.get('$kTradeList/profit-category', query: {
        "frequency": frequency.value,
      });

      if (response.statusCode != 200) {
        Fluttertoast.showToast(msg: 'Error fetching report');
        return;
      }

      reportResponse.value = (response.body as List)
          .map((e) => ReportResponse.fromJson(e))
          .toList();

      for (var element in reportResponse) {
        element.date = element.date?.split("-").reversed.join("-");
      }

      Fluttertoast.showToast(msg: 'Report fetched successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
