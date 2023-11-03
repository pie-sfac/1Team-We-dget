import 'package:flutter/material.dart';

class DrawColors extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const DrawColors({
    required this.color,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: isSelected ? 35 : 25,
      height: isSelected ? 35 : 25,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            offset: Offset(2, 2),
          ),
        ],
        border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
      ),
    );
  }
}

const pickedColors = [
  Colors.black,
  Colors.grey,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.lightGreenAccent,
  Colors.green,
  Colors.lightBlueAccent,
  Colors.blue,
  Colors.purple,
];
