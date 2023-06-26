import 'package:get/get.dart';

class TradesProvider extends GetConnect {
  Future<Response> getCall(url, market) async => await get(url, query: {
        "limit": "1000",
        "market": market,
        "status": "OPEN",
      });

  Future<Response> postCall(url, body) async => await post(url, body);
}
