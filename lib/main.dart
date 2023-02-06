import 'package:flutter/material.dart';
import 'package:task/screens/home_page.dart';
import 'package:task/screens/login_page.dart';
import 'package:task/screens/register_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final routes = {
    '/login': (BuildContext context) => const LoginPage(),
    '/home': (BuildContext context) => const HomeScreen(),
    '/register': (BuildContext context) => const RegisterPage(),
    '/': (BuildContext context) => const LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      title: 'PayPal Payment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}