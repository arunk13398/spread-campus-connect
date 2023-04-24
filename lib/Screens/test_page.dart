import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:floating_frosted_bottom_bar/floating_frosted_bottom_bar.dart';
import 'package:miniq/Screens/UserScreens/CmpltRegistration/complaint_registration.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/FeedPage.dart';
import 'package:miniq/Screens/UserScreens/NotificationScreen/notification_list.dart';
import 'package:miniq/Screens/UserScreens/ProfileScreen/profile_page.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:miniq/functions/camera.dart';

import '../demo_test.dart';
import '../test.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;

  final List<Color> colors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,

  ];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 5, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FrostedBottomBar(
        opacity: 0.6,
        sigmaX: 5,
        sigmaY: 5,
        child: TabBar(
          indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          controller: tabController,
          indicator:  UnderlineTabIndicator(
            borderSide: BorderSide( color: Colors.grey, width: 4),
            insets: EdgeInsets.fromLTRB(16, 0, 16, 8),
          ),
          tabs: [
            TabsIcon(
                icons: Icons.home,
                color: currentPage == 0 ? colors[0] : Colors.white),
            TabsIcon(
                icons: Icons.notifications_none,
                color: currentPage == 1 ? colors[1] : Colors.white),
            TabsIcon(
                icons: Icons.camera_alt_outlined,
                color: currentPage == 2 ? colors[2] : Colors.white),
            TabsIcon(
                icons: Icons.add_box_outlined,
                color: currentPage == 3 ? colors[3] : Colors.white),
            TabsIcon(
                icons: Icons.menu,
                color: currentPage == 4 ? colors[4] : Colors.white),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        duration: const Duration(milliseconds: 800),
        hideOnScroll: true,
        body: (context, controller) => TabBarView(
          controller: tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: [
            // TestPageDemo(),
            DemoTest(),
            // TestDemo(),
            // ComplaintRegistration(),
            // ProfilePage(),
          ],
        ),
      ),
    );
  }
}

class TabsIcon extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final IconData icons;

  const TabsIcon(
      {Key? key,
      this.color = Colors.white,
      this.height = 60,
      this.width = 50,
      required this.icons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: Icon(
          icons,
          color: color,
        ),
      ),
    );
  }
}
