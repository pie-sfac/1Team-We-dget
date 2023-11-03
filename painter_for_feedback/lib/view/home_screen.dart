import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../component/draw_colors.dart';
import '../../custom_painter/painter_controller.dart';
import '../component/add_image.dart';
import '../component/bottom_icon_layout.dart';
import '../component/menu_icon.dart';
import 'custom_canvas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomPopupMenuController menuController1Draw = CustomPopupMenuController();
  CustomPopupMenuController menuController2Album = CustomPopupMenuController();
  final PainterController controller = PainterController()..thickness = 6;

  Color pickedColor = pickedColors[0];
  bool eraserSelected = false;
  Color eraseColor = const Color(0xFFFFFFFE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      bottomNavigationBar: renderBottomNavigationBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCanvas(controller: controller),
            const SizedBox(height: 10),
            Container(
              height: 60,
              color: eraserSelected ? Colors.transparent : Colors.white,
              child: eraserSelected
                  ? null
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: controller.undo,
                          iconSize: 30,
                          color: pickedColor,
                          icon: const Icon(Icons.undo),
                        ),
                        IconButton(
                          onPressed: controller.redo,
                          iconSize: 30,
                          color: pickedColor,
                          icon: const Icon(Icons.redo),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              color: eraserSelected ? Colors.transparent : Colors.white,
              child: eraserSelected
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Slider(
                          activeColor: Colors.white,
                          value: controller.thickness,
                          onChanged: (double val) {
                            setState(() {
                              controller.thickness = val;
                            });
                          },
                          min: 4,
                          max: 32,
                        ),
                        const SizedBox(height: 55),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Slider(
                          activeColor: pickedColor,
                          value: controller.thickness,
                          onChanged: (double val) {
                            setState(() => controller.thickness = val);
                          },
                          min: 4,
                          max: 32,
                        ),
                        Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(64),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    pickedColor = pickedColors[index];
                                    controller.drawColor = pickedColor;
                                  });
                                },
                                child: DrawColors(
                                  color: pickedColors[index],
                                  isSelected:
                                      pickedColors[index] == pickedColor,
                                ),
                              );
                            },
                            itemCount: pickedColors.length,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  renderBottomNavigationBar() {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white.withOpacity(0.5),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          elevation: 0,
          onTap: (index) {
            if (index == 2) controller.clear();
          },
          items: [
            BottomNavigationBarItem(
              icon: BottomIconLayout(
                controller: menuController1Draw,
                icon: eraserSelected
                    ? Icons.clear_all
                    : CupertinoIcons.pencil_outline,
                menus: Column(
                  children: [
                    MenuIcon(
                      child:
                          const Icon(CupertinoIcons.pencil_outline, size: 22),
                      onTap: () {
                        menuController1Draw.hideMenu();
                        eraserSelected = false;
                        controller.drawColor = pickedColor;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 4),
                    MenuIcon(
                      child: const Icon(Icons.clear_all, size: 22),
                      onTap: () {
                        menuController1Draw.hideMenu();
                        eraserSelected = true;
                        controller.drawColor = eraseColor;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              label: eraserSelected ? '지우기' : '그리기',
            ),
            // 2. 앨범을 누르면 사진을 추가할 수 있게 한다.
            BottomNavigationBarItem(
              icon: BottomIconLayout(
                controller: menuController2Album,
                icon: Icons.photo_camera_back_outlined,
                menus: AddImage(
                  menuController: menuController2Album,
                  painterController: controller,
                  onTap: () {
                    setState(() {});
                  },
                ),
              ),
              label: '그림불러오기',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square),
              label: '새로그리기',
            ),
          ],
        ),
      ),
    );
  }
}
