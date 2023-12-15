import 'dart:async';
import 'dart:developer';

import 'package:bachelor_notes/model/shopping_note_model.dart';
import 'package:bachelor_notes/model/shopping_note_recyclebin_model.dart';
import 'package:bachelor_notes/utils/app%20toast.dart';
import 'package:flutter/material.dart';
import 'package:bachelor_notes/database/database_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FetchShoppingDataController extends GetxController {
  bool _isLoading = false;
  List<ShoppingNoteModel> _shoppingNoteList = [];
  List<ShoppingNoteModel> _searchShoppingNoteList = [];
  ShoppingNoteModel _shoppingNoteModel = ShoppingNoteModel();

  List<ShoppingNoteRecycleBinModel> _shoppingNoteRecycleBinList = [];
  ShoppingNoteRecycleBinModel _shoppingNoteRecycleBinModel = ShoppingNoteRecycleBinModel();

  bool get isLoading => _isLoading;
  List<ShoppingNoteModel> get shoppingNoteList => _shoppingNoteList;
  List<ShoppingNoteModel> get searchShoppingNoteList => _searchShoppingNoteList;
  ShoppingNoteModel get shoppingNoteModel => _shoppingNoteModel;

  List<ShoppingNoteRecycleBinModel> get shoppingNoteRecycleBinList =>
      _shoppingNoteRecycleBinList;
  ShoppingNoteRecycleBinModel get shoppingNoteRecycleBinModel =>
      _shoppingNoteRecycleBinModel;

  Future<bool> fetchData() async {
    try {
      _isLoading = true;
      update();

      final db = await DatabaseHelper().database;
      final response = await db.query('shoppingNotesTable',
          orderBy: "date DESC,id DESC"); //orderBy: "id DESC"

      _isLoading = false;
      if (response.isNotEmpty) {
        _shoppingNoteList = response
            .map((shoppingData) => ShoppingNoteModel.fromJson(shoppingData))
            .toList();

        _searchShoppingNoteList = _shoppingNoteList;
        log(_searchShoppingNoteList.toString());
        update();
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      log("==============> Shopping fetch data error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }

  void searchShoppingNote(String searchValue) {
    if (searchValue.isEmpty) {
      _searchShoppingNoteList = _shoppingNoteList;
    } else {
      _searchShoppingNoteList = _shoppingNoteList
          .where((element) =>
              element.title!.toLowerCase().contains(searchValue) ||
              element.date!.toLowerCase().contains(searchValue) ||
              element.title!.toUpperCase().contains(searchValue) ||
              element.date!.toUpperCase().contains(searchValue) ||
              _isDateMatch(
                element.date,
                searchValue,
              ))
          .toList();
    }
    update(); // shudu vule jai dite
  }

  bool _isDateMatch(String? shoppingDate, String searchValue) {
    try {
      DateTime searchDateTime = DateFormat("dd-MMM-yyyy").parse(searchValue);
      DateTime shoppingDateTime =
          DateFormat("dd-MMM-yyyy").parse(shoppingDate!);
      return searchDateTime.isAtSameMomentAs(shoppingDateTime);
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchShoppingRecycleBinData() async {
    try {
      _isLoading = true;
      update();

      final db = await DatabaseHelper().database;
      final response = await db.query('recycleBinTable',
          orderBy: "date DESC,id DESC"); //orderBy: "id DESC"

      _isLoading = false;
      if (response.isNotEmpty) {
        _shoppingNoteRecycleBinList = response
            .map((shoppingData) =>
                ShoppingNoteRecycleBinModel.fromJson(shoppingData))
            .toList();

        update();
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      log("==============>Fetch shopping recycle bin data Error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
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
      final response = await db
          .query('shoppingNotesTable', where: 'id = ?', whereArgs: [id]);

      if (response.isNotEmpty) {
        ShoppingNoteRecycleBinModel _deletedShoppingNote =
            ShoppingNoteRecycleBinModel.fromJson(response.first);

        // Now delete the note
        final deleteShoppingResponse = await db
            .delete('shoppingNotesTable', where: 'id = ?', whereArgs: [id]);

        _isLoading = false;

        if (deleteShoppingResponse > 0) {
          await db.insert('recycleBinTable', _deletedShoppingNote.toJson());
          await db.update(
              'recycleBinTable', {'time': time, 'deletedDate': deletedDate},
              where: 'id = ?', whereArgs: [id]);

          _searchShoppingNoteList.removeWhere((element) => element.id == id);

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
      log("==============> Shopping delete data Error: $e");
      return false;
    } finally {
      await DatabaseHelper().closeDatabase();
    }
  }

  Future<bool> deleteRecycleBinData({required int id}) async {
    try {
      _isLoading = true;
      update();

      final db = await DatabaseHelper().database;

      // Retrieve the note before deleting it
      final response =
          await db.query('recycleBinTable', where: 'id = ?', whereArgs: [id]);

      if (response.isNotEmpty) {
        ShoppingNoteRecycleBinModel _deleteRecycleBinNote =
            ShoppingNoteRecycleBinModel.fromJson(response.first);

        // Now delete the note
        final deleteRecycleBinResponse = await db
            .delete('recycleBinTable', where: 'id = ?', whereArgs: [id]);

        _isLoading = false;

        if (deleteRecycleBinResponse > 0) {
          _shoppingNoteRecycleBinList
              .removeWhere((element) => element.id == id);

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
      final response = await db
          .rawDelete("DELETE FROM recycleBinTable"); // table name dataTable

      _isLoading = false;
      if (response > 0) {
        _shoppingNoteRecycleBinList.clear(); // Clear the local list
        AppToast.showNormalToast('All Shopping notes have been deleted.');
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

  Future<bool> restoreDeletedData({
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
    try {
      // Find the deleted note in _deleteNoteList
      //   ShoppingNoteRecycleBinModel? restoredNote = _shoppingNoteRecycleBinList.firstWhereOrNull((element) => element.id == id);

      _shoppingNoteModel = ShoppingNoteModel(
          time: time,
          date: date,
          title: title,
          capital: capital,
          remain: remain,
          itemTitles: itemTitles,
          prices: prices,
          totalCost: totalCost);

      final db = await DatabaseHelper().database;
      final insertResponse =
          await db.insert('shoppingNotesTable', _shoppingNoteModel.toJson());

      if (insertResponse > 0) {
        final deleteResponse = await db
            .delete('recycleBinTable', where: 'id = ?', whereArgs: [id]);
        if (deleteResponse > 0) {
          _shoppingNoteRecycleBinList.removeWhere((element) =>
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

  // Future<void> autoDeleteDataAfter10Minutes() async {
  //   try {
  //     final db = await DatabaseHelper().database;
  //
  //     // Calculate the date and time 10 minutes ago
  //     DateTime tenMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));
  //     String formattedTenMinutesAgo = DateFormat("dd-MMM-yyyy").format(tenMinutesAgo);
  //
  //     // Retrieve items in the data table older than 10 minutes
  //     final oldTimeItems = await db.query('trashTable', where: 'time < ?', whereArgs: [formattedTenMinutesAgo]);
  //
  //     // Delete the old items
  //     for (final oldItem in oldTimeItems) {
  //       // Modify this part based on your data model
  //       final oldDataModel = TrashNoteModel.fromJson(oldItem);
  //       await db.delete('trashTable', where: 'id = ?', whereArgs: [oldDataModel.id]);
  //     }
  //
  //     // Update the local data list
  //     // Modify this part based on your data model
  //     _trashNotesList.removeWhere((element) => oldTimeItems.any((item) => item['id'] == element.id));
  //
  //     update();
  //   } catch (e) {
  //     log("==============>Auto Delete Data Error: $e");
  //   }
  // }
}
