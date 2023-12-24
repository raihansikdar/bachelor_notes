import 'dart:async';

import 'package:bachelor_notes/utils/app%20toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:bachelor_notes/controller/fetch_shopping_data_controller.dart';
import 'package:bachelor_notes/utils/app_colors.dart';
import 'package:bachelor_notes/utils/custom_size_extension.dart';

class RestoreShoppingNoteScreen extends StatefulWidget {
  final int id;
  final String title;
  final String date;
  final double capital;
  final double remain;
  final List<String>? itemTitles;
  final List<double>? prices;
  final double totalCost;
  const RestoreShoppingNoteScreen(
      {Key? key,
      required this.id,
      required this.title,
      required this.date,
      required this.capital,
      required this.remain,
      this.itemTitles,
      this.prices,
      required this.totalCost})
      : super(key: key);

  @override
  State<RestoreShoppingNoteScreen> createState() =>
      _RestoreShoppingNoteScreenState();
}

class _RestoreShoppingNoteScreenState extends State<RestoreShoppingNoteScreen> {
  List<TextEditingController> _itemTitleControllerList = [
    TextEditingController()
  ];
  List<TextEditingController> _priceControllerList = [TextEditingController()];

  final TextEditingController _dateTEController = TextEditingController();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _capitalTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double totalCost = 0.00;
  double remain = 0.00;

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

  String _formatPrice(double price) {
    return NumberFormat.currency(decimalDigits: 2, symbol: '').format(price);
  }

  @override
  void initState() {
    _titleTEController.text = widget.title;
    _dateTEController.text = widget.date;
    _capitalTEController.text = widget.capital.toString();
    _itemTitleControllerList = widget.itemTitles
            ?.map((title) => TextEditingController(text: title))
            .toList() ??
        [TextEditingController()];
    _priceControllerList = widget.prices
            ?.map((price) => TextEditingController(text: price.toString()))
            .toList() ??
        [TextEditingController()];
    totalCost = widget.totalCost;
    remain = widget.remain;

    _startClock();
    _updateCurrentDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FetchShoppingDataController>(
        builder: (_fetchShoppingDataController) {
      return Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.appBackgroundColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 18.0,
              color: AppColors.yellowColor,
            ),
          ),
          titleSpacing: 0.0,
          title: const Text(
            "Restore Notes",
            style: TextStyle(
                fontSize: 18.0, letterSpacing: 0.5, color: Colors.yellow),
          ),
          actions: [
            GestureDetector(
                onTap: () async {
                  final response = await _fetchShoppingDataController
                      .deleteRecycleBinData(id: widget.id);
                  if (response == true) {
                    _dateTEController.clear();
                    _titleTEController.clear();
                    _itemTitleControllerList.clear();
                    _priceControllerList.clear();
                    totalCost = 0.00;

                    AppToast.showWrongToast(AppToast.permanentlyDelete);

                    Future.delayed(const Duration(seconds: 2)).then((value) {
                      Navigator.pop(context);
                      Get.find<FetchShoppingDataController>().fetchData();
                    });
                  } else {
                    AppToast.showWrongToast(AppToast.notPermanentlyDelete);
                  }
                },
                child: Icon(
                  Icons.delete,
                  color: AppColors.yellowColor,
                )),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
                onTap: () async {
                  // Extract data from dynamic text fields
                  List<String>? itemTitles = [];
                  List<double>? prices = [];

                  for (int i = 0; i < _itemTitleControllerList.length; i++) {
                    itemTitles.add(_itemTitleControllerList[i].text.trim());
                    prices
                        .add(double.parse(_priceControllerList[i].text.trim()));
                  }

                  // Insert data into the database
                  final response =
                      await _fetchShoppingDataController.restoreDeletedData(
                    id: widget.id,
                    time: _time.trim(),
                    date: _dateTEController.text.trim(),
                    title: _titleTEController.text.trim(),
                    capital: double.parse(_capitalTEController.text.trim()),
                    remain: remain,
                    itemTitles: itemTitles,
                    prices: prices,
                    totalCost: totalCost,
                  );

                  if (response == true) {
                    AppToast.showNormalToast(AppToast.restored);

                    Future.delayed(const Duration(seconds: 2)).then((value) {
                      Navigator.pop(context);
                      Get.find<FetchShoppingDataController>()
                          .fetchShoppingRecycleBinData();
                    });
                  } else {
                    AppToast.showWrongToast(AppToast.notRestored);
                  }
                },
                child: const Icon(
                  Icons.restore,
                  color: Colors.white60,
                )),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 12),
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
                      const SizedBox(
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
                        hintText: 'Select Date',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: 18.0,
                        ),
                        border: InputBorder.none),
                  ),
                  TextFormField(
                    controller: _titleTEController,
                    minLines: 1,
                    maxLines: 4,
                    readOnly: true,
                    cursorColor: AppColors.yellowColor,
                    style: const TextStyle(color: Colors.white60),
                    decoration: const InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: 22.0,
                        ),
                        border: InputBorder.none),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 180.rw,
                        height: 60,
                        child: TextFormField(
                          controller: _capitalTEController,
                          minLines: 1,
                          maxLines: 4,
                          readOnly: true,
                          cursorColor: AppColors.yellowColor,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 20.0,
                          ),
                          decoration: const InputDecoration(
                              hintText: 'Capital tk',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 22.0,
                              ),
                              contentPadding: EdgeInsets.only(top: 10),
                              border: InputBorder.none),
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
                              child: Text(
                                '${remain.toStringAsFixed(2)} tk',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //  SizedBox(width: 40.rSp,),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _itemTitleControllerList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.yellow,
                              controller: _itemTitleControllerList[index],
                              readOnly: true,
                              style: TextStyle(
                                  color: AppColors.titleColor, fontSize: 18),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white12,
                                  hintText: 'Item title',
                                  hintStyle:
                                      TextStyle(color: AppColors.titleColor),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12.0)),
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return "This field remain blank";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _priceControllerList[index],
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.yellow,
                              style: TextStyle(
                                  color: AppColors.titleColor, fontSize: 18),
                              readOnly: true,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white12,
                                  hintText: 'tk',
                                  hintStyle:
                                      TextStyle(color: AppColors.titleColor),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12.0)),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return "Blank field";
                                }
                                int? intValue = int.tryParse(value!);

                                if (intValue == null) {
                                  return "Give number";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 180.rw,
                        child: const Card(
                          elevation: 4,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Total Cost : ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${totalCost.toStringAsFixed(2)} tk',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
