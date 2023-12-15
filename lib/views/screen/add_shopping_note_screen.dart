import 'dart:async';
import 'dart:developer';


import 'package:bachelor_notes/utils/app%20toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bachelor_notes/controller/add_shoping_data_controller.dart';
import 'package:bachelor_notes/controller/fetch_shopping_data_controller.dart';
import 'package:bachelor_notes/utils/app_colors.dart';
import 'package:bachelor_notes/utils/custom_size_extension.dart';

import '../../utils/assets_path.dart';

class AddShoppingNoteScreen extends StatefulWidget {
  const AddShoppingNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddShoppingNoteScreen> createState() => _AddShoppingNoteScreenState();
}

class _AddShoppingNoteScreenState extends State<AddShoppingNoteScreen> {
  List<TextEditingController> _itemTitleControllerList = [TextEditingController()];
  List<TextEditingController> _priceControllerList = [TextEditingController()];


  TextEditingController _dateTEController = TextEditingController();
  TextEditingController _titleTEController = TextEditingController();
  TextEditingController _capitalTEController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double result = 0.00;
  double remain = 0.00;

  double calculateTotalCost(){
   double totalCost = 0.0;

   for(int i =0; i<_priceControllerList.length;i++){
     String priceText = _priceControllerList[i].text.trim();
     if(priceText.isNotEmpty){
       double price = double.parse(priceText);
       totalCost += price;
     }
   }
   return totalCost;
 }

 double calculateRemainder(){
   double totalCost = 0.0;
   double remainder = 0.00;
   String capitalText = _capitalTEController.text.trim();

   for(int i =0; i<_priceControllerList.length;i++){
     double totalCost = calculateTotalCost();
     if(capitalText.isNotEmpty){
       double capital = double.parse(capitalText);
       remainder = capital - totalCost;
     }
   }
   return remainder;

 }



   TimeOfDay? _selectedTime;
   late String _time;

  void _startClock(){
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if(mounted){
        final DateTime now = DateTime.now();
        _selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
        _time = _selectedTime?.format(context).toString() ?? 'null';
        setState(() {});
      }
    });
  }

  String _currentDate = "";
  void _updateCurrentDate() {
    setState(() {
      // Get the current date and format it
      _currentDate = DateFormat("dd/MMM/yyyy").format(DateTime.now());
    });
  }

  @override
  void initState() {
    _startClock();
    _updateCurrentDate();
    calculateRemainder();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddShoppingDataController>(
      builder: (_addShoppingDataController) {
        return Scaffold(
          backgroundColor: AppColors.appBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: AppColors.appBackgroundColor,
            leading: GestureDetector(
              onTap:(){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios,size: 18.0,color: AppColors.yellowColor,),
            ),
            titleSpacing: 0.0,
            title: Text("Add Shopping Notes", style: TextStyle(fontSize: 20.rSp,letterSpacing: 0.5, color: Colors.yellow),),
            actions: [

              GestureDetector(onTap: () async{
                if(!_formKey.currentState!.validate()){
                  return null;
                }
                // Extract data from dynamic text fields
                List<String>? itemTitles = [];
                List<double>? prices = [];

                for (int i = 0; i < _itemTitleControllerList.length; i++) {
                  itemTitles.add(_itemTitleControllerList[i].text.trim());
                  prices.add(double.parse(_priceControllerList[i].text.trim()));
                }

                // Calculate total cost
                double totalCost = calculateTotalCost();

                final response = await _addShoppingDataController.insertData(
                  time: _time.trim(),
                  date: _dateTEController.text.trim(),
                  title: _titleTEController.text.trim(),
                  capital: double.parse(_capitalTEController.text.trim()),
                  remain: remain,
                  itemTitles: itemTitles,
                  prices: prices,
                  totalCost: totalCost,
                );

                if(response == true){

                  AppToast.showNormalToast(AppToast.added);

                   Future.delayed(const Duration(seconds: 2)).then((value) {
                    Navigator.pop(context);
                    Get.find<FetchShoppingDataController>().fetchData();
                  });

                }else{
                  AppToast.showNormalToast(AppToast.notAdded);
                }
              }, child: const Icon(Icons.check,color: Colors.white60,)),
              const SizedBox(width: 20,)
            ],

          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:  const EdgeInsets.only(top: 0,left: 12,right: 12,bottom: 12),
              child: Form(
                key: _formKey,
                child: Column(

                  children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 16.0,
                          color: Colors.white60,
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          _currentDate,
                          style: TextStyle(
                            fontSize: 16.rSp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Icon(
                          Icons.access_time_filled_rounded,
                          size: 16.0,
                          color: Colors.white60,
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          _selectedTime?.format(context) ?? "Please wait",
                          style: TextStyle(
                            fontSize: 16.rSp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10,)
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      controller: _dateTEController,
                      minLines: 1,
                      readOnly: true,
                      cursorColor: AppColors.yellowColor,
                      style: const TextStyle(color: Colors.white60),
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_month,color: Colors.white60,),
                          hintText: 'Select Date',
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 22.0,),
                          border: InputBorder.none
                      ),
                      onTap: (){
                        _selectDate();
                      },

                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "This field is mandatory";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _titleTEController,
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],

                      cursorColor: AppColors.yellowColor,
                      style: const TextStyle(color: Colors.white60),
                      decoration: const InputDecoration(
                          hintText: 'Day title',
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 22.0,),
                          border: InputBorder.none
                      ),
                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "This field is mandatory";
                        }
                        return null;
                      },
                    ),
                   //SizedBox(height: 10,),
                   Row(
                     children: [
                       SizedBox(
                         width:180.rw,
                         height: 60,
                         child: TextFormField(
                           controller: _capitalTEController,
                           minLines: 1,
                           maxLines: 4,
                           cursorColor: AppColors.yellowColor,
                           keyboardType: TextInputType.number,
                           style: const TextStyle(color: Colors.white60,fontSize: 20.0,),
                           inputFormatters: [LengthLimitingTextInputFormatter(10)],
                           decoration: const InputDecoration(
                               hintText: 'Capital tk',
                               hintStyle: TextStyle(color: Colors.white54, fontSize: 22.0,),
                               contentPadding: EdgeInsets.only(top: 10),
                               border: InputBorder.none
                           ),
                           onChanged: (String value){
                             if(value.isNotEmpty){
                               setState(() {
                                 remain = double.parse(_capitalTEController.text.trim());
                                 result = calculateTotalCost();
                                 remain = calculateRemainder();
                               });
                             }else{
                               remain = 0.00;
                               setState(() {});
                             }

                           },
                           validator: (String? value){

                             if(value?.isEmpty ?? true){
                               return "This field is mandatory";
                             }
                             double? doubleValue = double.tryParse(value!);

                             if(doubleValue == null){
                               return "Provide number";
                             }
                             return null;
                           },

                         ),
                       ),
                       const SizedBox(width: 6.0),
                       Expanded(
                         child: SizedBox(
                           height: 50,
                           child: Card(
                             elevation: 0,
                             color: Colors.white12,
                             child: Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Text('${remain.toStringAsFixed(2)} tk',
                                 overflow: TextOverflow.ellipsis,
                                 maxLines: 1,
                                 style: const TextStyle(
                                     fontSize: 18,
                                     fontWeight: FontWeight.w400,
                                   color: Colors.white70
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ),
                     //  SizedBox(width: 40.rSp,),
                     ],
                   ),
                    const SizedBox(height: 16.0),

                    ListView.separated(
                       shrinkWrap: true,
                       primary: false,
                       itemCount: _itemTitleControllerList.length,
                       itemBuilder: (context,index){
                         return Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             SizedBox(
                               width:180.rw,
                               child: TextFormField(
                                 cursorColor: AppColors.yellowColor,
                                 controller: _itemTitleControllerList[index],
                                 inputFormatters: [LengthLimitingTextInputFormatter(15)],
                                 style: TextStyle(color: AppColors.titleColor,fontSize: 18),
                                 decoration: InputDecoration(
                                     filled: true,
                                     fillColor: Colors.white12,
                                     hintText: 'Item title',
                                     hintStyle: TextStyle(color: AppColors.titleColor),
                                     border: InputBorder.none,
                                   contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12.0)
                                 ),
                                 validator: (String? value){
                                   if(value?.isEmpty ?? true){
                                     return "This field is mandatory";
                                   }
                                   return null;
                                 },
                               ),
                             ),
                             const SizedBox(width: 10,),
                             Expanded(
                               child: Stack(
                                 children: [
                                   TextFormField(
                                     controller: _priceControllerList[index],
                                     inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                     keyboardType: TextInputType.number,
                                     cursorColor: AppColors.yellowColor,
                                     style: TextStyle(color: AppColors.titleColor,fontSize: 18),
                                     onChanged: (String value){
                                       if(value.isNotEmpty){
                                         result = calculateTotalCost();
                                         remain = calculateRemainder();
                                         setState(() {});
                                       }
                                       result = calculateTotalCost();
                                       remain = calculateRemainder();
                                       setState(() {});
                                     },
                                     decoration:  InputDecoration(
                                       filled: true,
                                         fillColor: Colors.white12,
                                         hintText:'tk',
                                       hintStyle: TextStyle(color: AppColors.titleColor),
                                       border: InputBorder.none,
                                         contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12.0)
                                     ),
                                    // enabled: isCapitalProvided,  // Set the enabled property based on isCapitalProvided

                                     validator: (String? value){
                                       if(value?.isEmpty ?? true){
                                         return "Field is blank ";
                                       }
                                       double? doubleValue = double.tryParse(value!);

                                       if(doubleValue == null){
                                         return "Provide number";
                                       }
                                       return null;
                                     },
                                   ),
                                   Positioned(
                                     right: 0,
                                     top:0,
                                     child: GestureDetector(
                                       onTap: (){
                                         if(index !=0){
                                           _itemTitleControllerList[index].clear();
                                           _priceControllerList[index].clear();

                                           _itemTitleControllerList[index].dispose();
                                           _priceControllerList[index].dispose();

                                           _itemTitleControllerList.removeAt(index);
                                           _priceControllerList.removeAt(index);

                                           remain = calculateRemainder();
                                           result = calculateTotalCost();

                                           setState(() {});
                                         }else{
                                           _itemTitleControllerList[index].clear();
                                           _priceControllerList[index].clear();
                                           remain = calculateRemainder();
                                           result = calculateTotalCost();

                                           setState(() {});
                                         }
                                       },
                                       child: Card(
                                           margin: EdgeInsets.zero,
                                           elevation: 10,
                                           color: AppColors.yellowColor,
                                           child: Padding(
                                         padding: const EdgeInsets.all(2.0),
                                         child: Icon(index == 0 ? Icons.close : Icons.delete, size: 18.rh,color: Colors.black,),
                                       )),
                                     ),
                                   )
                                 ],
                               ),
                             ),
                            const SizedBox(width: 5,),


                           ],
                         );
                      }, separatorBuilder: (context,index)=> const SizedBox(height: 10,), ),
                    const SizedBox(height: 20,),

                    Row(
                      children: [
                         SizedBox(
                           width: 180.rw,
                           child: Card(
                            elevation: 4,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Total Cost : ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                        ),
                         ),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('${result.toStringAsFixed(2)} tk',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        ),
                      //SizedBox(width: 40.rSp,),

                      ],

                    ),

                  ],
                ),
              ),
            ),
          ),


          floatingActionButton:FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: (){

            _itemTitleControllerList.add(TextEditingController());
            _priceControllerList.add(TextEditingController());

            setState(() {});
          },
          child: const Icon(Icons.add,color: AppColors.appBackgroundColor,),
          )
        );
      }
    );
  }
  Future<void>_selectDate() async{
    DateTime? _picker = await showDatePicker(context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if(_picker != null){
      String formatedDate = DateFormat("dd-MMM-yyyy").format(_picker);
      _dateTEController.text = formatedDate.toString();
      setState(() {});
    }
  }
}
