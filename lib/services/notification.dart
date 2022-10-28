import 'package:allphanes/view/usernotifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';


class NotificationIcon extends StatefulWidget {
  const NotificationIcon({Key? key}) : super(key: key);

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>UserNotifications()));
          },
          icon:Stack(
              children:<Widget> [
                Icon(Icons.notifications,color: Colors.white,size: 3.h,),

              ]
          ) ,
        ),
        Positioned(
          right: 4,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle
            ),
            constraints: BoxConstraints(
              minWidth: 2.5.h,
              minHeight: 2.5.h,
            ),
            child:  Center(child: Text("0",style: TextStyle(color: Colors.white,fontSize: 1.5.h),textAlign: TextAlign.center,)),
          ),
        )
      ],
    );
  }
}

