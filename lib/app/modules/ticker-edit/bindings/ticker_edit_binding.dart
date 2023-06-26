import 'package:get/get.dart';

import '../controllers/ticker_edit_controller.dart';

class TickerEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TickerEditController>(
      () => TickerEditController(),
    );
  }
}
