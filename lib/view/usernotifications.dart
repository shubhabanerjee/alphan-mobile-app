import 'package:flutter/material.dart';


class UserNotifications extends StatefulWidget {
  const UserNotifications({Key? key}) : super(key: key);

  @override
  State<UserNotifications> createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 5,
        title: Text("Notifications",style: TextStyle(color:Color.fromRGBO(154,205,50,1),fontSize: 16),),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text("Working on it..",style:TextStyle(color: Colors.red),),
    )
    );
  }
}
