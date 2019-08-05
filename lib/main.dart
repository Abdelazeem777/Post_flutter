import 'package:flutter/material.dart';

import 'views/home/homeView.dart';
import 'views/login/loginView.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Post",
        routes: <String, WidgetBuilder>{
          Home.routeName: (BuildContext context) {
            return Home();
          },
          Login.routeName: (BuildContext context) {
            return Login();
          },
        },
        home: Login());
  }
}
