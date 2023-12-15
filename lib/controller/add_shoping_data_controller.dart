import 'dart:developer';

import 'package:bachelor_notes/database/database_helper.dart';
import 'package:bachelor_notes/model/shopping_note_model.dart';
import 'package:get/get.dart';


class AddShoppingDataController extends GetxController{
  bool _isLoading = false;
  ShoppingNoteModel _shoppingNoteModel = ShoppingNoteModel();

  bool get isLoading => _isLoading;
  ShoppingNoteModel get shoppingNoteModel => _shoppingNoteModel;

  Future<bool> insertData({
    required String time,
    required String date,
    required String title,
    required double capital,
    required double remain,
    required List<String>? itemTitles,
    required List<double>? prices,
    required double totalCost,
  }) async {
    try{
      _isLoading = true;
      update();

      _shoppingNoteModel = ShoppingNoteModel(time: time,date: date,title: title, capital: capital,remain: remain, itemTitles: itemTitles,prices:prices,totalCost: totalCost);

      final db = await DatabaseHelper().database;
      final response = await db.insert('shoppingNotesTable', _shoppingNoteModel.toJson());

      _isLoading = false;
      if (response > 0) {
        update();
        return true;
      } else {
        update();
        return false;
      }
    }catch(e){
      log("==============>Insert Data Error: $e");
      return false;
    }finally {
      await DatabaseHelper().closeDatabase();
    }
  }

}