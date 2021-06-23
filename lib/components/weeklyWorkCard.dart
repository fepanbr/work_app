import 'package:commute_app/constants.dart';
import 'package:commute_app/models/work.dart';
import 'package:flutter/material.dart';

class WeeklyWorkCard extends StatelessWidget {
  final Work work;

  WeeklyWorkCard({required this.work});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 120,
                  height: 50,
                  child: Center(
                    child: Text(
                      '출근시간',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        work.startWorkTime,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 120,
                  height: 50,
                  child: Center(
                    child: Text(
                      '퇴근시간',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        work.endWorkTime,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 120,
                  height: 50,
                  child: Center(
                    child: Text(
                      '식사시간',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        work.mealTimeToString,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 120,
                  height: 50,
                  child: Center(
                    child: Text(
                      '근무시간',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        work.workingTimeToString,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 120,
                  height: 50,
                  child: Center(
                    child: Text(
                      '식사포함',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        work.isAddMealTime ? '포함' : '미포함',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 120,
                  height: 50,
                  child: Center(
                    child: Text(
                      '연 차',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        work.onLeaveText,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Positioned(
          top: -33,
          left: 7,
          child: Text(
            work.workDate,
            style: TextStyle(fontSize: 23, color: kBackgroundColor),
          ),
        )
      ],
    );
  }
}
