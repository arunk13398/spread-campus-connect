import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Model/user_list_modal.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({Key? key}) : super(key: key);

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {

  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<UserListModel> userlist = [];
  String imageUrl='';
  @override
  void initState() {
    load();
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
              imageUrl!=""?CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 22,
                ),
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundImage: image,
                  radius: 22,
                ),
              ):CachedNetworkImage(
                imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 22,
                ),
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundImage: image,
                  radius: 22,
                ),
              ),
              SizedBox(width:15),
              SizedBox(
                width: width/2.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userlist[index].userName,style:TextStyle(fontSize:18,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                    Text(userlist[index].College,style:TextStyle(fontSize:12,color: Colors.blue.shade200)),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width:80,
                decoration: BoxDecoration(
                    color:Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10)
                ),
                child:Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Connect",style:TextStyle(fontSize:18,color: Colors.green,fontWeight: FontWeight.bold)),
                    )),
              ),
              SizedBox(width:10),
            ],
          ),
        ),
      ],
    );
  }
}
