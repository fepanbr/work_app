import 'package:commute_app/models/work.dart';
import 'package:flutter/material.dart';

class WeeklyWorkCard extends StatelessWidget {
  final Work work;

  WeeklyWorkCard({required this.work});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  '식사유무',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                child: Center(
                  child: Text(
                    work.haveMeal.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
