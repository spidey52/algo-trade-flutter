import 'package:algo_trade/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/grid_order_controller.dart';

class GridOrderView extends GetView<GridOrderController> {
  const GridOrderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 8,
        right: 8,
      ),
      child: Wrap(
        runSpacing: 20,
        children: [
          Text("${loggedInUser.toUpperCase()}"),
          OutlinedTextField(
            hint: "Symbol",
            controller: controller.symbolController,
          ),
          OutlinedTextField(
            hint: "count",
            controller: controller.countController,
          ),
          OutlinedTextField(
            hint: "price",
            controller: controller.priceController,
          ),
          OutlinedTextField(
            hint: "quantity",
            controller: controller.quantityController,
          ),
          OutlinedTextField(
            hint: "percentage",
            controller: controller.percentageController,
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.market.value),
                Switch(
                    value: controller.market.value == 'FUTURE',
                    onChanged: (val) {
                      controller.market.value = val ? 'FUTURE' : 'SPOT';
                    })
              ],
            ),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.side.value),
                Switch(
                    value: controller.side.value == 'BUY',
                    onChanged: (val) {
                      controller.side.value = val ? 'BUY' : 'SELL';
                    })
              ],
            ),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("SKIP"),
                Switch(
                    value: controller.skipOne.value,
                    onChanged: (val) {
                      controller.skipOne.value = val;
                    })
              ],
            ),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      controller.submitRequest();
                    },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  const Size(double.infinity, 44),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.onEditingComplete,
  });

  final String hint;
  final TextEditingController controller;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        hintText: hint,
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
