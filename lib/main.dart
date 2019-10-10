import "package:flutter/material.dart";
import "utils/colors.dart";
import "screens/dashboard.dart";
import "screens/login.dart";

void main() {
  runApp(MaterialApp(
    title: 'Vetevo App',
    theme: ThemeData(
      primaryColor: PrimaryColor,
    ),
    initialRoute: '/dashboard',
    routes: {
      '/': (context) => LoginScreen(),
      '/dashboard': (context) => DashboardScreen()
    },
  ));
}
