import 'package:algo_trade/app/data/models/binance_stream.dart';
import 'package:algo_trade/app/data/models/trade.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TradeItem extends StatelessWidget {
  const TradeItem({
    super.key,
    required this.trade,
    required this.ticker,
  });

  final Trade trade;
  final BinanceStream ticker;

  double get cp => trade.quantity * trade.buyPrice;
  double get sp => trade.quantity * ticker.price;
  double get profit => sp - cp;
  double get profitPercent => (profit / cp) * 100;

  get profitColor => profit > 0 ? kProfitColor : kLossColor;

  get ltpColor {
    if (ticker.prevPrice == ticker.price) return kNeutralColor;
    if (ticker.prevPrice < ticker.price) return kProfitColor;
    return kLossColor;
  }

  String get profitString {
    return "\$ ${profit > 0 ? '+' : ''} ${profit.toStringAsFixed(2)}";
  }

  String get profitPercentString {
    return "${profitPercent > 0 ? '+' : ''} ${profitPercent.toStringAsFixed(2)} %";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          Container(
            height: Get.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("hello world"), Text("details of the trade")],
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    Text("Qty. ${trade.quantity}"),
                    const SizedBox(width: 2),
                    Text("Avg. ${trade.buyPrice}")
                  ],
                ),
                Text(
                  profitPercentString,
                  style: TextStyle(
                    color: profitColor,
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
                  trade.symbol.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  profitString,
                  style: TextStyle(
                    color: profitColor,
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
                  Text(
                    cp.toStringAsFixed(2),
                  ),
                ]),
                Text(
                  "LTP ${ticker.price}",
                  style: TextStyle(
                    color: ltpColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
