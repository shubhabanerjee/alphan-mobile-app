import 'dart:async';
import 'dart:convert';
import 'package:allphanes/view/google_signin.dart';
import 'package:allphanes/widgets/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:google_sign_in/google_sign_in.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // final k1 = GlobalKey<FormState>();
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

  bool _isLoggedIn = false;
  late GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  // Future<void> signup(BuildContext context) async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await googleSignIn.signIn(); // await googleSignIn.signIn();
  //   if (googleSignInAccount != null) {
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;
  //     final AuthCredential authCredential = GoogleAuthProvider.credential(
  //         idToken: googleSignInAuthentication.idToken,
  //         accessToken: googleSignInAuthentication.accessToken);
  //     // Getting users credential
  //     UserCredential result = await auth.signInWithCredential(authCredential);
  //     User? user = result.user;
  //     if (result != null) {
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => HomePage()));
  //     } // if result not null we simply call the MaterialpageRoute,
  //     // for go to the HomePage screen
  //   } else {
  //     print(googleSignInAccount!.email.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //for space
              SizedBox(
                height: 10.h,
              ),
              //for logo
              SizedBox(
                height: 10.h,
                width: 50.w,
                child: Image.asset(
                  'images/main_logo_black.png',
                  fit: BoxFit.fill,
                ),
              ),
              //for space
              SizedBox(
                height: 6.h,
              ),
              //login text ui
              Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 4.h, fontWeight: FontWeight.w300),
              ),
              //for space
              SizedBox(
                height: 2.h,
              ),
              //textfield for email
              Padding(
                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                child: TextFormField(
                  cursorColor: kPrimaryBlack,
                  validator: (value) {
                    if (email.text.length < 1) {
                      return 'Please put your email id';
                    }
                  },
                  enableInteractiveSelection: true,
                  controller: email,
                  style: TextStyle(color: kPrimaryBlack, fontSize: 2.5.h),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.mail_outline_outlined,
                      color: kPrimaryBlack,
                    ),
                    filled: true,
                    fillColor: kPrimaryWhite,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryBlack),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryBlack),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: kPrimaryBlack,
                    ),
                  ),
                ),
              ),
              //for space
              SizedBox(
                height: 3.h,
                width: 100.w,
              ),
              //textfield for password
              Padding(
                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                child: TextFormField(
                  cursorColor: kPrimaryBlack,
                  validator: (value) {
                    if (password.text.length < 1) {
                      return 'Please put your password';
                    }
                  },
                  enableInteractiveSelection: true,
                  controller: password,
                  obscureText: true,
                  style: TextStyle(color: kPrimaryBlack, fontSize: 2.5.h),
                  decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: kPrimaryBlack,
                    ),
                    filled: true,
                    fillColor: kPrimaryWhite,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryBlack),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryBlack),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: kPrimaryBlack,
                    ),
                  ),
                ),
              ),
              //for space
              SizedBox(
                height: 5.h,
              ),
              //button for login
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: GestureDetector(
                  onTap: () {
                    // if (k1.currentState!.validate()) {
                    // setState(() {
                    //   indicator = 1;
                    // });
                    userLogin();
                    // } else {
                    //   Fluttertoast.showToast(
                    //       msg: "Put email and password",
                    //       gravity: ToastGravity.BOTTOM,
                    //       timeInSecForIosWeb: 1,
                    //       backgroundColor: Color.fromRGBO(154, 205, 50, 1),
                    //       textColor: Colors.red,
                    //       fontSize: 12.0);
                    // }
                  },
                  child: Container(
                    height: 5.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryBlack),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login'.toUpperCase(),
                          style:
                              TextStyle(color: kPrimaryWhite, fontSize: 2.5.h),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //for space
              SizedBox(
                height: 2.h,
              ),
              //forgot password
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Text(
                          'Forgot password?',
                          style:
                              TextStyle(color: kPrimaryBlack, fontSize: 2.2.h),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const InputMailId()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //for space
              SizedBox(
                height: 4.h,
              ),
              //for dividor lines
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: kPrimaryBlack,
                      indent: 10.w,
                      endIndent: 3.w,
                    ),
                  ),
                  Text(
                    'OR',
                    style: TextStyle(color: kPrimaryBlack, fontSize: 2.h),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: kPrimaryBlack,
                      indent: 3.w,
                      endIndent: 10.w,
                    ),
                  ),
                ],
              ),
              //for space
              SizedBox(
                height: 3.h,
              ),
              //for login using Google
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: InkWell(
                  child: Container(
                    height: 5.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryBlue),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 3.w,
                        ),
                        const Icon(
                          Icons.facebook_rounded,
                          color: kPrimaryWhite,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'Login with Google',
                          style: TextStyle(
                              color: kPrimaryWhite,
                              fontSize: 2.h,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    // _googleSignIn
                    //     .signIn()
                    //     .then((GoogleSignInAccount? userData) {
                    //   print(userData!.id);
                    //   print(userData.email);
                    //   setState(() {
                    //     _isLoggedIn = true;
                    //     _userObj = userData;
                    //   });
                    // }).catchError((e) {
                    //   print(e);
                    // });
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (BuildContext context) => const Register()));
                  },
                ),
              ),
              //for space
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: InkWell(
                  child: Container(
                    height: 5.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryBlue),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 3.w,
                        ),
                        const Icon(
                          Icons.facebook_rounded,
                          color: kPrimaryWhite,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'Login with Facebook',
                          style: TextStyle(
                              color: kPrimaryWhite,
                              fontSize: 2.h,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    // Authentication.signOut(context: context);
                    Authentication.signInWithGoogle(context: context);
                    // _googleSignIn.signIn().then((userData) {
                    //   print(userData!.id);
                    //   print(userData.email);
                    //   setState(() {
                    //     _isLoggedIn = true;
                    //     _userObj = userData;
                    //   });
                    // }).catchError((e) {
                    //   print(e);
                    // });
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (BuildContext context) => const Register()));
                  },
                ),
              ),
              //for space
              SizedBox(
                height: 3.h,
              ),
              //dont have account register section
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 2.2.h, color: kPrimaryBlack),
                    ),
                    InkWell(
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 2.6.h,
                            color: kPrimaryBlack,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()));
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Authentication {
  static Future signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        if (userCredential.additionalUserInfo!.isNewUser == true) {
          print("--------------------------------------------------------");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => GoogleRegister()));
        } else {
          // signOut(context: context);
          print("+++++++++++++++++++++++++++++++");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // ...
        } else if (e.code == 'invalid-credential') {
          // ...
        }
      } catch (e) {
        // ...
      }
    }
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {}
  }
}
