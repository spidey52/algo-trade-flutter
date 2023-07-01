import 'package:flutter/material.dart';

class TickerForm extends StatelessWidget {
  const TickerForm({
    super.key,

    // text controller
    required this.symbolController,
    required this.buyPercentController,
    required this.sellPercentController,
    required this.amountController,

    // switch controller
    required this.loopEnabled,
    required this.onLoopEnabledChanged,

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

  // switch controller
  final bool loopEnabled;
  final Function(bool) onLoopEnabledChanged;

  // button controller
  final bool isLoading;
  final Future<void> Function() onSave;

  final String buttonText;

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
            keyboardType: TextInputType.number,
          ),
          TickerTextField(
            controller: sellPercentController,
            label: "Sell Percent",
            keyboardType: TextInputType.number,
          ),
          TickerTextField(
            controller: amountController,
            label: "Amount",
            keyboardType: TextInputType.number,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "LOOP ENABLED",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Switch(
                value: loopEnabled,
                onChanged: onLoopEnabledChanged,
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
