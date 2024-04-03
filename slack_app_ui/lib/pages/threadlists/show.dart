import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:slack_app_ui/pages/layouts/appbar.dart';
import 'package:slack_app_ui/pages/leftpannels/leftpannel.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';

class Thread extends StatefulWidget {
  const Thread({super.key});

  @override
  State<Thread> createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  dynamic t_direct_messages = [];
  dynamic t_direct_threads = [];
  dynamic t_group_messages = [];
  dynamic t_group_threads = [];
  dynamic t_direct_star_msgids = [];
  dynamic t_direct_star_thread_msgids = [];
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
        Uri.parse("http://10.0.2.2:8000/thread?user_id=$user_id"),
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
          t_group_messages = data['t_group_messages'];
          t_group_threads = data['t_group_threads'];
          t_direct_star_msgids = data['t_direct_star_msgids'];
          t_direct_star_thread_msgids = data['t_direct_star_thread_msgids'];
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
                'Thread Lists',
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
                    'Direct Thread Lists',
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
                    itemCount: t_direct_messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      int count = 1;
                      final tDirect = t_direct_messages[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tDirect['name'],
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
                                    tDirect['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 60.0),
                                  Text(
                                    DateFormat('yyyy-MM-dd/ hh:mm a').format(
                                        DateTime.parse(tDirect['created_at'])),
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
                                            width: 270,
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
                                  Column(
                                    children: [
                                      if (t_direct_star_msgids
                                          .contains(tDirect['id']))
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.star,
                                            size: 25,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      if (!t_direct_star_msgids
                                          .contains(tDirect['id']))
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
                          const Text(
                            'Reply',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.indigo,
                            ),
                          ),
                          Column(
                            children: List.generate(t_direct_threads.length,
                                (indexThread) {
                              final tThread = t_direct_threads[indexThread];
                              if (tDirect['id'] ==
                                  tThread['t_direct_message_id']) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${count++}',
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
                                              .format(DateTime.parse(
                                                  tThread['created_at'])),
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
                                                  width: 270,
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
                                        Column(
                                          children: [
                                            if (t_direct_star_thread_msgids
                                                .contains(tThread['id']))
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.star,
                                                  size: 25,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                            if (!t_direct_star_thread_msgids
                                                .contains(tThread['id']))
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
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox
                                    .shrink(); // or any other widget as per your requirement
                              }
                            }),
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
                  // ----------group lists-----------
                  const Text(
                    'Group Thread Lists',
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
                      int count = 1;
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
                              const SizedBox(height: 10),
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
                          const Text(
                            'Reply',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children:
                                List.generate(t_group_threads.length, (index) {
                              final tGroupThread = t_group_threads[index];
                              if (tGroup['id'] ==
                                  tGroupThread['t_group_message_id']) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${count++}',
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
                                        const SizedBox(width: 8.0),
                                        Text(
                                          DateFormat('yyyy-MM-dd/ hh:mm a')
                                              .format(DateTime.parse(
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
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: 25),
                                                const Text(
                                                  '--> ',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Container(
                                                  width: 270,
                                                  child: Text(
                                                    tGroupThread[
                                                        'groupthreadmsg'],
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
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox
                                    .shrink(); // or any other widget as per your requirement
                              }
                            }),
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
