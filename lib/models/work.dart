import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_app/models/annualLeave.dart';
import 'package:commute_app/models/workState.dart';
import 'package:intl/intl.dart';

class Work {
  static final _now = DateTime.now();
  static final friday = DateTime(
      findLastDateOfTheWeek(_now).year,
      findLastDateOfTheWeek(_now).month,
      findLastDateOfTheWeek(_now).day,
      23,
      59,
      59);
  static final monday = DateTime(
      findFirstDateOfTheWeek(_now).year,
      findFirstDateOfTheWeek(_now).month,
      findFirstDateOfTheWeek(_now).day,
      0,
      0,
      0);
  static final DateTime _defaultWorkTime =
      DateTime(_now.year, _now.month, _now.day, 0, 0, 0);
  // static final DateTime _defaultEndTime = findLastDateOfTheWeek(_now);
  static final int _defaultWorkDuration = 0; // minutes
  static final int _defaultMealDuration = 60; // minutes
  String startTime;
  String endTime;
  int workingTime;
  int mealTime;
  bool isAddMealTime;
  int annualLeave;
  DocumentReference? reference;

  String get startWorkTime =>
      DateFormat('HH : mm').format(toDateTime(startTime));
  String get endWorkTime => DateFormat('HH : mm').format(toDateTime(endTime));
  String get workingTimeToString => _calculateWorkingTime(workingTime);
  String get mealTimeToString => _calculateWorkingTime(mealTime);
  String get workDate => DateFormat('d일').format(toDateTime(startTime));
  String get onLeaveText => _makeOnLeaveText();

  Work({
    required this.startTime,
    required this.endTime,
    required this.workingTime,
    required this.mealTime,
    required this.isAddMealTime,
    required this.annualLeave,
    this.reference,
  }) {
    print('startTime $startTime');
    print('reference, $endTime');
    print('reference, $workingTime');
    print('reference, $mealTime');
    print('reference, $reference');
  }

  static String defaultWorkTime() {
    return DateFormat('yyyyMMddHHmm').format(_defaultWorkTime);
  }

  // static String defaultEndTime() {
  //   return DateFormat('yyyyMMddHHmm').format(_defaultEndTime);
  // }

  static int defaultWorkingTime() {
    return _defaultWorkDuration;
  }

  static int defaultMealTime() {
    return _defaultMealDuration;
  }

  Work.fromJson(Map<dynamic, Object?> json, DocumentReference reference)
      : this(
            startTime: json['startTime']! as String,
            endTime: json['endTime']! as String,
            workingTime: json['workingTime']! as int,
            mealTime: json['mealTime']! as int,
            isAddMealTime: json['isAddMealTime']! as bool,
            annualLeave: json['annualLeave']! as int,
            reference: reference);

  Map<String, dynamic> toJson() {
    return {
      "startTime": startTime,
      "endTime": endTime,
      "workingTime": workingTime,
      "mealTime": mealTime,
      "isAddMealTime": isAddMealTime,
    };
  }

  static DateTime toDateTime(String time) {
    var timeData = time.substring(0, 8) + "T" + time.substring(8);
    return DateTime.parse(timeData);
  }

  static Work createDefaultWork() {
    return Work(
        startTime: DateFormat('yyyyMMddHHmm').format(_defaultWorkTime),
        endTime: DateFormat('yyyyMMddHHmm').format(_defaultWorkTime),
        isAddMealTime: false,
        mealTime: _defaultMealDuration,
        workingTime: 0,
        annualLeave: AnnualLeave.NONE.index);
  }

  static Work createOnLeaveWork() {
    return Work(
      startTime: Work.defaultWorkTime(),
      endTime: Work.defaultWorkTime(),
      isAddMealTime: false,
      mealTime: Work.defaultMealTime(),
      workingTime: Work.defaultWorkingTime(),
      annualLeave: AnnualLeave.ONLEAVE.index,
    );
  }

  WorkState currentWorkState() {
    var endTime = toDateTime(this.endTime);
    var startTime = toDateTime(this.startTime);
    if (_defaultWorkTime.difference(startTime).inMinutes == 0) {
      return WorkState.BEFORE_WORK;
    } else {
      if (_defaultWorkTime.difference(endTime).inMinutes == 0) {
        return WorkState.WORKING;
      } else {
        return WorkState.AFTER_WORK;
      }
    }
  }

  String _calculateWorkingTime(int inMinutes) {
    if (inMinutes == 0) return '계산 중';
    var hours = inMinutes ~/ 60;
    var minutes = inMinutes % 60;
    return '$hours시간 $minutes분';
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: 5 - dateTime.weekday));
  }

  void offWork() {
    var now = DateTime.now();
    var normalEndTime = now.subtract(Duration(minutes: _defaultMealDuration));
    if (isAddMealTime) {
      var workingTimeToDuraion = normalEndTime
          .add(Duration(minutes: mealTime))
          .difference(toDateTime(startTime));
      if (workingTimeToDuraion.isNegative) {
        throw 'dont offWork';
      } else {
        endTime = DateFormat("yyyyMMddHHmm").format(now);
        workingTime = workingTimeToDuraion.inMinutes;
      }
    } else {
      var workingTimeToDuraion =
          normalEndTime.difference(toDateTime(startTime));
      if (workingTimeToDuraion.isNegative) {
        throw 'dont offWork';
      } else {
        endTime = DateFormat("yyyyMMddHHmm").format(now);
        workingTime = workingTimeToDuraion.inMinutes;
      }
    }
  }

  String _makeOnLeaveText() {
    late String onLeaveText;
    switch (annualLeave) {
      case 0:
        {
          onLeaveText = '근 무';
          break;
        }
      case 1:
        {
          onLeaveText = '연 차';
          break;
        }
      case 2:
        {
          onLeaveText = '반 차';
          break;
        }
    }
    return onLeaveText;
  }

  bool isValidWorkTime() {
    var workingTime;
    if (annualLeave == AnnualLeave.NONE.index) {
      if (isAddMealTime) {
        workingTime = _now
            .add(Duration(minutes: mealTime - _defaultMealDuration))
            .difference(toDateTime(startTime));
      } else {
        workingTime = _now
            .subtract(Duration(minutes: _defaultMealDuration))
            .difference(toDateTime(startTime));
      }
    } else if (annualLeave == AnnualLeave.HALFONLEAVE.index) {
      workingTime = _now.difference(toDateTime(startTime));
    }
    return !workingTime.isNegative;
  }
}
