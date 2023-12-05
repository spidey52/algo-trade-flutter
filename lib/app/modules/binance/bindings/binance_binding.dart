import 'package:get/get.dart';

import '../controllers/binance_controller.dart';

class BinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BinanceController>(
      () => BinanceController(),
    );
  }
}
