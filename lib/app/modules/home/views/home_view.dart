import 'package:algo_trade/app/data/models/binance_stream.dart';
import 'package:algo_trade/app/data/models/dashboard_card.dart';
import 'package:algo_trade/app/modules/completed/views/completed_view.dart';
import 'package:algo_trade/app/modules/grid-order/views/grid_order_view.dart';
import 'package:algo_trade/app/modules/home/views/profit_view.dart';
import 'package:algo_trade/app/modules/home/views/trade_item_view.dart';
import 'package:algo_trade/app/modules/more/views/more_view.dart';
import 'package:algo_trade/app/routes/app_pages.dart';
import 'package:algo_trade/main.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pie_chart/pie_chart.dart';

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
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text("Select Market"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...users.keys.map((e) {
                            return ListTile(
                              onTap: () {
                                // controller.market.value = e;
                                box.write(kLoggedInUser, e);
                                Get.offAllNamed(Routes.SPLASH);
                              },
                              title: Text(e),
                            );
                          }).toList(),

                          // ListTile(
                          //   onTap: () {
                          //     controller.market.value = "FUTURE";
                          //     box.write('market', "FUTURE");
                          //     Get.back();
                          //   },
                          //   title: const Text("FUTURE"),
                          // ),
                          // ListTile(
                          //   onTap: () {
                          //     controller.market.value = "SPOT";
                          //     box.write('market', "SPOT");
                          //     Get.back();
                          //   },
                          //   title: const Text("SPOT"),
                          // ),
                        ],
                      ),
                    );
                  });
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
          // Obx(
          //   () => IconButton(
          //     onPressed: () {
          //       controller.toggleUrl();
          //     },
          //     icon: controller.url.value == "http://52.66.39.113:9001"
          //         ? const Icon(Icons.cloud_off)
          //         : const Icon(Icons.cloud),
          //   ),
          // ),
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
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchData();
        controller.priceController.reconnect();
      },
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(
              () => ScrollCard(
                  cardResult: controller.dashboardCard.value.result ?? []),
            ),
            ProfityBySymbol(controller: controller),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Get.toNamed(Routes.GROUPED_PENDING_TRADES),
                    onLongPress: () => Get.toNamed(Routes.BINANCE),
                    child: Obx(
                      () => Text(
                        'Pending Trades (${controller.trades.length}) '
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  TickerSelector(
                    selected: controller.search.value,
                    onChanged: (val) {
                      controller.search.value = val;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => SizedBox(
                  height: Get.height - 260,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      return controller.fetchTrades();
                    },
                    child: ListView.builder(
                      itemCount: controller.trades.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, idx) {
                        return Obx(() => TradeItem(
                              trade: controller.trades[idx],
                              ticker:
                                  controller.priceController.tickerStreamMap[
                                          controller.trades[idx].symbol] ??
                                      BinanceStream(),
                            ));
                      },
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ProfityBySymbol extends StatelessWidget {
  const ProfityBySymbol({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  get chart {
    return PieChart(
      dataMap: controller.mappedPieData,
      chartValuesOptions: const ChartValuesOptions(
        decimalPlaces: 2,
        showChartValuesInPercentage: true,
      ),
      legendOptions: const LegendOptions(
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.pieLoading.value
          ? const CircularProgressIndicator()
          : controller.mappedPieData.isEmpty
              ? const Text("No Data")
              : chart,
    );
  }
}

class ScrollCard extends StatelessWidget {
  const ScrollCard({
    super.key,
    required this.cardResult,
  });

  final List<CardResult> cardResult;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            ...cardResult
                .map(
                  (e) => SizedBox(
                    width: 200,
                    child: ProfitView(
                      title: e.title ?? "",
                      amount: (e.profit ?? 0.0).toStringAsFixed(2),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

List<MaterialColor> cardColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.lightBlue,
  Colors.pink,
];
