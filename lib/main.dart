import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

bool iconBool = false;

ThemeData _lightTheme = ThemeData.light(useMaterial3: true);
ThemeData _darkTheme = ThemeData.dark(useMaterial3: true);

class MyAppState extends State<MyApp> {
  callback(varIconBool) {
    setState(() {
      iconBool = varIconBool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: iconBool ? _darkTheme : _lightTheme,
      home: WeatherScreen(callbackFN: callback),
    );
  }
}
