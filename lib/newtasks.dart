import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:todoapp/sharedcompenent.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreen();
}

class _TasksScreen extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context,index)=>Buildtaskitem(),
      
    separatorBuilder: (context, index )=>Padding(
      padding: const EdgeInsetsDirectional.only(start: 20),
      child: Container(width: double.infinity,height: 1, color: Colors.grey,),
    ), itemCount: 20);
     
}}