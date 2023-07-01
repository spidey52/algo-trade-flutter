import 'package:get/get.dart';

import '../controllers/add_ticker_controller.dart';

class AddTickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTickerController>(
      () => AddTickerController(),
    );
  }
}
