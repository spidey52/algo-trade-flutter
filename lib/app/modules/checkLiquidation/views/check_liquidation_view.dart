import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/check_liquidation_controller.dart';

class CheckLiquidationView extends GetView<CheckLiquidationController> {
  const CheckLiquidationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckLiquidationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CheckLiquidationView is working',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter a search term'),
            ),
          ],
        ),
      ),
    );
  }
}

/*
already coin, current price, 

loop price 


*/
