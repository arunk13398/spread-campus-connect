import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/access_model.dart';
import '../../../Model/listdata_model.dart';
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

  String ImageUrl='';
  List<ListDataModel> datalist=[];
  ListDataModel?selectedItem;
  @override
  void initState() {
    load();
    getDataF1();
    loadNotification();
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
          RequestTo: value['RequestTo']
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:10.0,top:15,bottom:20),
              child: Align(alignment: Alignment.topLeft,
                child: Text(
                  "Access Request List",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
            ),
            Expanded(
                child: Container(
                  // height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child:ListView.builder(
                      itemCount: accesslist.length,
                      itemBuilder: (context, index) => AccessListview(index),),
                  ),
                ),
                // accesslist.length==0?Center(
                //   child: Container(child:Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset("assets/wrong.jpg",height:height/3,),
                //       Text("- No Request yet -")
                //     ],
                //   )),
                // ):Container(
                //   // height: 120,
                //   child: Padding(
                //     padding: const EdgeInsets.all(3.0),
                //     child:ListView.builder(
                //       itemCount: accesslist.length,
                //       itemBuilder: (context, index) => AccessListview(index),),
                //   ),
                // ),

            ),
          ],
        ),
      ),

    );
  }

  loadNotification() {
    mRootReference.child("AccessManagement").child("AccessList").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      datalist.clear();
      data.forEach((key, value) {
        datalist.add(ListDataModel(
          id: key,
        ));
      });
      setState(() {});
    });
  }


  Widget AccessListview(int index){
    return Column(
      children: [
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              accesslist[index].ImageUrl!=""?CachedNetworkImage(
                imageUrl: accesslist[index].ImageUrl,
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 20,
                ),
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundImage: image,
                  radius: 20,
                ),
              ):CachedNetworkImage(
                imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 20,
                ),
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundImage: image,
                  radius: 20,
                ),
              ),
              SizedBox(width:5),
              SizedBox(
                width: width/5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(accesslist[index].Name,style:TextStyle(fontSize:16,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                    Text(accesslist[index].Designation,style:TextStyle(fontSize:16,color: Colors.grey)),
                  ],
                ),
              ),
              SizedBox(width:5),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox( width: 50,child: Text("Reqstd : ",maxLines: 1,overflow: TextOverflow.ellipsis,)),
                      SizedBox( width: 95,child: Text(accesslist[index].RequestTo,style:TextStyle(fontSize:16,color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Container(
                    height: 30,
                    width:150,
                    decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 0.1,
                            )
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: const EdgeInsets.only(left:20.0,right:20),
                        child: DropdownButton<ListDataModel>(
                          value : selectedItem,
                          iconEnabledColor: Colors.black,
                          borderRadius: BorderRadius.circular(30),
                          icon: const Icon(Icons.swap_vert),
                          onChanged:(ListDataModel? newValue){
                            setState((){
                              selectedItem = newValue;
                            });
                          },
                          items: datalist.map<DropdownMenuItem<ListDataModel>>((ListDataModel value){
                            return DropdownMenuItem<ListDataModel>(
                                value: value,
                                child:Padding(
                                  padding: const EdgeInsets.only(left:10.0,right:10),
                                  child: Text(value.id),
                                )
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),


                ],
              ),
              Spacer(),
              // SizedBox(width:5),
              MaterialButton(
                  minWidth:10,
                  height:35,
                  onPressed: () async {
                    await  PageRequest(index).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.greenAccent,
                        content: Center(
                          child: Text(
                            "Successful",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ));
                      // newListController.clear();
                      // description.clear();

                    });
                  },
                  textColor: Colors.white,
                  color: Colors.red.shade100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child:Center(
                      child: Center(child: Text("Change To",style:TextStyle(fontSize:15,color: Colors.red,fontWeight: FontWeight.bold)))),),

              SizedBox(width:5),
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

  getDataF1() async {
    mRootReference
        .child("UsersList").child(await getString(UserPreferences.COLLEGE))
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(await getString(UserPreferences.DESIGNATION))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        setState(() {});
      }
    });
  }

  Future<void> PageRequest(int index) async {
    HashMap<String, dynamic> updateData = HashMap<String, dynamic>();
    updateData["AcessName"] = selectedItem!.id;
    await mRootReference.child("AccessControl").child(accesslist[index].Phone).update(updateData);
    await mRootReference.child("PageRequest").child(accesslist[index].Phone).remove();
    accesslist.removeAt(index);
    load();
  }
}
