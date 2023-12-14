import 'dart:developer';

import 'package:shopping_notes/database/database_helper.dart';
import 'package:shopping_notes/model/note_model.dart';
import 'package:get/get.dart';

class AddDataController extends GetxController {
  bool _isLoading = false;
  NoteModel _noteModel = NoteModel();

  bool get isLoading => _isLoading;
  NoteModel get noteModel => _noteModel;

  Future<bool> insertData({required String date,required String title,required String note,required String time}) async {
    try {
      _isLoading = true;
      update();
      _noteModel = NoteModel(date: date, title: title, note: note, time: time);

      final db = await DatabaseHelper().database;
      final response = await db.insert('notesTable', _noteModel.toJson());

      _isLoading = false;
      if (response > 0) {
        update();
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      log("==============>Insert Data Error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }
}
