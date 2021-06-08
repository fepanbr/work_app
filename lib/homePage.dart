import 'package:commute_app/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Tab> tabs = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.data == null) {
          return LoginPage();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('홈화면'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${snapshot.data!.displayName}님 환영합니다."),
                  ElevatedButton(
                    onPressed: () async {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text("로그아웃"),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
