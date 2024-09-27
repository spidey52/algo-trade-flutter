import 'package:flutter/material.dart';

class TickerForm extends StatelessWidget {
  const TickerForm({
    super.key,

    // text controller
    required this.symbolController,
    required this.buyPercentController,
    required this.sellPercentController,
    required this.amountController,
    required this.openOrdersController,
    required this.strategy,

    // switch controller
    required this.loopEnabled,
    required this.robEnabled,
    required this.rosEnabled,
    required this.onLoopEnabledChanged,
    required this.onRobEnabledChanged,
    required this.onRosEnabledChanged,
    required this.onStrategyChanged,

    // button controller
    required this.isLoading,
    required this.onSave,
    this.buttonText = "Save",
  });

  //  text controller
  final TextEditingController symbolController;
  final TextEditingController buyPercentController;
  final TextEditingController sellPercentController;
  final TextEditingController amountController;
  final TextEditingController openOrdersController;

  // switch controller
  final bool loopEnabled;
  final bool robEnabled;
  final bool rosEnabled;
  final Function(bool) onLoopEnabledChanged;
  final Function(bool) onRobEnabledChanged;
  final Function(bool) onRosEnabledChanged;
  final Function(String) onStrategyChanged;

  // button controller
  final bool isLoading;
  final Future<void> Function() onSave;

  final String buttonText;
  final String strategy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: Wrap(
        runSpacing: 14,
        children: [
          TickerTextField(
            controller: symbolController,
            label: "Symbol",
            keyboardType: TextInputType.text,
          ),
          TickerTextField(
            controller: buyPercentController,
            label: "Buy Percent",
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),

            // remove keyboard when click outside
          ),
          TickerTextField(
            controller: sellPercentController,
            label: "Sell Percent",
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          TickerTextField(
            controller: amountController,
            label: "Amount",
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          TickerTextField(
            controller: openOrdersController,
            label: "Open Orders",
            keyboardType: TextInputType.number,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "OOMP ENABLED",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Switch(
                value: loopEnabled,
                onChanged: onLoopEnabledChanged,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ROB ENABLED",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Switch(
                value: robEnabled,
                onChanged: onRobEnabledChanged,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ROS ENABLED",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Switch(
                value: rosEnabled,
                onChanged: onRosEnabledChanged,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // stra"GRID_ORDER",
                strategy,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Switch(
                value: strategy == "GRID_ORDER",
                onChanged: (val) {
                  if (val == true) {
                    onStrategyChanged("GRID_ORDER");
                  } else {
                    onStrategyChanged("AUTO_ORDER");
                  }
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    await onSave();
                  },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, 42),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    "SAVE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
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
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }
}
