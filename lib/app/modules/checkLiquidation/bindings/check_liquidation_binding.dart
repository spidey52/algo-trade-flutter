import 'package:get/get.dart';

import '../controllers/check_liquidation_controller.dart';

class CheckLiquidationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckLiquidationController>(
      () => CheckLiquidationController(),
    );
  }
}
