import 'package:commute_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

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
                              '근무시간',
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
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Expanded(
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
        ),
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
                onPressed: () {},
                child: Text(
                  '출근하기',
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
