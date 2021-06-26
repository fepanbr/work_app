import 'package:commute_app/constants.dart';
import 'package:commute_app/models/annualLeave.dart';
import 'package:commute_app/models/work.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ModifyPage extends StatefulWidget {
  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  Work work = Get.arguments;

  void saveWorkTime() {
    try {
      work.calculateWorkingTime();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "출퇴근 시간이 잘못되었습니다 다시 확인해주세요.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    Get.back(result: work);
  }

  Future<DateTime?> _selectTime(BuildContext context, DateTime time) async {
    var selectedTime = TimeOfDay.fromDateTime(time);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      var _hour;
      var _minute;
      DateTime result;
      selectedTime = picked;
      _hour = selectedTime.hour;
      _minute = selectedTime.minute;
      result = DateTime(time.year, time.month, time.day, _hour, _minute);
      return result;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Work App'),
        centerTitle: true,
        brightness: Brightness.dark,
        actions: [IconButton(onPressed: saveWorkTime, icon: Icon(Icons.save))],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      '출근시간',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      work.startWorkTime,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        var result = await _selectTime(
                            context, Work.toDateTime(work.startTime));
                        setState(() {
                          if (result != null) {
                            work.startTime =
                                DateFormat("yyyyMMddHHmm").format(result);
                          }
                        });
                      },
                      child: Text('수정하기'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      '퇴근시간',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      work.endWorkTime,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        var result = await _selectTime(
                            context, Work.toDateTime(work.endTime));
                        setState(() {
                          if (result != null) {
                            work.endTime =
                                DateFormat("yyyyMMddHHmm").format(result);
                          }
                        });
                      },
                      child: Text(
                        '수정하기',
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      '식사시간',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      work.mealTimeToString,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              title: Text('식사시간 변경'),
                              content: Container(
                                child: Text('구현 준비중입니다.'),
                              )),
                        );
                      },
                      child: Text('수정하기'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      '연차유무',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      work.onLeaveText,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
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
                      },
                      child: Text(
                        '수정하기',
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      '식사포함',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Switch(
                          value: work.isAddMealTime,
                          onChanged: (value) {
                            setState(() {
                              work.isAddMealTime = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
