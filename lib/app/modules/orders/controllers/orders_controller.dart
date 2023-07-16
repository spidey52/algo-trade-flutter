import 'package:algo_trade/app/network/api_service.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const kOrderSearchKey = "order_search_key";

class OrdersController extends GetxController {
  final arguments = Get.arguments;
  final box = GetStorage();

  final PageController pageController = PageController();

  RxBool isBuy = true.obs;

  RxBool isLoading = false.obs;
  RxBool isCancelLoading = false.obs;
  RxBool isCreateNewOrders = false.obs;

  RxString search = "".obs;

  final buyOrders = <BinanceOrder>[].obs;
  final sellOrders = <BinanceOrder>[].obs;

  final ApiService apiService = ApiService();

  void changeIsBuy(bool val) {
    pageController.animateToPage(
      val ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  List<BinanceOrder> get getOrders {
    return isBuy.value ? buyOrders : sellOrders;
  }

  @override
  void onInit() {
    search.value = box.read(kOrderSearchKey) ?? "";
    if (arguments != null && arguments.isNotEmpty) {
      search.value = arguments;
    }
    fetchOrders();

    debounce(search, (callback) {
      fetchOrders();
    }, time: const Duration(milliseconds: 500));

    ever(
      search,
      (callback) => box.write(kOrderSearchKey, search.value),
    );

    super.onInit();
  }

  Future<void> cancelOrder(List<String> ids, String search) async {
    try {
      isCancelLoading.value = true;

      final response = await apiService.cancelOrder(ids, search);

      if (response.statusCode != 200) {
        showToast(response.body["message"]);
        return;
      }

      showToast("Order cancelled successfully");
      await fetchOrders();
    } catch (e) {
      showToast(e.toString());
    } finally {
      isCancelLoading.value = false;
    }
  }

  Future<void> replaceAllSellOrders(String symbol) async {
    try {
      isCancelLoading.value = true;

      final response = await apiService.replaceAllSellOrders(symbol);

      if (response.statusCode != 200) {
        showToast(response.body["message"]);
        return;
      }

      showToast("Orders created successfully");
      await fetchOrders();
    } catch (e) {
      showToast(e.toString());
    } finally {
      isCancelLoading.value = false;
    }
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await apiService.fetchFutureOrders(search.value.trim());

      if (response.statusCode != 200) {
        showToast(response.body["message"]);
        return;
      }

      final data = response.body;

      buyOrders.clear();
      sellOrders.clear();

      BinanceOrderResponse binanceOrderResponse =
          BinanceOrderResponse.fromJson(data);

      buyOrders.addAll(binanceOrderResponse.buy!);
      sellOrders.addAll(binanceOrderResponse.sell!);

      buyOrders.sort((a, b) => b.price!.compareTo(a.price!));
      sellOrders.sort((a, b) => a.price!.compareTo(b.price!));
    } catch (e) {
      showToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
