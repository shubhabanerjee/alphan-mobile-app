import 'package:allphanes/view/userpost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';


class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 5,
      //backgroundColor: Color.fromRGBO(154,205,50,1),
      backgroundColor: Colors.red,
      mini: true,
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPost()));
      },
      child: Icon(
        Icons.post_add,
        color: Colors.white,
        //size: 2.5.h,
      ),
    );
  }
}
