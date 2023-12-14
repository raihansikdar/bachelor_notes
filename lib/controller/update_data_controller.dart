import 'dart:developer';

import 'package:shopping_notes/database/database_helper.dart';
import 'package:shopping_notes/model/note_model.dart';
import 'package:get/get.dart';

class UpdateDataController extends GetxController{

  bool _isLoading = false;
  NoteModel _noteModel = NoteModel();

  bool get isLoading => _isLoading;
  NoteModel get noteModel => _noteModel;

  Future<bool>updateData({required int id, required String date,required String title,required String note,required String time}) async{
    try{
      _isLoading = true;
      update();
      _noteModel = NoteModel(date: date,title: title,note: note,time: time);

      final db = await DatabaseHelper().database;

      final response = await db.update('notesTable',{'date':date,'title':title,'note':note,'time': time},where: 'id = ?',whereArgs: [id]);

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