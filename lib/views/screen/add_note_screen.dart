import 'dart:async';

import 'package:bachelor_notes/controller/fetch_data_controller.dart';
import 'package:bachelor_notes/controller/add_data_controller.dart';
import 'package:bachelor_notes/utils/app%20toast.dart';
import 'package:bachelor_notes/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _dateTEController = TextEditingController();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _noteTEController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TimeOfDay? _selectedTime;
  late String _time;

  void _startClock() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddDataController>(builder: (_insertDataController) {
      return Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 44, 32, 32),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 44, 32, 32),
            leading: GestureDetector(
              onTap:(){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios,size: 18.0,color: AppColors.yellowColor,),
            ),
            titleSpacing: 0.0,
            title: const Text(
              "Add Notes",
              style: TextStyle(
                  fontSize: 20.0, letterSpacing: 0.5, color: Colors.yellow),
            ),
            actions: [
              GestureDetector(
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) {
                      return null;
                    }
                    final response = await _insertDataController.insertData(
                        date: _dateTEController.text.trim(),
                        title: _titleTEController.text.trim(),
                        note: _noteTEController.text.trim(),
                        time: _time.trim());
                    if (response == true) {

                      AppToast.showNormalToast(AppToast.added);

                      Future.delayed(const Duration(seconds: 2)).then((value) {
                        Navigator.pop(context);
                        Get.find<FetchDataController>().fetchData();
                      });
                    } else {
                      AppToast.showNormalToast(AppToast.notAdded);
                    }
                  },
                  child: const Icon(
                    Icons.check,
                    color: Colors.white60,
                  )),
              const SizedBox(
                width: 20,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(
                top: 0, left: 16.0, right: 16, bottom: 16),
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
                      style: const TextStyle(
                        fontSize: 16.0,
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
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _dateTEController,
                  minLines: 1,
                  readOnly: true,
                  cursorColor: Colors.white60,
                  style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                  decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.white60,
                      ),
                      hintText: 'Date',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 22.0,
                      ),
                      border: InputBorder.none),
                  onTap: () {
                    _selectDate();
                  },
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return "This field is mandatory";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _titleTEController,
                  minLines: 1,
                  maxLines: 4,
                  cursorColor: AppColors.yellowColor,
                  style: const TextStyle(color: Colors.white60),
                  decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 22.0,
                      ),
                      border: InputBorder.none),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return "This field is mandatory";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _noteTEController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  cursorColor: AppColors.yellowColor,
                  style: const TextStyle(color: Colors.white60),
                  decoration: const InputDecoration(
                      hintText: 'Note',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 18.0,
                      ),
                      border: InputBorder.none),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _selectDate() async {
    DateTime? _picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (_picker != null) {
      String formattedDate = DateFormat("dd-MMM-yyyy").format(_picker);
      _dateTEController.text = formattedDate.toString();
      setState(() {});
    }
  }
}
