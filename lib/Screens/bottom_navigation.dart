import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/FeedPage.dart';
import 'package:miniq/Screens/UserScreens/NotificationScreen/notification_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../test.dart';
import 'UserScreens/CmpltRegistration/complaint_list.dart';
import 'UserScreens/ProfileScreen/dashboard_profile.dart';

class BottomNavigation extends StatefulWidget {

   BottomNavigation({Key? key,}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  // String number="";



  int _currentIndex=0;
  List _screens=[
    FeedPage(),
    NotificationPage(),
    ComplaintList(),
    ProfileDashboard(),
    TestDemo()];

  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _updateIndex,
        selectedItemColor: Colors.blue[700],
        selectedFontSize: 13,
        unselectedFontSize: 13,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Notification",
            icon: Icon(Icons.notifications_none),
          ),
          BottomNavigationBarItem(
            label: "registration",
            icon: Icon(Icons.app_registration),
          ),
          BottomNavigationBarItem(
            label: "My Account",
            icon: CachedNetworkImage(
              imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
              placeholder: (context, url) =>  CircleAvatar(
                backgroundColor: Colors.blue.shade300,
                radius: 15,
              ),
              imageBuilder: (context, image) => CircleAvatar(
                backgroundImage: image,
                radius: 15,
              ),
            ),
          ),
          // BottomNavigationBarItem(
          //   label: "testing",
          //   icon: Icon(Icons.bug_report_outlined),
          // ),
        ],
      ),
    );
  }


}
