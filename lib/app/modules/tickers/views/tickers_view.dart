import 'package:algo_trade/app/data/models/ticker.dart';
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
                Get.toNamed('/ticker-add');
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
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchTickers();
                    },
                    child: ListView.builder(
                      itemCount: controller.tickers.length,
                      itemBuilder: (context, index) {
                        return TickerItem(
                          ticker: controller.tickers[index],
                        );
                      },
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Get.toNamed('/ticker-edit', arguments: ticker);
        },
        title: Text(ticker.symbol ?? ''),
        subtitle: Text("Buy Percent: ${ticker.buyPercent}"),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete, color: Colors.red),
        ));
  }
}
