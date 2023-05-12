import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/feed_model.dart';
import '../../../Model/gallery_model.dart';
import '../../../Model/user_list_modal.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import '../../AdminScreen/TestPagesAkshy/splash_screen.dart';

class FriendsProfile extends StatefulWidget {
  final UserListModel userListModel;
   FriendsProfile({Key? key, required this.userListModel,}) : super(key: key);

  @override
  State<FriendsProfile> createState() => _FriendsProfileState();
}

class _FriendsProfileState extends State<FriendsProfile> {

  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();

  List<GalleryModel> Glist = [];

  String numberId='';
  String UserName='';
  String College='';
  String Designation='';
  String imageUrl='';
  String access='';


  @override
  void initState() {
    super.initState();
    load();

  }
  var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            imageUrl!=""?CachedNetworkImage(
                              imageUrl: imageUrl,
                              placeholder: (context, url) => const CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 60,
                              ),
                              imageBuilder: (context, image) => CircleAvatar(
                                backgroundImage: image,
                                radius: 60,
                              ),
                            ):CachedNetworkImage(
                              imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                              placeholder: (context, url) => const CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 60,
                              ),
                              imageBuilder: (context, image) => CircleAvatar(
                                backgroundImage: image,
                                radius: 60,
                              ),
                            ),

                            SizedBox(width: 20,),
                            SizedBox(
                              width:width/2.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.userListModel.userName,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                  Text(widget.userListModel.desigUser,style: TextStyle(fontSize: 16,color: Colors.grey),),
                                  SizedBox(height: 5,),
                                  MaterialButton(onPressed: () {
                                    // print("sshashj${imageUrl}");
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => EditProfile()));
                                  },
                                    color: MyColors.Colorgreen3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text("Connect with you ?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                  )
                                ],
                              ),
                            ),
                            Spacer(),
                            Align(alignment:Alignment.topRight,
                                child: InkWell(
                                  onTap:(){
                                    showAlertDialogMore(context);
                                  },
                                  child: SizedBox( width:40,height:40,
                                      child: Icon(Icons.more_vert_outlined)),
                                ))
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: width/1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:Border.all(color: Colors.grey.shade300,width: 1,)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text("0 followers",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Spacer(),
                                  Text("|",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Spacer(),
                                  Text("0 post",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Spacer(),
                                  Text("|",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Spacer(),
                                  Text(widget.userListModel.desigUser,style: TextStyle(fontWeight: FontWeight.bold),),
                                  Spacer(),],
                              ),
                            )),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          // color:Colors.red,
                            height: height / 1.3,
                            child: GridView.builder(
                                itemCount: Glist.length,
                                gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (BuildContext context, int index) =>
                                    galleryAdaptor(index))),
                      ),


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  load() async {
    mRootReference.
    child("UsersList").
    child(widget.userListModel.College).
    child(widget.userListModel.Phone).
    child(widget.userListModel.desigUser).
    child('Post').onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      Glist.clear();
      data.forEach((key, value) {
        Glist.add(GalleryModel(
          id: key,
          Description: value["Description"],
          gImageUrl: value["ImageUrl"],
          ToPublish: value["ToPublish"],

        ));
      });
      setState(() {});
    });
  }

  Widget galleryAdaptor(int index) {
    return InkWell(
      onLongPress: (){
        print("abcd ${Glist[index].id}");
        showAlertDialogMoreGallery(context,index);
      },
      onTap: (){
        showAlertDialogMoreGalleryView(context,index);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          width: double.infinity,
          fit: BoxFit.fill,
          imageUrl: Glist[index].gImageUrl,
          placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              )),
        ),
      ),
    );
  }

  showAlertDialogMore(BuildContext context) {

    AlertDialog alert = AlertDialog(
      title: const Text("More options",style: TextStyle(fontSize: 16,color: MyColors.Colorgreen3,fontWeight: FontWeight.bold),),
      content: Container(
        height:140,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Privacy policy",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
              SizedBox(height: 5,),
              InkWell(
                onTap: (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("About",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
              SizedBox(height: 5,),
              InkWell(
                onTap: (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("help",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
              SizedBox(height: 5,),
              InkWell(onTap: (){
                setBool(UserPreferences.IS_LOGIN,false);
                setString(UserPreferences.ACCESS_CODE,"");
                setString(UserPreferences.USER_NUMBER,"");
                setString(UserPreferences.USER_Name,"");
                setString(UserPreferences.USER_TYPE,"");
                finishAccountCreation( SplashScreen(), context);
                // showAlertDialog(context);
              },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color:Colors.red),),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Container(
              decoration: BoxDecoration(
                  color:MyColors.Colorgreen3,
                  borderRadius: BorderRadius.all(
                      Radius.circular(30)
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:15.0,right:15,top:8,bottom:8),
                child: const Text("Close",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color:Colors.white)),
              )),
          onPressed: () {
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

  Shimmer getShimmerLoading1(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade500,
      // enabled: _enabled,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:  Container(
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
          ),
        ),
      ),
    );
  }

  showAlertDialogMoreGallery(BuildContext context,int index) {

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
          onPressed: () async {
            mRootReference
                .child("UsersList").child(await getString(UserPreferences.COLLEGE))
                .child(await getString(UserPreferences.USER_NUMBER))
                .child(await getString(UserPreferences.DESIGNATION)).child("Post").child(Glist[index].id).remove();

            mRootReference.child('Feeds').child(Glist[index].ToPublish).child(Glist[index].id).remove();
            Glist.removeAt(index);
            load();
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

  showAlertDialogMoreGalleryView(BuildContext context,int index) {

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      content: CachedNetworkImage(
        width: 400,
        fit: BoxFit.fitWidth,
        imageUrl: Glist[index].gImageUrl,
        placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              color: MyColors.Colorgreen3,
            )),
      ),
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
