import 'package:algo_trade/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
        itemCount: 2,
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
