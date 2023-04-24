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
  var size, height, width;
  @override


  int _currentIndex = 0;


  var top=0.0;
  late ScrollController _scrollController;

  @override void initState() {
    loadComment();
    // getData();
    getData1();
    super.initState();
    _scrollController =  ScrollController();
    _scrollController.addListener(() {
      setState(() {

      });
    });
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
                child: Container(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(alignment: Alignment.centerLeft,
                    child: Text("Comments",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
              ),
              Container(
                height:height/2.7,
                child:commentList.length==0?Column(
                  children: [
                    Image.asset("assets/wrong.jpg"),
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
                  Row(
                    children: [
                      SizedBox(
                        width:315,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: comment,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Enter College',
                              hintText: 'eg: GECWayand',
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
                          color: Colors.blue,
                          child: Icon(Icons.arrow_forward_rounded),
                            onPressed: (){
                              addComment();
                              comment.clear();

                            }
                        ),
                      )
                    ],
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
    data["Date"] = DateTime.now().toString();
    data["Time"] = DateTime.now().millisecondsSinceEpoch.toString();

    await mRootReference.child('Feeds').child('Public').child(id).child('Comments').child(id1).update(data);

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
    String id = widget.feedModel.id;
    mRootReference.child('Feeds').child('Public').child(id).child('Comments').onValue.listen((event) {
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
      padding: const EdgeInsets.only(left: 6, right: 6),
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
