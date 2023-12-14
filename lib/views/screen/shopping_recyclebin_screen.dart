import 'dart:async';

import 'package:shopping_notes/controller/fetch_shopping_data_controller.dart';
import 'package:shopping_notes/utils/app_colors.dart';
import 'package:shopping_notes/utils/assets_path.dart';
import 'package:shopping_notes/utils/custom_size_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_notes/views/screen/restore_shopping_note_screen.dart';

import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:shopping_notes/views/widgets/shopping_recycle_note_data_widget.dart';

class ShoppingRecycleBinScreen extends StatefulWidget {
  const ShoppingRecycleBinScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingRecycleBinScreen> createState() => _ShoppingRecycleBinScreenState();
}

class _ShoppingRecycleBinScreenState extends State<ShoppingRecycleBinScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<FetchShoppingDataController>().fetchShoppingRecycleBinData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        elevation: 2,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
              Get.find<FetchShoppingDataController>().fetchData();

            },
            child: const Icon(Icons.arrow_back,)),
        title: Row(
          children: [
            Text(
              "Shopping Recycle Bin",
              style: TextStyle(fontSize: 23.rSp, color: Colors.yellow),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(

          children: [
            GestureDetector(
              onTap: (){
                Get.find<FetchShoppingDataController>().shoppingNoteRecycleBinList.isEmpty ?
                Get.snackbar("Empty", "Recycle bin is already empty",colorText: Colors.white,icon: const Icon(Icons.delete_sweep,color: Colors.white,size: 30,))
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
                        Get.find<FetchShoppingDataController>().clearData();
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
            const SizedBox(height: 12.0,),
            const ScrollLoopAutoScroll(
              scrollDirection: Axis.horizontal,
              //required
              delay: Duration(seconds: 1),
              duration: Duration(seconds: 150),
              gap: 25,
              reverseScroll: false,
              duplicateChild: 25,
              enableScrollInput: true,
              delayAfterScrollInput: Duration(seconds: 1),
                child: Text("All notes will be deleted permanently after 30 days.",
                  style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      color: Colors.yellow),
                ),

            ),
            const SizedBox(
              height: 10.0,
            ),
            GetBuilder<FetchShoppingDataController>(
                builder: (_fetchShoppingDataController) {
                  if (_fetchShoppingDataController.isLoading) {
                    return const Center(child: CircularProgressIndicator(
                      color: Colors.white60,));
                  }
                  else if (_fetchShoppingDataController.shoppingNoteRecycleBinList
                      .isEmpty) {
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _fetchShoppingDataController
                          .shoppingNoteRecycleBinList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(()=> RestoreShoppingNoteScreen(
                                id: _fetchShoppingDataController.shoppingNoteRecycleBinList[index].id!,
                                title: _fetchShoppingDataController.shoppingNoteRecycleBinList[index].title!,
                                date: _fetchShoppingDataController.shoppingNoteRecycleBinList[index].date!,
                                capital: _fetchShoppingDataController.shoppingNoteRecycleBinList[index].capital!,
                                remain: _fetchShoppingDataController.shoppingNoteRecycleBinList[index].remain!,
                                itemTitles: _fetchShoppingDataController.shoppingNoteRecycleBinList[index].itemTitles!,
                                prices: _fetchShoppingDataController.shoppingNoteRecycleBinList[index].prices!,
                                totalCost: _fetchShoppingDataController.shoppingNoteRecycleBinList[index].totalCost!,
                            ),
                            );
                          },
                          child: ShoppingRecycleBinNoteDataWidget(shoppingRecycleBinListData: _fetchShoppingDataController.shoppingNoteRecycleBinList[index],)
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