import 'package:get/get.dart';

import '../controllers/price_listener_controller.dart';

class PriceListenerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PriceListenerController>(
      () => PriceListenerController(),
    );
  }
}
