import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:algo_trade/app/data/models/future_trade.dart';
import 'package:algo_trade/main.dart';

import '../controllers/completed_controller.dart';

class CompletedView extends GetView<CompletedController> {
  const CompletedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 4,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    'Trades (${controller.count})'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Obx(
                  () => TickerSelector(
                    selected: controller.search.value,
                    onChanged: (val) {
                      controller.search.value = val;
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Obx(
            () => Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchCompletedTrades();
                },
                child: ListView.builder(
                  itemCount: controller.completedTrades.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => CompletedTradeItem(
                    trade: controller.completedTrades[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompletedTradeItem extends StatelessWidget {
  const CompletedTradeItem({
    super.key,
    required this.trade,
  });

  final FutureTrade trade;

  DateTime get buyTime {
    return DateTime.parse(trade.buyTime ?? "").toLocal();
  }

  DateTime get sellTime {
    return DateTime.parse(trade.sellTime ?? "").toLocal();
  }

  double get profit {
    if (trade.buyPrice == null || trade.sellPrice == null) return 0;
    return trade.quantity! * (trade.sellPrice! - trade.buyPrice!);
  }

  double get profitPercent {
    if (trade.buyPrice == null || trade.sellPrice == null) return 0;
    return (profit / (trade.buyPrice! * trade.quantity!)) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Wrap(
          runSpacing: 10,
          children: [
            KeyValue(
              title: trade.symbol ?? "",
              value: DateFormat("dd MM yyyy HH:mm:ss").format(sellTime),
              titleStyle: const TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              valueStyle: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            KeyValue(title: "QUANTITY", value: "${trade.quantity}"),
            KeyValue(title: "BUYPRICE", value: "${trade.buyPrice}"),
            KeyValue(
                title: "SELLPRICE", value: trade.sellPrice?.toString() ?? ""),
            KeyValue(
                title: "REALIZED PNL",
                value: "\$ ${profit.toStringAsFixed(2)}",
                valueStyle: TextStyle(
                  color: profit > 0 ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                )),
            KeyValue(
              title: "PNL %",
              value: "${profitPercent.toStringAsFixed(2)}%",
              valueStyle: TextStyle(
                color: profit > 0 ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            KeyValue(
              title: "BUY AT",
              value: DateFormat("dd MM yyyy HH:mm:ss").format(buyTime),
            ),
          ],
        ),
      ),
    );
  }
}

class KeyValue extends StatelessWidget {
  const KeyValue({
    super.key,
    required this.title,
    required this.value,
    this.titleStyle = const TextStyle(
      fontWeight: FontWeight.w600,
    ),
    this.valueStyle = const TextStyle(),
  });

  final TextStyle titleStyle;

  final TextStyle valueStyle;

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        Text(
          value,
          style: valueStyle,
        ),
      ],
    );
  }
}
