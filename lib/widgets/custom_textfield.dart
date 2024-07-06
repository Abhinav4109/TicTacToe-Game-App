import 'package:flutter/material.dart';
import 'package:tictactoe/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isReadOnly;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.isReadOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.blue, blurRadius: 5, spreadRadius: 1)
        ],
      ),
      child: TextField(
        readOnly: isReadOnly,
        controller: controller,
        decoration: InputDecoration(
            fillColor: bgColor,
            filled: true,
            hintText: hintText,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 0.5)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 0))),
      ),
    );
  }
}
