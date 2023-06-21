import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeehapp/res/colors/app_color.dart';
import 'package:tasbeehapp/views/mainView.dart';
import 'package:tasbeehapp/views/tasbeehView.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Get.to(() => const TasbeehView(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 450)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'Developed By Rashid',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.greyColor),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tasbeeh.png',
              height: 190,
            ),
            const Text(
              'Tasbeeh Islamic App',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColor.greyColor),
            )
          ],
        ),
      ),
    );
  }
}
