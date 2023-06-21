// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasbeehapp/controllers/reportController.dart';
import 'package:tasbeehapp/models/averageModel.dart';
import 'package:tasbeehapp/models/generatedreportModel.dart';
import 'package:tasbeehapp/models/reportModel.dart';
import 'package:tasbeehapp/res/colors/app_color.dart';
import 'package:tasbeehapp/res/constants/constants.dart';
import 'package:tasbeehapp/sql_dbHandler/db_handler.dart';
import 'package:tasbeehapp/utils/appdrawer.dart';
import 'package:tasbeehapp/utils/themeContainer.dart';
import 'package:tasbeehapp/views/aboutusView.dart';
import 'package:tasbeehapp/views/alarmView.dart';
import 'package:tasbeehapp/views/daroodView.dart';
import 'package:tasbeehapp/views/editreportView.dart';
import 'package:tasbeehapp/views/sharereportView.dart';
import 'package:tasbeehapp/views/tasbeehView.dart';

class GeneratereportView extends StatefulWidget {
  const GeneratereportView({super.key});

  @override
  State<GeneratereportView> createState() => _GeneratereportViewState();
}

class _GeneratereportViewState extends State<GeneratereportView> {
  final reportController = Get.put(ReportController());
  TextEditingController count = TextEditingController();
  int listCount = 0;
  DBHelper? dbHelper;
  late Future<List<ReportModel>> reports;
  late Future<List<GeneratedReportModel>> generatereports;
  late Future<List<AverageModel>> avgreports;
  loadData() {
    reports = dbHelper!.getsumreportList();
  }

  loadavgData() {
    avgreports = dbHelper!.getaverage();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
    loadavgData();
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
          'Generate Report',
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
                        'Shaikh Zardaq (radi Allahu anhu) says that when the writer of the book of Durood Shareef died, for one month the fragrance of flowers used to arise from his grave.'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('From',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: AppColor.blueColor)),
                          const SizedBox(
                            height: 10,
                          ),
                          FromdatePicker(context),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('To',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: AppColor.blueColor)),
                          const SizedBox(
                            height: 10,
                          ),
                          TodatePicker(context),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Date',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: AppColor.blueColor)),
                      Text('Event',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: AppColor.blueColor)),
                      Text('Count/Duration',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: AppColor.blueColor)),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 3,
                ),
                Obx(() {
                  return Container(
                    // color: AppColor.lightgreyColor,
                    height: Constants.getHeight(context) * 0.33,
                    child: reportController.generated.value
                        ? futureBuilderGen()
                        : futureBuilder(),
                  );
                }),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        )),
                    height: Constants.getHeight(context) * 0.08,
                    child: reportController.generated.value
                        ? avgDatabyDate()
                        : avgData(),
                  );
                }),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.off(
                              () => SharereportView(
                                    fromDate: reportController.fromselectedDate
                                        .toString(),
                                    toDate: reportController.toselectedDate
                                        .toString(),
                                    listCount: listCount,
                                  ),
                              transition: Transition.rightToLeftWithFade,
                              duration: const Duration(milliseconds: 450));
                        },
                        child: Container(
                          height: Constants.getHeight(context) * 0.07,
                          width: Constants.getWidth(context) * 0.55,
                          decoration: const BoxDecoration(
                              color: AppColor.redColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              )),
                          child: const Center(
                            child: Text('Generate Report',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    color: AppColor.whiteColor)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.off(
                              () => EditreportView(
                                    fromDate: reportController.fromselectedDate
                                        .toString(),
                                    toDate: reportController.toselectedDate
                                        .toString(),
                                    listCount: listCount,
                                    generated: reportController.generated.value,
                                  ),
                              transition: Transition.rightToLeftWithFade,
                              duration: const Duration(milliseconds: 450));
                        },
                        child: Container(
                          height: Constants.getHeight(context) * 0.07,
                          width: Constants.getWidth(context) * 0.25,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 207, 207, 207),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              )),
                          child: const Center(
                            child: Text('Edit',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    color: AppColor.blueColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<ReportModel>> futureBuilder() {
    return FutureBuilder(
        future: reports,
        builder: (context, AsyncSnapshot<List<ReportModel>> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    listCount = snapshot.data!.length;
                    String originalDate =
                        snapshot.data![index].date!.toString();
                    DateTime parsedDate = DateTime.parse(originalDate);
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(parsedDate);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formattedDate.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                          Text(snapshot.data![index].event!.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                          Text(
                              snapshot.data![index].event!.toString() ==
                                      'Darood e Pak'
                                  ? snapshot.data![index].count!.toString()
                                  : '${snapshot.data![index].count!.toString()}  min',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                        ],
                      ),
                    );
                  })
              : const Center(
                  child: Text('No data'),
                );
        });
  }

  FutureBuilder<List<AverageModel>> avgData() {
    return FutureBuilder(
        future: avgreports,
        builder: (context, AsyncSnapshot<List<AverageModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data![index].event!.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: AppColor.blueColor)),
                            Text(
                                snapshot.data![index].event!.toString() ==
                                        'Darood e Pak'
                                    ? 'Avg: ${snapshot.data![index].avgcount!.toString().split('.')[0]}'
                                    : 'Avg: ${snapshot.data![index].avgcount!.toString().split('.')[0]}  min',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: AppColor.blueColor)),
                          ],
                        ),
                      );
                    })
                : const Center(
                    child: Text('No data'),
                  );
          }
        });
  }

  FutureBuilder<List<AverageModel>> avgDatabyDate() {
    return FutureBuilder(
        future: reportController.avgreportsbyDate,
        builder: (context, AsyncSnapshot<List<AverageModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data![index].event!.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: AppColor.blueColor)),
                            Text(
                                snapshot.data![index].event!.toString() ==
                                        'Darood e Pak'
                                    ? 'Avg: ${snapshot.data![index].avgcount!.toString().split('.')[0]}'
                                    : 'Avg: ${snapshot.data![index].avgcount!.toString()..split('.')[0]}  min',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: AppColor.blueColor)),
                          ],
                        ),
                      );
                    })
                : const Center(
                    child: Text('No data'),
                  );
          }
        });
  }

  FutureBuilder<List<GeneratedReportModel>> futureBuilderGen() {
    return FutureBuilder(
        future: reportController.generatereports,
        builder: (context, AsyncSnapshot<List<GeneratedReportModel>> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    listCount = snapshot.data!.length;
                    String originalDate =
                        snapshot.data![index].date!.toString();
                    DateTime parsedDate = DateTime.parse(originalDate);
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(parsedDate);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formattedDate.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                          Text(snapshot.data![index].event!.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                          Text(
                              snapshot.data![index].event!.toString() ==
                                      'Darood e Pak'
                                  ? snapshot.data![index].count!.toString()
                                  : '${snapshot.data![index].count!.toString()}  min',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                        ],
                      ),
                    );
                  })
              : const Center(
                  child: Text('No data'),
                );
        });
  }

  // DataTable _createDataTable() {
  //   return DataTable(columns: _createColumns(), rows: _createRows(reports));
  // }

  // List<DataColumn> _createColumns() {
  //   return const [
  //     DataColumn(
  //         label: Text('Date',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 17,
  //                 color: AppColor.blueColor))),
  //     DataColumn(
  //         label: Text('Event',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 17,
  //                 color: AppColor.blueColor))),
  //     DataColumn(
  //         label: Text('Count/Duration',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 17,
  //                 color: AppColor.blueColor)))
  //   ];
  // }

  // List<DataRow> _createRows(Future<List<ReportModel>> reports) {
  //   return reports
  //       .map(
  //         (report) => DataRow(
  //           cells: [
  //             DataCell(
  //               Text(
  //                 report.date ?? '',
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.normal,
  //                   fontSize: 17,
  //                   color: AppColor.blueColor,
  //                 ),
  //               ),
  //             ),
  //             DataCell(
  //               Text(
  //                 report.event ?? '',
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.normal,
  //                   fontSize: 17,
  //                   color: AppColor.blueColor,
  //                 ),
  //               ),
  //             ),
  //             DataCell(
  //               Text(
  //                 report.count ?? '',
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.normal,
  //                   fontSize: 17,
  //                   color: AppColor.blueColor,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       )
  //       .toList();
  // }

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

  Container FromdatePicker(BuildContext context) {
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
          reportController.fromselectDate(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Obx(() {
                return Text(reportController.fromformattedDate.value.toString(),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColor.blueColor));
              }),
              const SizedBox(
                width: 25,
              ),
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

  Container TodatePicker(BuildContext context) {
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
          reportController.toselectDate(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Obx(() {
                return Text(reportController.toformattedDate.value.toString(),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColor.blueColor));
              }),
              const SizedBox(
                width: 25,
              ),
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
