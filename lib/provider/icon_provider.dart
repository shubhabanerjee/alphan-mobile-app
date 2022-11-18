import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class IconProvider with ChangeNotifier {
  int iconcount = 0;
  get getdata => iconcount;

  updateData() async {
    final allphanesuserdata = await SharedPreferences.getInstance();
    String userid = allphanesuserdata.getString("userid") ?? "";

    http.Response response = await http.get(Uri.parse(
        "https://powerful-shelf-35750.herokuapp.com/api/notifications/getnotification?token=$userid&count=true"));
    var rsp = jsonDecode(response.body);
    print(rsp['responseData'].runtimeType);

    iconcount = rsp['responseData'];
    print(iconcount);
    notifyListeners();
  }
}
