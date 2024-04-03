import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:slack_app_ui/pages/change_password/new.dart';
import 'package:slack_app_ui/pages/static_pages/home.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';
import "package:http/http.dart" as http;
import 'package:slack_app_ui/pages/static_pages/welcome.dart';

class MyAppBarWidget extends StatefulWidget implements PreferredSizeWidget{
 @override
 Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<MyAppBarWidget> createState() => _MyAppBarWidgetState();
}

class _MyAppBarWidgetState extends State<MyAppBarWidget> {

  String email = "";
  String? token = "";
  int? workspace_id;
  int? user_id;

  Future<void> fetchData() async {
    token = await SharedPrefUtils.getStr("token");
    workspace_id = await SharedPrefUtils.getInt("workspaceid");
    user_id = await SharedPrefUtils.getInt("userid");
    final response = await http.get(Uri.parse("http://10.0.2.2:8000/home?workspace_id=$workspace_id&user_id=$user_id"), headers: {
      'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
    },);

   final dynamic body = json.decode(response.body);
  
   if (response.statusCode == 200) {     
    setState(() {
      email ='${body["m_user"]['email']}';
    });
   
   }   
  }

  @override
  void initState(){
    super.initState();
   fetchData();
  }

   @override
  Future<void> _Logout(int id) async {
    await SharedPrefUtils.remove("token");
    await SharedPrefUtils.remove("workspaceid");
    await SharedPrefUtils.remove("userid");
      final response = await http.delete(Uri.parse("http://10.0.2.2:8000/logout"));
      if (response.statusCode == 200) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Welcome()),
          );
        });
      } else {
        throw Exception('Failed to Logout');
      }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text("Slack app", style: TextStyle(fontSize: 20),),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: Colors.black ,
      actions: [
        
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(title: 'SLACK APP',)) 
            );
          },

        ),

        IconButton(
          icon: Icon(Icons.lock),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePassword(userdata: email,)),
            );
          },
        ),
        IconButton(
          icon:const Icon(Icons.logout),
          onPressed: () {
            _Logout(user_id!);
          },
        ),
      ],           
    );
  }
}