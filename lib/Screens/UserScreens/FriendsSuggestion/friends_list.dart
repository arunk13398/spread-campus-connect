import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/listdata_model.dart';
import '../../../Model/user_list_modal.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import 'friends_profile.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({Key? key}) : super(key: key);

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {

  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<UserListModel> userlist = [];
  List<ListDataModel> userlistdata = [];

  String imageUrl='';
  String College='';
  String Designation='';
  String UserType='';
  String Status='';
  String numberId='';

  @override
  void initState() {
    load();
    getDataAccess();
    loadItem();
    // TODO: implement initState
    super.initState();
  }

  load() async {
    mRootReference.child("AccessControl").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      userlist.clear();
      data.forEach((key, value) {
        userlist.add(UserListModel(
          id: key,
          userName: value['Name'],
          desigUser: value['Designation'],
          Phone: value['Phone'],
          College: value['College'],
          AccessName: value['AcessName'],
          imageUrl: value['imageUrl'],
          Status: value['Status']
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:15.0,top:15,bottom:20),
              child: Align(alignment: Alignment.topLeft,
                child: Text(
                  "Recommented For you",
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
                    padding: const EdgeInsets.only(left:10.0,right:10,top:5,bottom:5),
                    child: ListView.builder(
                      itemCount: userlist.length,
                      itemBuilder: (context, index) => FriendsList(index),),
                  ),
                )

            ),
          ],
        ),
      ),
    );
  }

  Widget FriendsList(int index){
    return Column(
      children: [
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  if(Status=="blocked"){
                    showAlertDialogBloked(context);
                  }else{
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FriendsProfile( userListModel: userlist[index])));

                  }
                  },
                child: Row(
                  children: [
                    userlist[index].imageUrl!=""?CachedNetworkImage(
                      imageUrl:  userlist[index].imageUrl,
                      placeholder: (context, url) => const CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 25,
                      ),
                      imageBuilder: (context, image) => CircleAvatar(
                        backgroundImage: image,
                        radius: 25,
                      ),
                    ):CachedNetworkImage(
                      imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                      placeholder: (context, url) => const CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 25,
                      ),
                      imageBuilder: (context, image) => CircleAvatar(
                        backgroundImage: image,
                        radius: 25,
                      ),
                    ),
                    SizedBox(width:15),
                    SizedBox(
                      width: width/2.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userlist[index].userName,style:TextStyle(fontSize:18,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                          Text(userlist[index].College,style:TextStyle(fontSize:12,color: Colors.blue.shade200)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),

              MaterialButton(
                onPressed: () async {
                  if(userlistdata.length==0){
                    HashMap<String, dynamic> data = HashMap<String, dynamic>();
                    String id= userlist[index].Phone;
                    data["Id"] = userlist[index].Phone;
                    mRootReference.child("UsersList").child(await getString(UserPreferences.COLLEGE))
                        .child(await getString(UserPreferences.USER_NUMBER)).child('Friends').child(id).update(data);

                  }else{
                    if(userlistdata[index].id==userlist[index].Phone){
                      HashMap<String, dynamic> data = HashMap<String, dynamic>();
                      String id= userlist[index].Phone;
                      data["Id"] = userlist[index].Phone;
                      mRootReference.child("UsersList").child(await getString(UserPreferences.COLLEGE))
                          .child(await getString(UserPreferences.USER_NUMBER)).child('Friends').child(id).remove();
                    }
                    else{
                      HashMap<String, dynamic> data = HashMap<String, dynamic>();
                      String id= userlist[index].Phone;
                      data["Id"] = userlist[index].Phone;
                      mRootReference.child("UsersList").child(await getString(UserPreferences.COLLEGE))
                          .child(await getString(UserPreferences.USER_NUMBER)).child('Friends').child(id).update(data);
                    }
                  }

                },
                color: MyColors.ColorGreen1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child:
                userlistdata.length==0?Text("Connect",style: TextStyle(color: Colors.black)):
                Text(userlistdata[index].id==userlist[index].Phone?"DisConnect !":"Connect",style: TextStyle(color: Colors.black),)
              ),

              SizedBox(width:10),
            ],
          ),
        ),
      ],
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
        numberId = data["Phone"];
        Status = data["Status"];
        setState(() {});
      }
    });
  }

  loadItem() async {
    mRootReference.child("UsersList").child(await getString(UserPreferences.COLLEGE))
        .child(await getString(UserPreferences.USER_NUMBER)).child('Friends').onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      userlistdata.clear();
      data.forEach((key, value) {
        userlistdata.add(ListDataModel(
          id: key,
        ));
      });
      setState(() {});
    });
  }


//       IconButton(
//       onPressed: () {
// if(isLiked==true){
// HashMap<String, dynamic> data = HashMap<String, dynamic>();
// String id= numberId;
// data["UserName"] = UserName;
// data["Id"] = numberId;
// mRootReference.child('Likes').child(id).remove();
// }else{
// HashMap<String, dynamic> data = HashMap<String, dynamic>();
// String id= numberId;
// data["UserName"] = UserName;
// data["LikeId"] = numberId;
// mRootReference.child('Likes').child(id).update(data);
//   }
// setState(() {
//   isLiked=!isLiked;
//    });
// },
//   icon: isLiked?Container(height: 20,
//       child: Icon(Icons.favorite)):
//   Container(height: 20,
//       child: Icon(Icons.favorite_border)),)

}
