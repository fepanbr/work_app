import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_app/components/backgroundBlueBox.dart';
import 'package:commute_app/components/weeklyWorkCard.dart';
import 'package:commute_app/constants.dart';
import 'package:commute_app/models/annualLeave.dart';
import 'package:commute_app/models/work.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeeklyWorkPage extends StatefulWidget {
  const WeeklyWorkPage({Key? key}) : super(key: key);

  @override
  _WeeklyWorkPageState createState() => _WeeklyWorkPageState();
}

class _WeeklyWorkPageState extends State<WeeklyWorkPage> {
  final int friday = 5;
  int weeklyWorkingTime = 2400;
  final workRef = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('work')
      .withConverter<Work>(
        fromFirestore: (snapshot, _) =>
            Work.fromJson(snapshot.data()!, snapshot.reference),
        toFirestore: (work, _) => work.toJson(),
      );
  List<Work> workList = [];
  final now = DateTime.now();
  var startTime = DateFormat("yyyyMMddHHmm").format(Work.monday);
  var endTime = DateFormat("yyyyMMddHHmm").format(Work.friday);

  String restTimeString = '';
  String canOffWorkTimeToString = '';
  int restWorkingTime = 0;

  Future<void> setWork() async {
    List<QueryDocumentSnapshot<Work>> workListInServer = await workRef
        .where('startTime', isGreaterThanOrEqualTo: startTime)
        .get()
        .then((value) => value.docs);

    workList.clear();

    workList.addAll(workListInServer.map((e) => e.data()).toList());
    calculateWeeklyWorkingTime();
    calculateWorkingTimeInWeek();
    calculateOffWorkTime();
  }

  Future<void> updateWork(work) async {
    if (work.reference != null) {
      await workRef
          .doc(work.reference!.id)
          .update(work.toJson())
          .then((value) => print('저장'));

      setState(() {
        workList.clear();
      });
    } else {
      Fluttertoast.showToast(
          msg: "수정은 출근, 연차 지정 후 사용할 수 있습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  calculateWorkingTimeInWeek() {
    int workingTimeSum = 0;
    var workingTimeList = workList
        .where((element) => element.annualLeave != AnnualLeave.ONLEAVE.index)
        .where((element) => element.workingTime != 0)
        .map((e) => e.workingTime);

    if (workingTimeList.isEmpty == false) {
      workingTimeSum =
          workingTimeList.reduce((value, element) => value += element);
    }

    restWorkingTime = weeklyWorkingTime - workingTimeSum;
    var hour = restWorkingTime ~/ 60;
    var minutes = restWorkingTime % 60;
    if (restWorkingTime.isNegative) {
      restTimeString = '이번주 근무시간을 모두 채웠습니다.';
    } else {
      restTimeString = '이번주 남은 근무시간 : $hour시간 $minutes분';
    }
  }

  calculateOffWorkTime() {
    if (restWorkingTime.isNegative) {
      canOffWorkTimeToString = '이번주도 고생했습니다.';
    } else {
      if (now.weekday == friday) {
        var lastWork = Work.toDateTime(workList.last.startTime);
        if (lastWork.weekday == friday) {
          var canoffWorkTime = lastWork
              .add(Duration(minutes: restWorkingTime))
              .add(Duration(minutes: Work.defaultMealTime()));
          canOffWorkTimeToString =
              '${canoffWorkTime.hour}시 ${canoffWorkTime.minute}분에 퇴근 가능합니다.';
        }
      }
    }
  }

  calculateWeeklyWorkingTime() {
    var onLeaveCount = workList
        .where((element) => element.annualLeave == AnnualLeave.ONLEAVE.index)
        .length;
    var halafOnLeaveCount = workList
        .where(
            (element) => element.annualLeave == AnnualLeave.HALFONLEAVE.index)
        .length;
    weeklyWorkingTime =
        weeklyWorkingTime - onLeaveCount * 480 - halafOnLeaveCount * 240;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundBlueBox(),
        Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  DateFormat('M월').format(now),
                  style: TextStyle(
                    color: kBackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                  ),
                ),
              ),
              FutureBuilder(
                future: setWork(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        Container(
                          height: 360,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
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
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]),
                                margin: EdgeInsets.fromLTRB(kDefaultPadding, 40,
                                    kDefaultPadding, kDefaultPadding / 2),
                                width: 250,
                                child: InkWell(
                                  child: WeeklyWorkCard(work: workList[index]),
                                  onTap: () async {
                                    var result = await Get.toNamed('/modify',
                                        arguments: workList[index]);
                                    if (result != null) {
                                      await updateWork(result);
                                    }
                                  },
                                ),
                              );
                            },
                            itemCount: workList.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                restTimeString,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                canOffWorkTimeToString,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                        heightFactor: 10, child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
