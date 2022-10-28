import 'package:allphanes/view/searchprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';


class SearchIcon extends StatefulWidget {
  const SearchIcon({Key? key}) : super(key: key);

  @override
  State<SearchIcon> createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchProfile()));
      },
      icon:Icon(Icons.search,color: Colors.white,size: 3.h,),
    );
  }
}
