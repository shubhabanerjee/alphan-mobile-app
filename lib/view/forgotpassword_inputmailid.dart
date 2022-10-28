import 'dart:async';
import 'dart:convert';

import 'package:allphanes/view/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:http/http.dart' as http;


class InputMailId extends StatefulWidget {
  const InputMailId({Key? key}) : super(key: key);

  @override
  State<InputMailId> createState() => _InputMailIdState();
}

class _InputMailIdState extends State<InputMailId> {
  final k1= GlobalKey<FormState>();
  TextEditingController email =TextEditingController();
  TextEditingController pin =TextEditingController();

  var sendotpdata;
  Future sendOTP()  async{
    //allphanesuserdata=await SharedPreferences.getInstance();
    var APIURL = "https://api.allphanes.com/api/users/forgetpassword";
    Map mapeddate ={
      'email':email.text,
    };
    //send  data using http post to our php code
    http.Response reponse = await http.post(Uri.parse(APIURL),body:mapeddate );
    //getting response from php code, here
    var data = jsonDecode(reponse.body.toString());
    print("otp data: $data");
    setState((){
      sendotpdata=data;
    });
    if(data["ack"]==1){
      Fluttertoast.showToast(
          msg: "OTP send successful",
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(154,205,50,1),
          textColor: Colors.green,
          fontSize: 12.0
      );
    }
    else{
      Fluttertoast.showToast(
          msg: "OTP send Error!",
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
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white,fontSize: 1.5.h),
                        //autovalidate: false,
                        validator: (value){
                          if(email.text.length<1){
                            return 'Please put your email id';
                          }

                        },

                        enableInteractiveSelection: true,
                        controller: email,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(154,205,50,1),
                          // labelText: "Email Address",
                          // labelStyle: TextStyle(color: Colors.white),
                          hintText: "Your Register Email ID",
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
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 5.h,
                    width: 30.w,
                    child: ElevatedButton(
                        child: Text(
                            "Send OTP".toUpperCase(),
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
                            sendOTP();

                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "Put Your Register Email ID",
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


                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 25),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*.06,
                    width: MediaQuery.of(context).size.width*.8,
                    //color: Colors.blue,
                    child: Center(
                      child: PinCodeTextField(
                        controller: pin,
                        pinBoxHeight: MediaQuery.of(context).size.height*.04,
                        pinBoxWidth: MediaQuery.of(context).size.height*.035,
                        maxLength: 6,
                        highlightColor: Color.fromRGBO(154,205,50,1),
                        defaultBorderColor:Colors.grey,
                        hasTextBorderColor: Colors.black,
                        highlightPinBoxColor: Colors.white,
                        pinBoxBorderWidth: .5,
                        pinTextStyle: const TextStyle(color: Colors.black,fontSize:14,fontWeight: FontWeight.bold),
                        highlight: true,
                        onDone: (v){

                        },

                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 5.h,
                    width: 50.w,
                    child: ElevatedButton(
                        child: Text(
                            "Verify OTP".toUpperCase(),
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
                          if(sendotpdata!=null){
                            if(pin.text==""){
                              Fluttertoast.showToast(
                                  msg: "Put your OTP Then verify",
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color.fromRGBO(154,205,50,1),
                                  textColor: Colors.red,
                                  fontSize: 12.0
                              );
                            }
                            else{
                              if(pin.text == sendotpdata["otp"]){
                                Fluttertoast.showToast(
                                    msg: "OTP verified successfuly",
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Color.fromRGBO(154,205,50,1),
                                    textColor: Colors.green,
                                    fontSize: 12.0
                                );
                                Timer(Duration(seconds: 2), () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ResetPassword(sendotpdata["responseData"][0]["id"])));
                                });
                              }
                              else{
                                Fluttertoast.showToast(
                                    msg: "OTP is not correct!",
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Color.fromRGBO(154,205,50,1),
                                    textColor: Colors.red,
                                    fontSize: 12.0
                                );
                              }
                            }
                          }
                          else{
                              Fluttertoast.showToast(
                                  msg: "First you should send OTP",
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
