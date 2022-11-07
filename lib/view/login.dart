import 'dart:async';
import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:allphanes/view/forgotpassword_inputmailid.dart';
import 'package:allphanes/view/homepage.dart';
import 'package:allphanes/view/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final k1 = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  SharedPreferences? allphanesuserdata;
  bool unlock = false;

  var indicator;
  var logindata;
  Future userLogin() async {
    allphanesuserdata = await SharedPreferences.getInstance();
    var APIURL = "https://powerful-shelf-35750.herokuapp.com/api/users/login";
    Map mapeddate = {'email': email.text, 'password': password.text};
    //send  data using http post to our php code
    http.Response reponse = await http.post(Uri.parse(APIURL), body: mapeddate);
    //getting response from php code, here
    var data = jsonDecode(reponse.body.toString());
    print("login data: $data");
    setState(() {
      logindata = data;
      indicator = 2;
    });
    if (data["ack"] == 1) {
      allphanesuserdata!.setBool("newuser", false);
      allphanesuserdata!.setString("userid", "${data["responseData"]["id"]}");
      allphanesuserdata!
          .setString("showname", "${data["responseData"]["showName"]}");
      allphanesuserdata!
          .setString("username", "${data["responseData"]["userName"]}");
      allphanesuserdata!
          .setString("profilephoto", "${data["responseData"]["profilePhoto"]}");
      allphanesuserdata!
          .setString("coverphoto", "${data["responseData"]["coverPhoto"]}");
      Fluttertoast.showToast(
          msg: "Login Successfull",
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(154, 205, 50, 1),
          textColor: Colors.white,
          fontSize: 12.0);
      setState(() {
        unlock = true;
      });
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage())));
    } else {
      Fluttertoast.showToast(
          msg: "Wrong username and password",
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(154, 205, 50, 1),
          textColor: Colors.red,
          fontSize: 12.0);
    }
  }

  facebooklogin() async {
    print('try');
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        print(userData);
      }
    } catch (error) {
      print(error);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 10.h,
                      width: 70.w,
                      child: const Image(
                        image: AssetImage("images/splsh_logo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 3.h,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 6.5.h,
                        width: 80.w,
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
                            cursorColor: Colors.white,
                            style:
                                TextStyle(color: Colors.white, fontSize: 1.5.h),
                            //autovalidate: false,
                            validator: (value) {
                              if (email.text.length < 1) {
                                return 'Please put your email id';
                              }
                            },

                            enableInteractiveSelection: true,
                            controller: email,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(154, 205, 50, 1),
                              // labelText: "Email Address",
                              // labelStyle: TextStyle(color: Colors.white),
                              hintText: "Your Email Address",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154, 205, 50, 1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154, 205, 50, 1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 6.5.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
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
                            cursorColor: Colors.white,
                            style:
                                TextStyle(color: Colors.white, fontSize: 1.5.h),
                            //autovalidate: false,
                            validator: (value) {
                              if (password.text.length < 1) {
                                return 'Please put your password';
                              }
                            },

                            enableInteractiveSelection: true,
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(154, 205, 50, 1),
                              // labelText: "Password",
                              // labelStyle: TextStyle(color: Colors.white),
                              hintText: "Your Password",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154, 205, 50, 1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(154, 205, 50, 1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              SizedBox(
                                height: 5.h,
                                width: 60.w,
                                child: ElevatedButton(
                                    child: Text("LogIn".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 2.h,
                                          color:
                                              Color.fromRGBO(154, 205, 50, 1),
                                        )),
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  color: Colors.black))),
                                      // shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                                      // elevation: MaterialStateProperty.all<double>(10),
                                    ),
                                    onPressed: () {
                                      if (k1.currentState!.validate()) {
                                        setState(() {
                                          indicator = 1;
                                        });
                                        userLogin();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Put email and password",
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Color.fromRGBO(154, 205, 50, 1),
                                            textColor: Colors.red,
                                            fontSize: 12.0);
                                      }
                                    }), //user login button
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 13.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        SizedBox(
                                          height: 5.h,
                                          width: 60.w,
                                          child: ElevatedButton(
                                              child: Text(
                                                  "LogIn with Facebook"
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 2.h,
                                                    color: const Color.fromRGBO(
                                                        154, 205, 50, 1),
                                                  )),
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.black),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        side: BorderSide(
                                                            color:
                                                                Colors.black))),
                                                // shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                                                // elevation: MaterialStateProperty.all<double>(10),
                                              ),
                                              onPressed: facebooklogin),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              indicator == 1
                                  ? Container(
                                      height: 5.h,
                                      width: 50.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 15,
                                              width: 15,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          154, 205, 50, 1),
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Don't Have an Account?",
                            style: TextStyle(
                                color: Color.fromRGBO(154, 205, 50, 1),
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.black,
                                  decorationThickness: 2),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InputMailId()));
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                    unlock == true
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Lottie.asset(
                              "images/unlock.json",
                              width: 5.h,
                              height: 5.h,
                              fit: BoxFit.fill,
                              repeat: false,
                            ),
                          )
                        : Container()
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
