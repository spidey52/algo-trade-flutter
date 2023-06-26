import 'package:algo_trade/app/data/models/binance_stream.dart';
import 'package:algo_trade/app/modules/completed/views/completed_view.dart';
import 'package:algo_trade/app/modules/grid-order/views/grid_order_view.dart';
import 'package:algo_trade/app/modules/home/views/profit_view.dart';
import 'package:algo_trade/app/modules/home/views/trade_item_view.dart';
import 'package:algo_trade/app/modules/more/views/more_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          onDestinationSelected: (value) {
            controller.count.value = value;
          },
          selectedIndex: controller.count.value,
          // backgroundColor: Colors.white,
          elevation: 3,

          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home,
                color: Colors.pinkAccent,
              ),
              label: "home",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.abc,
                color: Colors.blueAccent,
              ),
              label: "completed",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.grid_3x3,
                color: Colors.greenAccent,
              ),
              label: "Grid Order",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.more,
                color: Colors.orangeAccent,
              ),
              label: "More",
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Algo Trade'),
        actions: [
          IconButton(
            onPressed: () {
              controller.toggleMarket();
            },
            icon: Obx(
              () => Icon(controller.market.value == 'FUTURE'
                  ? Icons.currency_bitcoin
                  : Icons.currency_rupee),
            ),
          ),
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);

              box.write('theme', Get.isDarkMode ? "light" : "dark");
            },
            icon: Icon(
              Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.count.value,
          children: [
            HomePage(controller: controller),
            const CompletedView(),
            const GridOrderView(),
            const MoreView(),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Obx(
              () => ProfitView(
                title: "Today Profit",
                amount: controller.todayProfit.value,
              ),
            ),
            Obx(
              () => ProfitView(
                title: "Total Profit",
                amount: controller.totalProfit.value,
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Obx(
          () => GestureDetector(
            onDoubleTap: () {
              controller.reconnect();
            },
            child: Text(
              'Pending Trades (${controller.trades.length})'.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          height: 50,
          child: TextField(
            controller: controller.searchController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              hintText: 'search',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Obx(() => Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  return controller.fetchTrades();
                },
                child: ListView.builder(
                  itemCount: controller.trades.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, idx) {
                    return TradeItem(
                      trade: controller.trades[idx],
                      ticker: controller
                              .tickerStreamMap[controller.trades[idx].symbol] ??
                          BinanceStream(),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }
}
