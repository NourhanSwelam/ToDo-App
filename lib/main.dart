import 'package:flutter/material.dart';
import 'package:todoapp/cubit/observed_bloc.dart';
import 'package:todoapp/homePage.dart';
import 'package:bloc/bloc.dart';
void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:ToDoScreen(),
    );
  }
}