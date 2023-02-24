
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

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
   bool IsbottomSheet = false;
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
  List  <Map> tasks=[];
  var database;
  var titleController=TextEditingController();
 var timeController=TextEditingController();
  var dateController=TextEditingController();

  IconData fabIcon = Icons.edit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createdatabase();
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();
 var formKey = GlobalKey<FormState>();
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
       
          if(IsbottomSheet){
               if(formKey.currentState!.validate()){
                insertToDataBasa(title: titleController.text, time: timeController.text, date: dateController.text).then((value) {
                   Navigator.pop(context);
                    IsbottomSheet=false;
                     setState(() {
              fabIcon=Icons.add;
            
                });
               
               
           
           });}
           
          }
          else{
              setState(() {
              fabIcon=Icons.edit;
            });
             scaffoldKey.currentState?.showBottomSheet(

            (context) =>Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              
              
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        onTap: (){ print('task title tapped $titleController'); },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          label: Text('Task Title'),
                        prefixIcon:Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('T',style: TextStyle(fontSize: 20,
                          
                          ),),
                        ), ),
                        
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        validator: ( value){
                          if(value==null|| value.isEmpty){
                            return 'Title must not be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 7,),
                      TextFormField(
                        onTap: (){
                        showTimePicker(context: context, initialTime: TimeOfDay.now(),).then(( value) {
                        
                          if (value!=null)
                         { print(value.format(context));
                          timeController.text=value.format(context);}
                       
                       
                          
                         
                           },
                        );
                        },

                        validator: ( value){
                          if(value==null|| value.isEmpty){
                            return 'Time must not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          label: Text('Task Time'),
                        prefixIcon:
                         
                           
                         Icon(Icons.watch_later_outlined, 
                            color: Colors.black,                   ),
                         ), 
                        
                        controller: timeController,
                        keyboardType: TextInputType.datetime,
                        
                      ),
                      SizedBox(height: 7,),
                     TextFormField(
                        onTap: (){
                          showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse('2025-12-29')).then((value) {

                                if (value!=null){
                       print(DateFormat.yMMMd().format(value));
                        dateController.text=DateFormat.yMMMd().format(value);
                          

                          }},
                          );
                      
                        
                       
                       
                          
                           },
                     
                        validator: ( value){
                          if(value==null|| value.isEmpty){
                            return 'Date must not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          label: Text('Task Date'),
                        prefixIcon:
                         
                           
                         Icon(Icons.calendar_today, 
                            color: Colors.black,                   ),
                         ), 
                        
                        controller:dateController,
                        keyboardType: TextInputType.datetime,
                        
                      ),
                    ],
                  ),
                ),
              ),
          
            elevation: 20,

          ).closed.then((value) {
             IsbottomSheet=false;
                     setState(() {
              fabIcon=Icons.add;
            
                });
          });

          IsbottomSheet=true;}
         
        },
        child:Icon(fabIcon),
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
      getDataFromDatabase(database).then((value) {tasks= value;
      print(tasks[1]);
      });
     
      
    print("data base is opend");
    });
  }

  Future insertToDataBasa({
    required String title,
    required String time,
    required String date,
  })  async{
    return await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title ,date, time, status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value insurted succesfully');
      }).catchError((error) {
        print('error in insurting data${error.toString()}');
      });

      return null;
    });
  }
  Future < List <Map>> getDataFromDatabase(database) async{
 
return await database.rawQuery('SELECT * FROM tasks');
 


  }
}
