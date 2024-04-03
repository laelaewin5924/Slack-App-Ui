import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slack_app_ui/pages/m_users/confirm.dart';
import 'package:slack_app_ui/pages/static_pages/deep_link_handler.dart';
import 'package:slack_app_ui/pages/static_pages/welcome.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Portal(
      child: MaterialApp(
    home: DeepLinkHandler(),
    debugShowCheckedModeBanner: false,
  )));
}