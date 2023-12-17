import 'package:get/get.dart';

import '../controllers/grouped_pending_trades_controller.dart';

class GroupedPendingTradesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupedPendingTradesController>(
      () => GroupedPendingTradesController(),
    );
  }
}
