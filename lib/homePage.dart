import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/sharedcompenent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/cubit/states.dart';

import 'package:todoapp/newtasks.dart';
import 'package:todoapp/archived.dart';
import 'package:todoapp/done.dart';

class ToDoScreen extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

 

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createdatabase(),
      child: BlocConsumer<AppCubit, AppCubitStates>(
        listener: (BuildContext context, AppCubitStates states) {
          if (states is insertDataBase) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppCubitStates states) {
          AppCubit cubit = AppCubit.git(context);

          return Scaffold(
            key: scaffoldKey,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentindex,
              onTap: (index) {
                cubit.BottmNAveChane(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archived'),
              ],
            ),
            appBar: AppBar(title: Text(cubit.titels[cubit.currentindex])),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.IsbottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDataBasa(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);

                    cubit.changebottomSheet(
                        isbottomsheetshow: false, icon: Icons.add);

                    print(cubit.newtasks);
                  }
                } else {
                  cubit.changebottomSheet(
                      isbottomsheetshow: true, icon: Icons.edit);

                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  onTap: () {
                                    print('task title tapped $titleController');
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    label: Text('Task Title'),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        'T',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then(
                                      (value) {
                                        if (value != null) {
                                          print(value.format(context));
                                          timeController.text =
                                              value.format(context);
                                        }
                                      },
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    label: Text('Task Time'),
                                    prefixIcon: Icon(
                                      Icons.watch_later_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2025-12-29'))
                                        .then(
                                      (value) {
                                        if (value != null) {
                                          print(
                                              DateFormat.yMMMd().format(value));
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        }
                                      },
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    label: Text('Task Date'),
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                    ),
                                  ),
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    cubit.changebottomSheet(
                        isbottomsheetshow: false, icon: Icons.edit);
                  });

                  cubit.changebottomSheet(
                      isbottomsheetshow: true, icon: Icons.add);
                }
               
              },
              child: Icon(cubit.fabIcon),
            ),
            body: ConditionalBuilder(
              condition: states is! getDataBaseLooding,
             
              builder: (context) => cubit.Screens[cubit.currentindex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            //  or tasks.length==0? Center(child: CircularProgressIndicator()) :Screens[currentindex],
          );
        },
      ),
    );
  }
}
