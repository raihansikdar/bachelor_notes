import 'dart:async';
import 'package:bachelor_notes/controller/fetch_data_controller.dart';
import 'package:bachelor_notes/controller/my_drawer_controller.dart';
import 'package:bachelor_notes/utils/app_colors.dart';
import 'package:bachelor_notes/utils/assets_path.dart';
import 'package:bachelor_notes/utils/debouncer.dart';
import 'package:bachelor_notes/views/screen/add_note_screen.dart';
import 'package:bachelor_notes/views/screen/recyclebin_screen.dart';
import 'package:bachelor_notes/views/screen/update_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:bachelor_notes/views/widgets/basic_note_data_widget.dart';

class BasicNoteHomeScreen extends StatefulWidget {
  const BasicNoteHomeScreen({Key? key}) : super(key: key);

  @override
  State<BasicNoteHomeScreen> createState() => _BasicNoteHomeScreenState();
}

class _BasicNoteHomeScreenState extends State<BasicNoteHomeScreen> {
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
      Get.find<FetchDataController>().fetchData();
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
                "Basic Notes",
                style: TextStyle(fontSize: 23.0, color: Colors.yellow),
            ),
             ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              //Get.offAll(() => const ShoppingNoteHomeScreen());
             Navigator.pop(context);
            },
            child: Icon(Icons.shopping_cart, color: AppColors.yellowColor, size: 20),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: () {
              Get.to(() => const RecycleBinScreen());
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
             children: [
               Expanded(
                 child: SizedBox(
                   height: 56.0,
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
                         Get.find<FetchDataController>().searchNote(value);
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
                             Get.find<FetchDataController>().fetchData();
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
                   child: const Icon(Icons.calendar_month,color: Colors.white60,),
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
            GetBuilder<FetchDataController>(
                builder: (_fetchDataController) {
                  if(_fetchDataController.isLoading){
                    return const Center(child: CircularProgressIndicator(color: Colors.white60,));
                  }
                  else if(_fetchDataController.searchNoteList.isEmpty ){
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
                child: GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _fetchDataController.searchNoteList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                  ),
                  itemBuilder: (context, index) {

                    return GestureDetector(
                      onTap: () {
                        Get.to(() =>  UpdateNoteScreen(id:_fetchDataController.searchNoteList[index].id! ,date: _fetchDataController.searchNoteList[index].date!, title: _fetchDataController.searchNoteList[index].title!, note: _fetchDataController.searchNoteList[index].note!,));
                        _dateTEController.clear();
                        _changeText = false;
                        setState(() {});
                      },
                      child: BasicNoteDataWidget(basicNoteData: _fetchDataController.searchNoteList[index],),
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
          Get.to(() => const AddNoteScreen());
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

      Get.find<FetchDataController>().searchNote(formattedDate); //searchbar e searchValue fetch er jonno
    }
  }
}


