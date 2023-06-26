import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/more_controller.dart';

class MoreView extends GetView<MoreController> {
  const MoreView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: ListTile(
        title: const Text('Tickers'),
        onTap: () {
          Get.toNamed('/tickers');
        },
      ),
    );
  }
}
