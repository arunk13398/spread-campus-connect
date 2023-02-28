import 'dart:collection';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Screens/UserScreens/CmpltRegistration/complaint_registration.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/FeedPage.dart';
import 'package:miniq/Screens/UserScreens/NotificationScreen/notification_page.dart';
import 'package:miniq/Screens/UserScreens/ProfileScreen/profile_page.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miniq/functions/camera.dart';

class BottomNavigation extends StatefulWidget {

   BottomNavigation({Key? key,}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  // String number="";



  @override
  Widget build(BuildContext context) {
    return CurvedNavBar(
      actionButton: CurvedActionBar(
        onTab: (value) async {
          // HashMap<String, dynamic> data = HashMap<String, dynamic>();
          // String id = number;
          // print(data);
          // data["id"]=number;
          // await mRootReference
          //     .child("UsersList").child(id).child("Profile").update(data);
        },
        activeIcon: Container(

          padding: EdgeInsets.all(8),
          decoration:
          BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(
            Icons.camera_alt,
            size: 40,
            color: MyColors.theme1,
          ),
        ),
        inActiveIcon: Container(
          padding: EdgeInsets.all(8),
          decoration:
          BoxDecoration(
              color: MyColors.theme1,
              shape: BoxShape.circle),
          child: Icon(
            Icons.camera_alt_outlined,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      activeColor: MyColors.theme1,
      navBarBackgroundColor: Colors.white,
      inActiveColor: Colors.black45,
      appBarItems: [
        FABBottomAppBarItem(
            activeIcon: Icon(
              Icons.home,
              size: 28,
              color: MyColors.theme1,
            ),
            inActiveIcon: Icon(
              Icons.home,
              size: 28,
              color: MyColors.theme1,
            ),text: ''
        ),
        FABBottomAppBarItem(
            activeIcon: Icon(
              Icons.notifications_none,
              color: MyColors.theme1,
              size: 28,
            ),
            inActiveIcon: Icon(
              Icons.notifications_none,
              color: MyColors.theme1,
              size: 28,
            ),
            text: ''
        ),
        FABBottomAppBarItem(
            activeIcon: Icon(
              Icons.bookmark_outline_outlined,
              color: MyColors.theme1,
              size: 28,
            ),
            inActiveIcon: Icon(
              Icons.bookmark_outline_outlined,
              color: MyColors.theme1,
              size: 28,
            ),
            text: ''),
        FABBottomAppBarItem(
            activeIcon: CachedNetworkImage(
              imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
              placeholder: (context, url) => const CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 15,
              ),
              imageBuilder: (context, image) => CircleAvatar(
                backgroundImage: image,
                radius: 15,
              ),
            ),
            inActiveIcon: CachedNetworkImage(
              imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
              placeholder: (context, url) => const CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 15,
              ),
              imageBuilder: (context, image) => CircleAvatar(
                backgroundImage: image,
                radius: 15,
              ),
            ),text: ''
        ),
      ],
      bodyItems: [
        FeedPage(),
        NotificationPage(),
        ComplaintRegistration(),
        ProfilePage(),
      ],
      actionBarView: Camera(),
    );
  }


}
