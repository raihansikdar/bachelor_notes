import 'dart:async';
import 'package:get/get.dart';
import 'package:shopping_notes/controller/fetch_data_controller.dart';

class AutoDeleteController extends GetxService {
  late Timer _autoDeleteTimer;

  void startAutoDeleteTimer() {
    _autoDeleteTimer = Timer.periodic(const Duration(minutes: 2), (Timer timer) async {
      await Get.find<FetchDataController>().autoDeleteDataAfter2Minutes();
    });
  }

  void cancel() {
    _autoDeleteTimer.cancel();
  }
}
