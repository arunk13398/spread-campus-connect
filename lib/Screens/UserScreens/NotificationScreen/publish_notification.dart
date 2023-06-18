import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../../Contraints/user_preference.dart';
import '../../../Model/CategoryListDataModel.dart';
import '../../../Model/listdata_model.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import '../../bottom_navigation.dart';
import 'notification_list.dart';

class PublishNotification extends StatefulWidget {
  const PublishNotification({Key? key}) : super(key: key);

  @override
  State<PublishNotification> createState() => _PublishNotificationState();
}

class _PublishNotificationState extends State<PublishNotification> {
  @override
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ListDataModel> datalist=[];
  List<CategoryListDataModel> Categorydatalist=[];
  ListDataModel?selectedItem;
  CategoryListDataModel?CategoryselectedItems;



  String numberId = '';
  String UserName = '';
  // String UserName1 = '';
  String College = '';
  String Designation = '';
  String imageUrl = '';



  TextEditingController _content = TextEditingController();
  TextEditingController _subject = TextEditingController();


  void initState(){

    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
      if(!isAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    getDataD1();
    loadItem();
    loadItem1();
    super.initState();
  }

  triggerNotification(){
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
          body: _content.text,
            title: _subject.text
        ));
  }

  loadItem() async {
    mRootReference.child("AccessManagement").child("Colleges").onValue.listen((event) {
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
  loadItem1() async {
    mRootReference.child("AccessManagement").child("Designation").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      Categorydatalist.clear();
      data.forEach((key, value) {
        Categorydatalist.add(CategoryListDataModel(
          id: key,
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
    return  Scaffold(
        body:SafeArea(
          child:
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Notification pubish form",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     // controller: _userName,
                //      enabled: false,
                //     // initialValue: UserName,
                //     controller: widget.UserName,
                //     style: TextStyle(color: Colors.black),
                //     decoration: InputDecoration(
                //       border: const OutlineInputBorder(),
                //       labelText: 'Publisher name',
                //       labelStyle: TextStyle(color: Colors.black),
                //       hintStyle: TextStyle(color: Colors.blue),
                //       hintText: 'Publisher name',
                //       filled: true,
                //       fillColor: Colors.white,
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
                //         borderSide: BorderSide(
                //             color: MyColors.LightBlackcolor, width: 1.2),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
                //         borderSide: BorderSide(
                //             color: MyColors.LightBlackcolor, width: 1.6),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,),
                  child: Align(alignment: Alignment.topLeft,
                      child: Text("User name",
                          style:TextStyle(color:MyColors.Colorgreen3))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.only(left:10,top:15),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.shade300
                      )
                    ),
                    child:Text(UserName,style:TextStyle()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,),
                  child: Align(alignment: Alignment.topLeft,
                      child: Text("Designation",style:TextStyle(color:MyColors.Colorgreen3))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.only(left:10,top:15),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300
                        )
                    ),
                    child:Text(Designation,style:TextStyle()),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Align(alignment:Alignment.topLeft, child: Text("To",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,))),
                ),


                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: width/1.1,
                    height: 40,
                    decoration:BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.black38,
                            width: 1
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
                              // loadNotification();
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
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width:width/1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width:5,),
                        SizedBox(
                            width:width/3,
                            child: Text("Select category to publish ",style: TextStyle(color: Colors.black,fontSize: 16,))),
                        Spacer(),
                        Container(
                          width: 200,
                          height: 40,
                          decoration:BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1
                              )
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0,right:20),
                              child: DropdownButton<CategoryListDataModel>(
                                value : CategoryselectedItems,
                                iconEnabledColor: Colors.black,
                                borderRadius: BorderRadius.circular(30),
                                icon: const Icon(Icons.swap_vert),
                                onChanged:(CategoryListDataModel? newValue){
                                  setState((){
                                    CategoryselectedItems = newValue;
                                    // loadNotification();
                                  });

                                },
                                items: Categorydatalist.map<DropdownMenuItem<CategoryListDataModel>>((CategoryListDataModel value){
                                  return DropdownMenuItem<CategoryListDataModel>(
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
                        SizedBox(width: 5,),
                      ],
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _subject,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Subject',
                      hintText: 'Subject',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color:MyColors.Colorgreen3),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Notification content",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:MyColors.Colorgreen3),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    child: TextFormField(
                      controller: _content,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Notification Content',
                        hintText: 'Notification Content',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color:MyColors.Colorgreen3),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.6),
                        ),
                      ),
                      maxLines: 100,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(
                        // onPressed:
                        // //triggerNotification,
                        //     () {
                        //       print("asdfghjkl ${numberId}");
                        //       print("asdfghjkl ${UserName}");
                        //       print("asdfghjkl ${College}");
                        //       // print("asdfghjkl ${UserName1}");
                        //       print("asdfghjkl ${Designation}");
                        // },
                        onPressed: () async {
                          await PublishNotification().then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: Colors.grey,
                              content: Text(
                                "Successful",
                                style: TextStyle(color: Colors.black),
                              ),
                            ));
                            triggerNotification();
                            // description.clear();
                            // finish(context);
                          });
                        },

                        textColor: Colors.white,
                        color:MyColors.Colorgreen3,
                        minWidth: double.infinity,
                        height: 60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(
                              fontSize: 18, color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }


  getDataD1() async {
    numberId = (await getString(UserPreferences.USER_NUMBER));
    UserName = (await getString(UserPreferences.USER_Name));
    College = (await getString(UserPreferences.COLLEGE));
    mRootReference
        .child("UsersList").child(await getString(UserPreferences.COLLEGE))
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(await getString(UserPreferences.DESIGNATION))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("efgh ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        College = data["College"];
        Designation = data["Designation"];
        UserName = data["Name"];
        imageUrl=data['ImageUrl'];
        setState(() {});
      }
    });
  }


  Future<void> PublishNotification() async {
    String id1 = DateTime.now().millisecondsSinceEpoch.toString();
    HashMap<String, dynamic> data = HashMap<String, dynamic>();

    data["Id"] =  DateTime.now().toString();
    data["Name"] = UserName;
    data["designation"] = Designation;
    data["College"] = College;
    data["Subject"] = _subject.text;
    data["NotificationContent"] = _content.text;
    data["UserProfileImage"]=imageUrl;
    await mRootReference.child("Notification").child(selectedItem!.id).child(CategoryselectedItems!.id).child(id1).update(data);
    Future.delayed(const Duration(seconds: 1), () {
      finishAccountCreation( NotificationList(), context);
    });
  }
}
