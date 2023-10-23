import 'dart:developer';

import 'package:algo_trade/utils/box.storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingController extends GetxController {
  final count = 0.obs;
  final box = GetStorage();

  final setting = false.obs;

  @override
  void onInit() {
    setting.value = MyBox.readProfitViewSetting();
    log("print this one");
    super.onInit();
  }

  void toggleProfitViewSetting(value) {
    MyBox.writeProfitViewSetting(value);
    setting.value = value;
  }
}
