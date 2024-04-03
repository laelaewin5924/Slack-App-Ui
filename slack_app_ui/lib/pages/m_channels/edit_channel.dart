import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:slack_app_ui/pages/layouts/appbar.dart';
import 'package:slack_app_ui/pages/leftpannels/leftpannel.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';
import 'package:slack_app_ui/pages/static_pages/home.dart';

class EditChannel extends StatefulWidget {
  EditChannel({super.key, required this.channelData});

  dynamic channelData;

  @override
  State<EditChannel> createState() => _EditChannelState();
}

class _EditChannelState extends State<EditChannel> {
  late TextEditingController channelNameController =
      TextEditingController(text: widget.channelData["channel_name"]);
  int? channel_status;
  final _formKey = GlobalKey<FormState>();
  String? token;
  int? user_id;
  int? workspace_id;

  Future editChannel(String channelName, int channelStatus) async {
  user_id = await SharedPrefUtils.getInt("userid");
  token = await SharedPrefUtils.getStr("token");
  workspace_id = await SharedPrefUtils.getInt("workspaceid");
    await http.put(
        Uri.parse(
            "http://10.0.2.2:8000/m_channels/channelupdate/${widget.channelData["id"]}"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'channel_name': channelName,
          'channel_status': channelStatus,
          'workspace_id': workspace_id,
          'user_id': user_id
        }));
  }

  @override
  void initState() {
    super.initState();
    channel_status = widget.channelData["channel_status"] ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBarWidget(),
        drawer: Leftpannel(),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Channel Edit",
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: channel_status,
                      onChanged: (value) {
                        setState(() {
                          channel_status = value;
                        });
                      },
                    ),
                    const Text('Public'),
                    const SizedBox(
                        width: 20), // Add spacing between the radio buttons
                    Radio(
                      value: 0,
                      groupValue: channel_status,
                      onChanged: (value) {
                        setState(() {
                          channel_status = value;
                        });
                      },
                    ),
                    const Text('Private'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                    validator: (String? value) {
                      return value!.isEmpty ? 'Invalid workspaceName' : null;
                    },
                    controller: channelNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'channel name',
                    )),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        editChannel(
                            channelNameController.text, channel_status!);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(title: 'SLACK APP',)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "Update",
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ))
            ],
          ),
        ));
  }
}
