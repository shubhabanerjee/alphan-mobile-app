import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:allphanes/view/homepage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/constant.dart';

class GoogleRegister extends StatefulWidget {
  final UserCredential additionalUserInfo;
  const GoogleRegister({required this.additionalUserInfo, Key? key})
      : super(key: key);

  @override
  State<GoogleRegister> createState() => _GoogleRegisterState();
}

class _GoogleRegisterState extends State<GoogleRegister> {
  List<CountryCode> countriesCode = [];
  bool isCountriesLoaded = false;
  CountryCode? selectedCountryCode;
  final k1 = GlobalKey<FormState>();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController refcode = TextEditingController();
  bool showname = false;
  bool termcondition = false;
  var indicator;
  SharedPreferences? allphanesuserdata;
  bool unlock = false;

  Future<List<CountryCode>> getApiCountryCode() async {
    var response = await http.get(Uri.parse(
        'https://powerful-shelf-35750.herokuapp.com/api/users/country'));
    if (response.statusCode == 200) {
      var mapResponse = jsonDecode(response.body);
      return (mapResponse['responseData'] as List)
          .map((mapCountryCode) => CountryCode.fromMap(mapCountryCode))
          .toList();
    } else {
      throw {Error};
    }
  }

  @override
  void initState() {
    super.initState();
    getApiCountryCode().then((_countriesCode) {
      countriesCode = _countriesCode;
      setState(() {
        isCountriesLoaded = true;
      });
    });
  }

  Future userRegister() async {
    allphanesuserdata = await SharedPreferences.getInstance();
    //https://powerful-shelf-35750.herokuapp.com/api/users/fblogin
    var APIURL = "https://powerful-shelf-35750.herokuapp.com/api/users/fblogin";
    //var APIURL = "https://allphanestest.herokuapp.com/api/users/create";
    Map mapeddate = {
      "countryDialCode": "+91",
      "email": "banerjee.00.subho@gmail.com",
      "firstName": "subho",
      "isEmailVerified": true,
      "lastName": "banerjee",
      "loginType": "google",
      "phone": "8167777417",
      'profilePhoto':
          "https://lh3.googleusercontent.com/a/ALm5wu2HU0KVpvODIjRR8IAF_B1yDsRVHacTcldksOLV=s96-c",
      "showName": "sb",
      "userID": "mVSyfiJO2Hgtdr1emzzVMOGLUMU2",
      "userName": "sb"
    };
    //send  data using http post to our php code
    http.Response reponse = await http.post(Uri.parse(APIURL), body: mapeddate);
    //getting response from php code, here
    var data = jsonDecode(reponse.body);
    print("registration: $data");
    setState(() {
      indicator = 2;
    });
    if (data["ack"] == 1) {
      Fluttertoast.showToast(
          msg: "Registration Successfull",
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(154, 205, 50, 1),
          textColor: Colors.white,
          fontSize: 12.0);
      allphanesuserdata?.setBool("newuser", false);
      allphanesuserdata?.setString("userid", "${data["responseData"]["id"]}");
      allphanesuserdata?.setString(
          "showname", "${data["responseData"]["showName"]}");
      allphanesuserdata?.setString(
          "username", "${data["responseData"]["userName"]}");
      allphanesuserdata?.setString(
          "profilephoto", "${data["responseData"]["profilePhoto"]}");
      allphanesuserdata?.setString(
          "coverphoto", "${data["responseData"]["coverPhoto"]}");
      setState(() {
        unlock = true;
      });
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage())));
    } else {
      Fluttertoast.showToast(
          msg: data["message"],
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(154, 205, 50, 1),
          textColor: Colors.red,
          fontSize: 12.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryWhite,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 10.h,
            width: 50.w,
            child: Image.asset(
              'images/main_logo_black.png',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Login with Google',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 4.h, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 2.h,
          ),
          CircleAvatar(
            radius: 4.h,
            child:
                ClipOval(child: Image.asset('images/default_profileimage.png')),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            widget.additionalUserInfo.user!.displayName.toString(),
            style: TextStyle(fontSize: 2.5.h, color: kPrimaryBlack),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Text(
            widget.additionalUserInfo.user!.email.toString(),
            style: TextStyle(fontSize: 2.h, color: kPrimaryBlack),
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w, left: 10.w, top: 2.h),
            child: TextFormField(
              cursorColor: kPrimaryBlack,
              enableInteractiveSelection: true,
              style: TextStyle(color: kPrimaryBlack, fontSize: 2.5.h),
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.person,
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
                hintText: 'Surname to Continue',
                hintStyle: TextStyle(
                  color: kPrimaryBlack,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w, left: 10.w, top: 2.h),
            child: TextFormField(
              cursorColor: kPrimaryBlack,
              enableInteractiveSelection: true,
              style: TextStyle(color: kPrimaryBlack, fontSize: 2.5.h),
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.phone,
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
                hintText: 'Phone Number',
                hintStyle: TextStyle(
                  color: kPrimaryBlack,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Flexible(
            child: GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 10.w, left: 10.w, top: 2.h),
                child: Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: kPrimaryBlack),
                    ),
                  ),
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        selectedCountryCode?.dialCode ?? '+91',
                        style: TextStyle(fontSize: 2.5.h, color: kPrimaryBlack),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: CircleAvatar(
                          backgroundColor: kPrimaryOffWhite,
                          radius: 2.h,
                          child: ClipOval(
                            child: ImageIcon(
                              AssetImage('images/down_arrow.png'),
                              size: 2.5.h,
                              color: kPrimaryBlack,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                if (isCountriesLoaded) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView.builder(
                              itemCount: countriesCode.length,
                              itemBuilder: (context, index) {
                                var countryCode = countriesCode[index];
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        selectedCountryCode = countryCode;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    leading: Text(countryCode.dialCode),
                                    title: Text(countryCode.name),
                                    trailing: Text(countryCode.code),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          SizedBox(
            height: 7.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: kPrimaryBlack,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'Register as Sri',
                    style: TextStyle(
                        fontSize: 2.5.h,
                        color: kPrimaryWhite,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              onTap: () {},
            ),
          )
        ],
      )),
    );
  }
}

class CountryCode {
  String id;
  String name;
  String dialCode;
  String code;

  CountryCode(
      {required this.id,
      required this.name,
      required this.dialCode,
      required this.code});

  factory CountryCode.fromMap(Map countryMapData) {
    return CountryCode(
      id: countryMapData['_id'],
      name: countryMapData['name'],
      dialCode: countryMapData['dial_code'],
      code: countryMapData['code'],
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CountryCode && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CountryCode(id : $id, name : $name, dialCode : $dialCode, code : $code)';
  }
}
