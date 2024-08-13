import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:algo_trade/app/routes/app_pages.dart';

import '../controllers/more_controller.dart';

class MoreView extends GetView<MoreController> {
  const MoreView({Key? key}) : super(key: key);

  get items {
    return [
      const MoreListItem(
        title: 'TICKERS PAGE',
        route: Routes.TICKERS,
      ),
      const MoreListItem(
        title: 'ADD TICKER',
        route: Routes.ADD_TICKER,
      ),
      const MoreListItem(
        title: 'REPORT PAGE',
        route: Routes.REPORT_PAGE,
      ),
      const MoreListItem(
        title: 'ORDERS PAGE',
        route: Routes.ORDERS,
      ),
      const MoreListItem(
        title: "SETTINGS PAGE",
        route: Routes.SETTING,
      ),
      const MoreListItem(
        title: "BINANCE PAGE",
        route: Routes.BINANCE,
      ),
      const MoreListItem(
        title: "GP TRADES",
        route: Routes.GROUPED_PENDING_TRADES,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 60,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {
              Get.toNamed(items[index].route);
            },
            child: Text(
              items[index].title,
              style: const TextStyle(fontSize: 16),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}

class MoreListItem {
  final String title;
  final String route;
  const MoreListItem({
    required this.title,
    required this.route,
  });
}
