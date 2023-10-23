import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingView'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Show Profit/loss",
                  style: TextStyle(fontSize: 16),
                ),
                Obx(() => Switch(
                      value: controller.setting.value,
                      onChanged: (val) {
                        controller.toggleProfitViewSetting(val);
                      },
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
