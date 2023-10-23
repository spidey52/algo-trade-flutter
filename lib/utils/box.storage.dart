import 'package:get_storage/get_storage.dart';

class MyBox {
  static const kProfitSettingKey = 'profit-setting-view';

  static final box = GetStorage();

  static writeProfitViewSetting(bool val) {
    box.write(kProfitSettingKey, val);
  }

  static readProfitViewSetting() {
    return box.read(kProfitSettingKey) == "true" ? true : false;
  }
}
