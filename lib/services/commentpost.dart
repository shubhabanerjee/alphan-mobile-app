import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CommentPost {
  String? referenceuserId;

  CommentPost(ruid) {
    this.referenceuserId = ruid;
  }

  Future<void> postComment(postid, msg) async {
    var APIURL =
        "https://powerful-shelf-35750.herokuapp.com/api/social/comments";
    Map mapeddate = {
      'referenceUserId': referenceuserId,
      'referencePostId': postid,
      'messageText': msg
    };
    //send  data using http post to our php code
    http.Response reponse = await http.post(Uri.parse(APIURL), body: mapeddate);
    //getting response from php code, here
    var data = jsonDecode(reponse.body);
    print(data);
  }
}
