import 'dart:async';
import 'dart:developer';

import 'package:bachelor_notes/controller/auto_delete_controller.dart';
import 'package:bachelor_notes/controller/fetch_data_controller.dart';
import 'package:bachelor_notes/utils/app%20toast.dart';
import 'package:bachelor_notes/utils/app_colors.dart';
import 'package:bachelor_notes/utils/assets_path.dart';
import 'package:bachelor_notes/views/screen/restore_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:bachelor_notes/views/widgets/basic_recyclebin_note_data_widget.dart';

class RecycleBinScreen extends StatefulWidget {
  const RecycleBinScreen({Key? key}) : super(key: key);

  @override
  State<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {


  // late Timer _autoDeleteTimer;
  // void startAutoDeleteTimer() {
  //   _autoDeleteTimer = Timer.periodic(const Duration(minutes: 2), (Timer timer) async {
  //     await Get.find<FetchDataController>().autoDeleteDataAfter10Minutes();
  //   });
  // }
  @override
  void initState() {
   // startAutoDeleteTimer();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<FetchDataController>().fetchTrashData();
      Get.find<AutoDeleteController>().startAutoDeleteTimer();
    });

    super.initState();
  }

  @override
  void dispose() {
   // _autoDeleteTimer.cancel();
    Get.find<AutoDeleteController>().cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 32, 32),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 32, 32),
        leading: GestureDetector(
          onTap:(){
            Get.find<FetchDataController>().fetchData();
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,size: 18.0,color: AppColors.yellowColor,),
        ),
        titleSpacing: 0.0,
        title: const Text("Recycle bin", style: TextStyle(fontSize: 20.0,letterSpacing: 0.5, color:Colors.yellow),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Get.find<FetchDataController>().trashNotesList.isEmpty ? AppToast.showNormalToast('Recycle bin is already empty.')
                    :  showDialog(context: context, builder: (context){

                      return AlertDialog(
                        backgroundColor: const Color.fromARGB(255, 56, 39, 39),
                        titlePadding: const EdgeInsets.only(top: 16,bottom: 8,left: 16,right: 16),
                        title: const Text("Confirm Delete",style: TextStyle(fontSize: 20.0,letterSpacing: 0.6,fontWeight: FontWeight.w600,color: Colors.white),),
                        contentPadding: const EdgeInsets.symmetric(vertical:8,horizontal: 16.0),
                        content: const Text("Are you sure you want to delete all the notes from Recycle bin?",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w400,color: Colors.yellow),),
                       actions: [
                         ElevatedButton(onPressed: (){
                           Navigator.pop(context);
                         }, child: const Text("Cancel")),
                         ElevatedButton(onPressed: (){
                           Get.find<FetchDataController>().clearData();
                           Navigator.pop(context);
                         }, child: const Text("Delete")),
                       ],
                      );

                });

              },
              child: Card(
                color: const Color.fromARGB(255, 79, 71, 71),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child:  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_sweep,color: AppColors.yellowColor,size: 22,),
                      const SizedBox(width: 10,),
                      Text("Clear Recycle bin",
                        style: TextStyle(fontSize: 18.0,letterSpacing: 0.5, color: AppColors.titleColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0,),
            const ScrollLoopAutoScroll(
              scrollDirection: Axis.horizontal, //required
              delay: Duration(seconds: 1),
              duration: Duration(seconds: 150),
              gap: 25,
              reverseScroll: false,
              duplicateChild : 25,
              enableScrollInput : true,
              delayAfterScrollInput : Duration(seconds: 1),
              child: Text("All notes will be deleted permanently after 30 days.",
              style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  color: Colors.yellow),)
            ),
            const SizedBox(height: 8.0,),
            GetBuilder<FetchDataController>(
                builder: (_fetchDataController) {
                  if(_fetchDataController.isLoading){
                    return const Center(child: CircularProgressIndicator(color: Colors.white60,));
                  }
                  else if(_fetchDataController.trashNotesList.isEmpty){
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 50,),
                          Image.asset(AssetsPath.noResultPNG,width: 150,),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _fetchDataController.trashNotesList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                      ),
                      itemBuilder: (context, index) {
                        log(_fetchDataController.trashNotesList.length.toString());
                        return GestureDetector(
                          onTap: () {
                        Get.to(
                            () => RestoreNoteScreen(
                                  id: _fetchDataController.trashNotesList[index].id!,
                                  date: _fetchDataController.trashNotesList[index].date!,
                                  title: _fetchDataController.trashNotesList[index].title!,
                                  note: _fetchDataController.trashNotesList[index].note ?? '',),
                                      );
                          },
                          child: BasicRecycleBinNoteDataWidget(basicRecycleNoteData:_fetchDataController.trashNotesList[index] ,)
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
