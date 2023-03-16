import 'package:flutter/material.dart';
import 'package:todoapp/cubit/cubit.dart';



import 'package:conditional_builder/conditional_builder.dart';




















Widget Buildtaskitem(Map model,context){
  return 
Dismissible(

    
    key: Key (model['status'].toString()),
    child: Padding(    
     padding: EdgeInsetsDirectional.all(15),
       child:  Row(
      
      children: [
        CircleAvatar(child:Text('${model['time']}', style: TextStyle(fontSize: 15,),),
         radius: 40,
         backgroundColor: Colors.blue,
  
  
        ),
        SizedBox(width: 15,),
         Expanded(
           child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
               
              children: [Text('${model['title']}', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            Text('${model['date']}', style: TextStyle(color: Colors.grey),),
              ]),
         ),
         SizedBox(width: 15,),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.green[300]
          ,child: IconButton(onPressed: (){
            AppCubit.git(context).updateDataBase(status: 'done', id:model['id'] );
          }, icon: Icon(Icons.done,color: Colors.white,))),
        SizedBox(width: 15,),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black45,
          child: IconButton(onPressed: (){
            AppCubit.git(context).updateDataBase(status: 'archived', id:model['id'] );
          }, icon: Icon(Icons.archive,color: Colors.white,))), 
  
      ],
      ),
  
  
  
  ),
  onDismissed: (direction){
    
    AppCubit.git(context).deleteDataBase(id: model['id']);
    
  },
   background: Container(
                 color: Colors.red[200],
                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.delete,
                    )
                  ],
                ),
              )
);           
}
             
 


Widget showTasksBuilder({required List <Map> task}){
  return ConditionalBuilder(
      condition: task.length>0,
      fallback:(context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_outlined,size: 80,color: Colors.black87,),
              Text('No Tasks Yet, Please add tasks',style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),)
            ],
          ),
        );},



        builder:(context) {
          
        return ListView.separated(
          itemBuilder: (context,index)=>Buildtaskitem(task[index],context),
          
        separatorBuilder: (context, index )=>Padding(
          padding: const EdgeInsetsDirectional.only(start: 20),
          child: Container(width: double.infinity,height: 1, color: Colors.grey,),
        ), itemCount: task.length
        );
        }
      );
}
 
