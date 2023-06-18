import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../Model/user_list_modal.dart';
import '../../../functions/functions.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {

  // String _academicDpValue = 'Club';
  // var _academicYear = ['User','Club', 'Reviewer','Publisher','Alumini','Admin',];
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<UserListModel> userlist = [];
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
    return  Scaffold (
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:10.0,top:15,bottom:20),
              child: Align(alignment: Alignment.topLeft,
                child: Text(
                  "UsersList",
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
                    child: ListView.builder(
                      itemCount: userlist.length,
                      itemBuilder: (context, index) => UsersListview(index),),
                  ),
                )

            ),
          ],
        ),
      ),
    );
  }
  Widget UsersListview(int index){
    return Slidable(
      // enabled: false,
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(
            onDismissed: () {
              showAlertDialog(context);
            }),

        // All actions are defined in the children parameter.
        children:  [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (context){
              // HashMap<String, dynamic> access = HashMap<String, dynamic>();
              // access["Status"] = "active";
              // mRootReference.child("AccessControl").child(userlist[index].id).update(access);
            },
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane:  ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.lock_open_rounded,
            label: 'unblock',
            onPressed: ( context) {
              HashMap<String, dynamic> access = HashMap<String, dynamic>();
              access["Status"] = "active";
              mRootReference
                  .child("AccessControl").child(userlist[index].id).update(access);
            },
          ),
          SlidableAction(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            icon: Icons.block_flipped,
            label: 'Block',
            onPressed: ( context) {
              HashMap<String, dynamic> access = HashMap<String, dynamic>();
              access["Status"] = "blocked";
              mRootReference
                  .child("AccessControl").child(userlist[index].id).update(access);
            },
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                userlist[index].imageUrl!=""?CachedNetworkImage(
                  imageUrl: userlist[index].imageUrl,
                  placeholder: (context, url) => const CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 25,
                  ),
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundImage: image,
                    radius: 25,
                  ),
                ):
                CachedNetworkImage(
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
                  width: width/2.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userlist[index].userName,style:TextStyle(fontSize:18,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                      Text(userlist[index].desigUser,style:TextStyle(fontSize:16,color: Colors.grey)),
                      Text(userlist[index].College,style:TextStyle(fontSize:12,color: Colors.blue.shade200)),
                    ],
                  ),
                ),
                SizedBox(width:10),
                Container(
                  width:80,
                  decoration: BoxDecoration(
                      color:userlist[index].Status=="active"?Colors.greenAccent.shade100:Colors.amber.shade200,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child:Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(userlist[index].Status,
                            style:TextStyle(fontSize:18,color: Colors.black,fontWeight: FontWeight.bold)),
                      )),
                ),
                Icon(Icons.more_vert)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 8,bottom: 0,top:10),
            child: Divider(height: 1,color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
void doNothing(BuildContext context) {}