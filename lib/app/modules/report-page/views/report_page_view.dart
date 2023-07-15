import 'package:algo_trade/app/data/models/report.models.dart';
import 'package:algo_trade/app/modules/completed/views/completed_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/report_page_controller.dart';

class ReportPageView extends GetView<ReportPageController> {
  const ReportPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReportPageView'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Obx(
              () => Text(
                'Profit Reports ( ${controller.reportResponse.length} )',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Obx(
            () => Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchReports();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.reportResponse.length,
                  itemBuilder: (_, idx) {
                    return ReportItem(
                      controller: controller,
                      idx: idx,
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ReportItem extends StatelessWidget {
  const ReportItem({
    super.key,
    required this.controller,
    required this.idx,
  });

  final ReportPageController controller;
  final int idx;

  get valueStyle {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        ReportResponse reportResponse = controller.reportResponse[idx];

        reportResponse.symbols?.sort((a, b) {
          return b.profit!.compareTo(a.profit!);
        });

        showBottomSheet(
            context: context,
            builder: (_) => Container(
                height: Get.height * 0.6,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Report Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: reportResponse.symbols?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 10),
                        itemBuilder: (_, idx) {
                          final symbol = reportResponse.symbols?[idx];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                runSpacing: 10,
                                children: [
                                  KeyValue(
                                    title: "symbol",
                                    value: "${symbol?.symbol}",
                                    valueStyle: valueStyle,
                                  ),
                                  KeyValue(
                                    title: "Total Profit",
                                    value:
                                        "\$ ${symbol?.profit?.toStringAsFixed(2)}",
                                    valueStyle: valueStyle,
                                  ),
                                  KeyValue(
                                    title: "Trade Count",
                                    value: "${symbol?.count}",
                                    valueStyle: valueStyle,
                                  ),
                                  KeyValue(
                                    title: "Total Investment",
                                    value:
                                        "\$ ${symbol?.invested?.toStringAsFixed(2)}",
                                    valueStyle: valueStyle,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            runSpacing: 10,
            children: [
              KeyValue(
                title: "Report Date",
                value: "${controller.reportResponse[idx].date}",
                valueStyle: valueStyle,
              ),
              KeyValue(
                title: "Total Profit",
                value:
                    "\$ ${controller.reportResponse[idx].totalProfit?.toStringAsFixed(2)}",
                valueStyle: valueStyle,
              ),
              KeyValue(
                title: "Trade Count",
                value: "${controller.reportResponse[idx].totalTrades}",
                valueStyle: valueStyle,
              ),
              KeyValue(
                title: "Total Investment",
                value:
                    "\$ ${controller.reportResponse[idx].totalInvested?.toStringAsFixed(2)}",
                valueStyle: valueStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
