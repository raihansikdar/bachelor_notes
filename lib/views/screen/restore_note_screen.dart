import 'dart:async';
import 'dart:developer';

import 'package:bachelor_notes/controller/fetch_data_controller.dart';
import 'package:bachelor_notes/utils/app%20toast.dart';
import 'package:bachelor_notes/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RestoreNoteScreen extends StatefulWidget {
  final int id;
  final String date;
  final String title;
  final String note;
  const RestoreNoteScreen(
      {Key? key,
      required this.id,
      required this.date,
      required this.title,
      required this.note})
      : super(key: key);

  @override
  State<RestoreNoteScreen> createState() => _RestoreNoteScreenState();
}

class _RestoreNoteScreenState extends State<RestoreNoteScreen> {
  final TextEditingController _dateTEController = TextEditingController();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _noteTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // bool _trash = false;

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
    _dateTEController.text = widget.date;
    _titleTEController.text = widget.title;
    _noteTEController.text = widget.note;
    log("Restore id: ${widget.id}");

    _startClock();
    _updateCurrentDate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 44, 32, 32),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 44, 32, 32),
          title: const Text(
            "Restore Note",
            style: TextStyle(
                fontSize: 20.0, letterSpacing: 0.5, color: Colors.yellow),
          ),
          actions: [
            Row(
              children: [
                GetBuilder<FetchDataController>(
                    builder: (_fetchDataController) {
                  return GestureDetector(
                      onTap: () async {
                        final response =
                            await _fetchDataController.deleteTrashData(
                          id: widget.id,
                        );
                        if (response == true) {
                          _dateTEController.clear();
                          _titleTEController.clear();
                          _noteTEController.clear();

                          AppToast.showWrongToast(AppToast.permanentlyDelete);

                          Future.delayed(const Duration(seconds: 2))
                              .then((value) {
                            Navigator.pop(context);
                            Get.find<FetchDataController>().fetchData();
                          });
                        } else {
                          AppToast.showWrongToast(
                              AppToast.notPermanentlyDelete);
                        }
                      },
                      child: Icon(
                        Icons.delete,
                        color: AppColors.yellowColor,
                      ));
                }),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                    onTap: () async {
                      final response = await Get.find<FetchDataController>()
                          .restoreDeletedData(
                              id: widget.id,
                              date: _dateTEController.text.trim(),
                              title: _titleTEController.text.trim(),
                              note: _noteTEController.text.trim(),
                              time: _time.trim());
                      if (response == true) {
                        AppToast.showNormalToast(AppToast.restored);
                        Future.delayed(const Duration(seconds: 2))
                            .then((value) {
                          Navigator.pop(context);
                          Get.find<FetchDataController>().fetchTrashData();
                        });
                      } else {
                        AppToast.showWrongToast(AppToast.notRestored);
                      }
                    },
                    child: const Icon(
                      Icons.restore,
                      color: Colors.white60,
                    )),
              ],
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 0, left: 16.0, right: 16, bottom: 16),
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
                    _selectedTime?.format(context) ?? 'Please wait',
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
                style: TextStyle(color: AppColors.yellowColor),
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
                  //_selectDate();
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
                readOnly: true,
                minLines: 1,
                maxLines: 4,
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
                readOnly: true,
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
  }
}
