import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:slack_app_ui/pages/layouts/appbar.dart';
import 'package:slack_app_ui/pages/leftpannels/leftpannel.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';

class MentionLists extends StatefulWidget {
  const MentionLists({super.key});

  @override
  State<MentionLists> createState() => _MentionListsState();
}

class _MentionListsState extends State<MentionLists> {
  dynamic t_group_messages = [];
  dynamic t_group_threads = [];
  dynamic t_group_star_msgids = [];
  dynamic t_group_star_thread_msgids = [];
  String? token = "";
  int? user_id;

  @override
  void initState() {
    super.initState();
    _fetchThread();
  }

  Future<void> _fetchThread() async {
    token = await SharedPrefUtils.getStr("token");
    user_id = await SharedPrefUtils.getInt("userid");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/mentionlists?user_id=$user_id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          final data = jsonDecode(response.body);
          t_group_messages = data['t_group_messages'];
          t_group_threads = data['t_group_threads'];
          t_group_star_msgids = data['t_group_star_msgids'];
          t_group_star_thread_msgids = data['t_group_star_thread_msgids'];
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Mention Lists',
                style: TextStyle(
                  fontSize: 29,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Group Mention Lists',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable ListView scrolling
                    itemCount: t_group_messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tGroup = t_group_messages[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tGroup['channel_name'],
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.indigo,
                                ),
                              ),
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
                                    tGroup['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 60.0),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
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
                                            width: 290,
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
                                  Column(
                                    children: [
                                      if (t_group_star_msgids
                                          .contains(tGroup['id']))
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.star,
                                            size: 25,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      if (!t_group_star_msgids
                                          .contains(tGroup['id']))
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.star_border_outlined,
                                            size: 25,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                  // ----------GROUP THREAD MENTION LISTS-----------
                  const Text(
                    'Group Thread Mention Lists',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable ListView scrolling
                    itemCount: t_group_threads.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tGroupThread = t_group_threads[index];
                      int count = 1;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tGroupThread['channel_name'],
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.indigo,
                                ),
                              ),
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
                                    tGroupThread['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 60.0),
                                  Text(
                                    DateFormat('yyyy-MM-dd/ hh:mm a').format(
                                        DateTime.parse(
                                            tGroupThread['created_at'])),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
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
                                              tGroupThread['groupthreadmsg'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      if (t_group_star_thread_msgids
                                          .contains(tGroupThread['id']))
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.star,
                                            size: 25,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      if (!t_group_star_thread_msgids
                                          .contains(tGroupThread['id']))
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.star_border_outlined,
                                            size: 25,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const Leftpannel(),
    );
  }
}
