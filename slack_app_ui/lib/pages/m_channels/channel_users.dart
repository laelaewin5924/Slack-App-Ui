import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:slack_app_ui/pages/layouts/appbar.dart';
import 'package:slack_app_ui/pages/leftpannels/leftpannel.dart';
import 'package:slack_app_ui/pages/m_channels/show_channel.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';

class ChannelUsers extends StatefulWidget {
  ChannelUsers({super.key, required this.channelData});
  dynamic channelData;

  @override
  State<ChannelUsers> createState() => _ChannelUsersState();
}

class _ChannelUsersState extends State<ChannelUsers> {
  dynamic mChannelsIds = [];
  List<dynamic> wUsers = [];
  List<dynamic> cUsers = [];
  List<dynamic> cUserIds = [];
  int sChannelId = 0;
  int? workspace_id;
  int? user_id;
  String? token;
  bool status = false;

  List<String> nameLists = [];
  String _name = "";

  Future<void> getChannelUserData() async {
    token = await SharedPrefUtils.getStr("token");
    user_id = await SharedPrefUtils.getInt("userid");
    workspace_id = await SharedPrefUtils.getInt("workspaceid");

    final response = await http.get(
      Uri.parse(
          "http://10.0.2.2:8000/channelusers?workspace_id=$workspace_id&s_channel_id=${widget.channelData["id"]}"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final dynamic data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        wUsers = data["w_users"];
        cUsers = data["c_users"];
        cUserIds = data["c_users_id"];
        sChannelId = data["s_channel"]["id"];
        for (var wUser in wUsers) {
          if (!cUserIds.contains(wUser["id"])) {
            nameLists.add(wUser["name"]);
          }
        }
      });
    }
  }

  Future<void> getHome() async {
    token = await SharedPrefUtils.getStr("token");
    user_id = await SharedPrefUtils.getInt("userid");
    workspace_id = await SharedPrefUtils.getInt("workspaceid");
    final response = await http.get(
      Uri.parse(
          "http://10.0.2.2:8000/home?workspace_id=$workspace_id&user_id=$user_id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final dynamic data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        mChannelsIds = data["m_channelsids"];
      });
    }
  }

  Future<void> removeChannelUser(int sChannelId, int userId) async {
    token = await SharedPrefUtils.getStr("token");
    final response = await http.delete(
      Uri.parse(
          "http://10.0.2.2:8000/channeluser/destroy/?s_channel_id=$sChannelId&user_id=$userId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      status = true;
    }
  }

  Future createChannelUser(int userId) async {
    token = await SharedPrefUtils.getStr("token");
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/channeluser/create"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, dynamic>{"user_id": userId, "s_channel_id": sChannelId}));
    if (response.statusCode == 200) {
      status = true;
    }
  }

  @override
  void initState() {
    super.initState();
    getChannelUserData();
    getHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(),
      drawer: Leftpannel(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: Colors.grey.shade400,
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(widget.channelData["channel_name"],
                      style: const TextStyle(fontSize: 20.0)),
                ],
              )),
          if (mChannelsIds.contains(sChannelId))
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  if (mChannelsIds.contains(sChannelId))
                    const Text(
                      "userlist:",
                      style: TextStyle(fontSize: 22.0),
                    ),
                  const SizedBox(width: 15),
                  if (mChannelsIds.contains(sChannelId))
                    Expanded(
                      child: DropdownButtonFormField(
                        items: nameLists.map((String name) {
                          return DropdownMenuItem(
                              value: name,
                              child: Row(
                                children: <Widget>[
                                  Text(name),
                                ],
                              ));
                        }).toList(),
                        onChanged: (newValue) {
                          // do other stuff with _category
                          setState(() => _name = newValue!);
                        },
                        hint: const Text("select name"),
                      ),
                    ),
                  const SizedBox(width: 5.0),
                  if (mChannelsIds.contains(sChannelId))
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        
                          for (var wUser in wUsers) {
                            if (wUser["name"] == _name) {
                               createChannelUser(wUser["id"]);
                            }
                          }
                       

                        if (status == true) {
                          print(status);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChannelUsers(
                                    channelData: widget.channelData)),
                          );
                        }
                      },
                      child: const Text("add",
                          style: TextStyle(color: Colors.white)),
                    )
                ],
              ),
            ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Row(
              children: [
                Text("No"),
                SizedBox(width: 30),
                Text("Name"),
                SizedBox(width: 80),
                Text("Email"),
                SizedBox(width: 130),
                Text("SetUp"),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          showChannelUser(),
        ],
      ),
    );
  }

  ListView showChannelUser() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(width: 40.0, child: Text((index + 1).toString())),
              SizedBox(width: 90, child: Text(cUsers[index]["name"])),
              SizedBox(width: 170, child: Text(cUsers[index]["email"])),
              if (cUsers[index]["created_admin"] == 0 &&
                  mChannelsIds.contains(sChannelId))
                TextButton(
                    onPressed: () async {
                      await removeChannelUser(sChannelId, cUsers[index]["id"]);
                      if (status == true) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChannelUsers(
                                    channelData: widget.channelData)),
                            (route) => false);
                      }
                    },
                    child: const Text(
                      "remove",
                      style: TextStyle(color: Color.fromARGB(255, 27, 5, 228)),
                    ))
            ],
          ),
        );
      },
    );
  }

  // Widget channelUsersDropDown() {
  //   return DropdownButtonFormField(
  //     items: nameLists.map((String name) {
  //       return DropdownMenuItem(
  //           value: name,
  //           child: Row(
  //             children: <Widget>[
  //               Text(name),
  //             ],
  //           ));
  //     }).toList(),
  //     onChanged: (newValue) {
  //       // do other stuff with _category
  //       setState(() => _name = newValue!);
  //     },
  //     hint: const Text("select name"),
  //   );
  // }
}
