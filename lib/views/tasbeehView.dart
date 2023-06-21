// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeehapp/controllers/setAlarmController.dart';
import 'package:tasbeehapp/controllers/tasbeehController.dart';
import 'package:tasbeehapp/controllers/tasbeehController.dart';
import 'package:tasbeehapp/models/alarmModel.dart';
import 'package:tasbeehapp/models/reportModel.dart';
import 'package:tasbeehapp/res/colors/app_color.dart';
import 'package:tasbeehapp/res/constants/constants.dart';
import 'package:tasbeehapp/sql_dbHandler/db_handler.dart';
import 'package:tasbeehapp/utils/appdrawer.dart';
import 'package:tasbeehapp/utils/themeContainer.dart';
import 'package:tasbeehapp/utils/utils.dart';
import 'package:tasbeehapp/views/aboutusView.dart';
import 'package:tasbeehapp/views/alarmView.dart';
import 'package:tasbeehapp/views/daroodView.dart';
import 'package:tasbeehapp/views/generatereportView.dart';

class TasbeehView extends StatefulWidget {
  const TasbeehView({super.key});

  @override
  State<TasbeehView> createState() => _TasbeehViewState();
}

class _TasbeehViewState extends State<TasbeehView> {
  final tasbeehController = Get.put(TasbeehController());
  TextEditingController count = TextEditingController();
  DBHelper? dbHelper;
  final alarmController = Get.put(SetAlarmController());
  late Future<List<AlarmModel>> alarms;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    alarms = dbHelper!.getAlarmdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: AppColor.blackColor,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Tasbeeh/Zikarr',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: AppColor.greyColor),
        ),
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: SizedBox(
        height: Constants.getHeight(context),
        width: Constants.getWidth(context),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ThemeContainer(
                    text:
                        'Abdullah bin Mas’ud narrated that :Allah\'s Messenger said: “The person closest to me on the Day of Judgement is the one who sent the most Salat upon me[Sunan al-Tirmidhī 484]'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Prayer',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: AppColor.redColor)),
                      Text('Time',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: AppColor.redColor))
                    ],
                  ),
                ),
                const Divider(thickness: 3),
                InkWell(
                  onTap: () {
                    Get.off(() => const AlarmView(),
                        transition: Transition.rightToLeftWithFade,
                        duration: const Duration(milliseconds: 450));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/sun.png',
                              height: 40,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('Fajar Alarm',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: AppColor.blueColor)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FutureBuilder<List<AlarmModel>>(
                              future:
                                  alarms, // Assuming `getAlarmdata` is defined as mentioned earlier
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<AlarmModel>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Display a loading indicator while data is being fetched
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Error: ${snapshot.error}'); // Display an error message if an error occurs
                                } else if (!snapshot.hasData) {
                                  return const Text(
                                      'No data available'); // Display a message if no data is available
                                } else {
                                  final List<AlarmModel> alarmData = snapshot
                                      .data!; // Retrieve the alarm data from the snapshot
                                  final alarmText = alarmData.isNotEmpty
                                      ? alarmData[0].alarmTime.toString()
                                      : 'No alarms found'; // Display the first alarm's data

                                  return Text(alarmText,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: AppColor
                                              .blueColor)); // Display the alarm data in a Text widget
                                }
                              },
                            ),
                            // const Text('3:40 am',
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: 20,
                            //         color: AppColor.blueColor)),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/images/alarm.png',
                              color: AppColor.greyColor,
                              height: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 3),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Text('Select Date',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: AppColor.blueColor)),
                ),
                datePicker(context),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Text('Select Event',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: AppColor.blueColor)),
                ),
                dropDown(),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 17.0),
                    child: Obx(() {
                      return Text(
                          tasbeehController.selectedItem.value == 'Darood e Pak'
                              ? 'Enter Count'
                              : 'Enter Duration',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: AppColor.blueColor));
                    })),
                CountField(),
                const SizedBox(
                  height: 17,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      dbHelper!
                          .insert(ReportModel(
                              date: tasbeehController.selectedDate
                                  .toIso8601String()
                                  .split('T')[0],
                              event: tasbeehController.selectedItem.value,
                              count: int.parse(count.text)))
                          .then((value) {
                        if (kDebugMode) {
                          print(tasbeehController.selectedDate
                              .toIso8601String()
                              .split('T')[0]);
                          print("data added");
                        }
                        Utils.toastMessage('Data Added');
                      }).onError((error, stackTrace) {
                        if (kDebugMode) {
                          print(error.toString());
                        }
                      }).catchError((error) {
                        Utils.toastMessage(error!.toString());
                      });
                      setState(() {
                        count.text = '';
                        tasbeehController.selectedDate = DateTime.now();
                        tasbeehController.formattedDate.value =
                            tasbeehController.getFormattedDate();
                      });
                    },
                    child: Container(
                      height: Constants.getHeight(context) * 0.07,
                      width: Constants.getWidth(context) * 0.6,
                      decoration: const BoxDecoration(
                          color: AppColor.redColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          )),
                      child: const Center(
                        child: Text('Save',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                                color: AppColor.whiteColor)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container CountField() {
    return Container(
        height: 60,
        decoration: BoxDecoration(
            color: AppColor.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            )),
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Obx(() {
                return TextFormField(
                  keyboardType: TextInputType.number,
                  controller: count,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        tasbeehController.selectedItem.value == 'Darood e Pak'
                            ? 'Count'
                            : 'Duration',
                  ),
                );
              })),
        ));
  }

  Container dropDown() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          )),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Obx(() {
              return DropdownButton(
                value: tasbeehController.selectedItem.value,
                items: tasbeehController.dropdownItems
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  tasbeehController.selectedItem.value = value!;
                },
                icon: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      size: 39,
                    )),
                isExpanded: true,
                underline: Container(),
                iconEnabledColor: AppColor.orangeColor, //Icon color
                style: const TextStyle(
                    color: AppColor.blueColor, //Font color
                    fontSize: 20 //font size on dropdown button
                    ),
                dropdownColor: AppColor.whiteColor, //dropdown background color
              );
            })),
      ),
    );
  }

  Container datePicker(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          )),
      child: InkWell(
        onTap: () {
          tasbeehController.selectDate(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Obx(() {
                return Text(tasbeehController.formattedDate.value.toString(),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColor.blueColor));
              }),
              const Icon(
                Icons.date_range_outlined,
                color: AppColor.greyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
