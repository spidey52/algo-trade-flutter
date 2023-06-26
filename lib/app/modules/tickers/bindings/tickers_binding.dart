import 'package:get/get.dart';

import '../controllers/tickers_controller.dart';

class TickersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TickersController>(
      () => TickersController(),
    );
  }
}
