import 'package:commute_app/constants.dart';
import 'package:commute_app/homePage.dart';
import 'package:commute_app/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: kPrimaryColor,
              accentColor: kPrimaryColor,
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            ),
            initialRoute: '/login',
            getPages: [
              GetPage(name: '/', page: () => HomePage()),
              GetPage(name: '/login', page: () => LoginPage()),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
