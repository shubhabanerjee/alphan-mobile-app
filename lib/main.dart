import 'package:allphanes/view/homepage.dart';
import 'package:allphanes/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(FlutterSizer(builder: (context, orientation, screenType) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AllPhanes",
      home: HomePage(),
    );
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
