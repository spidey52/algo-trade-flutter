import 'package:algo_trade/app/data/models/ticker.dart';
import 'package:algo_trade/app/modules/completed/views/completed_view.dart';
import 'package:algo_trade/app/routes/app_pages.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:algo_trade/widgets/my_chip.dart';
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
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Tickers (${controller.tickers.length})".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchTickers();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 8.0,
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: controller.tickers.length,
                        itemBuilder: (context, index) {
                          return TickerItemV1(
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

class TickerItemV1 extends StatelessWidget {
  const TickerItemV1({
    Key? key,
    required this.ticker,
  }) : super(key: key);

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

  final BinanceTicker ticker;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.TICKER_EDIT, arguments: ticker);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${ticker.symbol} (${ticker.maxPendingOrders})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: Colors.blue,
                    ),
                  ),
                  Icon(
                    Icons.radio_button_checked,
                    color: (ticker.oomp ?? true) ? Colors.green : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                children: [
                  MyChip(
                    label: "${ticker.buyPercent?.toStringAsFixed(2)} %",
                    color: kProfitColor,
                  ),
                  MyChip(
                    label: "${ticker.sellPercent?.toStringAsFixed(2)}%",
                    color: kLossColor,
                  ),
                  MyChip(
                    label: "${ticker.amount}",
                    color: Colors.deepPurple,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // KeyValue(
              //   title: "Max Buy",
              //   titleStyle: titleStyle,
              //   valueStyle: valueStyle,
              //   value: "${ticker.maxPendingOrders}",
              // ),
            ],
          ),
        ),
      ),
    );
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
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.TICKER_EDIT, arguments: ticker);
      },
      child: Card(
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
            ],
          ),
        ),
      ),
    );
  }
}
