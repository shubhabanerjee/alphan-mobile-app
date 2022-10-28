import 'dart:convert';

import 'package:allphanes/services/notification.dart';
import 'package:allphanes/services/post.dart';
import 'package:allphanes/services/posticontap.dart';
import 'package:allphanes/services/search.dart';
import 'package:allphanes/view/allphanesdrawer.dart';
import 'package:allphanes/view/myspace.dart';
import 'package:allphanes/view/sharepost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';



class Creations extends StatefulWidget {
  const Creations({Key? key}) : super(key: key);

  @override
  State<Creations> createState() => _CreationsState();
}

class _CreationsState extends State<Creations> with TickerProviderStateMixin{
  late AnimationController _controler;
  SharedPreferences? allphanesuserdata;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<TextEditingController>? textcontroller=[];
  bool seecomments=false;
  String commentsection="See Comments";

  var creationsdata;
  Future<void> fetchcreations()async{
    allphanesuserdata=await SharedPreferences.getInstance();
    String userid=allphanesuserdata!.getString("userid") ??"";
    print(userid);

    http.Response response=await http.get(Uri.parse("https://api.allphanes.com/api/posts/multiplefilters?token=$userid&type=Normal&lang=Bengali&&fav=false&sort=newf"));
    var data=jsonDecode(response.body);
    print(data);
    setState((){
      creationsdata=data;
    });
  }

  String calculatetime(d){
    var lastlogindate=DateTime.parse(d);
    var presenttime=DateTime.now();
    var difference=presenttime.difference(lastlogindate).inSeconds;
    if(difference>=60 && difference<3600){
      var m=difference/60;
      return "${m.toStringAsFixed(0)} m";
    }
    else if(difference>=3600 && difference<86400){
      var h=difference/3600;
      return '${h.toStringAsFixed(0)} h';

    }
    else if(difference>=86400){
      var d=difference/86400;
      return '${d.toStringAsFixed(0)} d';
    }
    else{
      var s=difference;
      return '${s.toStringAsFixed(0)} s';
    }
  }

  @override
  void initState(){
    super.initState();
    _controler=AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    fetchcreations();
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        //backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: GestureDetector(
            onTap: (){
              scaffoldKey.currentState!.isEndDrawerOpen?null: scaffoldKey.currentState?.openEndDrawer();

            },
            child: Center(
              child: AnimatedIcon(
                progress: _controler,
                icon: AnimatedIcons.menu_close,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 10.h,width: 10.w,
                  child: Image(image: AssetImage("images/allphanes_icon1.png"),fit: BoxFit.contain,)
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("My Canvas",style: TextStyle(color:  Color.fromRGBO(154,205,50,1),),),
              )
            ],
          ),
          actions:<Widget> [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SearchIcon(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: NotificationIcon(),
            ),
          ],
        ),
        //drawer: AllphanesDrawer(),
        endDrawer: AllphanesDrawer(),
        onEndDrawerChanged: (isOpened){
          if(isOpened){
            _controler.forward();
          }
          else{
            _controler.reverse();
          }

        },
        floatingActionButton: Post(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,


        body: SafeArea(
            child: creationsdata==null?Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child:
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context,index){
                    return ListTile(
                        leading: Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor:Colors.grey.shade200,
                          child: Container(
                            height: 7.h,
                            width: 7.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor:Colors.grey.shade200,
                          child: Row(
                            children: [
                              Container(
                                height: 1.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:5,bottom: 5),
                              child: Shimmer.fromColors(
                                highlightColor: Colors.white,
                                baseColor:Colors.grey.shade200,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 1.h,
                                      width: 40.w,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              highlightColor: Colors.white,
                              baseColor:Colors.grey.shade200,
                              child: Row(
                                children: [
                                  Container(
                                    height: 1.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    );
                  },
                )
              // Center(
              //   child: CircularProgressIndicator(backgroundColor:Color.fromRGBO(154,205,50,1),
              //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),strokeWidth: 5,),
              // ),
            ):
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image(image: AssetImage("images/home_bg.png"),fit: BoxFit.fill,),
                ),
                ListView.builder(
                  itemCount: creationsdata!=null?creationsdata["responseData"].length:0,
                  itemBuilder: (BuildContext context,index){
                    textcontroller!.add(new TextEditingController());
                    return
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // height: 40.h,
                          // width: 70.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            //border: Border.all(color: Colors.grey,width: .5)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 7.h,
                                      width: 60.w,
                                      //color: Colors.red,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: GestureDetector(
                                              onTap: ()async{
                                                allphanesuserdata=await SharedPreferences.getInstance();
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(allphanesuserdata!.getString("userid"), creationsdata["responseData"][index]["user_info"][0]["_id"])));
                                              },
                                              child: Container(
                                                height: 7.h,
                                                width: 7.h,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    //color: Colors.green,
                                                    image: creationsdata["responseData"][index]["user_info"][0]["profilePhoto"]!=""?DecorationImage(
                                                        image:
                                                        CachedNetworkImageProvider("${creationsdata["responseData"][index]["user_info"][0]["profilePhoto"]}",),fit: BoxFit.fill
                                                    ):
                                                    DecorationImage(image: AssetImage("images/default_profileimage.png"),fit: BoxFit.contain)
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: SizedBox(child: GestureDetector(
                                                        onTap: ()async{
                                                          allphanesuserdata=await SharedPreferences.getInstance();
                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(allphanesuserdata!.getString("userid"), creationsdata["responseData"][index]["user_info"][0]["_id"])));
                                                        },
                                                        child: Text("${creationsdata["responseData"][index]["user_info"][0]["showName"]}",style: TextStyle(fontSize: 2.5.w,fontWeight: FontWeight.bold),textAlign: TextAlign.justify))
                                                    )
                                                ),
                                                Text("${calculatetime(creationsdata["responseData"][index]["createdAt"])}",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 7.h,
                                      width:30.w,
                                      //color: Colors.red,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: ()async{
                                                IconButtonsTap tap=await new IconButtonsTap(allphanesuserdata!.getString("userid"));
                                                tap.TapOnFavorite(creationsdata["responseData"][index]["referenceUserId"],creationsdata["responseData"][index]["_id"]).then((value) =>fetchcreations() );

                                              },
                                              icon: Icon(Icons.bookmark,color:creationsdata["responseData"][index]["isFav"].length>0 && creationsdata["responseData"][index]["isFav"][0]["mark"]==false? Colors.grey:Colors.red,size: 3.5.h,),
                                            ),
                                            PopupMenuButton(
                                                itemBuilder: (_) => <PopupMenuItem<String>>[
                                                  // PopupMenuItem<String>(
                                                  //     child: Text('Block'), value: 'block'),
                                                  creationsdata["responseData"][index]["referenceUserId"]!=allphanesuserdata!.getString("userid")?
                                                  PopupMenuItem<String>(
                                                      child:Text('Report'), value: 'report'):
                                                  PopupMenuItem<String>(
                                                      child:Text('Delete Post'), value: 'delete post'),
                                                ],
                                                onSelected: (_) {

                                                }
                                            )

                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(height: .5,thickness: .5,color: Colors.grey.shade400,),
                              Padding(
                                padding: const EdgeInsets.only(top: 15,left: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(creationsdata["responseData"][index]["postTitle"]!="Quick Post"?"${creationsdata["responseData"][index]["postTitle"]}":"",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                                  ],
                                ),
                              ),
                              creationsdata["responseData"][index]["postInfo"].length>0?Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                    image:CachedNetworkImageProvider("${creationsdata["responseData"][index]["postInfo"][0]["postImagePath"]}")
                                  //image: NetworkImage("https://res.cloudinary.com/dsg7oitoj/image/upload/v1657552770/hhhx9auezdx2e14skekg.jpg"),
                                ),
                              ):
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${creationsdata["responseData"][index]["postDescription"]}",style: TextStyle(color: Colors.black,fontSize: 14),textAlign: TextAlign.justify,),
                              ),

                              creationsdata["responseData"][index]["postType"]=="Normal"?Container():
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey,width: .5),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: Container(
                                              height: 7.h,
                                              width: 60.w,
                                              //color: Colors.red,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(2),
                                                    child: GestureDetector(
                                                      onTap: ()async{
                                                        allphanesuserdata=await SharedPreferences.getInstance();
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(allphanesuserdata!.getString("userid"), creationsdata["responseData"][index]["shareUserId"])));
                                                      },
                                                      child: Container(
                                                        height: 6.h,
                                                        width: 6.h,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            //color: Colors.green,
                                                            image: creationsdata["responseData"][index]["shareProfile"]!=""?DecorationImage(
                                                                image:
                                                                CachedNetworkImageProvider("${creationsdata["responseData"][index]["shareProfile"]}",),fit: BoxFit.fill
                                                            ):
                                                            DecorationImage(image: AssetImage("images/default_profileimage.png"),fit: BoxFit.contain)
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: SizedBox(child: GestureDetector(
                                                                onTap: ()async{
                                                                  allphanesuserdata=await SharedPreferences.getInstance();
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(allphanesuserdata!.getString("userid"), creationsdata["responseData"][index]["shareUserId"])));
                                                                },
                                                                child: Text("${creationsdata["responseData"][index]["shareFullName"]}",style: TextStyle(fontSize: 2.5.w,fontWeight: FontWeight.bold),textAlign: TextAlign.justify))
                                                            )
                                                        ),
                                                        //Text("${calculatetime(mycanvasdata["responseData"][index]["createdAt"])}",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(height: .3,thickness: .3,color: Colors.grey.shade400,),
                                      creationsdata["responseData"][index]["shareGalleryInfo"]==""?Container():
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(image: CachedNetworkImageProvider('${creationsdata["responseData"][index]["shareGalleryInfo"]}'),fit: BoxFit.contain,),
                                      ),

                                      creationsdata["responseData"][index]["shareDescription"]==""?Container():
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("${creationsdata["responseData"][index]["shareDescription"]}",style: TextStyle(color: Colors.black,fontSize: 12),textAlign: TextAlign.justify,),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.favorite,color:creationsdata["responseData"][index]["isLiked"].length<1? Colors.grey:Colors.red,size: 3.h,),
                                      onPressed: ()async{
                                        IconButtonsTap tap=await new IconButtonsTap(allphanesuserdata!.getString("userid"));
                                        tap.TapOnLike(creationsdata["responseData"][index]["referenceUserId"],creationsdata["responseData"][index]["_id"]).then((value) =>fetchcreations() );
                                      },
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.comment_bank_rounded,color: Colors.grey,size: 3.h,),
                                      onPressed: (){

                                      },
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.send_rounded,color: Colors.grey,size: 3.h,),
                                      onPressed: (){
                                        if(allphanesuserdata!.getString("userid")==creationsdata["responseData"][index]["referenceUserId"]){
                                          Fluttertoast.showToast(
                                              msg: "Can't share own post",
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Color.fromRGBO(154,205,50,1),
                                              textColor: Colors.red,
                                              fontSize: 12.0
                                          );
                                        }
                                        else{
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SharePost(creationsdata["responseData"][index])));
                                        }
                                      },
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.link,color: Colors.grey,size: 3.h,),
                                      onPressed: (){

                                      },
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${creationsdata["responseData"][index]["totalLikes"]} Likes  ${creationsdata["responseData"][index]["totalComment"]} Comments",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Divider(height: .5,thickness: .5,color: Colors.grey.shade400,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Container(
                                              height: 5.h,
                                              width: 5.h,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  //color: Colors.green,
                                                  image:allphanesuserdata!.getString("profilephoto")!=""?DecorationImage(
                                                      image:
                                                      CachedNetworkImageProvider("${allphanesuserdata!.getString("profilephoto")}",),fit: BoxFit.fill

                                                  ):
                                                  DecorationImage(
                                                      image:
                                                      AssetImage("images/default_profileimage.png"),fit: BoxFit.contain
                                                  )

                                              ),
                                            ),
                                          ),

                                          Container(
                                            height: 6.5.h,
                                            width: 50.w,
                                            decoration: BoxDecoration(
                                              //color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              // color: Color.fromRGBO(154,205,50,1),
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color: Colors.grey.withOpacity(1),
                                              //     spreadRadius: 1,
                                              //     blurRadius: 5,
                                              //     offset: Offset(0,5), // changes position of shadow
                                              //   ),
                                              // ],
                                            ),
                                            child: Center(
                                              child: TextFormField(
                                                cursorColor: Colors.grey,
                                                style: TextStyle(color: Colors.black ,fontSize: 1.5.h),
                                                //autovalidate: false,
                                                validator: (value){

                                                },

                                                enableInteractiveSelection: true,
                                                controller: textcontroller![index],
                                                decoration: InputDecoration(
                                                  //filled: true,
                                                  //fillColor: Color.fromRGBO(154,205,50,1),
                                                  // labelText: "Email Address",
                                                  // labelStyle: TextStyle(color: Colors.white),
                                                  hintText: "Add Your Comment",
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  // focusedBorder: OutlineInputBorder(
                                                  //   borderRadius: BorderRadius.circular(10.0),
                                                  //   // borderSide: BorderSide(
                                                  //   //   color:Color.fromRGBO(154,205,50,1),
                                                  //   // ),
                                                  // ),
                                                  // enabledBorder: OutlineInputBorder(
                                                  //   borderRadius: BorderRadius.circular(10.0),
                                                  //   borderSide: BorderSide(
                                                  //     color: Color.fromRGBO(154,205,50,1),
                                                  //     width: 1.0,
                                                  //   ),
                                                  // ),
                                                ),
                                                keyboardType: TextInputType.text,
                                                onChanged: (value){
                                                },
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                        child: Text("Post",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 2.h),),
                                        onPressed: (){


                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color.fromRGBO(154,205,50,1),
                                          //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                        )
                                    )
                                  ],

                                ),
                              ),

                              creationsdata["responseData"][index]["user_comment"].length>0?
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ExpansionPanelList(
                                  animationDuration: const Duration(seconds: 1),
                                  elevation: 2,
                                  children: [
                                    ExpansionPanel(
                                        isExpanded:seecomments,
                                        canTapOnHeader: true,
                                        headerBuilder: (context, isExpanded) {
                                          return ListTile(
                                            onTap: (){
                                              setState(() {
                                                seecomments=!seecomments;
                                                commentsection=="See Comments"?commentsection="Hide Comments":commentsection="See Comments";
                                              });
                                            },
                                            title: Text('$commentsection', style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                                          );
                                        },
                                        body: Container(
                                          height: 100,
                                          width: 100,
                                          color: Colors.red,
                                        )
                                    )
                                  ],
                                ),
                              )
                                  :
                              Container(),

                            ],
                          ),
                        ),
                      );
                  },
                ),
              ],
            )
        ),

      );
  }
}
