import 'package:bachelor_notes/application/state_holder_binder.dart';
import 'package:bachelor_notes/utils/custom_size_extension.dart';
import 'package:bachelor_notes/views/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BachelorNotes extends StatelessWidget {
  const BachelorNotes({super.key});

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