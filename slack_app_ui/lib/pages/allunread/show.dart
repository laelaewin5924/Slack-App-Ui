import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:slack_app_ui/pages/layouts/appbar.dart';
import 'package:slack_app_ui/pages/leftpannels/leftpannel.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';

class AllUnread extends StatefulWidget {
  const AllUnread({super.key});
  @override
  State<AllUnread> createState() => _AllUnreadState();
}

class _AllUnreadState extends State<AllUnread> {
  dynamic t_direct_messages = [];
  dynamic t_direct_threads = [];
  dynamic t_user_channelids = [];
  dynamic t_group_messages = [];
  String? token = "";
  int? user_id;
  int number = 1;

  @override
  void initState() {
    super.initState();
    _fetchDirectUnreadMsg();
  }

  Future<void> _fetchDirectUnreadMsg() async {
    token = await SharedPrefUtils.getStr("token");
    user_id = await SharedPrefUtils.getInt("userid");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/allunread?user_id=$user_id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          final data = jsonDecode(response.body);
          t_direct_messages = data['t_direct_messages'];
          t_direct_threads = data['t_direct_threads'];
          t_user_channelids = data['t_user_channelids'];
          t_group_messages = data['t_group_messages'];
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 25),
                Center(
                  child: Text(
                    'All Unread Lists',
                    style: TextStyle(
                      fontSize: 29,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'Direct Unread Messages',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final tDirect = t_direct_messages[index];
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  color: const Color.fromARGB(226, 233, 238, 239),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tDirect['name'],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 60.0),
                          Text(
                            DateFormat('yyyy-MM-dd/ hh:mm a')
                                .format(DateTime.parse(tDirect['created_at'])),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const SizedBox(width: 25),
                          const Text(
                            '--> ',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 280,
                            child: Text(
                              tDirect['directmsg'],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: t_direct_messages.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(thickness: 1, color: Colors.grey),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 25),
          ),
          const SliverToBoxAdapter(
            child: Text(
              'Direct Unread Threads',
              style: TextStyle(
                fontSize: 26,
                color: Colors.indigo,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final tThread = t_direct_threads[index];
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  color: const Color.fromARGB(226, 233, 238, 239),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tThread['name'],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            DateFormat('yyyy-MM-dd/ hh:mm a')
                                .format(DateTime.parse(tThread['created_at'])),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const SizedBox(width: 25),
                          const Text(
                            '--> ',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 280,
                            child: Text(
                              tThread['directthreadmsg'],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: t_direct_threads.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(thickness: 1, color: Colors.grey),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 25),
          ),
          const SliverToBoxAdapter(
            child: Text(
              'Group Unread Messages',
              style: TextStyle(
                fontSize: 26,
                color: Colors.indigo,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final tGroup = t_group_messages[index];
                for (var tUserChannelId in t_user_channelids) {
                  if (int.parse(tUserChannelId) == tGroup["id"]) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      color: const Color.fromARGB(226, 233, 238, 239),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${number++}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tGroup['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                DateFormat('yyyy-MM-dd/ hh:mm a').format(
                                    DateTime.parse(tGroup['created_at'])),
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              const SizedBox(width: 25),
                              const Text(
                                '--> ',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: 280,
                                child: Text(
                                  tGroup['groupmsg'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Container();
              },
              childCount: t_group_messages.length,
            ),
          ),
        ],
      ),
      drawer: const Leftpannel(),
    );
  }
}
