import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  SearchField({
    super.key,
    this.onChanged,
    this.defaultValue = '',
  });

  final Function(String)? onChanged;
  final String defaultValue;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = defaultValue;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      height: 50,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          hintText: 'search',
          border: const OutlineInputBorder(),
          suffixIcon: GestureDetector(
            onTap: () {
              controller.clear();
              onChanged?.call('');
            },
            child: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}
