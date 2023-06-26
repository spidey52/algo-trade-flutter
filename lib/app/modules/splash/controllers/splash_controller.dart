import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/app/routes/app_pages.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  final TradesProvider tradesProvider = TradesProvider();

  final title = "splash screen".obs;

  @override
  void onReady() {

    Future.delayed(const Duration(seconds: 1), () {
      Get.offNamed(Routes.HOME);
    });
  }

  verifyToken() async {
    try {
      final token = box.read(kTokenKey);

      if (token == null) {
        Get.offNamed(Routes.LOGIN);
        return;
      }

      final response = await tradesProvider.get(kTokenVerifyUrl, headers: {
        "authorization": "Bearer $token",
      });

      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: "Session expired",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );

        Get.offNamed(Routes.LOGIN);
        return;
      }

      Get.offNamed(Routes.HOME);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      Get.offNamed(Routes.LOGIN);
    }
  }
}
