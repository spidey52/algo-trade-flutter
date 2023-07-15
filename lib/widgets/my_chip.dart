import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  const MyChip({
    super.key,
    required this.str,
    this.color = Colors.orange,
    this.padding = const EdgeInsets.all(10),
    this.radius = 4,
  });

  final String str;
  final Color color;
  // final double padding;
  final double radius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        str,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
