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

  get startWorkTime => DateFormat('HH : mm').format(toDateTime(startTime));
  get endWorkTime => DateFormat('HH : mm').format(toDateTime(endTime));
  get workingTimeToString => _calculateWorkingTime();

  Work({
    required this.startTime,
    required this.endTime,
    required this.workingTime,
    required this.mealTime,
    required this.haveMeal,
  }) {
    print('startTime $startTime');
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

  Work.fromJson(Map<dynamic, Object?> json)
      : this(
          startTime: json['startTime']! as String,
          endTime: json['endTime']! as String,
          workingTime: json['workingTime']! as int,
          mealTime: json['mealTime']! as int,
          haveMeal: json['haveMeal']! as bool,
        );

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

  String _calculateWorkingTime() {
    if (workingTime == 0) return '계산 중';
    var hours = workingTime ~/ 60;
    var minutes = workingTime % 60;
    return '$hours시간 $minutes분';
  }
}
