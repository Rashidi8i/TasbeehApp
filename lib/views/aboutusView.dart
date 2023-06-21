// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeehapp/controllers/daroodController.dart';
import 'package:tasbeehapp/res/colors/app_color.dart';
import 'package:tasbeehapp/res/constants/constants.dart';
import 'package:tasbeehapp/utils/themeContainer.dart';
import 'package:tasbeehapp/views/tasbeehView.dart';

class AboutusView extends StatefulWidget {
  const AboutusView({super.key});

  @override
  State<AboutusView> createState() => _AboutusViewState();
}

class _AboutusViewState extends State<AboutusView> {
  final daroodController = Get.put(DaroodController());
  TextEditingController count = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'Developed by Rashid',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.greyColor),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.greyColor,
            )),
        centerTitle: true,
        title: const Text(
          'About Us',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: AppColor.greyColor),
        ),
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
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
                      'One day a person from among the Bani Isra’il passed away. The people refused to bury him. They threw his body on a rubbish heap. They all considered him to be a great sinner.',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/tasbeeh.png',
                        height: 90,
                      ),
                      const Text('Tasbeeh Islamic App',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 27,
                              color: AppColor.greyColor))
                    ],
                  ),
                ),
                const SizedBox(
                  child: Text(
                    'The app is designed to help Muslims in performing daily Tasbeeh, Zikar, and Drood e Pak. It offers a simple and user-friendly interface that allows users to easily count their daily Tasbeeh and Zikar. The app also provides a collection of authentic Drood e Pak for users to recite and seek blessings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.5, fontSize: 22, color: AppColor.greyColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
