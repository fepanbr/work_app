import 'package:commute_app/constants.dart';
import 'package:commute_app/models/annualLeave.dart';
import 'package:commute_app/models/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkTimeCard extends StatefulWidget {
  const WorkTimeCard({
    Key? key,
    required this.work,
    required this.updateWork,
  }) : super(key: key);

  final Work work;

  final Function updateWork;

  @override
  _WorkTimeCardState createState() => _WorkTimeCardState();
}

class _WorkTimeCardState extends State<WorkTimeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(
            kDefaultPadding, 50, kDefaultPadding, kDefaultPadding / 2),
        height: 300,
        width: 400,
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
        child: widget.work.annualLeave == AnnualLeave.ONLEAVE.index
            ? Center(
                child: Text(
                  '연차',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              )
            : InkWell(
                onTap: () async {
                  var result =
                      await Get.toNamed('/modify', arguments: widget.work);
                  if (result != null) {
                    widget.updateWork();
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
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
                                  widget.work.startWorkTime,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
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
                                  value: widget.work.isAddMealTime,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.work.isAddMealTime = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
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
                                  widget.work.onLeaveText,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
