import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CommentPost{
  String? referenceuserId;

  CommentPost(ruid){
    this.referenceuserId=ruid;

  }



  Future<void> postComment(postid,msg)async{
      var APIURL = "https://api.allphanes.com/api/social/comments";
      Map mapeddate ={
        'referenceUserId':referenceuserId,
        'referencePostId':postid,
        'messageText':msg
      };
      //send  data using http post to our php code
      http.Response reponse = await http.post(Uri.parse(APIURL),body:mapeddate );
      //getting response from php code, here
      var data = jsonDecode(reponse.body) ;
      print(data);

    // if(currentuserid==postuserid){
    //   Fluttertoast.showToast(
    //       msg: "Can't like own post",
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Color.fromRGBO(154,205,50,1),
    //       textColor: Colors.red,
    //       fontSize: 12.0
    //   );
    // }
    // else{
    //   var APIURL = "https://powerful-shelf-35750.herokuapp.com/api/social/like";
    //   Map mapeddate ={
    //     'referenceUserId':currentuserid,
    //     'referencePostId':postid,
    //   };
    //   //send  data using http post to our php code
    //   http.Response reponse = await http.post(Uri.parse(APIURL),body:mapeddate );
    //   //getting response from php code, here
    //   var data = jsonDecode(reponse.body) ;
    //   print(data);
    //   if(data["ack"]==1){
    //     Fluttertoast.showToast(
    //         msg: "Done",
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Color.fromRGBO(154,205,50,1),
    //         textColor: Colors.white,
    //         fontSize: 12.0
    //     );
    //   }
    // }
  }

}