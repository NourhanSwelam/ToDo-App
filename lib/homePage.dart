// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:todoapp/newtasks.dart';
import 'package:todoapp/archived.dart';
import 'package:todoapp/done.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  int currentindex = 0;

  List<String> titels = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Widget> Screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  var database;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createdatabase();
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentindex,
          onTap: (index) {
            setState(() {
              currentindex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive), label: 'Archived'),
          ]),
      appBar: AppBar(title: Text(titels[currentindex])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scaffoldKey.currentState?.showBottomSheet(
            (context) => Container(
              height: 100,
              width:double.infinity,
              color: Colors.amber,
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Screens[currentindex],
    );
  }

  void createdatabase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print(
          'tabel is created',
        );
      }).catchError((error) {
        print('Error is ${error.toString}');
      });
    }, onOpen: (database) {
      print("data base is opend");
    });
  }

  void insertToDataBasa() {
    database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title ,date, time, status) VALUES ("First task","12/22","10.30","new")')
          .then((value) {
        print('$value insurted succesfully');
      }).catchError((error) {
        print('error in insurting data${error.toString()}');
      });

      return null;
    });
  }
}
