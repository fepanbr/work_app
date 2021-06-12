import 'package:cloud_firestore/cloud_firestore.dart';

class Work {
  int id;
  DateTime startTime;
  DateTime endTime;
  Duration workingTime;
  Duration mealTime;

  Work(this.id, this.startTime, this.endTime, this.workingTime, this.mealTime);

  Work.fromSnapshot(DocumentSnapshot documentSnapshot)
      : this.id = (documentSnapshot.data() as Map<String, dynamic>)['id'],
        this.startTime =
            (documentSnapshot.data() as Map<String, dynamic>)['startTime'],
        this.endTime =
            (documentSnapshot.data() as Map<String, dynamic>)['endTime'],
        this.workingTime =
            (documentSnapshot.data() as Map<String, dynamic>)['workingTime'],
        this.mealTime =
            (documentSnapshot.data() as Map<String, dynamic>)['mealTime'];

  toJson() {
    return {
      "id": id,
      "startTime": startTime,
      "endTime": endTime,
      "workingTime": workingTime,
      "mealTime": mealTime
    };
  }
}
