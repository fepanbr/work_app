import 'package:commute_app/components/workingBar.dart';
import 'package:commute_app/constants.dart';
import 'package:commute_app/models/WorkState.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late WorkState _workState;

  @override
  void initState() {
    super.initState();
    _workState = WorkState.BEFORE_WORK;
  }

  Future<void> startWork() async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: kBackgroundColor,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
            Container(
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
                              '00 : 00',
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
                              '00 : 00',
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
                              '1 시간 10분',
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
                              '8시간 20분',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        WorkingBar(),
        Expanded(
          child: Column(
            children: [
              Container(
                child: Text(
                  '8시간 50분 근무중!',
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
                    } else if (_workState == WorkState.WORKING) {
                      _workState = WorkState.AFTER_WORK;
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(300, 40)),
                    alignment: Alignment.center,
                    elevation: MaterialStateProperty.all(3),
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
