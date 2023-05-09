import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Model/comment_model.dart';
import 'package:miniq/Model/feed_model.dart';
import 'package:miniq/Theme/theme.dart';

class CommentViewScreen extends StatefulWidget {
  final FeedModel feedModel;
  CommentViewScreen({Key? key, required this.feedModel,}) : super(key: key);

  @override
  State<CommentViewScreen> createState() => _CommentViewScreenState();
}

class _CommentViewScreenState extends State<CommentViewScreen> {
  List<CommentModel> commentList = [];

  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  TextEditingController comment = TextEditingController();
  String username = '';
  String userProfImg = '';
  var size, height, width;
  @override


  int _currentIndex = 0;


  var top=0.0;

  @override void initState() {
    loadComment();
    getDataF1();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(onTap: (){
                print("ajfbsgdbfdv ${commentList.length}");
              },
                child: Stack(
                  children: [
                    Container(
                      height: height/2,
                      child: CachedNetworkImage(
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        imageUrl: widget.feedModel.imageUrl,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            )),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      child: Container(
                        color: Colors.black26,
                        width: width/1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.feedModel.description,style: TextStyle(color: Colors.white),
                              maxLines: 15,
                              overflow: TextOverflow.ellipsis),
                        ),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(alignment: Alignment.centerLeft,
                    child: Text("Comments",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
              ),
              Container(
                height:height/2.7,
                child:commentList.length==0?
                Column(
                  children: [
                    Image.asset("assets/wrong.jpg",height:height/3,),
                    Text("- No Comments -")
                  ],
                ):
                ListView.builder(
                          itemCount: commentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CommentAdaptor(index);
                          },
                        ),
                      ),
                  SizedBox(
                    width:width/1,
                    child: Row(
                      children: [
                        SizedBox(
                          width:width/1.27,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: comment,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Enter comment',
                                hintText: ' Comment',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.blue),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color:Colors.grey, width: 1.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            minWidth: 40,
                            height: 50,
                            color: MyColors.Colorgreen3,
                            child: Icon(Icons.arrow_forward_rounded),
                              onPressed: (){
                                addComment();
                                comment.clear();

                              }
                          ),
                        )
                      ],
                    ),
                  ),

            ],
          ),
        )

        // Stack(
        //   children: [
        //
        //   CachedNetworkImage(
        //            width: double.infinity,
        //            fit: BoxFit.fitWidth,
        //            imageUrl: widget.feedModel.imageUrl,
        //            placeholder: (context, url) => Center(
        //            child: CircularProgressIndicator(
        //                 color: Colors.red,
        //            )),
        //         ),
        //
        //   DraggableScrollableSheet(
        //   expand: true,
        //   initialChildSize: 0.6,
        //   minChildSize: 0.6,
        //   maxChildSize: 1,
        //   builder: (context,controller) {
        //     return Container(
        //       color:Colors.white,
        //       child: ListView.builder(
        //         controller: controller,
        //         itemCount: commentList.length,
        //         itemBuilder: (BuildContext context, int index) {
        //           return CommentAdaptor(index);
        //         },
        //       ),
        //
        //     );
        //   },),
        //   ],
        //     )

    );
  }




  Future<void> addComment() async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();
    String id = widget.feedModel.id;
    String id1 = DateTime.now().millisecondsSinceEpoch.toString();
    // print("gggggggg"+imageUrl);
    data["Description"] = comment.text;
    data["UserName"] = username;
    data["UserProfilImage"] = userProfImg;
    data["Date"] = DateTime.now().toString();
    data["Time"] = DateTime.now().millisecondsSinceEpoch.toString();

    await mRootReference.child('Feeds').child(widget.feedModel.toPublish).child(id).child('Comments').child(id1).update(data);

    // await
    // referenceRoot.child("Test")
    //     .child("Images").push().update(data);
  }

  getDataF1() async {
    username = (await getString(UserPreferences.USER_Name));
    mRootReference
        .child("UsersList").child(await getString(UserPreferences.COLLEGE))
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(await getString(UserPreferences.DESIGNATION))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        username=data['Name'];
        userProfImg=data['ImageUrl'];
        setState(() {});
      }
    });
  }

  loadComment() {
    String id = widget.feedModel.id;
    mRootReference.child('Feeds').child(widget.feedModel.toPublish).child(id).child('Comments').onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      commentList.clear();
      data.forEach((key, value) {
        commentList.add(CommentModel(
          id: key,
          username: value['UserName'],
          description: value['Description'],
          Time: value['Time'],
          UserProfImg: value['UserProfilImage']
        ));
      });
      setState(() {});
    });
  }

  Widget CommentAdaptor(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15,top:6,bottom:6),
      child: Row(
        children: [
          commentList[index].UserProfImg==''?
          CachedNetworkImage(
            imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
            placeholder: (context, url) =>  CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              radius: 20,
            ),
            imageBuilder: (context, image) => CircleAvatar(
              backgroundImage: image,
              radius: 20,
            ),
          ) :
          CachedNetworkImage(
            imageUrl: commentList[index].UserProfImg,
            placeholder: (context, url) =>  CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              radius: 20,
            ),
            imageBuilder: (context, image) => CircleAvatar(
              backgroundImage: image,
              radius: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commentList[index].username,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  commentList[index].description,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          Spacer(),
          InkWell(
            onTap: (){
              showAlertDialogMore(context,index);
            },
            child: Icon(
              Icons.more_vert_outlined,
              size: 27,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialogMore(BuildContext context,int index) {

    AlertDialog alert = AlertDialog(
      title: const Text("confirm"),
      content: const Text("Are you sure to delete"),
      actions: [
        TextButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () {
            mRootReference.child('Feeds').child(widget.feedModel.toPublish).child(widget.feedModel.id).child('Comments').child(commentList[index].id).remove();
            commentList.removeAt(index);
            Navigator.of(context).pop();
          },
        ),

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
