import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';

class BottomIconLayout extends StatelessWidget {
  final Widget menus;
  final CustomPopupMenuController controller;
  final IconData icon;

  const BottomIconLayout({
    required this.menus,
    required this.controller,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      barrierColor: Colors.black.withOpacity(0.7),
      controller: controller,
      showArrow: false,
      menuBuilder: () => ClipRRect(
        child: menus,
      ),
      pressType: PressType.singleClick,
      child: Icon(icon, size: 28,),
    );
  }
}
