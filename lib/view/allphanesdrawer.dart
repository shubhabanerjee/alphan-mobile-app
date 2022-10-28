import 'package:allphanes/view/creations.dart';
import 'package:allphanes/view/homepage.dart';
import 'package:allphanes/view/login.dart';
import 'package:allphanes/view/myspace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';



 class AllphanesDrawer extends StatefulWidget {
   const AllphanesDrawer({Key? key}) : super(key: key);

   @override
   State<AllphanesDrawer> createState() => _AllphanesDrawerState();
 }

 class _AllphanesDrawerState extends State<AllphanesDrawer> {

   SharedPreferences? allphanesuserdata;
   @override
   Widget build(BuildContext context) {
     return Drawer(
       //backgroundColor: Color.fromRGBO(154,205,50,1),
       backgroundColor: Colors.black,
       child: ListView(
         padding: EdgeInsets.zero,
         children: [
           const DrawerHeader(
             decoration: BoxDecoration(
               color: Colors.black
             ),
             child:  Center(
               child: Image(
                 image:   AssetImage("images/splsh_logo.png",),
                 filterQuality: FilterQuality.high,
                 fit: BoxFit.contain,
               ),
             ),
           ),
           const Divider(height: 1,thickness: 1,color: Colors.white,),
           ListTile(
             leading: Icon(Icons.home,color: Colors.white,size: 3.h,),
             title: Text("Home",style: TextStyle(color: Color.fromRGBO(154,205,50,1),fontSize: 2.h),),
             trailing: const Icon(Icons.arrow_forward_ios_sharp,size: 10,color: Colors.white,),
           ),

           ListTile(
             onTap: (){
               Navigator.pop(context);
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()),ModalRoute.withName('/'));
             },
             leading: Icon(Icons.draw,color: Colors.white,size: 3.h,),
             title: Text("My Canvas",style: TextStyle(color: Color.fromRGBO(154,205,50,1),fontSize: 2.h),),
             trailing: Icon(Icons.arrow_forward_ios_sharp,size: 10,color: Colors.white,),
           ),

           ListTile(
             onTap: ()async{
               allphanesuserdata=await SharedPreferences.getInstance();
               String? uid=allphanesuserdata!.getString("userid");
               Navigator.pop(context);
               Navigator.push(context, MaterialPageRoute(builder: (context)=>MySpace(uid,uid)));
             },
             leading: Icon(Icons.workspace_premium,color: Colors.white,size: 3.h,),
             title: Text("My Space",style: TextStyle(color: Color.fromRGBO(154,205,50,1),fontSize: 2.h),),
             trailing: Icon(Icons.arrow_forward_ios_sharp,size: 10,color: Colors.white,),
           ),

           ListTile(
             onTap: (){
               Navigator.pop(context);
               Navigator.push(context,MaterialPageRoute(builder: (context)=>Creations()));
             },
             leading: Icon(Icons.store,color: Colors.white,size: 3.h,),
             title: Text("Creations",style: TextStyle(color: Color.fromRGBO(154,205,50,1),fontSize: 2.h),),
             trailing: Icon(Icons.arrow_forward_ios_sharp,size: 10,color: Colors.white,),
           ),

           ListTile(
             leading: Icon(Icons.group,color: Colors.white,size: 3.h,),
             title: Text("Members",style: TextStyle(color: Color.fromRGBO(154,205,50,1),fontSize: 2.h),),
             trailing: Icon(Icons.arrow_forward_ios_sharp,size: 10,color: Colors.white,),
           ),

           ListTile(
             leading: Icon(Icons.settings,color: Colors.white,size: 3.h,),
             title: Text("Profile Settings",style: TextStyle(color: Color.fromRGBO(154,205,50,1),fontSize: 2.h),),
             trailing: Icon(Icons.arrow_forward_ios_sharp,size: 10,color: Colors.white,),
           ),

           ListTile(
             onTap: ()async{
               allphanesuserdata=await SharedPreferences.getInstance();
               Navigator.pop(context);
               allphanesuserdata!.getBool("newuser")==true;
               allphanesuserdata!.clear().then((value){
                 Fluttertoast.showToast(
                     msg: "You logged out successfully",
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Color.fromRGBO(154,205,50,1),
                     textColor: Colors.white,
                     fontSize: 12.0
                 );
                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LogIn()),ModalRoute.withName('/'));
               });

             },
             leading: Icon(Icons.logout,color: Colors.white,size: 3.h,),
             title: Text("Logout",style: TextStyle(color: Color.fromRGBO(154,205,50,1),fontSize: 2.h),),
             //trailing: Icon(Icons.arrow_forward_ios_sharp,size: 10,color: Colors.white,),
           )
         ],
       ),
     );
   }
 }
