import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:algo_trade/app/network/trade_provider.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  final TradesProvider tradeProvider = TradesProvider();

  final phonController = TextEditingController();
  final otpController = TextEditingController();

  final isLoading = false.obs;

  final otpLoading = false.obs;
  final isOtpSent = false.obs;

  login() async {
    if (phonController.text.length != 10) {
      Fluttertoast.showToast(
        msg: "Please enter valid phone number",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    try {} catch (e) {
      print('error from here  56');
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      isLoading.value = false;
    }
  }

  verify() async {
    if (otpController.text.length != 4) {
      Fluttertoast.showToast(
        msg: "Please enter valid OTP",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    otpLoading.value = true;

    try {} catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      otpLoading.value = false;
    }
  }

  final count = 0.obs;

  void increment() => count.value++;
}
