import 'package:annotations/constants.dart';
import 'package:annotations/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Annotations',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: KPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}