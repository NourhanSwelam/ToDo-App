import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/sharedcompenent.dart';
import 'package:todoapp/cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:todoapp/sharedcompenent.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/newtasks.dart';
import 'package:todoapp/done.dart';
import 'package:todoapp/archived.dart';
import 'package:sqflite/sqflite.dart';
class AppCubit extends Cubit<AppCubitStates>{
  AppCubit():super(InitialStateApp());
  static AppCubit git(context)=>BlocProvider.of(context);
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

  void BottmNAveChane(int index){
    currentindex = index;
       emit(ChaneAppNAvBar());
  }
  void createdatabase() {
    
      openDatabase('todo.db', version: 1,
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
    },
     onOpen: (database) {

      getDataFromDatabase(database);

      print("data base is opend");
    }
    ).then((value) {
      database=value;
      emit(CreateDataBase ());
    }
    );
 
  }
  void updateDataBase (
    {required String status,
    required int id}
   ) async
   
   {
      await database.rawUpdate(
      'UPDATE tasks SET status =? WHERE id =?',
      ['$status','$id'],).then((value){
      getDataFromDatabase(database);
        emit(UpdatedataBasestate());
          
      });



     



   }
void deleteDataBase (
    {
    required int id}
   ) async
   
   {
      await database.rawDelete(
      'DELETE FROM tasks WHERE id =?',
      ['$id'],).then((value){
      
        emit(DeletedataBasestate());
          
      });
getDataFromDatabase(database);


     



   }


  Future insertToDataBasa({
    required String title,
    required String time,
    required String date,
  }) async {
    
   await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title ,date, time, status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value insurted succesfully');

        emit(insertDataBase());
         getDataFromDatabase(database);

      }).catchError((error) {
        print('error in insurting data${error.toString()}');
      });

      return null;
    });
  }

  void getDataFromDatabase(database) {
    donetasks=[];
            newtasks=[];
           archivedtasks=[];
    emit(getDataBaseLooding());
    database.rawQuery('SELECT * FROM tasks').then((value) {
 
      print(newtasks);

      value.forEach((element) {
        print(element['status']);
        if (element['status'] == 'done')
          donetasks.add(element);
        else if (element['status'] == 'new')
          newtasks.add(element);
        else if (element['status'] == 'archived') archivedtasks.add(element);
      }
      );
     
    }
    );
     emit(getDataBase());
  }
   List  <Map> newtasks=[];
   List  <Map> donetasks=[];
   List  <Map> archivedtasks=[];
//  List  <Map> tasks=[];




bool IsbottomSheet = false;
 IconData fabIcon = Icons.edit;
 void changebottomSheet({
  required bool isbottomsheetshow,
 required IconData icon
  }

 ){
 
IsbottomSheet=isbottomsheetshow;
     fabIcon =   icon;
emit(changeBottomsheet());

 }




}