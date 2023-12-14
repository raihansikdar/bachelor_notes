import 'dart:developer';

import 'package:shopping_notes/database/database_helper.dart';
import 'package:get/get.dart';
import 'package:shopping_notes/model/shopping_note_model.dart';

class UpdateShoppingDataController extends GetxController{

  bool _isLoading = false;
  ShoppingNoteModel _shoppingNoteModel = ShoppingNoteModel();

  bool get isLoading => _isLoading;
  ShoppingNoteModel get shoppingNoteModel => _shoppingNoteModel;

  Future<bool> updateData({
    required int id,
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


      _shoppingNoteModel = ShoppingNoteModel(id: id,time: time,date: date,title: title, capital: capital,remain: remain, itemTitles: itemTitles,prices:prices,totalCost: totalCost);

      final db = await DatabaseHelper().database;

      final response = await db.update(
          'shoppingNotesTable',
          {'time': time,
            'date':date,
            'title':title,
            'capital':capital,
            'remain':remain,
            'itemTitles': itemTitles?.join(', ') ?? '', // Convert list to comma-separated string
            'prices': prices?.join(', ') ?? '', // Convert list to comma-separated string
            'totalCost':totalCost,
          },where: 'id = ?',whereArgs: [id]);

      _isLoading = false;
      if (response > 0) {
        update();
        return true;
      } else {
        update();
        return false;
      }
    }catch(e){
      log("==============>Update Data Error: $e");
      return false;
    }finally {
      await DatabaseHelper().closeDatabase();
    }
  }

}