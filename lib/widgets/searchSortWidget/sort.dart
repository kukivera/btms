import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final List<String> items;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final TextStyle? style;
  final Color underlineColor;

  const CustomDropdownButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.icon,
    this.iconColor = Colors.black,
    this.iconSize = 24,
    this.style,
    this.underlineColor = Colors.lightBlueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      icon: Icon(icon, color: iconColor),
      iconSize: iconSize,
      elevation: 16,
      style: style,
      underline: Container(
        height: 2,
        color: underlineColor,
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
