import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const kTokenKey = 'token';
const kLoggedInUser = 'loggedInUser';
String firebaseToken = '';

const kProfitColor = Colors.green;
const kLossColor = Colors.red;
const kNeutralColor = Colors.grey;

const users = {
  "gcs": "https://binance-spot-trade.spideyworld.co.in",
  "satyam": "https://satyam-algo-trade.spideyworld.co.in",
  // "gcs": "http://13.127.1.63:9001",
  // "amit": "http://3.109.94.54:9001",
  // "sudhanshu": "http://13.235.211.38:9001"
};

get loggedInUser {
  final box = GetStorage();
  return box.read(kLoggedInUser) ?? 'sudhanshu';
}

get availableUsers => users.keys.toList();

// const kApiUrl = "http://52.66.39.113:9001";
get kApiUrl => users[loggedInUser];

get kFcmTokenUrl => "$kApiUrl/fcm";
get kTradeList => '$kApiUrl/trades';
get kOrders => '$kApiUrl/orders';
get kGridOrder => '$kOrders/grid';
get kTickerList => '$kApiUrl/tickers';
get kReportProfit => '$kApiUrl/reports';
get kReportCard => '$kApiUrl/reports/future/card';
get kProfit => "$kTradeList/profit";

// Grouped Trades
get kGroupedPendingTrades => "$kTradeList/grouped/pending";
get kGroupedCompletedTrades => "$kTradeList/grouped/completed";

final kActiveButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
);

final kInactiveButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
);

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
  );
}

void handleApiError(Response response) {
  String message = response.body['message'] ??
      response.body['error'] ??
      'Something went wrong';

  showToast(message);
}
