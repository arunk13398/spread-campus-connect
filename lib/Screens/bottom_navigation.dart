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
  String imageUrl="";
  String UserType="";


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
    getDataAccess();
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
        unselectedItemColor: Colors.grey[400],
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
            CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              radius: 15,
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ):CachedNetworkImage(
              imageUrl: ProfimageUrl,
              placeholder: (context, url) =>  CircleAvatar(
                backgroundColor: Colors.blue.shade300,
                radius: 15,
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: Colors.blue.shade300,
                radius: 15,
                child: const Icon(Icons.person, size: 18, color: Colors.white),
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

  getDataAccess() async {
    College = (await getString(UserPreferences.COLLEGE));
    Designation = (await getString(UserPreferences.DESIGNATION));
    mRootReference
        .child("AccessControl")
        .child(await getString(UserPreferences.USER_NUMBER))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("fffffff ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        College = data["College"];
        Designation = data["Designation"];
        UserType = data["AcessName"];
        numberId =data["Phone"];
        setState(() {});
      }
    });
  }

  getDataF1() async {
    access = (await getString(UserPreferences.ACCESS_CODE)) ?? '';
    numberId = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    UserName = (await getString(UserPreferences.USER_Name)) ?? '';
    final college = await getString(UserPreferences.COLLEGE);
    final designation = await getString(UserPreferences.DESIGNATION);
    if (college == null || numberId.isEmpty || designation == null) return;
    mRootReference
        .child("UsersList")
        .child(college)
        .child(numberId)
        .child(designation)
        .onValue
        .listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;
        College = (data["College"] ?? '').toString();
        access = (data["AcessCode"] ?? '').toString();
        Designation = (data["Designation"] ?? '').toString();
        Phone = (data['Phone'] ?? '').toString();
        ProfimageUrl = (data['ImageUrl'] ?? '').toString();
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

}
