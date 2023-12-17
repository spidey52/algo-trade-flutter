import 'package:algo_trade/app/modules/home/controllers/home_controller.dart';
import 'package:algo_trade/app/routes/app_pages.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfitView extends StatelessWidget {
  ProfitView({Key? key, required this.title, required this.amount})
      : super(key: key);

  // final HomeController controller = Get.put(HomeController());
  final controller = Get.find<HomeController>();

  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.REPORT_PAGE);
      },
      child: Card(
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Obx(
            () => !controller.profitLoading.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "\$ $amount",
                        style: const TextStyle(
                          color: kProfitColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: kProfitColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
