import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast{
  AppToast._();
  static void showNormalToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      //backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showWrongToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  static String added = 'Note has been added.';
  static String notAdded = 'Note not added.';
  static String updated = 'Note has been updated.';
  static String notUpdated = 'Note not updated.';
  static String deleted = 'Note has been deleted.';
  static String notDeleted = 'Note not deleted.';
  static String restored = 'Note has been restored.';
  static String notRestored = 'Note not restored.';
  static String permanentlyDelete = 'Note has been delete permanently.';
  static String notPermanentlyDelete = 'Note not delete permanently.';
  static String empty = 'Recycle bin is already empty.';
}