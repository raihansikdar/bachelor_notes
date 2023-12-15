import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:bachelor_notes/controller/fetch_monthly_expanse_review_controller.dart';
import 'package:bachelor_notes/utils/app_colors.dart';
import 'package:bachelor_notes/utils/assets_path.dart';
import 'package:bachelor_notes/utils/custom_size_extension.dart';

class MonthlyExpenseReviewScreen extends StatefulWidget {
  final String firstDate;
  final String lastDate;
  const MonthlyExpenseReviewScreen({Key? key, required this.firstDate, required this.lastDate}) : super(key: key);

  @override
  State<MonthlyExpenseReviewScreen> createState() => _MonthlyExpenseReviewScreenState();
}

class _MonthlyExpenseReviewScreenState extends State<MonthlyExpenseReviewScreen> {



   @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<FetchMonthlyExpenseReviewController>().fetchRangeData(firstDate: widget.firstDate, lastDate: widget.lastDate);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        leading: GestureDetector(
          onTap:(){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,size: 18.0,color: AppColors.yellowColor,),
        ),
        titleSpacing: 0.0,
        title: Text("Monthly Expense Review Screen",
        style: TextStyle(
          fontSize: 20.rSp,
          color: AppColors.yellowColor
        ),
        ),
      ),
      body: GetBuilder<FetchMonthlyExpenseReviewController>(
        builder: (_fetchMonthlyExpenseReviewController) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 16),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text("${_fetchMonthlyExpenseReviewController.totalCapitalSum} tk",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text("Total Capital")
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text("${_fetchMonthlyExpenseReviewController.totalCostSum} tk",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                              const Text("Total Expense")
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text("${_fetchMonthlyExpenseReviewController.totalRemainderSum} tk",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text("Remainder")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                const ScrollLoopAutoScroll(
                    scrollDirection: Axis.horizontal, //required
                    delay: Duration(seconds: 1),
                    duration: Duration(seconds: 150),
                    gap: 25,
                    reverseScroll: false,
                    duplicateChild : 25,
                    enableScrollInput : true,
                    delayAfterScrollInput : Duration(seconds: 1),
                    child: Text("You can see all the note's calculation between date.",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: Colors.yellow),)
                ),
                const SizedBox(height: 10,),

                     Expanded(
                       child:_fetchMonthlyExpenseReviewController.shoppingNoteList.isEmpty ?
                       Center(
                         child: Column(
                           children: [
                             const SizedBox(height: 50,),
                             Image.asset(AssetsPath.noResultPNG,width: 150,),
                           ],
                         ),
                       )
                           : ListView.builder(
                        // shrinkWrap: true,
                        //   primary: false,
                          itemCount: _fetchMonthlyExpenseReviewController.shoppingNoteList.length,
                          itemBuilder: (context,index){
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                   //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.calendar_month),
                                        const SizedBox(width: 4,),
                                        Text(_fetchMonthlyExpenseReviewController.shoppingNoteList[index].date?? '',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(_fetchMonthlyExpenseReviewController.shoppingNoteList[index].title?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                      ),

                                    ),
                                    const SizedBox(height: 8.0,),
                                    Row(
                                      children: [
                                        const Text("Capital:",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        ),
                                        const Spacer(),
                                        Text("${_fetchMonthlyExpenseReviewController.shoppingNoteList[index].capital} tk",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4,),
                                    Row(
                                      children: [
                                        const Text("Expense:",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text("${_fetchMonthlyExpenseReviewController.shoppingNoteList[index].totalCost} tk",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(thickness: 2,color: Colors.black54,),
                                    Row(
                                      children: [
                                        const Text("Remainder:",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),

                                        Text("${_fetchMonthlyExpenseReviewController.shoppingNoteList[index].remain} tk" ,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4,),
                                  ],

                                ),
                              ),

                            );
                          }),
                     ),

              ],
            ),
          );
        }
      ),
    );
  }


}
