import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:slack_app_ui/pages/allunread/show.dart';
import 'package:slack_app_ui/pages/direct_show/show.dart';
import 'package:slack_app_ui/pages/m_channels/channel_create.dart';
import 'package:slack_app_ui/pages/m_channels/show_channel.dart';
import 'package:slack_app_ui/pages/member_invitation/new.dart';
import "package:http/http.dart" as http;
import 'package:slack_app_ui/pages/mentionlists/show.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';
import 'package:slack_app_ui/pages/starlists/show.dart';
import 'package:slack_app_ui/pages/threadlists/show.dart';
import 'package:slack_app_ui/pages/user_manage/usermanage.dart';

class Leftpannel extends StatefulWidget {
  const Leftpannel({super.key});

  @override
  State<Leftpannel> createState() => _LeftpannelState();
}

class _LeftpannelState extends State<Leftpannel> {
  String userName = "";
  String workspaceName = "";
  String admin = "";
  dynamic mChannels = [];
  dynamic musers = [];
  dynamic muser = [];
  String? token = "";
  int? workspace_id;
  int? user_id;
  int all_unread_count = 0;
  dynamic direct_msgcounts = [];
  dynamic mChannelIds = [];
  dynamic mPublicChannels = [];

  Future<void> fetchData() async {
    token = await SharedPrefUtils.getStr("token");
    workspace_id = await SharedPrefUtils.getInt("workspaceid");
    user_id = await SharedPrefUtils.getInt("userid");
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
        userName = '${body["m_user"]['name']}';
        workspaceName = '${body["m_workspace"]["workspace_name"]}';
        admin = '${body['m_user']['admin']}';
        mChannels = body["m_channels"];
        musers = body['m_users'];
        muser = body['m_user'];
        all_unread_count = body['all_unread_count'];
        direct_msgcounts = body['direct_msgcounts'];
        mChannelIds = body["m_channelsids"];
        mPublicChannels = body["m_p_channels"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    return Drawer(
      child: Scrollbar(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        workspaceName,
                        // child: Text('CMM',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    Text(
                      userName,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ]),
            ),
            ListTile(
              leading: const Icon(Icons.menu),
              title: const Text('全未読',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              trailing: all_unread_count > 0
                  ? Text(
                      all_unread_count.toString(),
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    )
                  : const Text(""),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllUnread()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('スレッド', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Thread()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('スター', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StarLists()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.alternate_email),
              title: const Text('アクティピテイ', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MentionLists()),
                );
              },
            ),
            if (admin == 'true')
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('ユーザ管理', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserManage()),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text(
                'メンバーを招待する',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MemberInvite(userworkspace: workspaceName)),
                );
              },
            ),
            SizedBox(
              child: ListTile(
                leading: const Icon(Icons.add),
                title: const Text(
                  'チャンネル',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChannelCreate()),
                  );
                },
              ),
            ),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true, // important
                itemCount: mChannels.length,
                itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: ListTile(
                        trailing: Text(
                          mChannels[index]["message_count"] > 0
                              ? mChannels[index]["message_count"].toString()
                              : '',
                          style: TextStyle(fontSize: 20.0, color: Colors.red),
                        ),
                        leading: mChannels[index]["channel_status"]
                            ? const Icon(Icons.public, size: 15)
                            : const Icon(Icons.lock, size: 15),
                        title: Text(mChannels[index]["channel_name"],
                            style: const TextStyle(fontSize: 16)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowChannel(
                                        channelData: mChannels[index],
                                      )));
                        },
                        // dense: true,
                      ),
                    )),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true, // important
                itemCount: mPublicChannels.length,
                itemBuilder: (context, index) {
                  if (!mChannelIds.contains(mPublicChannels[index]["id"])) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: ListTile(
                        leading: const Icon(Icons.public, size: 15),
                        title: Text(mPublicChannels[index]["channel_name"],
                            style: const TextStyle(fontSize: 16)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowChannel(
                                    channelData: mPublicChannels[index])),
                          );
                        },
                        dense: true,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
            ListTile(
              title: const Text('ダイレクトメッセージ', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                title: Text('$userName (自分)',
                    style: const TextStyle(fontSize: 16, color: Colors.green)),
              ),
            ),
            Column(
              children: musers
                  // .where((user) => user['admin'] == false)
                  .map<Widget>((user) {
                count++;
                return Container(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      user["name"],
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      SharedPrefUtils.saveInt("s_user_id", user['id']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const directmsgshow()));
                    },
                    trailing: direct_msgcounts[count - 1] != 0
                        ? Text(direct_msgcounts[count - 1].toString(),
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold))
                        : const Text(""),
                    // Other ListTile properties if needed
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
