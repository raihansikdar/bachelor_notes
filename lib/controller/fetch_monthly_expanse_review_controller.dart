import 'dart:developer';

import 'package:bachelor_notes/model/shopping_note_model.dart';
import 'package:get/get.dart';
import 'package:bachelor_notes/database/database_helper.dart';


class FetchMonthlyExpenseReviewController extends GetxController{

  bool _isLoading = false;
  List<ShoppingNoteModel> _shoppingNoteList = [];

  bool get isLoading => _isLoading;
  List<ShoppingNoteModel> get shoppingNoteList => _shoppingNoteList;

  double _totalCapitalSum = 0.00;
  double _totalCostSum = 0.00;
  double _totalRemainderSum = 0.00;

  double get totalCapitalSum => _totalCapitalSum;
  double get totalCostSum => _totalCostSum;
  double get totalRemainderSum => _totalRemainderSum;


  double calculateTotalCapitalSum(){
    double capitalSum = 0.00;
    for(var capital in _shoppingNoteList){
      capitalSum += capital.capital ?? 0.0;
    }
    return capitalSum;
  }

  double calculateTotalCostSum() {
    double costSum = 0.0;
    for (var totalCost in _shoppingNoteList) {
      costSum += totalCost.totalCost ?? 0.0;
    }
    return costSum;
  }

  double calculateRemanderSum(){
    double remainSum = 0.00;
    for(var remain in _shoppingNoteList){
      remainSum += remain.remain ?? 0.0;
    }
    return remainSum;
  }


  Future<bool> fetchRangeData({required String firstDate,required String lastDate}) async {
    try {
      _isLoading = true;
      update();


      final db = await DatabaseHelper().database;

      final response = await db.query('shoppingNotesTable',where: "date BETWEEN ? AND ?", whereArgs: [firstDate, lastDate], ); //orderBy: "id ASC"

      _isLoading = false;
      if (response.isNotEmpty) {
        _shoppingNoteList = response.map((shoppingData) => ShoppingNoteModel.fromJson(shoppingData)).toList();


        _totalCapitalSum = calculateTotalCapitalSum();
        _totalCostSum = calculateTotalCostSum();
         _totalRemainderSum = calculateRemanderSum();

        log(_shoppingNoteList.toString());
        update();
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      log("==============> Shopping fetch data error: $e");
      return false;
    }finally {
      await DatabaseHelper().closeDatabase();
    }
  }
}