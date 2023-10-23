import 'package:algo_trade/app/data/models/report.models.dart';
import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ReportPageController extends GetxController {
  final TradesProvider tradesProvider = TradesProvider();

  RxList<ReportResponse> reportResponse = <ReportResponse>[].obs;
  final daysCount = 0.obs;

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

    super.onInit();
  }

  fetchReports() async {
    try {
      final response =
          await tradesProvider.get('$kTradeList/profit-category', query: {
        "frequency": "daily",
      });

      // if (response.status != 200) {
      //   print(response.body);
      //   Fluttertoast.showToast(msg: 'Error fetching report');
      //   return;
      // }

      reportResponse.value = (response.body as List)
          .map((e) => ReportResponse.fromJson(e))
          .toList();

      Fluttertoast.showToast(msg: 'Report fetched successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
