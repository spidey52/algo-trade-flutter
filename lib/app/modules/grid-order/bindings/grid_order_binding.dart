import 'package:get/get.dart';

import '../controllers/grid_order_controller.dart';

class GridOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GridOrderController>(
      () => GridOrderController(),
    );
  }
}
