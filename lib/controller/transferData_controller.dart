import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_notes/controller/fetch_shopping_data_controller.dart';
import 'package:shopping_notes/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TransferDataController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> transferData() async {
    try {
      _isLoading = true;
      update();

      final Database db = await DatabaseHelper().database;

      // final countResponse = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM shoppingNotesTable'));
      //
      // if (countResponse == 0) {
      //   _isLoading = false;
      //   update();
      //   return false;
      // }
      final queryResponse = await db.query('shoppingNotesTable');
      final deleteResponse = await db.delete('shoppingNotesTable');

      _isLoading = false;
      if (deleteResponse > 0) {
        await db.transaction((txn) async {
          for (var row in queryResponse) {
            await txn.insert('recycleBinTable', row);
          }
        });
        Get.find<FetchShoppingDataController>().searchShoppingNoteList.clear();
        update();
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      log('===========>TransationData error: $e');

      update();
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }
}
