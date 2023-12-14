import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:shopping_notes/controller/my_drawer_controller.dart';
import 'package:shopping_notes/views/screen/profile_screen.dart';
import 'package:shopping_notes/views/screen/shopping_note_home_screen.dart';

class HomePage extends GetView<MyDrawerController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ZoomDrawer(
        style: DrawerStyle.defaultStyle,
        controller: controller.zoomDrawerController,
        menuScreen: const ProfileScreen(),
        mainScreen:  ShoppingNoteHomeScreen(),
        moveMenuScreen: true,
        borderRadius: 24.0,
        showShadow: true,
        angle: -12.0,
        drawerShadowsBackgroundColor: Colors.yellow,
        slideWidth: MediaQuery.of(context).size.width * 0.73,

      ),

    );
  }
}