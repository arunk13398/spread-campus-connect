import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../Model/access_model.dart';
import '../../../Model/user_list_modal.dart';
import '../../../functions/functions.dart';

class AccessRequestPage extends StatefulWidget {
  const AccessRequestPage({Key? key}) : super(key: key);

  @override
  State<AccessRequestPage> createState() => _AccessRequestPageState();
}

String _academicDpValue = 'Club';
var _academicYear = ['User','Club', 'Reviewer','Publisher','Alumini','Admin',];

class _AccessRequestPageState extends State<AccessRequestPage> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<UserListModel> userlist = [];
  List<AccessModel> accesslist = [];
  @override
  void initState() {
    load();
    // TODO: implement initState
    super.initState();
  }

  load() async {
    mRootReference.child("PageRequest").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      print("ppopopopopo ${event.snapshot.value}");
      accesslist.clear();
      data.forEach((key, value) {
        accesslist.add(AccessModel(
          id: key,
           Name: value['Name'],
           Designation: value['Designation'],
           Phone: value['Phone'],
           College: value['College'],
           ImageUrl: value['ImageUrl'],
        ));
      });
      setState(() {});
    });
  }

  @override
  var size,height,width;
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  Scaffold (
      appBar: AppBar(
        title: Text("Access request"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ListView.builder(
            itemCount: accesslist.length,
            itemBuilder: (context, index) => AccessListview(index),),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {  },
      //   child: Icon(Icons.add),
      // ),
    );
  }
  Widget AccessListview(int index){
    return Column(
      children: [
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color:Colors.blue,
                      borderRadius: BorderRadius.circular(60)
                  ),child:Center(child: Text("AK",style:TextStyle(fontSize:20,color: Colors.white)))),
              SizedBox(width:5),
              SizedBox(
                width: width/4.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(accesslist[index].Name,style:TextStyle(fontSize:18,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                    Text(accesslist[index].Designation,style:TextStyle(fontSize:16,color: Colors.grey)),
                  ],
                ),
              ),
              SizedBox(width:5),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 0.3,
                    )
                ),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      // width: width/3.2,
                      child: DropdownButton(
                        value: _academicDpValue,
                        iconEnabledColor: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _academicYear.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0,right:10),
                              child: Text(items),
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            _academicDpValue = newValue!;
                            print("asdfghjkl ${_academicDpValue}");
                            print("asdfghjkl ${_academicYear}");
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width:5),
              Container(
                width:width/5,
                decoration: BoxDecoration(
                    color:Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10)
                ),
                child:Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("To :"+"Reviewer",style:TextStyle(fontSize:15,color: Colors.red,fontWeight: FontWeight.bold)),
                    )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 8,bottom: 0,top:10),
          child: Divider(height: 1,color: Colors.grey),
        ),
      ],
    );
  }
}
