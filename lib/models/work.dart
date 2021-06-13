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

  Work({
    required this.startTime,
    required this.endTime,
    required this.workingTime,
    required this.mealTime,
    required this.haveMeal,
  });

  static String defaultWorkTime() {
    return DateFormat('yyyyMMddHHmmss').format(_defaultWorkTime);
  }

  static int defaultWorkingTime() {
    return _defaultWorkDuration;
  }

  static int defaultMealTime() {
    return _defaultMealDuration;
  }

  Work.fromJson(Map<String, Object?> json)
      : this(
          startTime: json['starTime'] as String,
          endTime: json['endTime'] as String,
          workingTime: json['workingTime'] as int,
          mealTime: json['mealTime'] as int,
          haveMeal: json['haveMeal'] as bool,
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
}
