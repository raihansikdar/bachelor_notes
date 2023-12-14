import 'package:shopping_notes/controller/add_shoping_data_controller.dart';
import 'package:shopping_notes/controller/auto_delete_controller.dart';
import 'package:shopping_notes/controller/fetch_data_controller.dart';
import 'package:shopping_notes/controller/add_data_controller.dart';
import 'package:shopping_notes/controller/fetch_shopping_data_controller.dart';
import 'package:shopping_notes/controller/fetch_monthly_expanse_review_controller.dart';
import 'package:shopping_notes/controller/my_drawer_controller.dart';
import 'package:shopping_notes/controller/transferData_controller.dart';
import 'package:shopping_notes/controller/update_data_controller.dart';
import 'package:get/get.dart';
import 'package:shopping_notes/controller/update_shopping_note_controller.dart';

class StateholderBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AddDataController());
    Get.put(FetchDataController());
    Get.put(UpdateDataController());
    Get.put(AddShoppingDataController());
    Get.put(FetchShoppingDataController());
    Get.put(UpdateShoppingDataController());
    Get.put(FetchMonthlyExpenseReviewController());
    Get.put(AutoDeleteController());
    Get.put(MyDrawerController());
    Get.put(TransferDataController());
  }
}
