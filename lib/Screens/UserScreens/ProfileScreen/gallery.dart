import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Model/feed_model.dart';
import 'package:miniq/Screens/UserScreens/ProfileScreen/edit_profile.dart';
import 'package:miniq/Theme/theme.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
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
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
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
    mRootReference.child("Feeds").child("Public").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      list.clear();
      data.forEach((key, value) {
        list.add(FeedModel(
          id: key,
          userName: value['UserName'],
          desigUser: value['Designation'],
          description: value['Description'],
          imageUrl: value['ImageUrl'],
          UpdatedTime: value['ImageUrlTime'],
          profImg: value['ProfileImage'],
          toPublish: value['ToPublish'],
          // ToPublish: value['ToPublish'],
        ));
      });
      setState(() {});
    });
  }

  Widget galleryAdaptor(int index) {
    return InkWell(
      onLongPress: (){
        print("abcd ${list[index].id}");
        AlertDialog(
          title: const Text("Remove"),
          content: const Text("Are you sure to Remove"),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                mRootReference.child("Feeds").child("Public").child(list[index].id).remove();
                list.removeAt(index);
              },
            ),
          ],
        );
      },
      child: ClipRRect(
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
              side: BorderSide( color: Colors.grey, width: 2)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                "https://th.bing.com/th/id/OIP.R4gEjzGdxIEBZ42eafUHfgAAAA?pid=ImgDet&rs=1",
                height: 50,
                width: 60,
                fit: BoxFit.fill,
              )),
        ),
      ],
    );
  }
}