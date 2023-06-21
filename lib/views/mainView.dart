import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeehapp/controllers/setAlarmController.dart';
import 'package:tasbeehapp/models/alarmModel.dart';
import 'package:tasbeehapp/res/colors/app_color.dart';
import 'package:tasbeehapp/res/constants/constants.dart';
import 'package:tasbeehapp/sql_dbHandler/db_handler.dart';
import 'package:tasbeehapp/utils/appdrawer.dart';
import 'package:url_launcher/url_launcher.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 100),
              child: Container(
                height: Constants.getHeight(context) * 0.2,
                decoration: BoxDecoration(
                    // color: AppColor.blueColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.asset(
                      'assets/images/masjid.png',
                      // height: 190,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
