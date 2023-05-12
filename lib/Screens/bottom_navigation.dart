import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/FeedPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miniq/Screens/test_page.dart';
import '../Contraints/user_preference.dart';
import '../Theme/theme.dart';
import '../demo_test.dart';
import '../test.dart';
import 'AdminScreen/TestPagesAkshy/admi.dart';
import 'AdminScreen/admin_dashboard.dart';
import 'UserScreens/CmpltRegistration/complaint_list.dart';
import 'UserScreens/FriendsSuggestion/friends_list.dart';
import 'UserScreens/LoginScreen/user_registration.dart';
import 'UserScreens/NotificationScreen/notification_list.dart';
import 'UserScreens/ProfileScreen/dashboard_profile.dart';

class BottomNavigation extends StatefulWidget {

   BottomNavigation({Key? key,}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  // String number="";
  String numberId = '';
  String UserName = '';
  String UserName1 = '';
  String College = '';
  String Designation = '';
  String Phone = '';
  String UidLike = '';
  String UidName = '';
  String ProfimageUrl = '';
  String access="";


  int _currentIndex=0;
  List _screens1=[FeedPage(),NotificationList(), ComplaintList(),FriendsListPage(),ProfileDashboard(),];

  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  void initState() {
    getDataF1();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      backgroundColor: Colors.white,
      body: _screens1[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _updateIndex,
        selectedItemColor: MyColors.Colorgreen3,
        unselectedItemColor: Colors.grey[500],
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
            icon: Icon(Icons.post_add),
          ),
          BottomNavigationBarItem(
            label: "Friends",
            icon: Icon(Icons.fork_right),
          ),
          BottomNavigationBarItem(
            label: "My Account",
            icon: ProfimageUrl==''?
            CachedNetworkImage(
              imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
              placeholder: (context, url) =>  CircleAvatar(
                backgroundColor: Colors.blue.shade300,
                radius: 15,
              ),
              imageBuilder: (context, image) => CircleAvatar(
                backgroundImage: image,
                radius: 15,
              ),
            ):CachedNetworkImage(
              imageUrl: ProfimageUrl,
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

        ],
      ),
    );
  }
  getDataF1() async {
    access = (await getString(UserPreferences.ACCESS_CODE));
    numberId = (await getString(UserPreferences.USER_NUMBER));
    UserName = (await getString(UserPreferences.USER_Name));
    mRootReference
        .child("UsersList").child(await getString(UserPreferences.COLLEGE))
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(await getString(UserPreferences.DESIGNATION))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        College = data["College"];
        access = data["AcessCode"];
        Designation = data["Designation"];
        Phone =data['Phone'];
        ProfimageUrl=data['ImageUrl'];
        setState(() {});
      }
    });

  }

}
