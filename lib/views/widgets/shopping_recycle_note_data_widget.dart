import 'package:flutter/material.dart';
import 'package:shopping_notes/model/shopping_note_model.dart';
import 'package:shopping_notes/model/shopping_note_recyclebin_model.dart';
import 'package:shopping_notes/utils/app_colors.dart';
import 'package:shopping_notes/utils/custom_size_extension.dart';

class ShoppingRecycleBinNoteDataWidget extends StatelessWidget {
  final ShoppingNoteRecycleBinModel shoppingRecycleBinListData;

  const ShoppingRecycleBinNoteDataWidget({
    super.key, required this.shoppingRecycleBinListData,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: Card(
            color: AppColors.textFormFieldFillColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: const BorderSide(
                  color: AppColors.textFormFieldBorderSideColor, width: 2.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0,bottom: 20,left: 12,right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height:60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: SizedBox(
                                width: 140.rw,
                                child: Text(
                                  shoppingRecycleBinListData.title ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    color: AppColors.titleColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0,top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.calendar_month,color: AppColors.textfieldColor,size: 16.0,),
                                  const SizedBox(width: 4.0,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Text(
                                      shoppingRecycleBinListData.date ?? ' ',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                        color: AppColors.textfieldColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Capital: ",
                                  overflow: TextOverflow.ellipsis,
                                  // maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    color: AppColors.textfieldColor,
                                  ),
                                ),

                                Text(
                                  "${shoppingRecycleBinListData.capital} tk",
                                  overflow: TextOverflow.ellipsis,
                                  // maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    color: AppColors.textfieldColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Remain: ",
                                  overflow: TextOverflow.ellipsis,
                                  ///maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    color: AppColors.textfieldColor,
                                  ),
                                ),
                                Text(
                                  "${shoppingRecycleBinListData.remain} tk",
                                  overflow: TextOverflow.ellipsis,
                                  //maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    color: AppColors.textfieldColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 4.0,
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: shoppingRecycleBinListData.itemTitles?.length ?? 0,
                    itemBuilder: (context,innerIndex){
                      final items = shoppingRecycleBinListData.itemTitles;
                      final price = shoppingRecycleBinListData.prices;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              color: Colors.black12,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${items?[innerIndex]}",
                                        style: TextStyle(
                                          color: AppColors.titleColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(" ${price?[innerIndex].toStringAsFixed(2)} tk",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.titleColor,
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ],
                      );
                    },),
                  const SizedBox(
                    height: 5,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: Colors.black12,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Total Cost :",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.yellowColor,
                                ),
                              ),
                              const Spacer(),
                              Text("${shoppingRecycleBinListData.totalCost?.toStringAsFixed(2)} tk",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.yellowColor,
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Positioned(
            right: 16,
            bottom: 8.5,
            child: Row(
              children: [
                Icon(Icons.access_time_filled_rounded,size: 14.0,color: AppColors.yellowColor,),
                const SizedBox(width: 4.0,),
                Text(
                  shoppingRecycleBinListData.time ?? '',
                  style:TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color:AppColors.yellowColor,
                  ),
                ),
              ],
            ))
      ],
    );
  }
}