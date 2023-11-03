import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../custom_painter/painter_controller.dart';
import 'menu_icon.dart';

class AddImage extends StatelessWidget {
  final CustomPopupMenuController menuController;
  final PainterController painterController;
  final GestureTapCallback onTap;

  const AddImage({
    required this.menuController,
    required this.painterController,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MenuIcon(
      child: Container(
        alignment: Alignment.center,
        child: Icon(
          painterController.bgImagePath == null ? Icons.add : Icons.remove,
          size: 16,
        ),
      ),
      onTap: () async {
        menuController.hideMenu();

        if (painterController.bgImagePath == null) {
          await ImagePicker()
              .pickImage(
            source: ImageSource.gallery,
          )
              .then((value) {
            painterController.bgImagePath = value?.path;
          });
        } else {
          painterController.bgImagePath = null;
        }

        onTap();
      },
    );
  }
}
