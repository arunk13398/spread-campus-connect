import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Screens/UserScreens/CmpltRegistration/complaint_list.dart';
import 'Screens/UserScreens/FeedScreen/FeedPage.dart';
import 'Screens/UserScreens/NotificationScreen/notification_page.dart';
import 'Screens/UserScreens/ProfileScreen/dashboard_profile.dart';
import 'Screens/UserScreens/ProfileScreen/profile_page.dart';

class TestDemo extends StatefulWidget {
  const TestDemo({Key? key}) : super(key: key);

  @override
  State<TestDemo> createState() => _TestDemoState();
}

class _TestDemoState extends State<TestDemo> {

  var top=0.0;
  late ScrollController _scrollController;

  @override void initState() {
    super.initState();
    _scrollController =  ScrollController();
    _scrollController.addListener(() {
      setState(() {

      });
    });
  }
var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Center(child: Text("Testing"))
    );
  }

}


