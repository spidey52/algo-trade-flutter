import 'package:algo_trade/app/network/trade_provider.dart';
import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

    try {
      isLoading.value = true;
      final response = await tradeProvider.post(kLoginUrl, {
        "phone": phonController.text,
      });
      isLoading.value = false;

      if (response.statusCode != 200) {
        print('error from here 37');
        Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        return;
      }

      isOtpSent.value = true;

        print('error from here 49');
      Fluttertoast.showToast(
        msg: "OTP sent successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (e) {
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

    try {
      Response response = await tradeProvider.post(kLoginVerifyUrl, {
        "phone": phonController.text,
        "otp": otpController.text,
      });

      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        return;
      }

      final token = response.body["token"];

      if (token == null) {
        Fluttertoast.showToast(
          msg: "No token found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        return;
      }

      Fluttertoast.showToast(
        msg: "Login successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      box.write("token", token);

      Get.offAllNamed("/home");
    } catch (e) {
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
