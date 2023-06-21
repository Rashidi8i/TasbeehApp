import 'package:flutter/material.dart';
import 'package:tasbeehapp/res/constants/constants.dart';

class ThemeContainer extends StatelessWidget {
  final text;
  const ThemeContainer({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Row(
          children: [
            Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 14),
                  ),
                )),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/masjid2.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
