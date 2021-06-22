import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_app/components/backgroundBlueBox.dart';
import 'package:commute_app/components/weeklyWorkCard.dart';
import 'package:commute_app/components/worktimeCard.dart';
import 'package:commute_app/constants.dart';
import 'package:commute_app/models/work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeeklyWorkPage extends StatefulWidget {
  const WeeklyWorkPage({Key? key}) : super(key: key);

  @override
  _WeeklyWorkPageState createState() => _WeeklyWorkPageState();
}

class _WeeklyWorkPageState extends State<WeeklyWorkPage> {
  final workRef =
      FirebaseFirestore.instance.collection('work').withConverter<Work>(
            fromFirestore: (snapshot, _) =>
                Work.fromJson(snapshot.data()!, snapshot.reference),
            toFirestore: (work, _) => work.toJson(),
          );
  List<Work> workList = [];
  final now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> setWork() async {
    var startTime = DateFormat("yyyyMMddHHmm").format(Work.monday);
    var endTime = DateFormat("yyyyMMddHHmm").format(Work.friday);
    List<QueryDocumentSnapshot<Work>> workListInServer = await workRef
        .where('startTime', isGreaterThanOrEqualTo: startTime)
        .where('startTime', isLessThanOrEqualTo: endTime)
        .get()
        .then((value) => value.docs);

    workList.addAll(workListInServer.map((e) => e.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundBlueBox(),
        Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  DateFormat('M월').format(now),
                  style: TextStyle(
                    color: kBackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                  ),
                ),
              ),
              FutureBuilder(
                future: setWork(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 310,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                            margin: EdgeInsets.fromLTRB(kDefaultPadding, 40,
                                kDefaultPadding, kDefaultPadding / 2),
                            width: 250,
                            child: WeeklyWorkCard(work: workList[index]),
                          );
                        },
                        itemCount: workList.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  } else {
                    return Center(
                        heightFactor: 10, child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
