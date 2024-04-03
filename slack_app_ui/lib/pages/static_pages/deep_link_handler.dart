import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slack_app_ui/pages/m_users/confirm.dart';
import 'package:slack_app_ui/pages/static_pages/home.dart';
import 'package:slack_app_ui/pages/static_pages/welcome.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkHandler extends StatefulWidget {
  @override
  _DeepLinkHandlerState createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  String tokenValue = '';
  @override
  void initState() {
    print("Init");
    initDeepLink();
    set_token();
    super.initState();
  }

  void initDeepLink() async {
    print('djfldjfldf');
    print("URI");
    try {
      String? initialLink = await getInitialLink();
      setState(() {
        final uri = Uri.parse(initialLink!);
        handleDeepLink(uri);
      });
    } catch (e) {
      print('Platform exception occurred while getting initial link.');
    }
  }

  void set_token() async {
    final prefs = await SharedPreferences.getInstance();
    // final username = prefs.getString('username');
    setState(() {
      tokenValue = prefs.getString('token')!;
    });
  }

  void handleDeepLink(Uri uri) {
    // Extract information from the deep link
    String? route = uri.path;
    String? email = uri.queryParameters['email'];
    String? channel_name = uri.queryParameters['channel_name'];
    String? workspace_name = uri.queryParameters['workspace_name'];
    String? workspaceid = uri.queryParameters['workspaceid'];
    print("Member invitation route");
    print(route);
    print(email);
    print(channel_name);
    print(workspace_name);
    // Navigate to the corresponding screen based on the route
    if (route == '/member_invite') {
      print('hello hello');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MemberConfirm(
                email, channel_name, workspace_name, workspaceid)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tokenValue != "") {
      return Scaffold(
        body: MyHomePage(
          title: "Home",
        ),
        // debugShowCheckedModeBanner: false,
      );
    } else {
      return const Scaffold(
        body: Welcome(),
      );
    }
  }
}
