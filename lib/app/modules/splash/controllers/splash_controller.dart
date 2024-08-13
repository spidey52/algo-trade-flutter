import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  final TradesProvider tradesProvider = TradesProvider();

  final title = "splash screen".obs;

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.offNamed(Routes.HOME);
    });
  }

  verifyToken() async {
    try {} catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      Get.offNamed(Routes.LOGIN);
    }
  }
}
