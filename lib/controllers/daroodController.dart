// ignore_for_file: unused_field, prefer_final_fields, curly_braces_in_flow_contr unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DaroodController extends GetxController {
  late DateTime selectedDate;
  late RxString formattedDate;
  RxString selectedItem = 'Darood e Pak'.obs;
  List<String> dropdownItems = [
    'Darood e Pak',
    'Tasbeeh/Zikarr',
  ];

  DaroodController() {
    selectedDate = DateTime.now();
    formattedDate = getFormattedDate().obs;
  }
  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(selectedDate);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      selectedDate = d;
      formattedDate.value =
          DateFormat('dd/MM/yyyy').format(selectedDate).toString();
      update(); // Notify GetX that the state has changed
    }
  }
}
