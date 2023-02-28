import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Model/feed_model.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/comment_view.dart';
import 'package:miniq/Theme/theme.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<FeedModel> list = [];
  String numberId = '';
  String UserName = '';
  bool isLiked = false;
  var size, height, width;

  @override
  void initState() {
    // TODO: implement initState
    load();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: MyColors.Blackcolor,
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: Container(
          // color:Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          "https://www.aais.com/hs-fs/hubfs/coming_soon_placeholder-01.jpg?width=4000&name=coming_soon_placeholder-01.jpg",
                          // list[index].imageUrl,
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserName,
                            style: TextStyle(
                                color: MyColors.Whitecolor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "College name",
                            style:
                                TextStyle(color: Colors.white60, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.notifications_none,
                            size: 30,
                            color: MyColors.Whitecolor,
                          ),
                        ),
                        Positioned(
                          left: 15,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.red,
                            ),
                            height: 25,
                            width: 25,
                            child: Center(child: Text("5")),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 5, top: 10),
                  child: Text("Trending",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          // color:Colors.red,
          // height: height/1.46,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return FeedAdaptor(index);
            },
          ),
        ),
      ),
    );
  }

  getData() async {
    numberId = (await getString(UserPreferences.USER_NUMBER));
    UserName = (await getString(UserPreferences.USER_Name));
    mRootReference
        .child("UsersList")
        .child(await getString(UserPreferences.USER_NUMBER))
        .child("Profile")
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("ajfbsgdbfdv ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        UserName = data["Name"];
        setState(() {});
      }
    });
  }

  load() async {
    mRootReference.child("Feeds").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      list.clear();
      data.forEach((key, value) {
        list.add(FeedModel(
          id: key,
          // username: value['Name'],
          description: value['Description'],
          imageUrl: value['ImageUrl'],
        ));
      });
      setState(() {});
    });
  }

  @override
  Widget FeedAdaptor(int index) {
    // int index  in function
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 10.0, right: 10, top: 6, bottom: 6),
          child: Card(
            color: MyColors.LightBlackcolor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          imageUrl: list[index].imageUrl,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            color: MyColors.Greencolor,
                          )),
                        ),
                      ),
                      Positioned(
                        top: height / 5.3,
                        left: width / 1.6,
                        child: Container(
                          width: 79,
                          height: 40,
                          decoration: BoxDecoration(
                              color: MyColors.Orangecolor,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                // color:Colors.red,
                                width: 37,
                                height: 40,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isLiked = !isLiked;
                                    });
                                  },
                                  icon: isLiked
                                      ? Icon(
                                          Icons.favorite,
                                          color: MyColors.Blackcolor,
                                          size: 26,
                                        )
                                      : Icon(Icons.favorite_border,
                                          color: MyColors.Blackcolor, size: 26),
                                ),
                              ),
                              Text(
                                "192",
                                style: TextStyle(
                                    color: MyColors.Blackcolor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width / 1.25,
                              child: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        "https://www.aais.com/hs-fs/hubfs/coming_soon_placeholder-01.jpg?width=4000&name=coming_soon_placeholder-01.jpg",
                                        // list[index].imageUrl,
                                        height: 35,
                                        width: 35,
                                        fit: BoxFit.cover,
                                      )),
                                  SizedBox(
                                    width: width / 1.6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 5),
                                          child: Text("User name",
                                              // list[index].username,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: MyColors.Whitecolor),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.start),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 5),
                                          child: Text(
                                            "3 min ago",
                                            // list[index].username
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white60),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentViewScreen(
                                                      feedModel: list[index])));
                                    },
                                    child: Icon(Icons.chat_bubble_outline,
                                        size: 27, color: MyColors.Greencolor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5),
                              child: SizedBox(
                                width: width / 1.3,
                                child: Text(list[index].description,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: MyColors.Whitecolor),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    textAlign: TextAlign.start),
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
          ),
        ),

        // SizedBox(height: 20,),
      ],
    );
  }
}

