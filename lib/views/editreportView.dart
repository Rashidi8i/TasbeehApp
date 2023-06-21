// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// ignore: implementation_imports
import 'package:path_provider/path_provider.dart';
import 'package:tasbeehapp/controllers/reportController.dart';
import 'package:tasbeehapp/models/generatedreportModel.dart';
import 'package:tasbeehapp/models/reportModel.dart';
import 'package:tasbeehapp/res/colors/app_color.dart';
import 'package:tasbeehapp/res/constants/constants.dart';
import 'package:tasbeehapp/sql_dbHandler/db_handler.dart';
import 'package:tasbeehapp/utils/appdrawer.dart';
import 'package:tasbeehapp/utils/themeContainer.dart';
import 'package:tasbeehapp/utils/utils.dart';
import 'package:tasbeehapp/views/generatereportView.dart';

class EditreportView extends StatefulWidget {
  final String toDate, fromDate;
  final int listCount;
  final bool generated;
  // final Future<List<GeneratedReportModel>> generatereports;
  const EditreportView({
    super.key,
    required this.toDate,
    required this.fromDate,
    required this.listCount,
    required this.generated,
    // required this.generatereports,
  });

  @override
  State<EditreportView> createState() => _EditreportViewState();
}

class _EditreportViewState extends State<EditreportView> {
  final reportController = Get.put(ReportController());
  List<TextEditingController> textFeildList = [];
  List<FocusNode> focusNodes = [];

  DBHelper? dbHelper;
  var copiedData = '';
  var filepath = '';
  List<List<dynamic>> excelData = [
    ['Date', 'Event', 'Count'],
  ];
  List<bool> isEditableList = [];

  late Future<List<ReportModel>> reports;
  loadData() {
    // reports = dbHelper!.getgeneratedList(widget.fromDate, widget.toDate);
    reports = dbHelper!.getsumreportList();
  }

  void exportToExcel(List<List<dynamic>> data) async {
    var excel = Excel.createExcel();
    var sheet = excel['TasbeehReport'];

    for (var i = 0; i < data.length; i++) {
      sheet.appendRow(data[i]);
    }

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String excelFilePath = '${appDocumentsDirectory.path}/tasbeehreport.xlsx';
    filepath = excelFilePath;
    File excelFile = File(excelFilePath);
    await excelFile.writeAsBytes(excel.save()!).then((value) {
      Utils.toastMessage('Export to [$excelFilePath]');
      if (kDebugMode) {
        print(excelFilePath);
      }
    }).catchError((error) {
      Utils.toastMessage(error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
    reportController.loadrangeData(widget.fromDate, widget.toDate);
    isEditableList = List.generate(widget.listCount, (_) => false);
    textFeildList =
        List.generate(widget.listCount, (index) => TextEditingController());
    focusNodes = List.generate(widget.listCount, (_) => FocusNode());
  }

  Future<bool> _onWillPop() async {
    return true; // Allow the screen to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            'Share Report',
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
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                  SizedBox(
                    height: Constants.getHeight(context) * 0.53,
                    child:
                        widget.generated ? futureBuilderGen() : futureBuilder(),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.off(() => const GeneratereportView(),
                                transition: Transition.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 450));
                          },
                          child: Transform.rotate(
                            angle: 3.14159,
                            child: Image.asset(
                              'assets/images/arrow.png',
                              color: AppColor.greyColor,
                              height: 40,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: copiedData))
                                .then((value) {
                              Utils.toastMessage('Copied to clipboard');
                            }).onError((error, stackTrace) {
                              Utils.toastMessage(error.toString());
                            });
                          },
                          child: Image.asset(
                            'assets/images/copy.png',
                            color: AppColor.greyColor,
                            height: 40,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            exportToExcel(excelData);
                            // openExcelFile(filepath);
                          },
                          child: Image.asset(
                            'assets/images/arrow.png',
                            color: AppColor.greyColor,
                            height: 40,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
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
                    var data = [];
                    data.add(snapshot.data![index].date!);
                    data.add(snapshot.data![index].event!);
                    data.add(snapshot.data![index].count!);
                    excelData.add(data);
                    copiedData +=
                        '${snapshot.data![index].date!} ${snapshot.data![index].event!} ${snapshot.data![index].count!}\n';
                    // if (kDebugMode) {
                    //   print(copiedData);
                    //   print(excelData);
                    // }
                    // List<bool> isEditableList = List.generate(
                    //     snapshot.data!.length, (_) => false);

                    textFeildList[index].text =
                        snapshot.data![index].count!.toString();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(snapshot.data![index].date!.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                          Text(snapshot.data![index].event!.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.blueColor),
                              keyboardType: TextInputType.number,
                              focusNode: focusNodes[index],
                              enabled: isEditableList[
                                  index], // Make the text field editable or non-editable based on the isEditableList
                              controller: textFeildList[index],
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              onTapOutside: (event) {
                                print('object');
                              },
                              onEditingComplete: () {
                                dbHelper!
                                    .updateCount(
                                        snapshot.data![index].date!.toString(),
                                        snapshot.data![index].event!.toString(),
                                        textFeildList[index].text)
                                    .then((value) {
                                  if (kDebugMode) {
                                    print("data updated");
                                  }
                                  setState(() {
                                    widget.generated
                                        ? reportController.loadrangeData(
                                            widget.fromDate, widget.toDate)
                                        : loadData();
                                  });
                                  Utils.toastMessage('Data Updated');
                                }).onError((error, stackTrace) {
                                  if (kDebugMode) {
                                    print(error.toString());
                                  }
                                }).catchError((error) {
                                  Utils.toastMessage(error!.toString());
                                });

                                if (kDebugMode) {
                                  print('done');
                                }
                                setState(() {
                                  // Enable editing for the tapped text field
                                  isEditableList[index] = false;
                                });
                                focusNodes[index].unfocus();
                              },
                            ),
                          ),
                          // Text(
                          //     snapshot.data![index].count!
                          //         .toString(),
                          //     style: const TextStyle(
                          //         fontWeight: FontWeight.w500,
                          //         fontSize: 17,
                          //         color: AppColor.blueColor)),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[index]);
                                  isEditableList[index] =
                                      !isEditableList[index];
                                  if (kDebugMode) {
                                    print(isEditableList);
                                  }
                                });
                                if (!isEditableList[index]) {
                                  dbHelper!
                                      .updateCount(
                                          snapshot.data![index].date!
                                              .toString(),
                                          snapshot.data![index].event!
                                              .toString(),
                                          textFeildList[index].text)
                                      .then((value) {
                                    if (kDebugMode) {
                                      print("data updated");
                                    }
                                    setState(() {
                                      widget.generated
                                          ? reportController.loadrangeData(
                                              widget.fromDate, widget.toDate)
                                          : loadData();
                                    });
                                    Utils.toastMessage('Data Updated');
                                  }).onError((error, stackTrace) {
                                    if (kDebugMode) {
                                      print(error.toString());
                                    }
                                  }).catchError((error) {
                                    Utils.toastMessage(error!.toString());
                                  });
                                }
                                FocusScope.of(context)
                                    .requestFocus(focusNodes[index]);
                              },
                              child: Icon(
                                isEditableList[index] ? Icons.done : Icons.edit,
                                color: AppColor.blueColor,
                              ))
                        ],
                      ),
                    );
                    // return ListTile(
                    //   leading: Text(
                    //       snapshot.data![index].date!.toString(),
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 17,
                    //           color: AppColor.blueColor)),
                    //   title: Text(
                    //       snapshot.data![index].event!.toString(),
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 17,
                    //           color: AppColor.blueColor)),
                    //   trailing: Text(
                    //       snapshot.data![index].count!.toString(),
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 17,
                    //           color: AppColor.blueColor)),
                    // );
                  })
              : const Center(
                  child: Text('No data'),
                );
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
                    var data = [];
                    data.add(snapshot.data![index].date!);
                    data.add(snapshot.data![index].event!);
                    data.add(snapshot.data![index].count!);
                    excelData.add(data);
                    copiedData +=
                        '${snapshot.data![index].date!} ${snapshot.data![index].event!} ${snapshot.data![index].count!}\n';
                    if (kDebugMode) {
                      // print(copiedData);
                      // print(excelData);
                    }
                    // List<bool> isEditableList = List.generate(
                    //     snapshot.data!.length, (_) => false);

                    textFeildList[index].text =
                        snapshot.data![index].count!.toString();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(snapshot.data![index].date!.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                          Text(snapshot.data![index].event!.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: AppColor.blueColor)),
                          Container(
                            color: isEditableList[index]
                                ? AppColor.lightgreyColor
                                : Colors.transparent,
                            width: 80,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.blueColor),
                              keyboardType: TextInputType.number,
                              focusNode: focusNodes[index],
                              enabled: isEditableList[
                                  index], // Make the text field editable or non-editable based on the isEditableList
                              controller: textFeildList[index],
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              onTap: () {
                                if (kDebugMode) {
                                  print('object');
                                }
                              },
                              onEditingComplete: () {
                                dbHelper!
                                    .updateCount(
                                        snapshot.data![index].date!.toString(),
                                        snapshot.data![index].event!.toString(),
                                        textFeildList[index].text)
                                    .then((value) {
                                  if (kDebugMode) {
                                    print("data updated");
                                  }
                                  setState(() {
                                    widget.generated
                                        ? reportController.loadrangeData(
                                            widget.fromDate, widget.toDate)
                                        : loadData();
                                  });
                                  Utils.toastMessage('Data Updated');
                                }).onError((error, stackTrace) {
                                  if (kDebugMode) {
                                    print(error.toString());
                                  }
                                }).catchError((error) {
                                  Utils.toastMessage(error!.toString());
                                });

                                if (kDebugMode) {
                                  print('done');
                                }
                                setState(() {
                                  // Enable editing for the tapped text field
                                  isEditableList[index] = false;
                                });
                                focusNodes[index].unfocus();
                              },
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[index]);
                                  isEditableList[index] =
                                      !isEditableList[index];
                                  if (kDebugMode) {
                                    print(isEditableList);
                                  }
                                });
                                if (!isEditableList[index]) {
                                  dbHelper!
                                      .updateCount(
                                          snapshot.data![index].date!
                                              .toString(),
                                          snapshot.data![index].event!
                                              .toString(),
                                          textFeildList[index].text)
                                      .then((value) {
                                    if (kDebugMode) {
                                      print("data updated");
                                    }
                                    setState(() {
                                      widget.generated
                                          ? reportController.loadrangeData(
                                              widget.fromDate, widget.toDate)
                                          : loadData();
                                    });
                                    Utils.toastMessage('Data Updated');
                                  }).onError((error, stackTrace) {
                                    if (kDebugMode) {
                                      print(error.toString());
                                    }
                                  }).catchError((error) {
                                    Utils.toastMessage(error!.toString());
                                  });
                                }
                                FocusScope.of(context)
                                    .requestFocus(focusNodes[index]);
                              },
                              child: Icon(
                                isEditableList[index] ? Icons.done : Icons.edit,
                                color: AppColor.blueColor,
                              ))
                        ],
                      ),
                    );
                    // return ListTile(
                    //   leading: Text(
                    //       snapshot.data![index].date!.toString(),
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 17,
                    //           color: AppColor.blueColor)),
                    //   title: Text(
                    //       snapshot.data![index].event!.toString(),
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 17,
                    //           color: AppColor.blueColor)),
                    //   trailing: Text(
                    //       snapshot.data![index].count!.toString(),
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 17,
                    //           color: AppColor.blueColor)),
                    // );
                  })
              : const Center(
                  child: Text('No data'),
                );
        });
  }
}
