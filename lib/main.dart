import 'package:allphanes/provider/icon_provider.dart';
import 'package:allphanes/view/homepage.dart';
import 'package:allphanes/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(FlutterSizer(builder: (context, orientation, screenType) {
    return
        // MaterialApp(
        //   debugShowCheckedModeBanner: false,
        //   title: "AllPhanes",
        //   home:
        MyApp();
    // );
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IconProvider(),
      child: MaterialApp(
        title: "AllPhanes",
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
