import 'dart:convert';
import 'package:allphanes/services/post.dart';
import 'package:allphanes/services/posticontap.dart';
import 'package:allphanes/services/search.dart';
import 'package:allphanes/view/allphanesdrawer.dart';
import 'package:allphanes/services/notification.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class MySpace extends StatefulWidget {
  //const MySpace({Key? key}) : super(key: key);
  String? userid;
  String? userspaceid;
  MySpace(uid,uspid){
    this.userid=uid;
    this.userspaceid=uspid;
  }

  @override
  State<MySpace> createState() => _MySpaceState();
}

class _MySpaceState extends State<MySpace> with TickerProviderStateMixin{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controler;
  SharedPreferences? allphanesuserdata;
  List<TextEditingController>? textcontroller=[];

  var myspacedata;
  Future<void> fetchmyspace()async{
    allphanesuserdata=await SharedPreferences.getInstance();
    String userid=allphanesuserdata!.getString("userid") ??"";
    print(userid);
    http.Response response=await http.get(Uri.parse("https://api.allphanes.com/api/posts/multiplefilters?token=${widget.userspaceid}&refToken=${widget.userspaceid}"));
    // http.Response response=await http.get(Uri.parse("https://api.allphanes.com/api/posts/userspace/${widget.userid}/${widget.userspaceid}"));
    var data=jsonDecode(response.body);
    print(data);
    setState((){
      myspacedata=data;
    });
  }

  var numberofpost;
  Future<void> fetchnumberofpost()async{
    allphanesuserdata=await SharedPreferences.getInstance();
    String userid=allphanesuserdata!.getString("userid") ??"";
    print(userid);

    http.Response response=await http.get(Uri.parse("https://api.allphanes.com/api/services/numOfPost/62a6e09582ad207566bc1384/$userid"));
    var data=jsonDecode(response.body);
    print(data);
    setState((){
      numberofpost=data["responseData"];
    });
  }

  void initState(){
    super.initState();
    _controler=AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    fetchmyspace();
  }

  @override
  void dispose(){
    _controler.dispose();
    for(int i=0;i<textcontroller!.length;i++){
      textcontroller![i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 10.h,width: 10.w,
                child: Image(image: AssetImage("images/allphanes_icon1.png"),fit: BoxFit.contain,)
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("My Space",style: TextStyle(color:  Color.fromRGBO(154,205,50,1),),),
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
        child: myspacedata==null?
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:Center(
            child: CircularProgressIndicator(backgroundColor:Color.fromRGBO(154,205,50,1),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),strokeWidth: 5,),
          ),
        )
            :
        myspacedata["responseData"].length<1?
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text("No UserData",style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),
              ),
            ):
        ListView(
          children: [
            Stack(
              //fit: StackFit.loose,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                      image: allphanesuserdata!.getString("coverphoto")==""?
                      DecorationImage(
                          image:AssetImage("images/default_profileimage.png"),
                        fit: BoxFit.fill
                      ):
                      DecorationImage(
                          image:CachedNetworkImageProvider("${allphanesuserdata!.getString("coverphoto")}"),
                        fit: BoxFit.fill
                      )
                  ),
                ),
                Container(
                  height: 25.h,
                  width: 100.w,
                  //color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: IconButton(
                          onPressed: (){

                          },
                          icon: Icon(Icons.camera_enhance_rounded,color: Colors.blue,size: 3.5.h,),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 23.h,
                  left: 2.h,
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 8.h,
                              width: 8.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                  //border:Border.all(color: Colors.black),
                                  //color: Colors.white,
                                image: myspacedata["responseData"][0]["user_info"][0]["profilePhoto"]==""?DecorationImage(
                                      image:AssetImage("images/default_profileimage.png"),
                                  fit: BoxFit.fill
                                ):
                                    DecorationImage(
                                      image: CachedNetworkImageProvider("${myspacedata["responseData"][0]["user_info"][0]["profilePhoto"]}"),
                                      fit: BoxFit.fill
                                    )

                              ),
                          ),
                          Positioned(
                            top: 4.h,
                            left: 4.h,
                            child: IconButton(
                              onPressed: (){

                              },
                              icon: Icon(Icons.camera_enhance_rounded,color: Colors.blue,size: 3.h,),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("${myspacedata["responseData"][0]["user_info"][0]["showName"]}",style: TextStyle(color: Colors.black,fontSize: 3.h,fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.h,),
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("1",style: TextStyle(color: Colors.black,fontSize: 4.w,fontWeight: FontWeight.bold),),
                      ),
                      Text("FRIENDS",style: TextStyle(color: Colors.grey,fontSize: 4.w),)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("0",style: TextStyle(color: Colors.black,fontSize: 4.w,fontWeight: FontWeight.bold),),
                      ),
                      Text("POSTS",style: TextStyle(color: Colors.grey,fontSize: 4.w),)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("3",style: TextStyle(color: Colors.black,fontSize: 4.w,fontWeight: FontWeight.bold),),
                      ),
                      Text("PHOTOS",style: TextStyle(color: Colors.grey,fontSize: 4.w),)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("0",style: TextStyle(color: Colors.black,fontSize: 4.w,fontWeight: FontWeight.bold),),
                      ),
                      Text("VIDEOS",style: TextStyle(color: Colors.grey,fontSize: 4.w),)
                    ],
                  ),
                )
              ],
            ),
            DefaultTabController(
              length: 4,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      labelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 1,
                      isScrollable: true,
                      indicatorColor: Color.fromRGBO(154,205,50,1),
                      tabs: [
                        Tab(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Posts",style: TextStyle(fontSize: 14),),
                            ),
                          ),
                        ),

                        Tab(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Videos",style: TextStyle(fontSize: 14),),
                            ),
                          ),
                        ),

                        Tab(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Photos",style: TextStyle(fontSize: 14),),
                            ),
                          ),
                        ),

                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Friends",style: TextStyle(fontSize: 14),),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 50.h,
                      color: Colors.grey.shade100,
                      child: TabBarView(
                        children: [
                          //posts......................................................................
                          ListView.builder(
                            itemCount: myspacedata["responseData"].length>0?myspacedata["responseData"].length:0,
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
                                                      child: Container(
                                                        height: 7.h,
                                                        width: 7.h,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            //color: Colors.green,
                                                            image: myspacedata["responseData"][index]["user_info"][0]["profilePhoto"]!=""?DecorationImage(
                                                                image:
                                                                NetworkImage("${myspacedata["responseData"][index]["user_info"][0]["profilePhoto"]}",),fit: BoxFit.fill
                                                            ):
                                                            DecorationImage(image: AssetImage("images/default_profileimage.png"),fit: BoxFit.contain)
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: SizedBox(child: Text("${myspacedata["responseData"][index]["user_info"][0]["showName"]}",style: TextStyle(fontSize: 2.5.w,fontWeight: FontWeight.bold),textAlign: TextAlign.justify))
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
                                                          tap.TapOnFavorite(myspacedata["responseData"][index]["referenceUserId"],myspacedata["responseData"][index]["_id"]).then((value) =>fetchmyspace() );

                                                        },
                                                        icon: Icon(Icons.bookmark,color:myspacedata["responseData"][index]["isFav"].length>0 && myspacedata["responseData"][index]["isFav"][0]["mark"]==false? Colors.grey:Colors.red,size: 3.5.h,),
                                                      ),
                                                      PopupMenuButton(
                                                          itemBuilder: (_) => <PopupMenuItem<String>>[
                                                            // PopupMenuItem<String>(
                                                            //     child: Text('Block'), value: 'block'),
                                                            myspacedata["responseData"][index]["referenceUserId"]!=allphanesuserdata!.getString("userid")?
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
                                              Text(myspacedata["responseData"][index]["postTitle"]!="Quick Post"?"${myspacedata["responseData"][index]["postTitle"]}":"",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                                            ],
                                          ),
                                        ),
                                        myspacedata["responseData"][index]["postInfo"].length>0?Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Image(
                                                  image:NetworkImage("${myspacedata["responseData"][index]["postInfo"][0]["postImagePath"]}")
                                                //image: NetworkImage("https://res.cloudinary.com/dsg7oitoj/image/upload/v1657552770/hhhx9auezdx2e14skekg.jpg"),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(myspacedata["responseData"][index]["keywords2"]!=null?"${myspacedata["responseData"][index]["keywords2"]}":"",style: TextStyle(color: Colors.blue,fontSize: 14))
                                                ],
                                              )
                                            ],
                                          ),
                                        ):
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text("${myspacedata["responseData"][index]["postDescription"]}",style: TextStyle(color: Colors.black,fontSize: 14),textAlign: TextAlign.justify,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(myspacedata["responseData"][index]["keywords2"]!=null?"${myspacedata["responseData"][index]["keywords2"]}":"",style: TextStyle(color: Colors.blue,fontSize: 14))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),

                                        myspacedata["responseData"][index]["postType"]=="Normal"?Container():
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
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(allphanesuserdata!.getString("userid"), myspacedata["responseData"][index]["shareUserId"])));
                                                                },
                                                                child: Container(
                                                                  height: 6.h,
                                                                  width: 6.h,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      //color: Colors.green,
                                                                      image: myspacedata["responseData"][index]["shareProfile"]!=""?DecorationImage(
                                                                          image:
                                                                          CachedNetworkImageProvider("${myspacedata["responseData"][index]["shareProfile"]}",),fit: BoxFit.fill
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
                                                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(allphanesuserdata!.getString("userid"), myspacedata["responseData"][index]["shareUserId"])));
                                                                          },
                                                                          child: Text("${myspacedata["responseData"][index]["shareFullName"]}",style: TextStyle(fontSize: 2.5.w,fontWeight: FontWeight.bold),textAlign: TextAlign.justify))
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
                                                myspacedata["responseData"][index]["shareGalleryInfo"]==""?Container():
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Image(image: CachedNetworkImageProvider('${myspacedata["responseData"][index]["shareGalleryInfo"]}'),fit: BoxFit.contain,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(myspacedata["responseData"][index]["keywords2"]!=null?"${myspacedata["responseData"][index]["keywords2"]}":"",style: TextStyle(color: Colors.blue,fontSize: 14))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),

                                                myspacedata["responseData"][index]["shareDescription"]==""?Container():
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text("${myspacedata["responseData"][index]["shareDescription"]}",style: TextStyle(color: Colors.black,fontSize: 12),textAlign: TextAlign.justify,),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(myspacedata["responseData"][index]["keywords2"]!=null?"${myspacedata["responseData"][index]["keywords2"]}":"",style: TextStyle(color: Colors.blue,fontSize: 14))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.favorite,color:myspacedata["responseData"][index]["isLiked"].length<1? Colors.grey:Colors.red,size: 3.h,),
                                                onPressed: ()async{
                                                  IconButtonsTap tap=await new IconButtonsTap(allphanesuserdata!.getString("userid"));
                                                  tap.TapOnLike(myspacedata["responseData"][index]["referenceUserId"],myspacedata["responseData"][index]["_id"]).then((value) =>fetchmyspace() );

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
                                          padding: const EdgeInsets.only(left:15.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: (){

                                                },
                                                  child: Text("${myspacedata["responseData"][index]["totalLikes"]} Likes",style: TextStyle(color: Colors.grey,fontSize: 12),)
                                              ),
                                              TextButton(
                                                onPressed: (){

                                                },
                                                  child: Text("${myspacedata["responseData"][index]["totalComment"]} Comments",style: TextStyle(color: Colors.grey,fontSize: 12))
                                              )
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
                                                                NetworkImage("${allphanesuserdata!.getString("profilephoto")}",),fit: BoxFit.fill
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
                                        )

                                      ],
                                    ),
                                  ),
                                );
                            },
                          ),

                          Text("2"),
                          Text("3"),
                          Text("4")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
