import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_app/models/workState.dart';
import 'package:intl/intl.dart';

class Work {
  static final _now = DateTime.now();
  static final DateTime _defaultWorkTime =
      DateTime(_now.year, _now.month, _now.day, 0, 0, 0);
  static final int _defaultWorkDuration = 0; // minutes
  static final int _defaultMealDuration = 60; // minutes
  String startTime;
  String endTime;
  int workingTime;
  int mealTime;
  bool haveMeal;
  DocumentReference? reference;

  get startWorkTime => DateFormat('HH : mm').format(toDateTime(startTime));
  get endWorkTime => DateFormat('HH : mm').format(toDateTime(endTime));
  get workingTimeToString => _calculateWorkingTime(workingTime);
  get mealTimeToString => _calculateWorkingTime(mealTime);

  Work({
    required this.startTime,
    required this.endTime,
    required this.workingTime,
    required this.mealTime,
    required this.haveMeal,
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
            haveMeal: json['haveMeal']! as bool,
            reference: reference);

  Map<String, dynamic> toJson() {
    return {
      "startTime": startTime,
      "endTime": endTime,
      "workingTime": workingTime,
      "mealTime": mealTime,
      "haveMeal": haveMeal,
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
      haveMeal: false,
      mealTime: _defaultMealDuration,
      workingTime: 0,
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

  void offWork() {
    var now = DateTime.now();
    var normalEndTime = now.subtract(Duration(minutes: _defaultMealDuration));
    if (haveMeal) {
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
}
