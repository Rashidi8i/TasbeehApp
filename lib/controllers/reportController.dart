import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasbeehapp/models/averageModel.dart';
import 'package:tasbeehapp/models/generatedreportModel.dart';
import 'package:tasbeehapp/sql_dbHandler/db_handler.dart';

class ReportController extends GetxController {
  late DateTime fromselectedDate;
  late RxString fromformattedDate;
  late DateTime toselectedDate;
  late RxString toformattedDate;
  RxBool generated = false.obs;
  DBHelper? dbHelper = DBHelper();
  late Future<List<GeneratedReportModel>> generatereports;
  late Future<List<AverageModel>> avgreportsbyDate;

  ReportController() {
    fromselectedDate = DateTime.now();
    fromformattedDate = getfromFormattedDate().obs;
    toselectedDate = DateTime.now();
    toformattedDate = gettoFormattedDate().obs;
  }

  String getfromFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(fromselectedDate);
  }

  String gettoFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(toselectedDate);
  }

  void loadrangeData(String fromDate, String toDate) {
    generatereports = dbHelper!.getgeneratedList(fromDate, toDate);
    if (kDebugMode) {
      // print(generatereports);
    }
  }

  void loadavgData(String fromDate, String toDate) {
    avgreportsbyDate = dbHelper!.getaverageBydate(fromDate, toDate);
    if (kDebugMode) {
      print('loadavgData');
      print(avgreportsbyDate);
    }
  }

  Future<void> fromselectDate(BuildContext context) async {
    generated.value = false;
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      generated.value = true;
      fromselectedDate = d;
      fromformattedDate.value =
          DateFormat('dd/MM/yyyy').format(fromselectedDate).toString();
      update();
      // Notify GetX that the state has changed
      loadavgData(fromselectedDate.toString(), toselectedDate.toString());

      loadrangeData(fromselectedDate.toString(), toselectedDate.toString());
    }
  }

  Future<void> toselectDate(BuildContext context) async {
    generated.value = false;

    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      generated.value = true;

      toselectedDate = d;
      toformattedDate.value =
          DateFormat('dd/MM/yyyy').format(toselectedDate).toString();
      update(); // Notify GetX that the state has changed
      loadavgData(fromselectedDate.toString(), toselectedDate.toString());

      loadrangeData(fromselectedDate.toString(), toselectedDate.toString());
    }
  }
}
