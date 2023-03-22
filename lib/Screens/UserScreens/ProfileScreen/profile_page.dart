import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Model/feed_model.dart';
import 'package:miniq/Screens/UserScreens/ProfileScreen/edit_profile.dart';
import 'package:miniq/Theme/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<FeedModel> list = [];
  var size, height, width;
  String numberId = '';
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                    placeholder: (context, url) => const CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 60,
                    ),
                    imageBuilder: (context, image) => CircleAvatar(
                      backgroundImage: image,
                      radius: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Salvin sam",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: MyColors.Whitecolor)),
                        Icon(
                          Icons.school,
                          color: MyColors.Greencolor,
                        )
                      ],
                    ),
                  ),
                  Text("Gecwyd",
                      style:
                          TextStyle(fontSize: 16, color: MyColors.Whitecolor)),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Third year",
                      style:
                          TextStyle(fontSize: 16, color: MyColors.Whitecolor)),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()));
                            },
                            textColor: Colors.white,
                            color: MyColors.LightBlackcolor,
                            minWidth: width / 2.3,
                            height: 60,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 5),
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Row(
                              children: [
                                Icon(
                                  // Icons.favorite_border,
                                  Icons.edit_note_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Edit",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            )),
                        MaterialButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HomeScreenBuyer()));
                            },
                            textColor: Colors.black,
                            color: MyColors.Orangecolor,
                            minWidth: width / 2.3,
                            height: 60,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 5),
                                borderRadius: BorderRadius.circular(15.0)),
                            child: const Text(
                              "Post",
                              style: TextStyle(fontSize: 18),
                            )),

                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width:width/1.6,
                          height: 60,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SuggestAdaptor(),
                              SuggestAdaptor(),
                              SuggestAdaptor(),
                            ],
                          ),
                        ),
                        MaterialButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HomeScreenBuyer()));
                            },
                            textColor: Colors.black,
                            color: MyColors.Whitecolor,
                            minWidth: width / 3.3,
                            height: 55,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 5),
                                borderRadius: BorderRadius.circular(15.0)),
                            child: const Text(
                              "Take a look",
                              style: TextStyle(fontSize: 18),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text("Gallery",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                        height: height / 1.3,
                        child: GridView.builder(
                            itemCount: list.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 150,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (BuildContext context, int index) =>
                                galleryAdaptor(index))),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  getData() async {
    numberId = (await getString(UserPreferences.USER_NUMBER));
    mRootReference
        .child("UsersList")
        .child(await getString(UserPreferences.USER_NUMBER))
        .child("Profile")
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("ajfbsgdbfdv ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        data = data["Name"];
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

  Widget galleryAdaptor(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: CachedNetworkImage(
        width: double.infinity,
        fit: BoxFit.fill,
        imageUrl: list[index].imageUrl,
        placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
          color: Colors.red,
        )),
      ),
    );
  }
}

class SuggestAdaptor extends StatelessWidget {
  const SuggestAdaptor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
              side: BorderSide(color: MyColors.theme1, width: 2)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                "https://th.bing.com/th/id/OIP.R4gEjzGdxIEBZ42eafUHfgAAAA?pid=ImgDet&rs=1",
                height: 50,
                width: 60,
                fit: BoxFit.fill,
              )),
        ),
        // SizedBox(
        //   width: 70,
        //   child: Text("aravind",
        //       style: TextStyle(color: Colors.white),
        //       maxLines: 1,
        //       textAlign: TextAlign.center,
        //       overflow: TextOverflow.ellipsis),
        // ),
        // SizedBox(
        //   width: 5,
        // ),
      ],
    );
  }
}