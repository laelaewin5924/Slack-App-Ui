import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:slack_app_ui/pages/layouts/appbar.dart';
import 'package:slack_app_ui/pages/leftpannels/leftpannel.dart';
import 'package:slack_app_ui/pages/share_pref_utils.dart';

class StarLists extends StatefulWidget {
  const StarLists({super.key});

  @override
  State<StarLists> createState() => _StarListsState();
}

class _StarListsState extends State<StarLists> {
  dynamic t_direct_messages = [];
  dynamic t_direct_threads = [];
  dynamic t_group_messages = [];
  dynamic t_group_threads = [];
  String? token = "";
  int? user_id;

  @override
  void initState() {
    super.initState();
    _fetchStarLists();
  }

  Future<void> _fetchStarLists() async {
    token = await SharedPrefUtils.getStr("token");
    user_id = await SharedPrefUtils.getInt("userid");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/starlists?user_id=$user_id"),
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
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 25),
                Center(
                  child: Text(
                    'Star Lists',
                    style: TextStyle(
                      fontSize: 29,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'Direct Star Lists',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.star,
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
              'Direct Threads Star Lists',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.star,
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
              'Group Star Lists',
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
                            tGroup['name'],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            DateFormat('yyyy-MM-dd/ hh:mm a')
                                .format(DateTime.parse(tGroup['created_at'])),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.star,
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
                );
              },
              childCount: t_group_messages.length,
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
              'Group Thread Star Lists',
              style: TextStyle(
                fontSize: 26,
                color: Colors.indigo,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final tGroupThread = t_group_threads[index];
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
                            tGroupThread['name'],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            DateFormat('yyyy-MM-dd/ hh:mm a').format(
                                DateTime.parse(tGroupThread['created_at'])),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.star,
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
                );
              },
              childCount: t_group_threads.length,
            ),
          ),
        ],
      ),
      drawer: const Leftpannel(),
    );
  }
}
