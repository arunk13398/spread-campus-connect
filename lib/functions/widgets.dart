import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Contraints/user_preference.dart';

Shimmer getShimmerLoading(){
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade500,
    // enabled: _enabled,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top:10.0,left:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Container(
                      //   width: double.infinity,
                      //   height: 8.0,
                      //   color: Colors.white,
                      // ),

                      Container(
                        width: 150,
                        height: 12.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 60.0,
                        height: 12.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height:10),
          Container(
            width: double.infinity,
            height: 12.0,
            color: Colors.white,
          ),
          SizedBox(height:10),
          Container(
            width: double.infinity,
            height: 230.0,
            color: Colors.white,
          ),
          SizedBox(height: 5,),
          Container(
            width: double.infinity,
            height: 30.0,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}


void checkRealtimeConnection(my_result,ConnectivityResult) {
  Connectivity().onConnectivityChanged.listen((my_result) {
    if (my_result == ConnectivityResult.mobile ||
        my_result == ConnectivityResult.wifi) {
      // print("connected");
      // setState(() {
      //   isConnected = true;
      // });
    } else if (my_result == ConnectivityResult.none) {
      print("not connected");
      // setState(() {
      //   isConnected = false;
      // });
    }
  });
}


initAuth(String Uid,user) async {
  late FirebaseAuth _auth;
  late Stream<User?> _authStateChanges;

  await Future.delayed(const Duration(seconds: 2));
  _auth = FirebaseAuth.instance;
  _authStateChanges = _auth.authStateChanges();
  _authStateChanges.listen((User? user) {

    // setState(() {
    //   Uid = user?.uid??"";
    // });
    // print("...user id ${user?.uid}....");
  });
}



getDataF1() async {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();

  var numberId = (await getString(UserPreferences.USER_NUMBER));
  var UserName = (await getString(UserPreferences.USER_Name));
  // College = (await getString(UserPreferences.COLLEGE));

  mRootReference
      .child("AccessControl")
      .child(await getString(UserPreferences.USER_NUMBER))
      .once()
      .then((value) {
    if (value.snapshot.exists) {
      print("efgh ${value.snapshot.value}");
      Map<dynamic, dynamic> data = value.snapshot.value as Map;
      var College = data["College"];
      var  Designation = data["Designation"];
      // setState(() {});
    }
  });
}
