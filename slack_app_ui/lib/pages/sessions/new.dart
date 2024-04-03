import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:slack_app_ui/pages/share_pref_utils.dart';
import 'package:slack_app_ui/pages/static_pages/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool member_status = false;
  bool invalid_message = false;
  bool deactivate_message = false;
  String token = "";
  Map<String, dynamic> user_workspace = {};

  late TextEditingController workspaceNameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  String error = '';
  bool _isTextBoxVisible = false;

  Future<void> CreateSignIn(
      String workspace_name, String email, String password) async {
    final response = await http.post(Uri.parse("http://10.0.2.2:8000/signin"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'workspace_name': workspace_name,
          'email': email,
          'password': password
        }));
    final body = json.decode(response.body);
    if (body['errors'] == null) {
      error = '';
      token = body['token'];
      user_workspace = body['user_workspace'];
      SharedPrefUtils.saveStr("token", body['token']);
      SharedPrefUtils.saveInt("userid", body['user_workspace']['userid']);
      SharedPrefUtils.saveInt(
          "workspaceid", body['user_workspace']['workspaceid']);
      SharedPrefUtils.saveInt("rdirectsize", 10);
      SharedPrefUtils.saveInt("rgroupsize", 10);
    } else {
      error = body['errors'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Slack App',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
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
                    child: Text(
                      "$error",
                      style: TextStyle(
                        color: Color.fromARGB(255, 223, 59, 47), // Text color
                        // Add more text styling as needed
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Workspace Name',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: workspaceNameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    contentPadding: EdgeInsets.all(5.0)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Email',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    contentPadding: EdgeInsets.all(5.0)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Password',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    contentPadding: EdgeInsets.all(5.0)),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: () async {
                      await CreateSignIn(
                        workspaceNameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                      if (error == '') {
                        setState(() {
                          _isTextBoxVisible = false;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                      title: "Slack App",
                                    )),
                            (route) => false);
                      } else {
                        setState(() {
                          _isTextBoxVisible = true;
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(12, 109, 182, 1),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
