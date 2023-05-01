import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Contraints/user_preference.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({Key? key,}) : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {

  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  String numberId='';
  String UserName='';
  String College='';
  String Designation='';
  String AccessCode='';
  String AccessName='';
  String CreatedBy='';
  String Date='';
  String TC='';
  String Phone='';



  @override
  void initState() {
    super.initState();
    getDataF1();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
              child: TextFormField(

                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'College',
                  hintText: 'College',
                  prefixIcon: Icon(Icons.location_on_outlined,
                      size: 20,
                      color: Colors.blue.shade300),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade300, width: 1.2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:  Colors.green, width: 1.2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
              child: Text(College,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
              child: Text(Designation,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
              child: Text(UserName,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
              child: Text(AccessCode,style: TextStyle(fontWeight: FontWeight.bold),),
            ),Padding(
              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
              child: Text(AccessName,style: TextStyle(fontWeight: FontWeight.bold),),
            ),Padding(
              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
              child: Text(CreatedBy,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
              child: Text(Date,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
            //   child: Text(TC,style: TextStyle(fontWeight: FontWeight.bold),),
            // ),
              Padding(
              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
              child: Text(Phone,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }

  getDataF1() async {
    numberId = (await getString(UserPreferences.USER_NUMBER));
    UserName = (await getString(UserPreferences.USER_Name));
    mRootReference
        .child("UsersList").child("GECWayanad")
        .child(await getString(UserPreferences.USER_NUMBER))
        .child("Teacher")
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        College = data["College"];
        Designation = data["Designation"];
        AccessCode = data["AcessCode"];
        AccessName = data["AcessName"];
        CreatedBy = data["CreatedBy"];
        Date = data["Date"];
        // TC = data["TC"];
        Phone = data["Phone"];
        setState(() {});
      }
    });



  }

}
