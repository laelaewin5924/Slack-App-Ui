import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:slack_app_ui/pages/layouts/appbar.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';
import "package:http/http.dart" as http;
import 'package:slack_app_ui/pages/static_pages/home.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key,required this.userdata});
  dynamic userdata;
  
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  String? token = "";
  int? user_id;
  bool _isTextBoxVisible = false;
  String error = '';

  Future<void> changepassword(String password, String confirmpassword) async{

    token = await SharedPrefUtils.getStr("token");
    user_id = await SharedPrefUtils.getInt("userid");
    final response = await http.get(Uri.parse("http://10.0.2.2:8000/home?user_id=$user_id"), 
    headers: {
      'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
    },);

    final postResponse = await http.post(Uri.parse("http://10.0.2.2:8000/change_password?user_id=$user_id"),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'm_user':{
        'password': password,
        'password_confirmation': confirmpassword,
        }
      })
    );

    final responseJson = jsonDecode(postResponse.body);
      
    if (responseJson['error'] == null) {
      error = '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hello This is Snackbar'),
        )
      );

    }else{
      error = responseJson['error'];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
              child: const Center(
                child: Text(
                  'Change Password',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          
            Visibility(
              visible: _isTextBoxVisible,
              child: Container(
                width: 450.0,
                color: Color.fromARGB(255, 233, 201, 211), // Background color
                padding: EdgeInsets.all(8.0), // Padding around the text
                child: Center(
                  child: Text('$error',
                    style: TextStyle(
                    color: Color.fromARGB(255, 223, 59, 47), // Text color
                    // Add more text styling as needed
                    ),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Email',style: TextStyle(fontSize: 20,color:Colors.black),),
                  Text('${widget.userdata}',style: TextStyle(fontSize: 18),),
                ]
              ),
            ),
          
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Password',style: TextStyle(fontSize: 20,color: Colors.black),),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // hintText: 'Enter a search term',
                    isDense: true,
                    
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Password confirmation',style: TextStyle(fontSize: 20,color:Colors.black),),
                  TextFormField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Container(
                  width: 375,
                  child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    
                  ),
                  onPressed: () async{
                    await changepassword(passwordController.text, confirmController.text);
                    if(error == ''){
                      setState(() {
                        _isTextBoxVisible = false;
                      });

                      showSuccessDialog(context);

                    }
                    else{
                      setState(() {
                        _isTextBoxVisible = true;
                      });
                    }
                    
                  },
                  child: const Text('Update', style: TextStyle(fontSize: 20, color: Colors.white,),
                  
                  ),
                ),
                ),
              ),
          ],
              ),
          ),
        ),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change Password Success'),
        content: Text('Congratulations! Your password changing is successful.'),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage(title: 'SLACK APP',)),
                      (route) => false);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
