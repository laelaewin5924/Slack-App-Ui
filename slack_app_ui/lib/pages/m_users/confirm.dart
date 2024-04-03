import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:slack_app_ui/pages/share_pref_utils.dart';
import 'dart:convert';

import 'package:slack_app_ui/pages/static_pages/welcome.dart';

class MemberConfirm extends StatefulWidget {
  String? email;
  String? channel_name;
  String? workspace_name;
  String? workspaceid;
  MemberConfirm(
      this.email, this.channel_name, this.workspace_name, this.workspaceid,
      {super.key});
  @override
  _MemberConfirmState createState() {
    print("Route1111");
    print(email);
    print(workspaceid);
    return _MemberConfirmState(
        email, channel_name, workspace_name, workspaceid);
  }
  // State<MemberConfirm> createState() => _MemberConfirmState(email);
}

class _MemberConfirmState extends State<MemberConfirm> {
  String? email;
  String? channel_name;
  String? workspace_name;
  String? workspaceid;
  _MemberConfirmState(
      this.email, this.channel_name, this.workspace_name, this.workspaceid);

  late TextEditingController nameController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController passwordConfirmController =
      TextEditingController();

  List<dynamic> error = [];
  bool _isTextBoxVisible = false;
  bool status = false;
  String? token;

  Future<bool> createNewMember(
    String name,
    // String email,
    String password,
    String passwordConfirmation,
    // String profile_image,
    // String remember_digest,
  ) async {
    token = await SharedPrefUtils.getStr("token");
    final response = await http.post(
        Uri.parse(
            "http://10.0.2.2:8000/m_users?invite_workspaceid=$workspaceid"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'profile_image': channel_name,
          'remember_digest': workspace_name,
          'admin': 0,
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
        margin: const EdgeInsets.only(
          top: 40,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
              8.0, 0, 8.0, 8.0), // Adjust top padding as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Member Confirmation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Visibility(
                visible: _isTextBoxVisible,
                child: Container(
                  color: const Color.fromARGB(
                      255, 208, 104, 138), // Background color
                  padding: const EdgeInsets.all(8.0), // Padding around the text
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
                          margin: const EdgeInsets.only(
                              top: 4.0), // Align bullet with the text
                          width: 8.0,
                          height: 8.0,
                          decoration: const BoxDecoration(
                            color: Colors.red, // Bullet color
                            shape: BoxShape.circle, // Bullet shape
                          ),
                        ),
                        const SizedBox(
                            width: 8.0), // Spacing between bullet and text
                        Expanded(
                          // Expanded to fill available width
                          child: Text(
                            error[index], // Display current error message
                            style: const TextStyle(
                                color: Colors.red), // Text color
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Text(
                'Workspaces Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    hintText: '${widget.workspace_name}',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Channel Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    hintText: '${widget.channel_name}',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
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
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
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
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    hintText: '${widget.email}',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
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
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Password Confirmation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 45,
                child: TextField(
                  obscureText: true,
                  controller: passwordConfirmController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    bool status1 = await createNewMember(
                      nameController.text,
                      passwordController.text,
                      passwordConfirmController.text,
                    );
                    if (status1 == true) {
                      showSuccessDialog(context);
                    } else {
                      _isTextBoxVisible = true;
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue, // Set background color
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black, // Set text color
                    ),
                    alignment: Alignment.center, // align the text at the center
                  ),
                  child: const Text('Create my account'),
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
        title: const Text('Sign Up Success'),
        content: const Text('Congratulations! Your sign-up was successful.'),
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
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
