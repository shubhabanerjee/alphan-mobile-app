import 'dart:async';
import 'dart:convert';

import 'package:allphanes/view/homepage.dart';
import 'package:allphanes/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final k1= GlobalKey<FormState>();
  TextEditingController firstname=TextEditingController();
  TextEditingController lastname=TextEditingController();
  TextEditingController username=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController refcode=TextEditingController();
  bool showname=false;
  bool termcondition=false;
  var indicator;
  SharedPreferences? allphanesuserdata;
  bool unlock=false;


  Future userRegister()  async{
    allphanesuserdata=await SharedPreferences.getInstance();
    var APIURL = "https://powerful-shelf-35750.herokuapp.com/api/users/create?refcode=${refcode.text}";
    //var APIURL = "https://allphanestest.herokuapp.com/api/users/create";
    Map mapeddate ={
      'firstName':firstname.text,
      'lastName':lastname.text,
      'userName':username.text,
      'showName':showname==true?username.text:"",
      'email':email.text,
      'phone':phone.text,
      'password':password.text,
    };
    //send  data using http post to our php code
    http.Response reponse = await http.post(Uri.parse(APIURL),body:mapeddate);
    //getting response from php code, here
    var data = jsonDecode(reponse.body) ;
    print("registration: $data");
    setState((){
      indicator=2;
    });
    if(data["ack"]==1){
      Fluttertoast.showToast(
          msg: "Registration Successfull",
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(154,205,50,1),
          textColor: Colors.white,
          fontSize: 12.0
      );
      allphanesuserdata?.setBool("newuser", false);
      allphanesuserdata?.setString("userid", "${data["responseData"]["id"]}");
      allphanesuserdata?.setString("showname","${data["responseData"]["showName"]}");
      allphanesuserdata?.setString("username", "${data["responseData"]["userName"]}");
      allphanesuserdata?.setString("profilephoto", "${data["responseData"]["profilePhoto"]}");
      allphanesuserdata?.setString("coverphoto", "${data["responseData"]["coverPhoto"]}");
      setState((){
        unlock=true;
      });
      Timer(Duration(seconds: 3),
              ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()))
      );

    }
    else{
      Fluttertoast.showToast(
          msg: data["message"],
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(154,205,50,1),
          textColor: Colors.red,
          fontSize: 12.0
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(154,205,50,1),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: AssetImage("images/sign_inout_bg.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: Form(
                key: k1,
                child: ListView(
                  shrinkWrap: true,
                  padding:const EdgeInsets.all(30.0) ,
                  children: [
                    Center(
                      child: Container(
                        height: 10.h,
                        width: 70.w,
                        child: const Image(
                          image: AssetImage("images/splsh_logo.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Center(child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text("Register",style: TextStyle(color: Colors.black,fontSize: 3.h,fontWeight: FontWeight.bold),),
                    )),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 6.5.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white,fontSize: 2.h),
                            validator: (value){
                              if(firstname.text.length<1){
                                return 'Pleasse put your firstname';
                              }
                              else{

                              }

                            },
                            enableInteractiveSelection: true,
                            controller: firstname,
                            decoration: InputDecoration(
                              // labelText: "First Name",
                              // labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromRGBO(154,205,50,1),
                              hintText: "Your First Name",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color:Color.fromRGBO(154,205,50,1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154,205,50,1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value){
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 6.5.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white,fontSize: 2.h),
                            validator: (value){
                              if(lastname.text.length<1){
                                return 'Please put your lastname';
                              }
                              else{

                              }

                            },
                            enableInteractiveSelection: true,
                            controller: lastname,
                            decoration: InputDecoration(
                              // labelText: "Last Name",
                              // labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromRGBO(154,205,50,1),
                              hintText: "Your Last Name",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color:Color.fromRGBO(154,205,50,1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154,205,50,1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value){
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 6.5.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white,fontSize: 2.h),
                            validator: (value){
                              if(username.text.length<1){
                                return 'Please set a username';
                              }
                              else{

                              }

                            },
                            enableInteractiveSelection: true,
                            controller: username,
                            decoration: InputDecoration(
                              // labelText: "UserName",
                              // labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromRGBO(154,205,50,1),
                              hintText: "put a username",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color:Color.fromRGBO(154,205,50,1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154,205,50,1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value){
                            },
                          ),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Checkbox(
                          value: showname,
                          onChanged: (value){
                            setState((){
                              showname=!showname;
                            });
                            print(showname);
                          },
                        ),
                        Text("Show as display name")
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 6.5.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white,fontSize:2.h),
                            validator: (value){
                              if(email.text.length<1){
                                return 'Please put your email id';
                              }
                              else if(!email.text.contains('@')){
                                return 'Incorrect email id';
                              }
                              else{

                              }

                            },
                            enableInteractiveSelection: true,
                            controller: email,
                            decoration: InputDecoration(
                              // labelText: "Email ID",
                              // labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromRGBO(154,205,50,1),
                              hintText: "Your Email ID",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color:Color.fromRGBO(154,205,50,1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154,205,50,1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value){
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 6.5.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white,fontSize: 2.h),
                            validator: (value){
                              if(phone.text.length<1){
                                return 'Please put your phone number';
                              }
                              else if(phone.text.length!=10){
                                return 'Incorrect phone number';
                              }
                              else{

                              }

                            },
                            enableInteractiveSelection: true,
                            controller:phone,
                            decoration: InputDecoration(
                              // labelText: "Phone Number",
                              // labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromRGBO(154,205,50,1),
                              hintText: "Your Phone Number",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color:Color.fromRGBO(154,205,50,1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154,205,50,1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (value){
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: Container(
                        height: 6.5.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextFormField(
                            obscureText: true,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white,fontSize: 2.h),
                            validator: (value){
                              if(password.text.length<1){
                                return 'Please set a password';
                              }
                              else if(password.text.length<8){
                                return 'It requires minimum 8 characters';
                              }
                              else{

                              }

                            },
                            enableInteractiveSelection: true,
                            controller: password,
                            decoration: InputDecoration(
                              // labelText: "Password",
                              // labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromRGBO(154,205,50,1),
                              hintText: "Set a Password",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color:Color.fromRGBO(154,205,50,1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154,205,50,1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value){
                            },
                          ),
                        ),
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: Container(
                        height: 6.5.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextFormField(
                            //obscureText: true,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white,fontSize: 2.h),
                            validator: (value){

                            },
                            enableInteractiveSelection: true,
                            controller: refcode,
                            decoration: InputDecoration(
                              // labelText: "Password",
                              // labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromRGBO(154,205,50,1),
                              hintText: "Put referel code here",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color:Color.fromRGBO(154,205,50,1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154,205,50,1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value){
                            },
                          ),
                        ),
                      ),
                    ),


                    Row(
                      children: [
                        Checkbox(
                          value: termcondition,
                          onChanged: (v){
                            setState((){
                              termcondition=!termcondition;
                            });
                          },
                        ),
                        Text("Agree to our "),
                        Text("Terms of use",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                        Text(" & "),
                        Text("Privacy Policy",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold))
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:20 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 5.h,
                                width: 50.w,
                                child: ElevatedButton(
                                    child: Text(
                                        "Register".toUpperCase(),
                                        style: TextStyle(fontSize: 2.h,color: Color.fromRGBO(154,205,50,1),)
                                    ),
                                    style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                side: BorderSide(color: Colors.black)
                                            )
                                        )
                                    ),
                                    onPressed:()async{
                                      if(k1.currentState!.validate()){
                                        if(termcondition==true){
                                          setState((){
                                            indicator=1;
                                          });
                                          userRegister();
                                        }
                                        else{
                                          Fluttertoast.showToast(
                                              msg: "Please check out term & condition first",
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Color.fromRGBO(154,205,50,1),
                                              textColor: Colors.red,
                                              fontSize: 12.0
                                          );
                                        }
                                      }
                                      else{
                                        Fluttertoast.showToast(
                                            msg: "Fill all the fields correctly",
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color.fromRGBO(154,205,50,1),
                                            textColor: Colors.red,
                                            fontSize: 12.0
                                        );
                                      }

                                    }
                                ),
                              ),
                              indicator==1?Container(
                                height: 5.h,
                                width: 50.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 15,
                                        width: 15,
                                        child: Center(
                                          child: CircularProgressIndicator(backgroundColor:Color.fromRGBO(154,205,50,1),
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),strokeWidth: 2,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ):Container(),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Already Have an Account?",style: TextStyle(color: Color.fromRGBO(154,205,50,1),),),
                          TextButton(
                            onPressed: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LogIn()));
                            },
                            child: Text("LogIn",style: TextStyle(color: Colors.black,fontSize:16,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,decorationColor: Colors.black,decorationThickness: 2),),
                          )
                        ],
                      ),
                    ),
                    unlock==true?Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Lottie.asset("images/unlock.json",width: 5.h,height: 5.h,fit: BoxFit.fill,repeat: false,),
                    ):Container()


                  ],

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
