import 'package:algo_trade/app/data/models/ticker.dart';
import 'package:algo_trade/app/modules/completed/views/completed_view.dart';
import 'package:algo_trade/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tickers_controller.dart';

class TickersView extends GetView<TickersController> {
  const TickersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TickersView'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADD_TICKER);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              Obx(() => Text(
                    "Tickers View (${controller.tickers.length})".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  )),
              Obx(
                () => Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchTickers();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 8.0),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.tickers.length,
                        itemBuilder: (context, index) {
                          return TickerItem(
                            ticker: controller.tickers[index],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class TickerItem extends StatelessWidget {
  const TickerItem({
    super.key,
    required this.ticker,
  });

  final BinanceTicker ticker;

  get titleStyle {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
    );
  }

  get valueStyle {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
    );
  }

  get buyValueStyle {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
      color: Colors.green,
    );
  }

  get sellValueStyle {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          direction: Axis.horizontal,
          runSpacing: 6,
          children: [
            KeyValue(
              title: "SYMBOL",
              value: "${ticker.symbol}",
              titleStyle: titleStyle,
              valueStyle: valueStyle,
            ),
            KeyValue(
              title: "Buy Percent",
              value: "${ticker.buyPercent} %",
              titleStyle: titleStyle,
              valueStyle: buyValueStyle,
            ),
            KeyValue(
              title: "Sell Percent",
              value: "${ticker.sellPercent} %",
              titleStyle: titleStyle,
              valueStyle: sellValueStyle,
            ),
            KeyValue(
              title: "OOMP Enabled",
              value: "${ticker.oomp}",
              titleStyle: titleStyle,
              valueStyle: valueStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.TICKER_EDIT, arguments: ticker);
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () async {
                    await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text("Delete Ticker"),
                        content: const Text(
                            "Are you sure you want to delete this ticker?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back(result: false);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Get.back(result: true);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  padding: const EdgeInsets.only(right: 0),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
