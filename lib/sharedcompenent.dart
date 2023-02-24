import 'package:flutter/material.dart';
Widget Buildtaskitem(){
  return Padding(    
   padding: EdgeInsetsDirectional.all(15),
     child:  Row(
    
    children: [
      CircleAvatar(child:Text('20.02 pm', style: TextStyle(fontSize: 15,),),
       radius: 40,
       backgroundColor: Colors.blue,


      ),
      SizedBox(width: 15,),
       Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
      
          children: [Text('Task title', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        Text('Task date', style: TextStyle(color: Colors.grey),),
          ]),
   
       

    ],
    ),



);
}