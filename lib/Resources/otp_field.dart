import 'package:flutter/material.dart';

class OTPTextField extends StatefulWidget {
  final FocusNode focusNode;
  final int index;
  final Function(String) onCompleted;

  const OTPTextField({
    required this.focusNode,
    required this.index,
    required this.onCompleted,
  });

  @override
  State<OTPTextField> createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      if (_controller.text.length == 1) {
        // Move focus to the next text field
        widget.focusNode.nextFocus();

        // Call the onCompleted callback with the value of the text field
        widget.onCompleted(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
