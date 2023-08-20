import 'package:flutter/material.dart';

class AppTheme {
  ThemeData themeData = ThemeData(
      primarySwatch: Colors.deepOrange,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 218, 192, 163)))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 218, 192, 163),
          selectedIconTheme:
              IconThemeData(color: Color.fromARGB(255, 248, 240, 229)),
          unselectedIconTheme:
              IconThemeData(color: Color.fromARGB(255, 234, 219, 200)),
          selectedItemColor: Color.fromARGB(255, 248, 240, 229)),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 234, 219, 200),
        titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 248, 240, 229));
}
