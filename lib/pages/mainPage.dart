import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_app/components/backgroundBlueBox.dart';
import 'package:commute_app/components/workingBar.dart';
import 'package:commute_app/components/worktimeCard.dart';
import 'package:commute_app/constants.dart';
import 'package:commute_app/models/work.dart';
import 'package:commute_app/models/workState.dart';
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
  final workRef =
      FirebaseFirestore.instance.collection('work').withConverter<Work>(
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
            haveMeal: false,
            mealTime: Work.defaultMealTime(),
            workingTime: Work.defaultWorkingTime(),
          ),
        )
        .then((value) => value)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> offWork() async {
    try {
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

    print('갱신!');
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
                children: [BackgroundBlueBox(), WorkTimeCard(work: work)],
              ),
              SizedBox(
                height: 30,
              ),
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
                    )
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
