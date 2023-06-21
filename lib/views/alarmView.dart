// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_types_as_parameter_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasbeehapp/controllers/setAlarmController.dart';
import 'package:tasbeehapp/models/alarmModel.dart';
import 'package:tasbeehapp/res/colors/app_color.dart';
import 'package:tasbeehapp/res/constants/constants.dart';
import 'package:tasbeehapp/sql_dbHandler/db_handler.dart';
import 'package:tasbeehapp/utils/appdrawer.dart';
import 'package:tasbeehapp/utils/themeContainer.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:tasbeehapp/utils/utils.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  final alarmController = Get.put(SetAlarmController());
  TextEditingController count = TextEditingController();
  DBHelper? dbHelper;
  late Future<List<AlarmModel>> alarms;

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {},
  );

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    alarms = dbHelper!.getAlarmdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          'Set Alarm',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ThemeContainer(
                  text:
                      'One day a person from among the Bani Isra\'il passed away. The people refused to bury him. They threw his body on a rubbish heap. They all considered him to be a great sinner.',
                ),
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
                Padding(
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
                const Divider(thickness: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          alarmController.selectDates.value = true;
                          alarmController.allDays.value = false;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 163, 163, 163)
                                      .withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              )),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text('Select Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: AppColor.blueColor)),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Daily:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                          Obx(() {
                            return Checkbox(
                                value: alarmController.allDays.value,
                                onChanged: (Value) {
                                  alarmController.allDays.value =
                                      !alarmController.allDays.value;
                                  if (alarmController.selectDates.value) {
                                    alarmController.selectDates.value = false;
                                  }
                                });
                          })
                        ],
                      )
                    ],
                  ),
                ),
                Obx(() {
                  return alarmController.selectDates.value
                      ? Container(
                          height: Constants.getHeight(context) * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CalendarCarousel<Event>(
                                onDayPressed: (date, events) {
                                  _handleDayTap(date);
                                },
                                height: 200.0,
                                markedDatesMap: _markedDateMap,
                                showIconBehindDayText: true,
                                markedDateShowIcon: true,
                                markedDateIconMaxShown: 2,
                                markedDateIconBuilder: (event) {
                                  return event.icon ??
                                      const Icon(Icons.help_outline);
                                },
                                markedDateMoreShowTotal: true,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      alarmController.selectDates.value = false;
                                      if (kDebugMode) {
                                        print(alarmController.datesForinsert);
                                      }
                                    },
                                    child: const Center(
                                      child: Text('ok',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: AppColor.blueColor)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      alarmController.selectDates.value = false;
                                      alarmController.datesForinsert.clear();
                                      _markedDateMap.clear();
                                      if (kDebugMode) {
                                        print(_markedDateMap);
                                      }
                                    },
                                    child: const Center(
                                      child: Text('cancel',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: AppColor.redColor)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : Container();
                }),

                // datePicker(context),
                // Container(
                //   height: 100,
                //   decoration: BoxDecoration(
                //       color: AppColor.whiteColor,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.3),
                //           spreadRadius: 3,
                //           blurRadius: 5,
                //           offset:
                //               const Offset(0, 3), // changes position of shadow
                //         ),
                //       ],
                //       borderRadius: const BorderRadius.all(
                //         Radius.circular(15),
                //       )),
                //   child: Padding(
                //     padding: const EdgeInsets.all(4.0),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: [
                //             daySeletor('MON'),
                //             daySeletor('TUE'),
                //             daySeletor('WED'),
                //             daySeletor('THU'),
                //             daySeletor('FRI'),
                //             daySeletor('SAT'),
                //             daySeletor('SUN'),
                //           ],
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           children: [
                //             const Text('All Days:'),
                //             Obx(() {
                //               return Checkbox(
                //                   value: alarmController.allDays.value,
                //                   onChanged: (Value) {
                //                     alarmController.allDays.value =
                //                         !alarmController.allDays.value;
                //                   });
                //             })
                //           ],
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Text('Select Time',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: AppColor.blueColor)),
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      )),
                  child: InkWell(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        DateTime dateTime = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        String formattedTime =
                            DateFormat('hh:mm a').format(dateTime);
                        alarmController.selectedTime.value = formattedTime;
                        if (kDebugMode) {
                          print(formattedTime);
                        } // Output: 10:23 pm
                      } else {
                        if (kDebugMode) {
                          print("Time is not selected");
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Obx(() {
                            return Text(alarmController.selectedTime.toString(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: AppColor.blueColor));
                          }),
                          const Icon(
                            Icons.timelapse_rounded,
                            color: AppColor.greyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 90,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      alarmController
                          .listTostring(alarmController.datesForinsert);
                      dbHelper!
                          .insertAlarm(AlarmModel(
                              alarmDays: alarmController.allDays.value
                                  ? 'daily'
                                  : alarmController.datesStr.toString(),
                              alarmTime:
                                  alarmController.selectedTime.toString()))
                          .then((value) {
                        if (kDebugMode) {
                          print("Alarm added");
                        }
                        Utils.toastMessage('Alarm Added');
                        setState(() {
                          _markedDateMap.clear();
                          alarmController.datesStr = '';
                          alarmController.selectedTime.value = '00:00 am';
                          alarmController.datesForinsert.clear();
                        });
                        alarms = dbHelper!.getAlarmdata();
                      }).onError((error, stackTrace) {
                        if (kDebugMode) {
                          print(error.toString());
                        }
                      }).catchError((error) {
                        Utils.toastMessage(error!.toString());
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
                        child: Text('Set Alarm',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
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

  void _handleDayTap(DateTime date) {
    setState(() {
      List<Event>? events = _markedDateMap.getEvents(date);
      String formatDate = date.toString().split(' ')[0];
      alarmController.addDates(formatDate);
      _markedDateMap.add(
          date, Event(date: date, title: 'Present', icon: _eventIconYellow));
    });
  }

  static final Widget _eventIconYellow = Container(
    decoration: const BoxDecoration(
      color: Colors.yellow,
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.label, color: Colors.yellow),
  );
  InkWell daySeletor(String dayName) {
    return InkWell(onTap: () {
      // alarmController.addDays(dayName);
    }, child: Obx(() {
      return Container(
        decoration: BoxDecoration(
            color: AppColor.whiteColor,
            shape: BoxShape.circle,
            border: Border.all(width: 1)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(dayName),
          ),
        ),
      );
    }));
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
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: count,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'count',
              ),
            ),
          ),
        ));
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
          alarmController.selectDate(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Obx(() {
                return Text(alarmController.formattedDate.value.toString(),
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
