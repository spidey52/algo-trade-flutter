import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ticker_edit_controller.dart';

class TickerEditView extends GetView<TickerEditController> {
  const TickerEditView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TickerEditView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text('TickerEditView'),

          TickerTextField(
            controller: controller.symbolController,
            label: "Ticker",
            keyboardType: TextInputType.text,
          ),
          // create a ticker editing form on basis of BinanceTicker model ??
        ],
      ),
    );
  }
}

class TickerTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  const TickerTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16.0),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }
}
