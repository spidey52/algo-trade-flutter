import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:algo_trade/app/data/models/binance_stream.dart';
import 'package:algo_trade/utils/constants.dart';

import '../controllers/grouped_pending_trades_controller.dart';

class GroupedPendingTradesView extends GetView<GroupedPendingTradesController> {
  const GroupedPendingTradesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Trades'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trades (${controller.groupedPendingTrades.length})"
                          .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      "${controller.pnl.toPrecision(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: controller.pnl >= 0 ? kProfitColor : kLossColor,
                      ),
                    ),
                  ],
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Divider(),
              // ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchGroupedPendingTrades();
                  },
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: controller.groupedPendingTrades.length,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            final trade =
                                controller.groupedPendingTrades[index];
                            return Obx(
                              () => PendingTradeItemCard(
                                symbol: trade.symbol ?? "",
                                price: trade.avgBuyPrice ?? 0.0,
                                quantity: trade.totalQty ?? 0.0,
                                binanceStream: controller.priceController
                                        .tickerStreamMap[trade.symbol] ??
                                    BinanceStream(
                                      symbol: trade.symbol ?? "",
                                      price: trade.avgBuyPrice ?? 0.0,
                                      prevPrice: trade.avgBuyPrice ?? 0.0,
                                    ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PendingTradeItemCard extends StatelessWidget {
  const PendingTradeItemCard({
    Key? key,
    required this.symbol,
    required this.price,
    required this.quantity,
    required this.binanceStream,
  }) : super(key: key);

  final String symbol;
  final double price;
  final double quantity;
  final BinanceStream binanceStream;

  double get ltp => binanceStream.price;
  get investedAmount => price * quantity;
  get unrealizedProfit => (ltp - price) * quantity;
  get profitPercent => unrealizedProfit / investedAmount * 100;

  get profitPercentColor {
    if (profitPercent > 0) {
      return kProfitColor;
    } else if (profitPercent < 0) {
      return kLossColor;
    } else {
      return kNeutralColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Qty. ${quantity.toStringAsFixed(2)}"),
                    const SizedBox(width: 2),
                    Text("Avg. ${price.toStringAsFixed(2)}")
                  ],
                ),
                Text(
                  // profitPercentString,
                  "${profitPercent.toStringAsFixed(2)} %",
                  style: TextStyle(
                    color: profitPercentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  // profitString,
                  "\$ ${unrealizedProfit.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: profitPercentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Text(
                    "Invested ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(investedAmount.toStringAsFixed(2)),
                ]),
                Text(
                  "LTP ${ltp.toPrecision(4)}",
                  style: const TextStyle(
                    // color: ltpColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
