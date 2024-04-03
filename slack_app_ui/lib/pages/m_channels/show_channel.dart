// ignore_for_file: avoid_unnecessary_containers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:slack_app_ui/pages/layouts/appbar.dart';
import 'package:slack_app_ui/pages/leftpannels/leftpannel.dart';
import 'package:slack_app_ui/pages/m_channels/channel_users.dart';
import 'package:slack_app_ui/pages/m_channels/edit_channel.dart';
import 'package:slack_app_ui/pages/m_channels/show_group_thread.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';
import 'package:slack_app_ui/pages/static_pages/home.dart';

bool status = false;

class ShowChannel extends StatefulWidget {
  ShowChannel({super.key, required this.channelData});

  dynamic channelData;


  @override
  State<ShowChannel> createState() => _ShowChannelState();
}

class _ShowChannelState extends State<ShowChannel> {
  int userCount = 0;
  dynamic tGroupMessage = [];
  dynamic tGroupMessageDates = [];
  dynamic tGroupMessageDatesSizes = [];
  dynamic tGroupStarMsgids = [];
  final DateFormat formatter = DateFormat('jm');
  final DateFormat ymd = DateFormat('yyyy-MM-dd');
  int channelId = 0;
  dynamic channelData = [];
  dynamic channelUsersLists = [];
  List<Map<String, dynamic>> channelUsers = [];
  int? user_id;
  int? workspace_id;
  String? token = "";
  dynamic mChannelIds = [];
  bool isLoading = true;

  

  Future<void> fetchData() async {
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

    final dynamic body = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        mChannelIds = body["m_channelsids"];
      });
    }
  }

  Future<void> retrieveGroupMessage() async {
    token = await SharedPrefUtils.getStr("token");
    user_id = await SharedPrefUtils.getInt("userid");
    workspace_id = await SharedPrefUtils.getInt("workspaceid");
    final response = await http.get(
      Uri.parse(
          "http://10.0.2.2:8000/m_channels/channelshow?id=${widget.channelData["id"]}&user_id=$user_id&workspace_id=$workspace_id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final dynamic data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        userCount = data["retrieveGroupMessage"]["u_count"];
        tGroupMessageDates =
            data["retrieveGroupMessage"]["t_group_message_dates"];
        tGroupMessageDatesSizes =
            data["retrieveGroupMessage"]["t_group_message_datesize"];
        tGroupMessage = data["retrieveGroupMessage"]["t_group_messages"];
        channelId = data["retrieveGroupMessage"]["s_channel"]["id"];
        channelData = data["retrieveGroupMessage"]["s_channel"];
        tGroupStarMsgids = data["retrieveGroupMessage"]["t_group_star_msgids"];
        channelUsersLists = data["retrieveGroupMessage"]["m_channel_users"];
        for (var user in channelUsersLists) {
          channelUsers
              .add({"id": user["id"].toString(), "display": user["name"]});
        }
      });
    }
  }

  Future sendGroupMessage(String message, int channelId) async {
    String? token;
    int? userId;
    int? workspaceId;
    List<String> mentionedNameList = [];

    token = await SharedPrefUtils.getStr("token");
    userId = await SharedPrefUtils.getInt("userid");
    workspaceId = await SharedPrefUtils.getInt("workspaceid");
    List sendMessageWords = message.split(" ");

    for (var word in sendMessageWords) {
      if (word.startsWith("@")) {
        mentionedNameList.add(word);
      }
      
    }

    if (message.isEmpty) {
      return;
    } else {
      final response =
          await http.post(Uri.parse("http://10.0.2.2:8000/groupmsg"),
              headers: <String, String>{
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'message': message,
                'workspace_id': workspaceId,
                'user_id': userId,
                's_channel_id': channelId,
                'mention_name': mentionedNameList
              }));
      setState(() {
        if (response.statusCode == 200) {
          status = true;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveGroupMessage();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    String sendText = "";
    GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();

    return Scaffold(
      appBar: MyAppBarWidget(),
      drawer: const Leftpannel(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: const Color.fromARGB(255, 77, 76, 76),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(widget.channelData["channel_name"],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20.0)),
                      ),
                      const SizedBox(width: 10.0),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChannelUsers(channelData: channelData)),
                              (route) => false);
                        },
                        icon: const Icon(Icons.people, color: Colors.white),
                        label: Text(userCount.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20.0)),
                      ),
                      const SizedBox(width: 10.0),
                      Row(
                        children: [
                          if (mChannelIds.contains(channelId))
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditChannel(
                                            channelData: widget.channelData)),
                                    (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 77,
                                    76, 76), // Set the background color to gray
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.edit,
                                      color: Colors.white), // Edit icon
                                  SizedBox(
                                      width:
                                          8), // Add spacing between icon and text
                                  // Button text
                                ],
                              ),
                            ),
                          if (mChannelIds.contains(channelId))
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 77, 76, 76)),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Are you sure to delete'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteChannel(widget.channelData["id"]);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage(
                                                      title: 'SLACK APP',
                                                    )),
                                            (route) => false);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                const Row(
                  children: [
                    Icon(Icons.restart_alt, color: Colors.blue),
                    Text("Load More",
                        style: TextStyle(color: Colors.blue, fontSize: 20.0)),
                  ],
                ),
                Expanded(
                    flex: 3,
                    child: showMessages(
                        tGroupMessageDates,
                        tGroupMessageDatesSizes,
                        tGroupMessage,
                        formatter,
                        ymd,
                        tGroupStarMsgids,
                        channelData)),
                isLoading
                    ? const Text("")
                    : Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: mChannelIds.contains(channelId)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: FlutterMentions(
                                        onChanged: (value) {
                                          sendText = value;
                                        },
                                        key: key,
                                        suggestionPosition:
                                            SuggestionPosition.Top,
                                        maxLines: 1,
                                        minLines: 1,
                                        suggestionListDecoration: BoxDecoration(
                                          color:
                                              Colors.white, // Background color
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Border radius
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                blurRadius: 5.0)
                                          ], // Shadow
                                        ),
                                        decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                            hintText: 'type message',
                                            border: OutlineInputBorder()),
                                        mentions: [
                                          Mention(
                                              trigger: '@',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                              ),
                                              data: channelUsers,
                                              matchAll: false,
                                              suggestionBuilder: (data) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 0, 0, 0),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const SizedBox(
                                                          width: 20.0,
                                                        ),
                                                        Column(
                                                          children: <Widget>[
                                                            Text(
                                                              data['display'],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          20.0),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                          Mention(
                                            trigger: '#',
                                            disableMarkup: true,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                            matchAll: true,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(50, 50),
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onPressed: () async {
                                      await sendGroupMessage(
                                          sendText, channelId);
                                      if (status == true) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowChannel(
                                                        channelData:
                                                            channelData)),
                                            (route) => false);
                                      }
                                    },
                                    child: const Text("send",
                                        style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  await channelJoin(channelId);
                                  print("From show channel $status");
                                  if (status == true) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShowChannel(
                                                channelData: channelData)),
                                        (route) => false);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: const Text("JOIN",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white))))
              ],
            ),
    );
  }
}

Future channelJoin(int sChannelId) async {
  String? token;
  int? userId;
  token = await SharedPrefUtils.getStr("token");
  userId = await SharedPrefUtils.getInt("userid");

  final request = await http.post(
      Uri.parse("http://10.0.2.2:8000/channelUserJoin"),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{'s_channel_id': sChannelId, 'userid': userId}));

  if (request.statusCode == 200) {
    status = true;
  }
}

Future createStar(int msgId) async {
  String? token;
  int? userId;
  userId = await SharedPrefUtils.getInt("userid");
  token = await SharedPrefUtils.getStr("token");
  final response =
      await http.post(Uri.parse("http://10.0.2.2:8000/groupstarmsg"),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'msgid': msgId,
            'user_id': userId,
          }));

  if (response.statusCode == 201) {
    status = true;
  }
}

Future destroyStar(int msgId) async {
  String? token;
  int? userId;
  userId = await SharedPrefUtils.getInt("userid");
  token = await SharedPrefUtils.getStr("token");
  final response =
      await http.post(Uri.parse("http://10.0.2.2:8000/groupunstar"),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'msgid': msgId,
            'user_id': userId,
          }));
  if (response.statusCode == 200) {
    status = true;
  }
}

Future deleteGroupMessage(int msgId, int channelId) async {
  String? token;
  int? userId;
  userId = await SharedPrefUtils.getInt("userid");
  token = await SharedPrefUtils.getStr("token");
  final request = await http.post(
      Uri.parse("http://10.0.2.2:8000/delete_groupmsg"),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': msgId,
        'user_id': userId,
        'channel_id': channelId
      }));

  if (request.statusCode == 200) {
    status = true;
  }
}

Future deleteChannel(int channelId) async {
  String? token;
  token = await SharedPrefUtils.getStr("token");
  await http.post(Uri.parse("http://10.0.2.2:8000/delete_channel"),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'s_channel_id': channelId}));
}

Widget showMessages(
    dynamic tGroupMessageDates,
    dynamic tGroupMessageDatesSizes,
    dynamic tGroupMessage,
    DateFormat formatter,
    DateFormat ymd,
    dynamic tGroupStarMsgids,
    dynamic channelData) {
  ScrollController groupMessageDateScroller = ScrollController();
  ScrollController groupMessageScroller = ScrollController();

  SchedulerBinding.instance.addPostFrameCallback((_) {
    groupMessageDateScroller.animateTo(
      groupMessageDateScroller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 60),
      curve: Curves.easeOut,
    );
  });

  return Scrollbar(
    child: ListView.builder(
      controller: groupMessageDateScroller,
      itemCount: tGroupMessageDates.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index1) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tGroupMessageDatesSizes
              .contains(tGroupMessageDates[index1]["created_date"]))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Text(
                    tGroupMessageDates[index1]["created_date"],
                    style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
                ListView.builder(
                  controller: groupMessageScroller,
                  shrinkWrap: true, // important
                  itemCount: tGroupMessage.length,
                  itemBuilder: (context, index) => Column(
                    children: <Widget>[
                      if (tGroupMessageDates[index1]["created_date"]
                              .toString() ==
                          ymd.format(DateTime.parse(
                              tGroupMessage[index]["created_at"].toString())))
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text("${index + 1}"),
                                Text(tGroupMessage[index]["name"]),
                                Text(formatter.format(DateTime.parse(
                                    tGroupMessage[index]["created_at"]))),
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Row(
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowGroupThread(
                                                          message:
                                                              tGroupMessage[
                                                                  index],
                                                          channelId:
                                                              channelData[
                                                                  "id"])),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.message,
                                            size: 15,
                                            color:
                                                Color.fromARGB(255, 63, 6, 197),
                                          ),
                                          label: Text(
                                            tGroupMessage[index]["count"]
                                                .toString(),
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 63, 6, 197)),
                                          )),
                                      if (tGroupStarMsgids
                                          .contains(tGroupMessage[index]["id"]))
                                        IconButton(
                                            onPressed: () async {
                                              await destroyStar(
                                                  tGroupMessage[index]["id"]);
                                              if (status == true) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ShowChannel(
                                                                channelData:
                                                                    channelData)),
                                                    (route) => false);
                                              }
                                            },
                                            icon: const Icon(Icons.star),
                                            color: const Color.fromARGB(
                                                255, 63, 6, 197))
                                      else
                                        IconButton(
                                            onPressed: () async {
                                              await createStar(
                                                  tGroupMessage[index]["id"]);
                                              if (status == true) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ShowChannel(
                                                                channelData:
                                                                    channelData)),
                                                    (route) => false);
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.star_outline),
                                            color: const Color.fromARGB(
                                                255, 63, 6, 197)),
                                      IconButton(
                                        onPressed: () async {
                                          await deleteGroupMessage(
                                              tGroupMessage[index]["id"],
                                              channelData["id"]);
                                          if (status == true) {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowChannel(
                                                            channelData:
                                                                channelData)),
                                                (route) => false);
                                          }
                                        },
                                        icon: const Icon(Icons.delete_outline),
                                        color: const Color.fromARGB(
                                            255, 63, 6, 197),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(60, 0, 20, 20),
                                  child: Icon(Icons.arrow_forward),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                    child: Text(
                                        tGroupMessage[index]["groupmsg"],
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                width: 370.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 206, 205, 205),
                                        width: 1.0),
                                  ),
                                )),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            )
          else
            const Text("Error"),
        ],
      ),
    ),
  );
}
