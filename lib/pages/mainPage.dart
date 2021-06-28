import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_app/components/backgroundBlueBox.dart';
import 'package:commute_app/components/workingBar.dart';
import 'package:commute_app/components/worktimeCard.dart';
import 'package:commute_app/constants.dart';
import 'package:commute_app/models/annualLeave.dart';
import 'package:commute_app/models/work.dart';
import 'package:commute_app/models/workState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late WorkState _workState;
  final workRef = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('work')
      .withConverter<Work>(
        fromFirestore: (snapshot, _) =>
            Work.fromJson(snapshot.data()!, snapshot.reference),
        toFirestore: (work, _) => work.toJson(),
      );
  late Work work;
  String workingMsg = '';

  String _getWorkingTime(Duration duration) {
    var hours = duration.inMinutes ~/ 60;
    var minutes = duration.inMinutes % 60;
    return '$hours시간 $minutes분 근무 중!';
  }

  @override
  void initState() {
    super.initState();
    setWork();
  }

  Future<void> startWork() async {
    await workRef
        .add(
          Work(
            startTime: DateFormat("yyyyMMddHHmm").format(DateTime.now()),
            endTime: Work.defaultWorkTime(),
            isAddMealTime: false,
            mealTime: Work.defaultMealTime(),
            workingTime: Work.defaultWorkingTime(),
            annualLeave: AnnualLeave.NONE.index,
          ),
        )
        .then((value) => value)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> offWork() async {
    try {
      if (!work.isValidWorkTime()) throw 'don\'t calculate workingTime';
      work.offWork();
      await workRef
          .doc(work.reference!.id)
          .update(work.toJson())
          .then((value) => print('저장'));
    } catch (e) {
      Fluttertoast.showToast(
          msg: "근무시간이 너무 짧아요",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> setWork() async {
    List<QueryDocumentSnapshot<Work>> workList = await workRef
        .where('startTime', isGreaterThanOrEqualTo: Work.defaultWorkTime())
        .get()
        .then((value) => value.docs);

    if (workList.length == 1) {
      work = workList[0].data();
    } else {
      work = Work.createDefaultWork();
    }
    _workState = work.currentWorkState();
    if (work.currentWorkState() == WorkState.WORKING) {
      Duration workingTime =
          DateTime.now().difference(Work.toDateTime(work.startTime));
      workingMsg = _getWorkingTime(workingTime);
    } else if (work.currentWorkState() == WorkState.AFTER_WORK) {
      workingMsg = '';
    }
  }

  Future<void> setOnLeave() async {
    await workRef
        .add(Work.createOnLeaveWork())
        .then((value) => value)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> updateWork() async {
    if (work.reference != null) {
      await workRef
          .doc(work.reference!.id)
          .update(work.toJson())
          .then((value) => print('저장'));
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setWork(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Stack(
                children: [
                  BackgroundBlueBox(),
                  WorkTimeCard(
                    work: work,
                    updateWork: updateWork,
                  ),
                  Positioned(
                    right: kDefaultPadding,
                    top: kDefaultPadding / 2,
                    child: InkWell(
                      onTap: () async {
                        if (work.currentWorkState() == WorkState.AFTER_WORK) {
                          Fluttertoast.showToast(
                              msg: "퇴근 후에는 설정할 수 없습니다.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        }

                        var result = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('휴일 선택'),
                            content: Text('연차입니까, 반차입니까?'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    work.annualLeave = AnnualLeave.NONE.index;
                                  });
                                  Navigator.pop(context, "none");
                                },
                                child: Text('근무'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    work.annualLeave =
                                        AnnualLeave.ONLEAVE.index;
                                  });
                                  Navigator.pop(context, "onleave");
                                },
                                child: Text('연차'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    work.annualLeave =
                                        AnnualLeave.HALFONLEAVE.index;
                                  });
                                  Navigator.pop(context, "halfonleave");
                                },
                                child: Text('반차'),
                              ),
                            ],
                          ),
                        );
                        if (result == 'onleave') {
                          setOnLeave();
                        }
                      },
                      child: Icon(
                        Icons.settings,
                        color: kBackgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 30,
              // ),
              WorkingBar(work: work),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        workingMsg,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_workState == WorkState.BEFORE_WORK) {
                            _workState = WorkState.WORKING;
                            startWork();
                          } else if (_workState == WorkState.WORKING) {
                            _workState = WorkState.AFTER_WORK;
                            offWork();
                          } else {
                            Fluttertoast.showToast(
                                msg: "하루에 출근은 한번만 하세요..",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        });
                      },
                      child: Text(
                        _workState == WorkState.WORKING ? '퇴근하기' : '출근하기',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(300, 40)),
                          alignment: Alignment.center,
                          elevation: MaterialStateProperty.all(3),
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor)),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
