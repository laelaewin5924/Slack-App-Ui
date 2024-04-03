import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:slack_app_ui/pages/static_pages/welcome.dart';

class workspacenew extends StatefulWidget {
  const workspacenew({super.key});
  @override
  State<workspacenew> createState() => _workspacenewState();
}

class _workspacenewState extends State<workspacenew> {
  late TextEditingController workspaceNameController = TextEditingController();
  late TextEditingController channelNameController = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController passwordConfirmController =
      TextEditingController();
  List<dynamic> error = [];
  bool _isTextBoxVisible = false;
  bool status = false;
  Future<bool> createMWorkspace(
    String name,
    String email,
    String password,
    String password_confirmation,
    String profile_image,
    String remember_digest,
  ) async {
    final response = await http.post(Uri.parse("http://10.0.2.2:8000/m_users"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password_confirmation,
          'profile_image': profile_image,
          'remember_digest': remember_digest,
          'admin': 1,
        }));
    final responseJson = jsonDecode(response.body);
    // if response.status == 201
    //     status = true;
    // end
    if (response.statusCode == 201) {
      setState(() {
        status = true;
      });
      return status;
    } else {
      setState(() {
        error = responseJson['error'];
      });
      return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Slack App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 40,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
              8.0, 0, 8.0, 8.0), // Adjust top padding as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Create Workspace',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Visibility(
                visible: _isTextBoxVisible,
                child: Container(
                  color: const Color.fromARGB(
                      255, 208, 104, 138), // Background color
                  padding: EdgeInsets.all(8.0), // Padding around the text
                  child: Text(
                    'The form contains ${error.length.toString()} errors.',
                  ),
                ),
              ),
              Visibility(
                visible: _isTextBoxVisible,
                child: ListView.builder(
                  shrinkWrap: true, // Adjust to fit children size
                  itemCount: error.length, // Number of error messages
                  itemBuilder: (context, index) {
                    return Row(
                      // Row to add bullets before each error message
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align messages to the top
                      children: [
                        Container(
                          // Bullet container
                          margin: EdgeInsets.only(
                              top: 4.0), // Align bullet with the text
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: Colors.red, // Bullet color
                            shape: BoxShape.circle, // Bullet shape
                          ),
                        ),
                        SizedBox(width: 8.0), // Spacing between bullet and text
                        Expanded(
                          // Expanded to fill available width
                          child: Text(
                            error[index], // Display current error message
                            style: TextStyle(color: Colors.red), // Text color
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Text(
                'Workspaces Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: workspaceNameController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Channel Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: channelNameController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Password Confirmation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              SizedBox(
                height: 45,
                child: TextField(
                  obscureText: true,
                  controller: passwordConfirmController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    bool status1 = await createMWorkspace(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                      passwordConfirmController.text,
                      channelNameController.text,
                      workspaceNameController.text,
                    );
                    if (status1 == true) {
                      showSuccessDialog(context);
                    } else {
                      _isTextBoxVisible = true;
                    }
                  },
                  child: Text('Create my account'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue, // Set background color
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black, // Set text color
                    ),
                    alignment: Alignment.center, // align the text at the center
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

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Sign Up Success'),
        content: Text('Congratulations! Your sign-up was successful.'),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Welcome()),
                  (route) => false);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
