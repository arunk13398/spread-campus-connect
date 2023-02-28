import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniq/Screens/bottom_navigation.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:miniq/functions/functions.dart';

class UserRegistration extends StatefulWidget {
  String number;
   UserRegistration({Key? key,required this.number}) : super(key: key);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  // bool isChecked=false;
  TextEditingController name= TextEditingController();
  TextEditingController number= TextEditingController();
  TextEditingController college= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: name,
              inputFormatters: [
                // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
              ],
              // controller: value.contactPerson,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                hintText: 'Name',
                filled: true,
                fillColor: Colors.white,
              ),
              autofocus: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              enabled: false,
              controller: number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]'))
              ],
              // controller: value.contactPerson,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contact Number',
                hintText: 'Enter Contact Number',
                filled: true,
                fillColor: Colors.white,
              ),
              autofocus: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: college,
              inputFormatters: [
                // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
              ],
              // controller: value.contactPerson,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'College',
                hintText: 'College',
                filled: true,
                fillColor: Colors.white,
              ),
              autofocus: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:15.0,right: 15,top: 20,bottom: 20),
            child: Container(
              height: 50,
              child: MaterialButton(
                color: MyColors.theme3,
                minWidth: double.infinity,
                onPressed: () async {
                  await addCustomer().then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.white,
                      content: Text(
                        "Successful",
                        style: TextStyle(color: Colors.black),
                      ),
                    ));
                    finish(context);
                  });
                },
                child: const Text("Register",style: TextStyle(color: Colors.white,fontSize: 20)),
              ),
            ),
          ),
        ],
      )
    );
  }

  Future<void> addCustomer() async {


    HashMap<String, dynamic> data = HashMap<String, dynamic>();
    String id = widget.number;
    data["Id"] = id;
    data["Name"] = name.text;
    data["Phone"] = id;
    data["CreatedBy"] = widget.number;
    data["College"] =college.text;
    data["Date"] = DateTime.now().toString();
    data["AcessCode"] = '1';
    data["AcessName"] = 'UsersList';
    data["DateMillisecondsSinceEpoch"] =
        DateTime.now().millisecondsSinceEpoch.toString();

    HashMap<String, dynamic> access = HashMap<String, dynamic>();
    access["Name"] = name.text;
    access["Phone"] = id;
    access["AcessCode"] = '1';
    access["AcessName"] = 'Users';
    await mRootReference
        .child("UsersList")
        .child(id)
        .child("Profile")
        .update(data);
    await mRootReference.child("AccessControl").child(id).update(access);
    Future.delayed(const Duration(seconds: 1), () {
      finishAccountCreation( BottomNavigation(), context);
    });

  }
}
