import 'package:shopping_notes/application/state_holder_binder.dart';
import 'package:shopping_notes/views/screen/basic_note_home_screen.dart';
import 'package:shopping_notes/utils/custom_size_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_notes/views/screen/home_page.dart';
import 'package:shopping_notes/views/screen/shopping_note_home_screen.dart';
import 'package:shopping_notes/views/screen/splash_screen.dart';

class DailyNotes extends StatelessWidget {
  const DailyNotes({super.key});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    ScreenSizes.screenWidth = size.width;
    ScreenSizes.screenHeight = size.height;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: StateholderBinder(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}