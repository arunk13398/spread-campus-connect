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
  CommentViewScreen({Key? key, required this.feedModel}) : super(key: key);

  @override
  State<CommentViewScreen> createState() => _CommentViewScreenState();
}

class _CommentViewScreenState extends State<CommentViewScreen> {
  List<CommentModel> commentList = [];

  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  TextEditingController comment = TextEditingController();
  String username = '';
  var size, height, width;
  @override
  void initState() {
    // TODO: implement initState
    loadComment();
    // getData();
    getData1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        backgroundColor: MyColors.Blackcolor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: height / 2,
                  decoration: BoxDecoration(
                    color: MyColors.LightBlackcolor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          height: height / 3,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          imageUrl: widget.feedModel.imageUrl,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            color: Colors.red,
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 15),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          "https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0",
                                          height: 25,
                                          width: 25,
                                          fit: BoxFit.cover,
                                        )),
                                    SizedBox(
                                      width: width / 1.7,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 5),
                                        child: Text(
                                          "User name",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: Icon(
                                        // Icons.favorite_border,
                                        Icons.favorite,
                                        size: 27,
                                        color: MyColors.Greencolor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "192",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5),
                                        child: Icon(
                                          Icons.chat_bubble_outline,
                                          size: 27,
                                          color: MyColors.Orangecolor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "192",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5),
                                  child: SizedBox(
                                    width: width / 1.1,
                                    child: Text(
                                      // "svavsgva cha chg  as gsa",
                                      widget.feedModel.description,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Comments",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: height / 2.8,
                  child: ListView.builder(
                    itemCount: commentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CommentAdaptor(index);
                    },
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, top: 5, bottom: 5),
                      child: SizedBox(
                        width: width / 1.4,
                        child: TextFormField(
                          controller: comment,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Comment',
                            hintText: 'Enter your Comment',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    "https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0",
                                    height: 10,
                                    width: 10,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: MyColors.theme3, width: 1.2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                        color: MyColors.Orangecolor,
                        height: 50,
                        minWidth: width / 5.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onPressed: () {
                          addComment();
                          comment.clear();
                        },
                        child: Icon(
                          Icons.send,
                          size: 30,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> addComment() async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();
    String id = widget.feedModel.id;
    String id1 = DateTime.now().millisecondsSinceEpoch.toString();
    ;
    // print("gggggggg"+imageUrl);
    data["Description"] = comment.text;
    data["UserName"] = username;
    data["Date"] = DateTime.now().toString();
    data["Time"] = DateTime.now().millisecondsSinceEpoch.toString();

    await mRootReference.child('Comments').child(id1).update(data);

    // await
    // referenceRoot.child("Test")
    //     .child("Images").push().update(data);
  }

  getData1() async {
    username = (await getString(UserPreferences.USER_Name));
    mRootReference
        .child("UsersList")
        .child(await getString(UserPreferences.USER_NUMBER))
        .child("Profile")
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("ajfbsgdbfdv ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        username = data["Name"];
        setState(() {});
      }
    });
  }

  loadComment() {
    mRootReference.child("Comments").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      commentList.clear();
      data.forEach((key, value) {
        commentList.add(CommentModel(
          id: key,
          username: value['UserName'],
          description: value['Description'],
          Time: value['Time'],
        ));
      });
      setState(() {});
    });
  }

  Widget CommentAdaptor(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 6, right: 6),
      child: Row(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commentList[index].username,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  commentList[index].description,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          Spacer(),
          Icon(
            Icons.favorite_border,
            size: 27,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
