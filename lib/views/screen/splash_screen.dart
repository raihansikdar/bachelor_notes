import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bachelor_notes/utils/app_colors.dart';
import 'package:bachelor_notes/utils/assets_path.dart';
import 'package:bachelor_notes/views/screen/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      Get.offAll(HomePage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
            AssetsPath.appLogoPNG,
            height: 100,
            width: 100,
          )),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, top: 4),
            child: Text(
              "Bachelor Notes",
              style: TextStyle(
                  color: AppColors.yellowColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
