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
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Get.offAll(const HomePage());
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


// import 'package:bachelor_notes/utils/animation/custom_animation.dart';
// import 'package:bachelor_notes/utils/animation/custom_animation_controller.dart';
// import 'package:bachelor_notes/utils/custom_size_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:bachelor_notes/utils/app_colors.dart';
// import 'package:bachelor_notes/utils/assets_path.dart';
// import 'package:bachelor_notes/views/screen/home_page.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   // @override
//   // void initState() {
//   //   Future.delayed(Duration(seconds: 3)).then((value) {
//   //     Get.offAll(HomePage());
//   //   });
//   //   super.initState();
//   // }
//   final CustomAnimationController _customAnimationController = Get.put(CustomAnimationController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appBackgroundColor,
//       body: Stack(
//         children: [
//         Obx(() =>   CustomAnimation(
//           duration: 1600,
//           opacity: _customAnimationController.animate.value ? 1 : 0,
//           // top: _customAnimationController.animate.value ? 220 : 190,
//           bottom: _customAnimationController.animate.value ? MediaQuery.of(context).size.height / 2 - 10 : MediaQuery.of(context).size.height / 2 + 30,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: Image.asset(
//               AssetsPath.appLogoPNG,
//               height: 100,
//               width: 100,
//             ),
//           ),
//         ),),
//
//           Obx(() => CustomAnimation(
//             duration: 1600,
//             opacity: _customAnimationController.animate.value ? 1 : 0,
//            // bottom: _customAnimationController.animate.value ? 290 : 260,
//             top: _customAnimationController.animate.value ? MediaQuery.of(context).size.height / 2 + 10 : MediaQuery.of(context).size.height / 2 + 30,
//             right: 0,
//             left: 0,
//             child: Center(
//               child: Text(
//                 "Bachelor Notes",
//                 style: TextStyle(
//                     color: AppColors.yellowColor,
//                     fontSize: 18,
//                     fontFamily: 'Lobster',
//                     fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),),
//         ],
//       ),
//
//     );
//   }
// }