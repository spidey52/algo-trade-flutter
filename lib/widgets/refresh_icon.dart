import 'package:flutter/material.dart';

class RefreshIconButton extends StatefulWidget {
  const RefreshIconButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Future<void> Function() onPressed;

  @override
  State<RefreshIconButton> createState() => _RefreshIconButtonState();
}

class _RefreshIconButtonState extends State<RefreshIconButton> {
  bool isCalling = false;

  void onPressed() async {
    if (isCalling) {
      return;
    }
    setState(() {
      isCalling = true;
    });
    await widget.onPressed();

    setState(() {
      isCalling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isCalling ? null : onPressed,
      icon: Icon(isCalling ? Icons.pending : Icons.refresh),
    );
  }
}
