import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/cubit/states.dart';
import 'package:todoapp/sharedcompenent.dart';

class TasksScreen extends StatelessWidget {
  

 
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppCubitStates>(
listener: (BuildContext context,AppCubitStates states ) {},
builder: (BuildContext context,AppCubitStates states) {
  var task=AppCubit.git(context).newtasks;
 



return showTasksBuilder(task: task);
}
    );
     
}
}