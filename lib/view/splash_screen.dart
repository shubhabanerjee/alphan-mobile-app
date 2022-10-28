import 'dart:async';

import 'package:allphanes/view/homepage.dart';
import 'package:allphanes/view/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceIn,
  );
  SharedPreferences? allphanesuserdata;
  bool? isnewuser;

  Future<void> checknewuser()async{
    allphanesuserdata=await SharedPreferences.getInstance();
    bool newuser=allphanesuserdata!.getBool("newuser") ??true;
    setState((){
      isnewuser=newuser;
    });
  }

  @override
  void initState(){
    super.initState();
    checknewuser().then((value){
      Timer(
          Duration(seconds: 6),
              (){
            if(isnewuser==true){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogIn()));
            }
            else{
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
            }

          }
      );
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child:AnimatedBuilder(
            animation: _controller,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width*.8,
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(1),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: Offset(5,10), // changes position of shadow
                  ),
                ],

              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage("images/splsh_logo.png"),fit: BoxFit.contain,
                ),
              ),
            ),
            builder: (context, widget) => Transform(
              transform: Matrix4.skewY(_controller.value * .3),
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}
