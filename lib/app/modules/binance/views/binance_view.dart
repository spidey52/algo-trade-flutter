import 'package:algo_trade/app/data/models/binance_balance.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:algo_trade/widgets/refresh_icon.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/binance_controller.dart';

class BinanceView extends GetView<BinanceController> {
  const BinanceView({Key? key}) : super(key: key);

  BinanceBalance get balance {
    return controller.balance.value;
  }

  List<Positions> get positions {
    final bal = controller.balance.value;

    final positions = bal.info?.positions;
    if (positions != null) {
      positions
          .sort((a, b) => b.unrealizedProfit!.compareTo(a.unrealizedProfit!));
      return positions.where((element) => element.positionAmt != 0.0).toList();
    }

    return [];
  }

  double get totalInvestment {
    double total = 0.0;
    for (final position in positions) {
      final entryPrice = position.entryPrice ?? 0.0;
      final positionAmt = position.positionAmt ?? 0.0;
      final localTotal = entryPrice * positionAmt;
      total += localTotal;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BinanceView'),
        centerTitle: true,
      ),
      body: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  title: Text(
                      "Total Balance ${balance.uSDT?.total?.toStringAsFixed(2)}"),
                  subtitle: Text(
                      "Free Balance ${balance.uSDT?.free?.toStringAsFixed(2)}"),
                  trailing: RefreshIconButton(
                    onPressed: () async {
                      await controller.fetchBalance();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "POSITIONS (${positions.length}) ${totalInvestment.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                  child: ListView(
                      children: positions.map((e) {
                return PositionItem(e: e);
              }).toList())),
            ],
          )),
    );
  }
}

class PositionItem extends StatelessWidget {
  const PositionItem({
    super.key,
    required this.e,
  });

  final Positions e;

  double get entryPrice => e.entryPrice ?? 0;
  double get unrealizedProfit => e.unrealizedProfit ?? 0.0;

  double get profitPercent => unrealizedProfit / investedAmount * 100;

  double get notionalValue {
    final askPrice = double.parse(e.askNotional ?? '0.0');
    final notional = double.parse(e.notional ?? '0.0');
    // return askPrice * notional;
    return notional * askPrice;
  }

  double get investedAmount {
    final entryPrice = e.entryPrice ?? 0.0;
    final positionAmt = e.positionAmt ?? 0.0;
    final total = entryPrice * positionAmt;
    return total;
  }

  get profitPercentColor => profitPercent >= 0 ? kProfitColor : kLossColor;

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
                    Text("Qty. ${e.positionAmt}"),
                    const SizedBox(width: 2),
                    Text("Avg. ${entryPrice.toPrecision(2)}")
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
                  "${e.symbol}",
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
                  "LTP ${e.askNotional}",
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
