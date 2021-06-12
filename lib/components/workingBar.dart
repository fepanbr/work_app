import 'package:commute_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WorkingBar extends StatelessWidget {
  const WorkingBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                SizedBox(
                  width: (Get.width - 50) * 0.9,
                ),
                Icon(
                  Icons.directions_run_outlined,
                  size: 50,
                  color: kTextColor,
                ),
              ],
            ),
          ),
          new LinearPercentIndicator(
            lineHeight: 10.0,
            // percent: _value.restTime,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: kPrimaryColor,
            percent: 0.9,
          ),
        ],
      ),
    );
  }
}
