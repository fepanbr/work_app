import 'package:commute_app/constants.dart';
import 'package:commute_app/homePage.dart';
import 'package:commute_app/pages/loginPage.dart';
import 'package:commute_app/pages/modifyPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light, //status bar brightness
    statusBarIconBrightness: Brightness.light, //status barIcon Brightness
  ));
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
              appBarTheme: Theme.of(context)
                  .appBarTheme
                  .copyWith(brightness: Brightness.dark),
              primaryColor: kPrimaryColor,
              accentColor: kPrimaryColor,
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            ),
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => HomePage()),
              GetPage(name: '/login', page: () => LoginPage()),
              GetPage(name: '/modify', page: () => ModifyPage()),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
