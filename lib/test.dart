import 'dart:collection';

import 'package:chip_list/chip_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniq/Screens/bottom_navigation.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:miniq/functions/functions.dart';

class TestDemo extends StatefulWidget {
  TestDemo({Key? key,}) : super(key: key);

  @override
  State<TestDemo> createState() => _TestDemoState();
}

class _TestDemoState extends State<TestDemo> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();


  String nameTest ='';
  String id = '+919099999998';
  String id1 = 'GECIdukki';
  String id2 = 'Alumni';
  TextEditingController Test= TextEditingController();

@override
  void initState() {
     getDataF1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:SafeArea(
            child:
            Column(
              children: [
               Container(
                 height:200,
                 color:Colors.red,
                 width: 100,
               )
              ],
            )
        )
    );
  }




  getDataF1() async {
    mRootReference
        .child("Test")
        .child(id1)
        .child(id)
        .child(id2)
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("Testingsahagjvcha ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        nameTest = data["Name"];
        setState(() {});
      }
    });
  }

  Future<void> addCustomerqqq() async {

    HashMap<String, dynamic> data = HashMap<String, dynamic>();

    data["Id"] = id;
    data["Name"] = Test.text;
    data["designation"] = id2;



    // HashMap<String, dynamic> access = HashMap<String, dynamic>();
    // access["Name"] = name.text;
    // access["Phone"] = id;
    // access["AcessCode"] = '1';
    // access["AcessName"] = 'Users';
    // access["College"] =_collegeDpValue;
    // access["Designation"] =_designationDpValue;
    //

    await mRootReference.child("Test").child(id1).child(id).child(id2).update(data);

    // await mRootReference.child("AccessControl").child(id).update(access);
    Future.delayed(const Duration(seconds: 1), () {
      finishAccountCreation( BottomNavigation(), context);
    });

  }
}
