import 'package:bachelor_notes/utils/custom_size_extension.dart';
import 'package:flutter/material.dart';
import 'package:bachelor_notes/model/note_model.dart';
import 'package:bachelor_notes/utils/app_colors.dart';

class BasicNoteDataWidget extends StatelessWidget {
  final NoteModel basicNoteData;
  const BasicNoteDataWidget({
    super.key, required this.basicNoteData,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: AppColors.textFormFieldFillColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(
                color: AppColors.textFormFieldBorderSideColor, width: 2.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0,bottom:10,left: 10,right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          basicNoteData.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: AppColors.titleColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_month,color: AppColors.textfieldColor,size: 16.0,),
                    const SizedBox(width: 4.0,),
                    Text(
                      basicNoteData.date ?? ' ',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.textfieldColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    basicNoteData.note ?? '',
                    textAlign: TextAlign.justify,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style:TextStyle(
                      fontSize: 15.rSp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      wordSpacing: 0.3,
                      color: AppColors.notesColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 16,
            bottom: 8.5,
            child: Row(
              children: [
                Icon(Icons.access_time_filled_rounded,size: 14.0,color: AppColors.yellowColor,),
                const SizedBox(width: 4.0),
                Text(
                  basicNoteData.time ?? '',
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