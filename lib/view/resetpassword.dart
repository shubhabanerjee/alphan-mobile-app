import 'dart:async';
import 'dart:convert';

import 'package:allphanes/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class ResetPassword extends StatefulWidget {
  //const ResetPassword({Key? key}) : super(key: key);
  String? userid;
  ResetPassword(id){
    this.userid=id;
  }


  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final k1= GlobalKey<FormState>();
  TextEditingController password =TextEditingController();
  TextEditingController conpassword =TextEditingController();

  var resetpassworddata;
  Future resetPassword()  async{
    //allphanesuserdata=await SharedPreferences.getInstance();
    var APIURL = "https://api.allphanes.com/api/users/passwordset/${widget.userid}";
    Map mapeddate ={
      'newPassword':password.text,
      'confirmPassword':conpassword.text
    };
    //send  data using http post to our php code
    http.Response reponse = await http.patch(Uri.parse(APIURL),body:mapeddate );
    //getting response from php code, here
    var data = jsonDecode(reponse.body.toString());
    print("otp data: $data");
    setState((){
      resetpassworddata=data;
    });
    if(data["ack"]=="1"){
      Fluttertoast.showToast(
          msg: "Password reset successful",
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(154,205,50,1),
          textColor: Colors.green,
          fontSize: 12.0
      );
      Timer(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LogIn()),ModalRoute.withName('/'));
      });
    }
    else{
      Fluttertoast.showToast(
          msg: "Error! Try again",
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
      body: SafeArea(
        child: Center(
          child: Form(
            key: k1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        obscureText: true,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white,fontSize: 1.5.h),
                        //autovalidate: false,
                        validator: (value){
                          if(password.text.length<1){
                            return 'Please put a password';
                          }

                        },

                        enableInteractiveSelection: true,
                        controller: password,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(154,205,50,1),
                          // labelText: "Email Address",
                          // labelStyle: TextStyle(color: Colors.white),
                          hintText: "put a password",
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
                        obscureText: true,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white,fontSize: 1.5.h),
                        //autovalidate: false,
                        validator: (value){
                          if(conpassword.text.length<1){
                            return 'Please put confirm password';
                          }
                          else if(password.text!=conpassword.text){
                            return 'both password should be match';
                          }

                        },

                        enableInteractiveSelection: true,
                        controller: conpassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(154,205,50,1),
                          // labelText: "Email Address",
                          // labelStyle: TextStyle(color: Colors.white),
                          hintText: "confirm password",
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
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 5.h,
                    width: 50.w,
                    child: ElevatedButton(
                        child: Text(
                            "Reset Password".toUpperCase(),
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
                          ),
                          // shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                          // elevation: MaterialStateProperty.all<double>(10),
                        ),
                        onPressed:(){
                          if(k1.currentState!.validate()){
                            resetPassword();
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "Put password and confirm password",
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
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
