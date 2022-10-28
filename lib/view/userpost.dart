import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:allphanes/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';


class UserPost extends StatefulWidget {
  const UserPost({Key? key}) : super(key: key);

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  VideoPlayerController? _controller;
  final k1= GlobalKey<FormState>();
  SharedPreferences? allphanesuserdata;
  TextEditingController language=TextEditingController();
  TextEditingController domain=TextEditingController();
  TextEditingController subdomain=TextEditingController();
  TextEditingController title=TextEditingController();
  TextEditingController description=TextEditingController();
  TextEditingController hashtag=TextEditingController();
  int uploading=0;

  String? selectedlanguageid;
  var languagedetail;
  var languages=<String>[];
  Future<void> fetchlanguages()async{
    allphanesuserdata=await SharedPreferences.getInstance();
    String userid=allphanesuserdata!.getString("userid") ??"";
    print(userid);

    http.Response response=await http.get(Uri.parse("https://api.allphanes.com/api/language"));
    var data=jsonDecode(response.body);
    print(data);
    setState((){
      languagedetail=data;
    });
    for(int i=0;i<data["responseData"].length;i++){
      languages.add(data["responseData"][i]["language"]);
    }

  }

  String? selecteddomain;
  var domainsdata;
  var domains=<String>[];
  Future<void> fetchdomain()async{
    allphanesuserdata=await SharedPreferences.getInstance();
    String userid=allphanesuserdata!.getString("userid") ??"";
    print(userid);

    http.Response response=await http.get(Uri.parse("https://api.allphanes.com/api/postcategory"));
    var data=jsonDecode(response.body);
    print(data);
    setState((){
      domainsdata=data;
    });
    for(int i=0;i<data["responseData"].length;i++){
      domains.add(data["responseData"][i]["postCategory"]);
    }

  }

  String? selectedsubdomain;
  var subdomainsdata;
  var subdomains=<String>[];
  Future<void> fetchsubdomain()async{
    allphanesuserdata=await SharedPreferences.getInstance();
    String userid=allphanesuserdata!.getString("userid") ??"";
    print(userid);

    http.Response response=await http.get(Uri.parse("https://api.allphanes.com/api/postsubcategory/$selecteddomain"));
    var data=jsonDecode(response.body);
    print(data);
    setState((){
      subdomainsdata=data;
    });
    if(data["responseData"].length>0){
      for(int i=0;i<data["responseData"].length;i++){
        subdomains.add(data["responseData"][i]["postSubCategory"]);
      }
    }
    else{
      subdomains=<String>[];
    }


  }

  @override
  void initState(){
    super.initState();
    fetchlanguages().then((value){
      fetchdomain();
    });
  }

  @override
  void dispose(){
    super.dispose();
    print("${language.text} ${domain.text} ${subdomain.text}");
    language.dispose();
    domain.dispose();
    subdomain.dispose();
  }


  File? videofile;
  File? imagefile;
  getImageFromCamera(String m)async{
    ImagePicker pick=await ImagePicker();
    if(m=="image"){
      final pickedImage=await pick.pickImage(source: ImageSource.camera,) ;
      if(pickedImage != null){
        setState(() {
          imagefile=File(pickedImage.path);
          videofile=null;
        });
      }
      else{
        imagefile=imagefile;
      }
    }
    else{
      final pickedImage=await pick.pickVideo(source: ImageSource.camera,) ;
      if(pickedImage != null){
        setState(() {
          videofile=File(pickedImage.path);
          imagefile=null;
        });
        _controller=VideoPlayerController.file(videofile!)
          ..initialize().then((_) {
            setState(() {

            });
          });
      }
      else {
        setState(() {
          videofile=videofile;
        });
      }
    }


  }

  getImageFromGallery(String m)async{
    ImagePicker pick=await ImagePicker();
    if(m=="image"){
      final pickedImage=await pick.pickImage(source: ImageSource.gallery,) ;
      if(pickedImage != null){
        setState(() {
          imagefile=File(pickedImage.path);
          videofile=null;
        });
      }
      else{
        imagefile=imagefile;
      }
    }
    else{
      final pickedImage=await pick.pickVideo(source: ImageSource.gallery,) ;
      if(pickedImage != null){
        setState(() {
          videofile=File(pickedImage.path);
          imagefile=null;
        });
        _controller=VideoPlayerController.file(videofile!)
          ..initialize().then((_) {
            setState(() {

            });
          });
      }
      else {
        setState(() {
          videofile=videofile;
        });
      }
    }

  }

  Future<void> takePhoto(String mode) async {
    return showDialog<void>(
        context: this.context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose either Camera or Gallery",style: TextStyle(color: Colors.black,fontSize: 16),textAlign: TextAlign.center,),
            backgroundColor: Colors.white,
            actions: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          getImageFromCamera(mode);
                          Navigator.pop(context);
                        },
                        child: Container(
                          // height: MediaQuery.of(context).size.height*.05,
                          // width: MediaQuery.of(context).size.width*.6,
                          //color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Container(
                              //     height: MediaQuery.of(context).size.height*.04,
                              //     width: MediaQuery.of(context).size.width*.2,
                              //     child: Image(image: NetworkImage("https://icon-library.com/images/material-design-camera-icon/material-design-camera-icon-18.jpg"),fit: BoxFit.contain,)
                              // ),
                              Icon(Icons.camera_alt,size: 5.h,color: Color.fromRGBO(154,205,50,1),),
                              SizedBox(height: 2,),
                              Text("Camera",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*.03,),
                      GestureDetector(
                        onTap: (){
                          getImageFromGallery(mode);
                          Navigator.pop(context);
                        },
                        child: Container(
                          // height: MediaQuery.of(context).size.height*.05,
                          // width: MediaQuery.of(context).size.width*.5,
                          //color: Colors.yellow,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Container(
                              //     height: MediaQuery.of(context).size.height*.04,
                              //     width: MediaQuery.of(context).size.width*.2,
                              //     child: Image(image: NetworkImage("https://sbcs.ac.in/assets/images/1040241.png"),fit: BoxFit.cover)
                              // ),
                              Icon(Icons.image,size:5.h,color: Color.fromRGBO(154,205,50,1),),
                              SizedBox(height: 2,),
                              Text("Gallery",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                   SizedBox(height: 30,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: (){
                  //         Navigator.pop(context);
                  //       },
                  //       child: Container(
                  //         width: MediaQuery.of(context).size.width*.2,
                  //         decoration: BoxDecoration(
                  //             border: Border.all(color: Colors.blue),
                  //             borderRadius: BorderRadius.circular(5)
                  //         ),
                  //         child: Center(
                  //           child: Text("Cancle",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18),),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  //SizedBox(height: 10,)
                ],
              )
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 5,
        title: Text("Post Your Ideas",style: TextStyle(color:Color.fromRGBO(154,205,50,1),fontSize: 16),),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child:Stack(
          children: [
            Center(
              child: Form(
                key: k1,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 6.h,
                            width: 75.w,
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                TextFormField(
                                  style:TextStyle(color: Colors.grey,fontSize: 12),
                                  validator: (value){
                                  },
                                  enableInteractiveSelection: false,
                                  controller: language,
                                  onChanged: (value){
                                  },
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: " Select Language",
                                    labelStyle: TextStyle(color: Color.fromRGBO(154,205,50,1)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(154,205,50,1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  readOnly: true,
                                  //keyboardType: TextInputType.none,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child:Text("")
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.white,
                                        menuMaxHeight: 60.h,
                                        //value: profilefor,
                                        icon: const Icon(Icons.arrow_drop_down,color: Color.fromRGBO(154,205,50,1),size:25,),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.black),
                                        underline: Container(color: Colors.white,),
                                        onChanged: (newValue) {
                                          setState(() {
                                            language.text=newValue!;
                                          });
                                        },
                                        // items: <String>
                                        // ['English','Hindi','Bengali']
                                          items:languages
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            onTap: (){
                                             int lindex=languages.indexOf(value);
                                             setState((){
                                               selectedlanguageid=languagedetail["responseData"][lindex]["_id"];
                                             });
                                            },
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),




                    //Domain.............................................

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 6.h,
                            width: 75.w,
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                TextFormField(
                                  style:TextStyle(color: Colors.grey,fontSize: 12),
                                  validator: (value){
                                  },
                                  enableInteractiveSelection: false,
                                  controller: domain,
                                  onChanged: (value){
                                  },
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: " Choose Domain",
                                    labelStyle: TextStyle(color: Color.fromRGBO(154,205,50,1)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(154,205,50,1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  readOnly: true,
                                  //keyboardType: TextInputType.none,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child:Text("")
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.white,
                                        menuMaxHeight: 60.h,
                                        //value: profilefor,
                                        icon: const Icon(Icons.arrow_drop_down,color: Color.fromRGBO(154,205,50,1),size:25,),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.black),
                                        underline: Container(color: Colors.white,),
                                        onChanged: (newValue) {
                                          setState(() {
                                            domain.text=newValue!;
                                          });
                                        },
                                        // items: <String>
                                        // ['English','Hindi','Bengali']
                                          items:domains
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            onTap: (){
                                              subdomain.text="";
                                              setState((){
                                                subdomains=<String>[];
                                              });
                                              int index=domains.indexOf(value);
                                              setState((){
                                                selecteddomain=domainsdata["responseData"][index]["_id"];
                                              });
                                              fetchsubdomain();

                                            },
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),



                    //subdomain.........................................................

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 6.h,
                            width: 75.w,
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                TextFormField(
                                  style:TextStyle(color: Colors.grey,fontSize: 12),
                                  validator: (value){
                                  },
                                  enableInteractiveSelection: false,
                                  controller: subdomain,
                                  onChanged: (value){
                                  },
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: " Choose Sub-Domain",
                                    labelStyle: TextStyle(color: Color.fromRGBO(154,205,50,1)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(154,205,50,1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  readOnly: true,
                                  //keyboardType: TextInputType.none,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child:Text("")
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.white,
                                        menuMaxHeight: 60.h,
                                        //value: profilefor,
                                        icon: const Icon(Icons.arrow_drop_down,color: Color.fromRGBO(154,205,50,1),size:25,),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.black),
                                        underline: Container(color: Colors.white,),
                                        onChanged: (newValue) {
                                          setState(() {
                                            subdomain.text=newValue!;
                                          });
                                        },
                                        // items: <String>
                                        // ['English','Hindi','Bengali']
                                          items:subdomains
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            onTap: (){
                                              int sdindex=subdomains.indexOf(value);
                                              setState((){
                                                selectedsubdomain=subdomainsdata["responseData"][sdindex]["_id"];
                                              });
                                            },
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //titel..................................
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Container(
                  height: 10.h,
                  width: 85.w,
                  color: Colors.transparent,
                    child: TextFormField(
                      minLines: 2,
                      maxLines: 5,
                      style:TextStyle(color: Colors.grey,fontSize: 12),
                      validator: (value){
                      },
                      enableInteractiveSelection: true,
                      controller: title,
                      onChanged: (value){
                      },
                      cursorColor: Color.fromRGBO(154,205,50,1),
                      decoration: InputDecoration(
                        hintText: "Enter Title Here",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: " ${domain.text} title",
                        labelStyle: TextStyle(color: Color.fromRGBO(154,205,50,1)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(154,205,50,1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  )
                  ]
              )
              ),

                    //descp..........................................................................
                    Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 10.h,
                                width: 85.w,
                                color: Colors.transparent,
                                child: Center(
                                  child: TextFormField(
                                    minLines: 2,
                                    maxLines: 5,
                                    style:TextStyle(color: Colors.grey,fontSize: 12),
                                    validator: (value){
                                    },
                                    enableInteractiveSelection: true,
                                    controller: description,
                                    onChanged: (value){
                                    },
                                    cursorColor: Color.fromRGBO(154,205,50,1),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: " ${domain.text} description",
                                      labelStyle: TextStyle(color: Color.fromRGBO(154,205,50,1)),
                                      hintText: "Share Your Idea Here",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(154,205,50,1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
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
                            ]
                        )
                    ),


                    //#tag................................................................
                    Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 10.h,
                                width: 85.w,
                                color: Colors.transparent,
                                child: Center(
                                  child: TextFormField(
                                    minLines: 2,
                                    maxLines: 5,
                                    style:TextStyle(color: Colors.grey,fontSize: 12),
                                    validator: (value){
                                    },
                                    enableInteractiveSelection: true,
                                    controller: hashtag,
                                    onChanged: (value){
                                    },
                                    cursorColor: Color.fromRGBO(154,205,50,1),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: " HashTag",
                                      labelStyle: TextStyle(color: Color.fromRGBO(154,205,50,1)),
                                      hintText: "HashTage Here",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(154,205,50,1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
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
                            ]
                        )
                    ),

                    videofile!=null || imagefile!=null?
                        videofile!=null?Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 40.h,
                            width: 90.w,
                            child: Stack(
                              children: [
                                videofile!=null
                                    ? VideoPlayer(
                                    _controller!
                                  //..play()..setVolume(1.0),
                                ):Center(
                                  child: CircularProgressIndicator(),
                                ),
                                Center(
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      if(_controller!.value.isPlaying){
                                        setState(() {
                                          _controller?.pause();
                                        });
                                      }
                                      else{
                                        setState(() {
                                          _controller?.play();
                                          _controller?.setVolume(1.0);
                                        });
                                      }

                                    },
                                    child: Icon(
                                      _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ):
                            imagefile!=null?Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Image(
                                  image: Image.file(imagefile!).image,
                                ),
                              ),
                            ):
                                Container()
                    :Container(),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: Colors.black)
                                  )
                              ),
                              // shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                              // elevation: MaterialStateProperty.all<double>(10),
                            ),
                            onPressed: (){
                              takePhoto("image");
                            },
                            child: Icon(Icons.image,color: Colors.white,),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(color: Colors.black)
                                    )
                                ),
                                // shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                                // elevation: MaterialStateProperty.all<double>(10),
                              ),
                              onPressed: (){
                                takePhoto("video");
                              },
                              child: Icon(Icons.video_call,color: Colors.white,),
                            ),
                          )
                        ],
                      ),
                    ),

                    uploading==1?Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Uploading...",style:TextStyle(color: Colors.grey))
                        ],
                      ),
                    ):Container(),
                    videofile!=null || imagefile!=null?SizedBox(
                      height: 10.h,
                    ):
                        Container()

                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState((){
                        uploading=1;
                      });
                      postUpload();
                    },
                    child: Container(
                      color: Color.fromRGBO(154,205,50,1),
                      height: 5.h,
                      child: Center(
                        child: Text("POST",style: TextStyle(color: Colors.white,fontSize: 2.h),),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Future postUpload()async{
    allphanesuserdata=await SharedPreferences.getInstance();
    final uri=Uri.parse("https://api.allphanes.com/api/posts/genarate");
    print("Image detail: $videofile");
    var request=http.MultipartRequest('POST',uri);
    //request.files.add(await http.MultipartFile.fromPath("image", videofile!.path));
    // request.files.add(await http.MultipartFile('image',
    //     File(imagefile!.path).readAsBytes().asStream(),
    //     File(imagefile!.path).lengthSync(),
    //     filename: imagefile!.path.split("/").last));
    request.fields['referenceUserId']=allphanesuserdata!.getString("userid").toString();
    request.fields['postType']="Normal";
    request.fields['postTitle']=title.text;
    request.fields['postMode']="normal";
    //request.fields['isSaved']="false";
    request.fields['text']=description.text;
    //request.fields['postCategory']=domain.text;
    //request.fields['postSubDomain']=subdomain.text;
    //request.fields['language']=language.text;
   // request.fields['referenceLanguageId']=selectedlanguageid!;
    //request.fields['referenceDomainId']=selecteddomain!;
    //request.fields['referenceSubDomainId']=selectedsubdomain!;
    request.fields['isFile']="true";
    request.fields['keywords']=hashtag.text;
    request.fields['keywords2']="#${hashtag.text}";
    request.fields['galleryType']=imagefile!=null?"photos":"video";
    //request.fields['isFile']="true";


     var image_videofile=imagefile!=null?
    await http.MultipartFile.fromPath("image",imagefile!.path,)
    :
    videofile!=null?await http.MultipartFile.fromPath("image",videofile!.path,)
        :
        null;
    //var image_videofile=await http.MultipartFile.fromPath("image",imagefile!.path);
    //
    // //await http.MultipartFile.fromPath("file","");
    // imagefile!=null || videofile!=null?request.files.add(image_videofile!):null;
    request.files.add(image_videofile!);
    // var pic2=await http.MultipartFile.fromPath("identity_image_new",pickImageNew.path);
    // request.files.add(pic2);
    //request.files.add(await http.MultipartFile.fromPath("image",imagefile!.path,),);
    //final headers = {"Content-type": "multipart/form-data"};
    //request.files.add(await http.MultipartFile.fromBytes();
    //request.headers.addAll(headers);
    var  response =await request.send();
    var data=response.statusCode;
    print("response:${data}");
    response.stream.transform(utf8.decoder).listen((value) {
      print("new response: ${value}");
      setState((){
        uploading=0;
      });
      if(value[7]=="1"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text("Post uploaded Successfully",style: TextStyle(color: Colors.green,fontSize: 12)),
          action: SnackBarAction(
            label: "DONE",
            textColor: Colors.green,
            onPressed: (){

            },
          ),
        ));
        Timer(Duration(seconds: 2),()=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()),ModalRoute.withName('/')));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text("Post not uploaded! Try again",style: TextStyle(color: Colors.red,fontSize: 12)),
          action: SnackBarAction(
            label: "ERROR!",
            textColor: Colors.red,
            onPressed: (){

            },
          ),
        ));
      }

    });
    if(response.statusCode==200){
      setState(() {
      });
      print("video uploaded");

      // logindata.setBool("videouploaded", true);
      // Timer.periodic(Duration(seconds: 2), (timer) {
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const AyurvedaHomePage()),ModalRoute.withName('/'));
      // });

    }
    else{
      setState(() {

      });
      print("video not uploaded");

    }

  }


}
