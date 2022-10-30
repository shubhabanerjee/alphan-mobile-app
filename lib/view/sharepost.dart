import 'dart:async';
import 'dart:convert';

import 'package:allphanes/view/homepage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePost extends StatefulWidget {
  //const SharePost({Key? key}) : super(key: key);
  var post;
  SharePost(p) {
    this.post = p;
  }

  @override
  State<SharePost> createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  TextEditingController text = TextEditingController();
  SharedPreferences? allphanesuserdata;
  int processing = 0;

  String calculatetime(d) {
    var lastlogindate = DateTime.parse(d);
    var presenttime = DateTime.now();
    var difference = presenttime.difference(lastlogindate).inSeconds;
    if (difference >= 60 && difference < 3600) {
      var m = difference / 60;
      return "${m.toStringAsFixed(0)} m";
    } else if (difference >= 3600 && difference < 86400) {
      var h = difference / 3600;
      return '${h.toStringAsFixed(0)} h';
    } else if (difference >= 86400) {
      var d = difference / 86400;
      return '${d.toStringAsFixed(0)} d';
    } else {
      var s = difference;
      return '${s.toStringAsFixed(0)} s';
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 5,
          title: Text(
            "Share Post",
            style:
                TextStyle(color: Color.fromRGBO(154, 205, 50, 1), fontSize: 16),
          ),
          centerTitle: true,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Stack(
            children: [
              Center(
                child: ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 7.h,
                                      width: 60.w,
                                      //color: Colors.red,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: GestureDetector(
                                              onTap: () async {
                                                allphanesuserdata =
                                                    await SharedPreferences
                                                        .getInstance();
                                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(allphanesuserdata!.getString("userid"), mycanvasdata["responseData"][index]["user_info"][0]["_id"])));
                                              },
                                              child: Container(
                                                height: 7.h,
                                                width: 7.h,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    //color: Colors.green,
                                                    image: widget.post["user_info"]
                                                                    [0][
                                                                "profilePhoto"] !=
                                                            ""
                                                        ? DecorationImage(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              "${widget.post["user_info"][0]["profilePhoto"]}",
                                                            ),
                                                            fit: BoxFit.fill)
                                                        : DecorationImage(
                                                            image: AssetImage(
                                                                "images/default_profileimage.png"),
                                                            fit: BoxFit
                                                                .contain)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: SizedBox(
                                                        child: GestureDetector(
                                                            onTap: () async {
                                                              allphanesuserdata =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(allphanesuserdata!.getString("userid"), mycanvasdata["responseData"][index]["user_info"][0]["_id"])));
                                                            },
                                                            child: Text(
                                                                "${widget.post["user_info"][0]["showName"]}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        2.5.w,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign: TextAlign
                                                                    .justify)))),
                                                Text(
                                                  "${calculatetime(widget.post["createdAt"])}",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: .5,
                                      thickness: .5,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.post["postTitle"] != "Quick Post"
                                          ? "${widget.post["postTitle"]}"
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              widget.post["postInfo"].length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image(
                                          image: CachedNetworkImageProvider(
                                              "${widget.post["postInfo"][0]["postImagePath"]}")
                                          //image: NetworkImage("https://res.cloudinary.com/dsg7oitoj/image/upload/v1657552770/hhhx9auezdx2e14skekg.jpg"),
                                          ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${widget.post["postDescription"]}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 10.h,
                                width: 90.w,
                                color: Colors.transparent,
                                child: Center(
                                  child: TextFormField(
                                    minLines: 2,
                                    maxLines: 5,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    validator: (value) {},
                                    enableInteractiveSelection: true,
                                    controller: text,
                                    onChanged: (value) {},
                                    cursorColor:
                                        Color.fromRGBO(154, 205, 50, 1),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: " Want to write somthing",
                                      labelStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(154, 205, 50, 1)),
                                      hintText: "Write Here",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(154, 205, 50, 1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                  ),
                                ),
                              )
                            ])),
                    processing == 1
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Post Sharing...",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 7.h,
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          processing = 1;
                        });
                        sharePost();
                      },
                      child: Container(
                        color: Color.fromRGBO(154, 205, 50, 1),
                        height: 5.h,
                        child: Center(
                          child: Text(
                            "SHARE POST",
                            style:
                                TextStyle(color: Colors.white, fontSize: 2.h),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future sharePost() async {
    allphanesuserdata = await SharedPreferences.getInstance();
    var APIURL = "https://api.allphanes.com/api/posts/sharepost";
    Map mapeddate = {
      'referenceUserId': allphanesuserdata!.getString("userid"),
      'postType': "shared",
      'postTitle':
          widget.post["postTitle"] != "" ? widget.post["postTitle"] : "Default",
      'postDescription': text.text,
      'postCategory': widget.post["postCategory"] != null
          ? widget.post["postCategory"]
          : "",
      'postSubDomain': widget.post["postSubDomain"] != null
          ? widget.post["postSubDomain"]
          : "",
      'language':
          widget.post["language"] != null ? widget.post["language"] : "English",
      'shareUserId': widget.post["referenceUserId"],
      'sharePostId': widget.post["_id"],
      'shareGalleryInfo': widget.post["postInfo"].length > 0
          ? widget.post["postInfo"][0]["postImagePath"]
          : "",
      'shareDescription': widget.post["postDescription"] != null
          ? widget.post["postDescription"]
          : "",
      'populator': "Boton Knows",
      'shareFullName': widget.post["user_info"][0]["showName"] != null
          ? widget.post["user_info"][0]["showName"]
          : "",
      'shareProfile': widget.post["user_info"][0]["profilePhoto"] != null
          ? widget.post["user_info"][0]["profilePhoto"]
          : ""
    };
    //send  data using http post to our php code
    http.Response reponse = await http.post(Uri.parse(APIURL), body: mapeddate);
    //getting response from php code, here
    var data = jsonDecode(reponse.body);
    print("registration: $data");
    setState(() {
      processing = 0;
    });
    // if (data["ack"] == "1") {
    Fluttertoast.showToast(
        msg: "post shared",
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromRGBO(154, 205, 50, 1),
        textColor: Colors.white,
        fontSize: 12.0);
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            ModalRoute.withName('/')));
  }
}
