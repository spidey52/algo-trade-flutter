import 'package:algo_trade/app/data/models/price_listener.dart';
import 'package:algo_trade/app/network/api_service.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:get/get.dart';

class PriceListenerController extends GetxController {
  //TODO: Implement PriceListenerController

  final apiProvider = ApiService();

  final RxList<PriceListener> listenerList = <PriceListener>[].obs;
  final RxBool isCreating = false.obs;

  Future<void> fetchListeners() async {
    final response = await apiProvider.get("$kApiUrl/price-listeners");

    if (response.statusCode == 200) {
      final data = response.body['data'] as List;
      listenerList.value = data.map((e) => PriceListener.fromJson(e)).toList();
    }
  }

  Future<void> addPriceListener(PriceListener listener) async {
    isCreating.value = true;

    final response = await apiProvider.post(
      "$kApiUrl/price-listeners",
      listener.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      showToast("Listener ${listener.symbol} added");
      await fetchListeners();
    } else {
      showToast(response.body['message']);
    }

    isCreating.value = false;
  }

  Future<void> deleteListener(PriceListener listener) async {
    final response = await apiProvider.delete(
      "$kApiUrl/price-listeners/${listener.sId ?? ""}",
    );

    if (response.statusCode == 200) {
      await fetchListeners();
      showToast("Listener ${listener.symbol} deleted");
    } else {
      showToast(response.body['message']);
    }
  }

  Future<void> toggleListener(PriceListener listener) async {
    final response = await apiProvider.patch(
      "$kApiUrl/price-listeners/${listener.sId ?? ""}",
      {
        "active": !(listener.active ?? false),
      },
    );

    showToast("Listener ${listener.symbol} updated");

    if (response.statusCode == 200) {
      fetchListeners();
    }
  }

  @override
  void onInit() {
    fetchListeners();

    super.onInit();
  }
}
