import 'dart:async';
import 'dart:developer';

import 'package:bachelor_notes/database/database_helper.dart';
import 'package:bachelor_notes/model/note_model.dart';
import 'package:bachelor_notes/model/recyclebin_note_model.dart';
import 'package:bachelor_notes/utils/app%20toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FetchDataController extends GetxController {
  bool _isLoading = false;
  List<NoteModel> _noteList = [];
  List<NoteModel> _searchNoteList = [];
  List<RycleBinNoteModel> _trashNotesList = [];
  NoteModel _noteModel = NoteModel();

  bool get isLoading => _isLoading;
  List<NoteModel> get noteList => _noteList;
  List<NoteModel> get searchNoteList => _searchNoteList;
  List<RycleBinNoteModel> get trashNotesList => _trashNotesList;
  NoteModel get noteModel => _noteModel;

  Future<bool> fetchData() async {
    try {
      _isLoading = true;
      update();

      final db = await DatabaseHelper().database;
      final response = await db.query('notesTable',
          orderBy: "date DESC,id DESC"); //orderBy: "id DESC"

      _isLoading = false;
      if (response.isNotEmpty) {
        _noteList =
            response.map((notesData) => NoteModel.fromJson(notesData)).toList();

        // _noteList.clear();
        // for (final result in response) {
        //   final chapterModel = NoteModel.fromJson(result);
        //   _noteList.add(chapterModel);
        // }
        _searchNoteList = _noteList;
        update();
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      log("==============>fetch Data Error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }

  Future<bool> fetchTrashData() async {
    try {
      _isLoading = true;
      update();

      final db = await DatabaseHelper().database;
      final response = await db.query('trashTable',
          orderBy: "date DESC,id DESC"); //orderBy: "id DESC"

      _isLoading = false;
      if (response.isNotEmpty) {
        _trashNotesList = response
            .map((notesData) => RycleBinNoteModel.fromJson(notesData))
            .toList();

        //_searchNoteList = _noteList;
        update();
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      log("==============>fetch Recycle bin Data Error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }

  void searchNote(String searchValue) {
    if (searchValue.isEmpty) {
      _searchNoteList = _noteList;
    } else {
      _searchNoteList = _noteList
          .where((element) =>
              element.title!.toLowerCase().contains(searchValue) ||
              element.date!.toLowerCase().contains(searchValue) ||
              element.title!.toUpperCase().contains(searchValue) ||
              element.date!.toUpperCase().contains(searchValue) ||
              _isDateMatch(element.date, searchValue))
          .toList();
    }
    update(); // shudu vule jai dite
  }

  bool _isDateMatch(String? noteDate, String searchValue) {
    try {
      DateTime searchDateTime = DateFormat("dd-MMM-yyyy").parse(searchValue);
      DateTime noteDateTime = DateFormat("dd-MMM-yyyy").parse(noteDate!);
      return searchDateTime.isAtSameMomentAs(noteDateTime);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteData(
      {required int id,
      required String time,
      required String deletedDate}) async {
    try {
      _isLoading = true;
      update();

      final db = await DatabaseHelper().database;

      // Retrieve the note before deleting it
      final response =
          await db.query('notesTable', where: 'id = ?', whereArgs: [id]);

      if (response.isNotEmpty) {
        NoteModel _deletedNote = NoteModel.fromJson(response.first);

        // Now delete the note
        final deleteResponse =await db.delete('notesTable', where: 'id = ?', whereArgs: [id]);

        _isLoading = false;

        if (deleteResponse > 0) {
          await db.insert('trashTable', _deletedNote.toJson());
          await db.update('trashTable', {'time': time, 'deletedDate': deletedDate}, where: 'id = ?', whereArgs: [id]);

          _searchNoteList.removeWhere((element) => element.id == id);

          update();
          return true;
        } else {
          update();
          return false;
        }
      } else {
        _isLoading = false;
        update();
        return false;
      }
    } catch (e) {
      log("==============>Delete Data Error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }

  Future<bool> deleteTrashData({required int id}) async {
    try {
      _isLoading = true;
      update();

      final db = await DatabaseHelper().database;

      // Retrieve the note before deleting it
      final response =
          await db.query('trashTable', where: 'id = ?', whereArgs: [id]);

      if (response.isNotEmpty) {
        RycleBinNoteModel _deleteTrashNote =
            RycleBinNoteModel.fromJson(response.first);
        // Now delete the note
        final deleteTrashResponse =
            await db.delete('trashTable', where: 'id = ?', whereArgs: [id]);

        _isLoading = false;

        if (deleteTrashResponse > 0) {
          _trashNotesList.removeWhere((element) => element.id == id);

          update();
          return true;
        } else {
          update();
          return false;
        }
      } else {
        _isLoading = false;
        update();
        return false;
      }
    } catch (e) {
      log("==============>Delete Trash Data Error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }

  Future<bool> clearData() async {
    try {
      _isLoading = true;
      update();

      final db = await DatabaseHelper().database;
      final response = await db.rawDelete("DELETE FROM trashTable");

      _isLoading = false;
      if (response > 0) {
        _trashNotesList.clear();
        AppToast.showNormalToast('All note has been deleted.');
        update();
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      log("==============>Clear Data Error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }

  Future<bool> restoreDeletedData(
      {required int id,
      required String date,
      required String title,
      required String note,
      required String time}) async {
    try {
      // Find the deleted note in _deleteNoteList
      RycleBinNoteModel? restoredNote =
          _trashNotesList.firstWhereOrNull((element) => element.id == id);

      _noteModel = NoteModel(date: date, title: title, note: note, time: time);

      final db = await DatabaseHelper().database;
      final insertResponse = await db.insert('notesTable', _noteModel.toJson());

      if (insertResponse > 0) {
        final deleteResponse =
            await db.delete('trashTable', where: 'id = ?', whereArgs: [id]);

        if (deleteResponse > 0) {
          _trashNotesList.removeWhere((element) =>
              element.id ==
              id); // Remove the restored note from _deleteNoteList
          update();
          return true;
        } else {
          update();
          return false;
        }
      } else {
        update();
        return false;
      }
    } catch (e) {
      log("==============>Restore Deleted Data Error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }

  // Future<void> autoDeleteTrashAfter30Days() async {
  //   try {
  //     final db = await DatabaseHelper().database;
  //
  //     // Calculate the date 30 days ago
  //     DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 1));
  //     String formattedThirtyDaysAgo = DateFormat("yyyy-MM-dd").format(thirtyDaysAgo);
  //
  //     // Retrieve items in the trash table older than 30 days
  //     final oldTrashItems = await db.query('trashTable', where: 'date < ?', whereArgs: [formattedThirtyDaysAgo]);
  //
  //
  //     // Delete the old items
  //     for (final oldItem in oldTrashItems) {
  //       final oldTrashNote = TrashNoteModel.fromJson(oldItem);
  //       await db.delete('trashTable', where: 'id = ?', whereArgs: [oldTrashNote.id]);
  //     }
  //
  //     // Update the local trashNotesList
  //     _trashNotesList.removeWhere((element) => oldTrashItems.any((item) => item['id'] == element.id));
  //
  //     update();
  //   } catch (e) {
  //     log("==============>Auto Delete Trash Data Error: $e");
  //   }
  // }
  //
  //
  // // Example of how to schedule this method to run periodically (e.g., every day)
  // void startAutoDeleteTimer() {
  //   Timer.periodic(const Duration(days: 1), (Timer timer) async {
  //     await autoDeleteTrashAfter30Days();
  //   });
  // }

  Future<void> autoDeleteDataAfter2Minutes() async {
    try {
      final db = await DatabaseHelper().database;

      // Calculate the date and time 2 minutes ago
      DateTime tenMinutesAgo =
          DateTime.now().subtract(const Duration(minutes: 2));
      String formattedTenMinutesAgo =
          DateFormat("dd-MMM-yyyy").format(tenMinutesAgo);

      // Retrieve items in the data table older than 2 minutes
      final oldTimeItems = await db.query('trashTable',
          where: 'time < ?', whereArgs: [formattedTenMinutesAgo]);

      // Delete the old items
      for (final oldItem in oldTimeItems) {
        // Modify this part based on your data model
        final oldDataModel = RycleBinNoteModel.fromJson(oldItem);
        await db.delete('trashTable',
            where: 'id = ?', whereArgs: [oldDataModel.id]);
      }

      // Update the local data list
      // Modify this part based on your data model
      _trashNotesList.removeWhere(
          (element) => oldTimeItems.any((item) => item['id'] == element.id));
      _trashNotesList.clear();
      update();
    } catch (e) {
      log("==============>Auto Delete Data Error: $e");
    }
  }
}
