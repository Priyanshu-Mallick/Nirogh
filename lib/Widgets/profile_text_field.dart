import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    Key? key,
    required this.ttext,
    required this.isDarkMode,
    required this.icon,
    this.read = false,
    this.ctext = '',
    this.onTap,
  }) : super(key: key);

  final bool isDarkMode;
  final Icon icon;
  final String ttext;
  final bool read;
  final String ctext;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(

      readOnly: read,
      cursorColor: isDarkMode ? Colors.white : Colors.black,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(
            width: 2,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        labelText: ttext,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        prefixIcon: icon,
        prefixIconColor: isDarkMode ? Colors.white : Colors.black,
      ),
      controller: TextEditingController(text: ctext),
      onTap: onTap,
    );
  }
}