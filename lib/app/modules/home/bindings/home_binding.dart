import 'package:get/get.dart';

import 'package:algo_trade/app/modules/completed/controllers/completed_controller.dart';
import 'package:algo_trade/app/modules/grid-order/controllers/grid_order_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CompletedController>(() => CompletedController());
    Get.lazyPut<GridOrderController>(() => GridOrderController());
  }
}
