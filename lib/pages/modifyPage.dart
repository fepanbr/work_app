import 'package:flutter/material.dart';

class ModifyPage extends StatefulWidget {
  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Work App'),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
    );
  }
}
