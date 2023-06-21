// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SetAlarmController extends GetxController {
  RxString selectedTime = '00:00 am'.obs;
  RxString alarmTime = '00:00 am'.obs;
  String datesStr = '';
  List<String> datesForinsert = [];
  List<String> alarmdates = [];
  RxBool allDays = false.obs;
  RxBool selectDates = false.obs;
  late DateTime selectedDate;
  late RxString formattedDate;
  RxString selectedItem = 'Darood e Pak'.obs;
  List<String> dropdownItems = [
    'Darood e Pak',
    'Tasbeeh/Zikarr',
  ];

  SetAlarmController() {
    selectedDate = DateTime.now();
    formattedDate = getFormattedDate().obs;
  }

  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(selectedDate);
  }

  void addDates(String date) {
    if (!datesForinsert.contains(date)) {
      datesForinsert.add(date);
    } else {
      datesForinsert.remove(date);
    }
  }

  void listTostring(List<String> list) {
    for (String date in list) {
      datesStr += '$date,';
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (d != null) {
      selectedDate = d;
      formattedDate.value =
          DateFormat('dd/MM/yyyy').format(selectedDate).toString();
      update(); // Notify GetX that the state has changed
    }
  }
}
