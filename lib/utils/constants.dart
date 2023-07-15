import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kTokenKey = 'token';
String firebaseToken = '';

const kProfitColor = Colors.green;
const kLossColor = Colors.red;
const kNeutralColor = Colors.grey;

String kApiUrl = "http://52.66.39.113:9001";
const kBaseUrl = "https://magadhmahan.spideyworld.co.in/api/v1";

const kLoginUrl = "$kBaseUrl/admin/users/login/request";
const kLoginVerifyUrl = "$kBaseUrl/admin/users/login/verify";
const kTokenVerifyUrl = "$kBaseUrl/admin/users/token/verify";

String kFcmTokenUrl = "$kApiUrl/fcm";
String kTradeList = '$kApiUrl/trades';
String kOrders = '$kApiUrl/orders';
String kGridOrder = '$kOrders/grid';
String kTickerList = '$kApiUrl/tickers';
String kReportProfit = '$kApiUrl/reports';
String kProfit = "$kTradeList/profit";

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
