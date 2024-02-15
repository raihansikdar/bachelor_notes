import 'package:bachelor_notes/views/screen/shopping_note_home_screen.dart';
import 'package:get/get.dart';

class CustomAnimationController extends GetxController{

  RxBool animate = false.obs;

  @override
  void onInit() {
    splashAnimation();
    super.onInit();
  }


  void splashAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 3000));
    animate.value = false;
    await Future.delayed(const Duration(milliseconds: 1600));
    Get.offAll(() => const ShoppingNoteHomeScreen());
  }
}

