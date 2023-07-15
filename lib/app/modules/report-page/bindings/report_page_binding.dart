import 'package:get/get.dart';

import '../controllers/report_page_controller.dart';

class ReportPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportPageController>(
      () => ReportPageController(),
    );
  }
}
