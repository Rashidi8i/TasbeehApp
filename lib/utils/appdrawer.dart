import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeehapp/res/colors/app_color.dart';
import 'package:tasbeehapp/res/constants/constants.dart';
import 'package:tasbeehapp/views/aboutusView.dart';
import 'package:tasbeehapp/views/alarmView.dart';
import 'package:tasbeehapp/views/daroodView.dart';
import 'package:tasbeehapp/views/generatereportView.dart';
import 'package:tasbeehapp/views/tasbeehView.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  _launchURL() async {
    final Uri url = Uri.parse('http://elabdisb.com/elabdtech/#home');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.whiteColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColor.whiteColor),
            accountName: const Text(
              'Islamic App',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: AppColor.greyColor),
            ),
            currentAccountPicture: Image.asset(
              'assets/images/tasbeeh.png',
            ),
            accountEmail: null,
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text(
              "Tasbeeh/Zikarr",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: AppColor.blueColor),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Get.to(() => const TasbeehView(),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 450));
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text(
              "Darood e Pak",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: AppColor.blueColor),
            ),
            onTap: () {
              Navigator.of(context).pop();

              Get.to(() => const DaroodView(),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 450));
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text(
              "Set Alarm",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: AppColor.blueColor),
            ),
            onTap: () {
              Navigator.of(context).pop();

              Get.to(() => const AlarmView(),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 450));
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text(
              "Generate Report",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: AppColor.blueColor),
            ),
            onTap: () {
              Navigator.of(context).pop();

              Get.to(() => const GeneratereportView(),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 450));
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text(
              "About Us",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: AppColor.blueColor),
            ),
            onTap: () {
              Navigator.of(context).pop();

              Get.to(() => const AboutusView(),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 450));
            },
          ),
          const Divider(thickness: 1),
          SizedBox(
            height: Constants.getHeight(context) * 0.25,
          ),
          Align(
            alignment: FractionalOffset.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _launchURL();
                },
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: AppColor.greyColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
