import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:slack_app_ui/pages/layouts/appbar.dart';
import 'package:slack_app_ui/pages/leftpannels/leftpannel.dart';
import 'dart:convert';
import 'package:slack_app_ui/pages/share_pref_utils.dart';

bool status = false;

class UserManage extends StatefulWidget {
  const UserManage({super.key});

  @override
  State<UserManage> createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  String? token = "";
  int? workspace_id;
  int? user_id;
  dynamic user_manages_activate = [];
  dynamic user_manages_deactivate = [];
  dynamic user_manages_admin = [];

  Future<void> _fetchUserList() async {
    token = await SharedPrefUtils.getStr("token");
    workspace_id = await SharedPrefUtils.getInt("workspaceid");
    user_id = await SharedPrefUtils.getInt("userid");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/usermanage?workspace_id=$workspace_id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          final dynamic data = jsonDecode(response.body);
          user_manages_activate = data['user_manages_activate'];
          user_manages_deactivate = data['user_manages_deactivate'];
          user_manages_admin = data['user_manages_admin'];
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> AddToWorkspace(int id) async {
    token = await SharedPrefUtils.getStr("token");
    workspace_id = await SharedPrefUtils.getInt("workspaceid");
    user_id = await SharedPrefUtils.getInt("userid");

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/update/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      status = true;
    }
  }

  Future<void> RemoveFromWorkspace(int id) async {
    token = await SharedPrefUtils.getStr("token");
    workspace_id = await SharedPrefUtils.getInt("workspaceid");
    user_id = await SharedPrefUtils.getInt("userid");

    final editresponse = await http.post(
      Uri.parse("http://10.0.2.2:8000/edit/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (editresponse.statusCode == 200) {
      status = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                child: const Text(
                  'User Manage',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                'ユーザ名とメールアドレス',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Text(
                'セットアップ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //ADMIN///////////
                  CustomScrollView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final adminActive = user_manages_admin[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              adminActive['name'],
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 60),
                                      Column(
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              '-',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              adminActive['email'],
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: user_manages_admin.length,
                        ),
                      ),
                    ],
                  ),
                  //Activate User////////
                  CustomScrollView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final userActive = user_manages_activate[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userActive['name'],
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 60),
                                      Column(
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              await RemoveFromWorkspace(
                                                  userActive['id']);
                                              if (status == true) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const UserManage(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              '解除',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationThickness: 2,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userActive['email'],
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: user_manages_activate.length,
                        ),
                      ),
                    ],
                  ),
                  //Deactivate User
                  CustomScrollView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final userDeactive = user_manages_deactivate[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userDeactive['name'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                backgroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 60),
                                      Column(
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              await AddToWorkspace(
                                                  userDeactive['id']);
                                              if (status == true) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const UserManage(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              '有効',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationThickness: 2,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userDeactive['email'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                backgroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: user_manages_deactivate.length,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Leftpannel(),
    );
  }
}
