import 'package:commute_app/constants.dart';
import 'package:commute_app/models/work.dart';
import 'package:flutter/material.dart';

class WorkTimeCard extends StatefulWidget {
  const WorkTimeCard({
    Key? key,
    required this.work,
  }) : super(key: key);

  final Work work;

  @override
  _WorkTimeCardState createState() => _WorkTimeCardState();
}

class _WorkTimeCardState extends State<WorkTimeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(
            kDefaultPadding, 50, kDefaultPadding, kDefaultPadding / 2),
        height: 250,
        decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 120,
                    child: Center(
                      child: Text(
                        '출근시간',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: Center(
                      child: Text(
                        widget.work.startWorkTime,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 120,
                    child: Center(
                      child: Text(
                        '퇴근시간',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: Center(
                      child: Text(
                        widget.work.endWorkTime,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 120,
                    child: Center(
                      child: Text(
                        '식사시간',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: Center(
                      child: Text(
                        widget.work.mealTimeToString,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 120,
                    child: Center(
                      child: Text(
                        '근무시간',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: Center(
                      child: Text(
                        widget.work.workingTimeToString,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 120,
                    child: Center(
                      child: Text(
                        '식사포함',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: Center(
                      child: Switch(
                        value: widget.work.haveMeal,
                        onChanged: (value) {
                          setState(() {
                            widget.work.haveMeal = value;
                          });
                        },
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ],
        ));
  }
}