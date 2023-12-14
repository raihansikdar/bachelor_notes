import 'dart:async';

import 'package:shopping_notes/controller/fetch_shopping_data_controller.dart';
import 'package:shopping_notes/controller/my_drawer_controller.dart';
import 'package:shopping_notes/controller/transferData_controller.dart';
import 'package:shopping_notes/utils/app_colors.dart';
import 'package:shopping_notes/utils/assets_path.dart';
import 'package:shopping_notes/utils/custom_size_extension.dart';
import 'package:shopping_notes/utils/debouncer.dart';
import 'package:shopping_notes/views/screen/basic_note_home_screen.dart';
import 'package:shopping_notes/views/screen/add_shopping_note_screen.dart';
import 'package:shopping_notes/views/screen/monthy_expense_review_screen.dart';
import 'package:shopping_notes/views/screen/shopping_recyclebin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shopping_notes/views/screen/update_shopping_note_screen.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:shopping_notes/views/widgets/shopping_note_data_widget.dart';

class ShoppingNoteHomeScreen extends StatefulWidget {
  const ShoppingNoteHomeScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingNoteHomeScreen> createState() => _ShoppingNoteHomeScreenState();
}

class _ShoppingNoteHomeScreenState extends State<ShoppingNoteHomeScreen> {

  TextEditingController _dateTEController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 100);
  bool _changeText = false;
  bool _emptyPic = false;

  String _currentDate = "";
  void _currentDateToday() {
    setState(() {
      _currentDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<FetchShoppingDataController>().fetchData();
    });
    _currentDateToday();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        elevation: 2,
        title: Row(
          children: [
            GestureDetector(
                onTap: (){
                  Get.find<MyDrawerController>().toggleDrawer();
                },
                child: Image.asset(AssetsPath.appLogoPNG,height: 24,errorBuilder: (_,__,___){return const Icon(Icons.image);},)),
            const SizedBox(width: 10,),
            const Expanded(
              child: Text(
                "Shopping Notes",
                style: TextStyle(fontSize: 23, color: Colors.yellow),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showBottomSheet();
            },
            child: Icon(
              Icons.calendar_month,
              color: AppColors.yellowColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: () {
              Get.to(() => const BasicNoteHomeScreen());
            },
            child: Icon(
              Icons.edit,
              color: AppColors.yellowColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: () {
              Get.to(() => const ShoppingRecycleBinScreen());
            },
            child: Icon(Icons.auto_delete, color: AppColors.yellowColor, size: 20),
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: TextFormField(
                      controller: _dateTEController,
                      onChanged: (String value) {
                        if (value.isNotEmpty) {
                          _changeText = true;
                          _emptyPic = true;

                        } else {
                          _changeText = false;
                          _emptyPic = false;
                        }
                        setState(() {});
                        _debouncer.run(() {
                          Get.find<FetchShoppingDataController>().searchShoppingNote(value);
                        });
                      },
                      style: const TextStyle(color: Colors.white60),
                      decoration: InputDecoration(
                          contentPadding:  const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.textFormFieldFillColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: AppColors.textFormFieldBorderSideColor, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: AppColors.textFormFieldBorderSideColor, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: AppColors.textFormFieldBorderSideColor, width: 2),
                          ),
                          hintStyle:  const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              color: Colors.white60
                          ),
                          prefixIcon:  const Icon(Icons.search,color: Colors.white60,size: 20,),
                          hintText:'Search note',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _dateTEController.clear();
                              _changeText = false;
                              _emptyPic = false;
                              Get.find<FetchShoppingDataController>().fetchData();
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: Center(
                                child: _changeText ?   Icon(Icons.close, size: 20,color: AppColors.textfieldColor,) : null,
                              ),
                            ),

                          )
                      ),

                    ),
                  ),
                ),
                const SizedBox(width: 20.0,),
                GestureDetector(
                  onTap: (){
                    _selectDate();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.calendar_month,color: Colors.white60,),
                  ),
                ),
                const SizedBox(width: 8.0,),
              ],
            ),
            const SizedBox(height: 5,),
            ScrollLoopAutoScroll(
              scrollDirection: Axis.horizontal, //required
              delay: const Duration(seconds: 1),
              duration: const Duration(seconds: 150),
              gap: 25,
              reverseScroll: false,
              duplicateChild : 25,
              enableScrollInput : true,
              delayAfterScrollInput : const Duration(seconds: 1),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "Welcome to Shopping Notes.",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: Colors.yellow,
                        )
                    ),
                    TextSpan(
                        text: " You can add, modify and search your notes here.",
                        style:  TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: Colors.yellow,
                        )
                    ),
                  ],
                ),
              ),

            ),

            const SizedBox(
              height: 10.0,
            ),
            GetBuilder<FetchShoppingDataController>(
                builder: (_fetchShoppingDataController) {
                  if(_fetchShoppingDataController.isLoading){
                    return const Center(child: CircularProgressIndicator(color: Colors.white60,));
                  }
                  else if(_fetchShoppingDataController.searchShoppingNoteList.isEmpty ){
                    return  Center(
                      child: _emptyPic ? Column(
                        children: [
                          const SizedBox(height: 50,),
                          Image.asset(AssetsPath.noResultPNG,width: 150,),
                        ],
                      ) : null,
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _fetchShoppingDataController.searchShoppingNoteList.length,
                      itemBuilder: (context, index) {

                        return GestureDetector(
                          onTap: () {
                             Get.to(() =>  UpdateShoppingNoteScreen(
                                 id: _fetchShoppingDataController.searchShoppingNoteList[index].id!,
                                 title: _fetchShoppingDataController.searchShoppingNoteList[index].title!,
                                 date: _fetchShoppingDataController.searchShoppingNoteList[index].date!,
                                 capital: _fetchShoppingDataController.searchShoppingNoteList[index].capital!,
                                 remain: _fetchShoppingDataController.searchShoppingNoteList[index].remain!,
                                 itemTitles: _fetchShoppingDataController.searchShoppingNoteList[index].itemTitles!,
                                 prices: _fetchShoppingDataController.searchShoppingNoteList[index].prices!,
                                 totalCost: _fetchShoppingDataController.searchShoppingNoteList[index].totalCost!,
                             ));
                            _dateTEController.clear();
                            _changeText = false;
                            setState(() {});
                          },
                          child: ShoppingNoteDataWidget(shoppingListData: _fetchShoppingDataController.searchShoppingNoteList[index],),
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Get.to(() => const AddShoppingNoteScreen());
          _dateTEController.clear();
          _changeText = false;
          setState(() {});
        },
        child: const Icon(Icons.add,color: Colors.black,),
      ),
    );
  }
  Future<void>_selectDate() async{
    DateTime? _picker = await showDatePicker(context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if(_picker != null){
      String formattedDate = DateFormat("dd-MMM-yyyy").format(_picker);
      _dateTEController.text = formattedDate.toString();

      // Trigger onChanged manually
      if (formattedDate.isNotEmpty) {
        _changeText = true;
      } else {
        _changeText = false;
      }
      setState(() {});


      Get.find<FetchShoppingDataController>().searchShoppingNote(formattedDate); //searchbar e date searchValue calender theke fetch er jonno
    }
  }

  void showBottomSheet(){
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.blueGrey,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            )
        ),
        context: context, builder: (context){
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 300,

          child: Padding(
            padding: const EdgeInsets.only(left: 24.0,right: 24.0,top: 30.0),
            child: Column(
              children: [
                SizedBox(
                  child: TextFormField(
                    controller: _firstDateTEController,
                    style: TextStyle(color: AppColors.titleColor,fontSize: 18),
                    cursorColor: AppColors.yellowColor,
                    readOnly: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white12,
                        hintText: 'From Date',
                        hintStyle: TextStyle(color: AppColors.titleColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16,horizontal: 12.0),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          _selectFirstDate();
                  },
                      child: Icon(Icons.calendar_month,color: AppColors.yellowColor,)),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                SizedBox(
                  child: TextFormField(
                    controller: _lastDateTEController,
                    style: TextStyle(color: AppColors.titleColor,fontSize: 18),
                    readOnly: true,
                    cursorColor: AppColors.yellowColor,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white12,
                        hintText: 'To Date',
                        hintStyle: TextStyle(color: AppColors.titleColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16,horizontal: 12.0),
                      suffixIcon: GestureDetector(
                          onTap: (){
                            _selectSecondDate();
                          },
                          child: Icon(Icons.calendar_month,color: AppColors.yellowColor,)),
                    ),

                  ),
                ),
               SizedBox(height: 30.rh),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellowColor,
                      ),
                      onPressed: () {
                        _firstDateTEController.clear();
                        _lastDateTEController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel",
                      style: TextStyle(
                        color: AppColors.appBackgroundColor,
                      ),
                      ),
                    ),

                    const SizedBox(width: 20.0),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        DateTime? parseDate(String date) {
                          try {
                            return DateFormat("dd-MMM-yyyy").parseStrict(date);
                          } catch (e) {
                            return null;
                          }
                        }
                        String firstDate = _firstDateTEController.text.trim();
                        String lastDate = _lastDateTEController.text.trim();

                        // DateTime? firstDateTime = DateTime.tryParse(firstDate);
                        // DateTime? lastDateTime = DateTime.tryParse(lastDate);
                        DateTime? firstDateTime = parseDate(firstDate);
                        DateTime? lastDateTime = parseDate(lastDate);

                        // Check if both dates are non-null
                        if (firstDateTime != null && lastDateTime != null) {
                          if (firstDateTime.isBefore(lastDateTime)) {
                            Get.to(() => MonthlyExpenseReviewScreen(
                              firstDate: firstDate,
                              lastDate: lastDate,
                            ))!.then((value) {
                              _firstDateTEController.clear();
                              _lastDateTEController.clear();
                              Navigator.pop(context);
                            });
                          } else {
                            Get.snackbar(
                              'Invalid date range',
                              'Please make sure the first date is less than last date.',
                              colorText: AppColors.titleColor,
                              backgroundColor: Colors.red.withOpacity(0.7),
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Date field is Blank',
                            'Please fill blank field with valid date.',
                            colorText: AppColors.titleColor,
                            backgroundColor: Colors.red.withOpacity(0.7),
                          );
                        }
                      },
                      child: const Text("Submit"),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
  TextEditingController _firstDateTEController = TextEditingController();
  TextEditingController _lastDateTEController = TextEditingController();

  Future<void>_selectFirstDate() async{
    DateTime? _picker = await showDatePicker(context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if(_picker != null){
      String formattedDate = DateFormat("dd-MMM-yyyy").format(_picker);
      _firstDateTEController.text = formattedDate.toString();
      setState(() {});
    }
  }
  Future<void> _selectSecondDate() async{
    DateTime? _picker = await showDatePicker(context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if(_picker != null){
      String formattedDate = DateFormat("dd-MMM-yyyy").format(_picker);
      _lastDateTEController.text = formattedDate.toString();
      setState(() {});
    }
  }
}

