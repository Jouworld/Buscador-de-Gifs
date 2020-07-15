import 'package:flutter/material.dart';
import 'Home_Page.dart';
void main(){
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        )),
    debugShowCheckedModeBanner: false,
  ));
}


//
