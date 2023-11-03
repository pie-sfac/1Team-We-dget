import 'package:flutter/material.dart';

class MenuIcon extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final double? height;

  const MenuIcon({
    required this.child,
    required this.onTap,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: height ?? 40,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.yellowAccent,
              blurRadius: 0.2,
              spreadRadius: 0.2,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
