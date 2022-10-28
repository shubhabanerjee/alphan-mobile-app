import 'dart:convert';

import 'package:allphanes/view/myspace.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class SearchProfile extends StatefulWidget {
  const SearchProfile({Key? key}) : super(key: key);

  @override
  State<SearchProfile> createState() => _SearchProfileState();
}

class _SearchProfileState extends State<SearchProfile> {
  SharedPreferences? allphanesuserdata;
  TextEditingController searchtext=TextEditingController();
  var searchitem;
  Future<void> membersearch()async{
    allphanesuserdata=await SharedPreferences.getInstance();
    String userid=allphanesuserdata!.getString("userid") ??"";
    print(userid);

    http.Response response=await http.get(Uri.parse("https://api.allphanes.com/api/services/searchbar/${searchtext.text}/$userid"));
    var data=jsonDecode(response.body);
    print(data);
    setState((){
      searchitem=data;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 5,
        title: Text("Search Profile",style: TextStyle(color:Color.fromRGBO(154,205,50,1),fontSize: 16),),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey,width: .3)
                  ),
                  child: Center(
                    child: TextField(
                      onChanged: (v){
                        if(searchtext.text.length>0){
                          membersearch();
                        }
                        },
                      controller: searchtext,
                      cursorColor: Color.fromRGBO(154,205,50,1),
                      cursorHeight: 18,
                      decoration: InputDecoration(
                        hintText: "Search a profile here",
                        hintStyle: TextStyle(color: Colors.grey,),
                        prefixIcon: Icon(Icons.search,color: Colors.grey.shade300,size: 25,),
                        suffixIcon: searchtext.text.length>=1?
                        IconButton(
                            onPressed: (){
                              setState(() {
                                searchtext.clear();
                                searchitem=null;
                              });

                            },
                            icon:Icon(Icons.close,color: Colors.red,size: 18,)
                        ):null,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              searchitem!=null?Padding(
                padding: const EdgeInsets.only(top: 5,left: 10,right: 10),
                child: Container(
                  height: searchitem["responseData"].length*10.h,
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                    maxHeight: 50.h,
                    minHeight: 25.h
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                  ),
                  child: searchitem["responseData"].length>0?ListView.builder(
                    itemCount: searchitem!=null?searchitem["responseData"].length:0,
                    itemBuilder: (BuildContext context,index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ListTile(
                          onTap: ()async{
                            allphanesuserdata=await SharedPreferences.getInstance();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(allphanesuserdata!.getString("userid"),searchitem["responseData"][index]["_id"]))).then((value){
                              setState(() {
                                searchitem=null;
                                searchtext.clear();
                              });
                            });
                          },
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 5,bottom: 5),
                            child: Container(
                              height: 7.h,
                              width: 7.h,
                              //color: Colors.red,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: searchitem["responseData"][index]["profilePhoto"]!=""?
                                    DecorationImage(image:CachedNetworkImageProvider("${searchitem["responseData"][index]["profilePhoto"]}"),fit: BoxFit.contain)
                                    :
                                    DecorationImage(image:AssetImage("images/default_profileimage.png"),fit: BoxFit.contain )
                              ),
                            ),
                          ),
                          title: Text("${searchitem["responseData"][index]["showName"]}"),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,color: Color.fromRGBO(154,205,50,1),size: 15,),

                        ),
                      );

                    },
                  )
                      :
                      Center(
                        child: Text("No such profiles!",style: TextStyle(color: Colors.red),),
                      )
                  ,
                ),
              ):Container()
            ],
          ),
        ],
      ),

    );
  }
}
