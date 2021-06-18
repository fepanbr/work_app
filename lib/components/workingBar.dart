import 'dart:async';

import 'package:commute_app/constants.dart';
import 'package:commute_app/models/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WorkingBar extends StatefulWidget {
  const WorkingBar({
    Key? key,
    required this.work,
  }) : super(key: key);

  final Work work;

  @override
  _WorkingBarState createState() => _WorkingBarState();
}

class _WorkingBarState extends State<WorkingBar> {
  double percent = 0.0;
  TimeOfDay _timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      calculatePercent();
    });
  }

  void calculatePercent() {
    Duration workingTime =
        DateTime.now().difference(Work.toDateTime(widget.work.startTime));
    setState(() {
      if ((480 - workingTime.inMinutes) / 480 >= 1.0) {
        percent = 1.0;
      } else {
        percent = (480 - workingTime.inMinutes) / 480;
      }
    });
  }

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
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: (Get.width - 50) * percent,
                  child: SizedBox(
                    width: (Get.width - 50) * percent,
                  ),
                ),
                Icon(
                  Icons.directions_run_outlined,
                  size: 40,
                  color: kTextColor,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              calculatePercent();
            },
            child: new LinearPercentIndicator(
              lineHeight: 10.0,
              animationDuration: 1000,
              animation: true,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: kPrimaryColor,
              percent: percent,
            ),
          ),
        ],
      ),
    );
  }
}
