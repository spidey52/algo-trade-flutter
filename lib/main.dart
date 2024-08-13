import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:algo_trade/app/data/models/binance_stream.dart';
import 'package:algo_trade/app/data/models/ticker.dart';
import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/firebase/firebase_init.dart';
import 'package:algo_trade/utils/constants.dart';

import 'app/routes/app_pages.dart';

final wsUrl = Uri.parse('wss://glm1.spideyworld.co.in/crypto-stream');
// final wsUrl = Uri.parse('ws://172.30.2.35:8080/crypto-stream');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isAndroid) {
    // await AndroidAlarmManager.initialize();
    await Firebase.initializeApp();
    await FirebaseApi().initNotifcations();
  }
  await GetStorage.init();
  final box = GetStorage();
  // box.writeIfNull('theme', 'light');

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: box.read('theme') == 'dark' ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(PriceController());
      }),
    ),
  );
}

class PriceController extends GetxController {
  final RxBool isProfitVisible = false.obs;
  final RxList<String> tickers = <String>[].obs;
  final RxList<BinanceTicker> binanceTickers = <BinanceTicker>[].obs;

  final TradesProvider tradesProvider = TradesProvider();

  final RxMap<String, BinanceStream> tickerStreamMap =
      <String, BinanceStream>{}.obs;

  late WebSocketChannel channel;

  BinanceTicker getTicker(String symbol) {
    final ticker = binanceTickers.firstWhere(
        (element) => element.symbol == symbol,
        orElse: () => BinanceTicker());

    ticker.price = tickerStreamMap[symbol]?.price ?? 0.0;

    return ticker;
  }

  Future<void> fetchTickers() async {
    try {
      Response response = await tradesProvider.get(kTickerList, query: {
        "future": 'true',
        "limit": '100',
      });

      if (response.statusCode == 200) {
        var tickerBody = response.body as List;
        tickers.value = tickerBody.map((e) => e['symbol'].toString()).toList();

        binanceTickers.value = tickerBody
            .map((e) => BinanceTicker.fromJson(e as Map<String, dynamic>))
            .toList();

        tickers.sort(((a, b) => a.compareTo(b)));
        tickers.insert(0, "All");
      } else {
        showToast(response.body['message']);
      }
    } catch (e) {
      //show
      showToast(e.toString());
    }
  }

  void connect() async {
    try {
      if (tickers.isEmpty) {
        await fetchTickers();
      }
      channel = WebSocketChannel.connect(wsUrl);
      Fluttertoast.showToast(msg: "Socket connected");

      final payload = jsonEncode(tickers.map((e) => e.toString()).toList());
      channel.sink.add(payload);

      channel.stream.listen(
        (event) {
          // print(event);

          try {
            final eventData = jsonDecode(event) as Map<String, dynamic>;
            final tickersData = eventData['tickers'] as List;
            // print(tickersData);
            for (var element in tickersData) {
              final symbol = element['ticker'];
              final price = element['price'];
              final exist = tickerStreamMap[symbol];

              if (exist != null) {
                exist.prevPrice = exist.price;
                exist.price = double.tryParse("$price") ?? 0.0;

                tickerStreamMap.update(
                  symbol,
                  (value) => BinanceStream(
                    symbol: symbol,
                    price: exist.price,
                    prevPrice: exist.prevPrice,
                  ),
                );
              } else {
                tickerStreamMap.putIfAbsent(
                  symbol,
                  () => BinanceStream(
                      symbol: symbol,
                      // price: double.tryParse(price) ?? 0.0,
                      price: 0.0,
                      prevPrice: 0.0),
                );
              }
            }
          } catch (e) {
            Fluttertoast.showToast(msg: e.toString());
          }
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void reconnect() async {
    channel.sink.close();
    connect();
  }

  @override
  void onInit() {
    super.onInit();
    connect();
  }
}

class TickerSelector extends GetView<PriceController> {
  const TickerSelector({
    Key? key,
    required this.selected,
    required this.onChanged,
    this.value = false,
  }) : super(key: key);

  final String selected;
  final bool value;
  final Function(String) onChanged;

  Color textColor(String value) {
    if (value == "All" && selected == "") return Colors.blue;
    final blackColor = Get.isDarkMode ? Colors.white : Colors.black;
    return value == selected ? Colors.blue : blackColor;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Obx(() => DropdownButton<String>(
            value: value ? selected : null,
            icon: Icon(
              Icons.filter_list,
              color: textColor(selected),
            ),
            iconSize: 24,
            isDense: true,
            menuMaxHeight: 300,
            hint: const Text(""),
            onChanged: (val) {
              if (val == "All") {
                onChanged("");
                return;
              }
              if (val != null) onChanged(val);
            },
            items: controller.tickers
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: textColor(value),
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}
