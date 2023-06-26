import 'package:flutter/material.dart';

const kTokenKey = 'token';

const kProfitColor = Colors.greenAccent;
const kLossColor = Colors.redAccent;
const kNeutralColor = Colors.grey;

const kApiUrl = "https://binance-spot-trade.spideyworld.co.in";
const kBaseUrl = "https://magadhmahan.spideyworld.co.in/api/v1";

const kLoginUrl = "$kBaseUrl/admin/users/login/request";
const kLoginVerifyUrl = "$kBaseUrl/admin/users/login/verify";
const kTokenVerifyUrl = "$kBaseUrl/admin/users/token/verify";

const kTradeList = '$kApiUrl/trades';
const kOrders = '$kApiUrl/orders';
const kGridOrder = '$kOrders/grid';
const kTickerList = '$kApiUrl/tickers';
const kReportProfit = '$kApiUrl/reports';
const kProfit = "$kTradeList/profit";
