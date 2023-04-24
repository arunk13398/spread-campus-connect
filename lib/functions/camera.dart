import 'dart:collection';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Screens/bottom_navigation.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:shimmer/shimmer.dart';

import '../Screens/UserScreens/FeedScreen/FeedPage.dart';
import 'functions.dart';
// import 'Pakage:Test';

class Camera extends StatefulWidget {
  Camera({
    Key? key,
  }) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  GlobalKey key = GlobalKey();

  XFile? file;

  TextEditingController description = TextEditingController();
  String numberId = "";
  String UserName = "";
  String imageUrl = '';
  String College = '';
  String Designation = '';
  String designationU = '';
  String CollegeU = '';
  String Uid = '';
  late FirebaseAuth _auth;
  late Stream<User?> _authStateChanges;

  bool isConnected = false;

  String _categoryDpValue = 'Public';
  var _category = [
    'Public',
    'Connections',
  ];

  @override
  void initState() {
    super.initState();
    //_read_onechld();
    getSharPdata();
    checkRealtimeConnection();
    getDataF1();
    // print("desig dwerx ${UserName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
                  child: Text("Upload Image",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.camera);
                        print('${file?.path}');
                        if (file == null) return;
                        String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                        Reference mRootReference = FirebaseStorage.instance.ref();
                        Reference referenceDirImages = mRootReference.child('images');

                        Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
                        try {await referenceImageToUpload.putFile(File(file!.path));
                        imageUrl = await referenceImageToUpload.getDownloadURL();
                        } catch (error) {}

                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.blue.shade200,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Upload from camera",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        print("Testing${file?.path}");
                        if (file == null) return;

                        String uniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        Reference mRootReference =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            mRootReference.child('images');

                        Reference referenceImageToUpload =
                            referenceDirImages.child(uniqueFileName);
                        try {
                          await referenceImageToUpload
                              .putFile(File(file!.path));
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                        } catch (error) {}
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.blue.shade200,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Upload from gallery",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: description,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Enter discription',
                      hintText: 'Enter discription',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color: Colors.blue),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color:Colors.grey, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Text("Feed Publish to", style: TextStyle(fontSize: 18)),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border:
                                Border.all(color: Colors.black38, width: 1)),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 20),
                            child: DropdownButton(
                              // Initial Value
                              value: _categoryDpValue,
                              iconEnabledColor: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                              // Down Arrow Icon
                              icon: const Icon(Icons.swap_vert),
                              // Array list of items
                              items: _category.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Text(items),
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  _categoryDpValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                imageUrl != ""
                    ? CachedNetworkImage(
                        // height: 250,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        imageUrl: imageUrl,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          color: Colors.grey,
                        )),
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: MaterialButton(
              color: Colors.blue,
              minWidth: double.infinity,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                "submit",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),

              onPressed: () async {
                if (file == null) {
                  alertDialog(context, "is empty file path", "${file?.path}");
                } else {
                  //alertDialog(context,"is not empty","is url not empty${imageUrl}");
                  add().then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.grey,
                      content: Text(
                        "Successful",
                        style: TextStyle(color: Colors.black),
                      ),
                    ));
                    description.clear();
                    // finish(context);
                  });
                }
              },
              // _reference.add(dataToSend);
            ),
          ),
        ],
      )),
    );
  }


  void checkRealtimeConnection() {
    Connectivity().onConnectivityChanged.listen((my_result) {
      if (my_result == ConnectivityResult.mobile ||
          my_result == ConnectivityResult.wifi) {
        print("connected");
        setState(() {
          isConnected = true;
        });
      } else if (my_result == ConnectivityResult.none) {
        print("not connected");
        setState(() {
          isConnected = false;
        });
      }
    });
  }

  showmodelBottomsheet() {
    return showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                height: 200,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Uplord Image",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            // cameraAccess();
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Upload from camera",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            // galleryAccess();
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Upload from gallery",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )),
                  ],
                ))),
          );
        });
  }

  // galleryAccess()  async {
  //    ImagePicker imagePicker = ImagePicker();
  //    file = await imagePicker.pickImage(source: ImageSource.gallery);
  //    print("Testing${file?.path}");
  //    if (file == null) return;
  //
  //    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //    Reference mRootReference = FirebaseStorage.instance.ref();
  //    Reference referenceDirImages = mRootReference.child('images');
  //
  //    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
  //    try {
  //      await referenceImageToUpload.putFile(File(file!.path));
  //      imageUrl = await referenceImageToUpload.getDownloadURL();
  //    } catch (error) {}
  //  }
  //
  //  cameraAccess() async {
  //    ImagePicker imagePicker = ImagePicker();
  //    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
  //    print('${file?.path}');
  //    if (file == null) return;
  //
  //    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //    Reference mRootReference = FirebaseStorage.instance.ref();
  //    Reference referenceDirImages = mRootReference.child('images');
  //
  //    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
  //    try {
  //      await referenceImageToUpload.putFile(File(file!.path));
  //      imageUrl = await referenceImageToUpload.getDownloadURL();
  //    } catch (error) {}
  //  }

  Future<void> add() async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String subId = _categoryDpValue;
    print("gggggggg" + imageUrl);
    data["Description"] = description.text;
    data["ImageUrl"] = imageUrl;
    data['UserName'] = UserName;
    data['Designation'] = designationU;
    // data['Uid']=Uid;
    data["Date"] = DateTime.now().toString();
    data["ImageUrlTime"] = DateTime.now().millisecondsSinceEpoch.toString();

    await mRootReference.child("Feeds").child(subId).child(id).update(data);
    await mRootReference.child("UsersList").child('GECWayanad').child('+919562592737').child('Student').child('Post').child(id).update(data);

    Future.delayed(const Duration(seconds: 1), () {
      finishAccountCreation(BottomNavigation(), context);
    });

    // await
    // referenceRoot.child("Test")
    //     .child("Images").push().update(data);
  }

  getDataF1() async {
    // numberId = (await getString(UserPreferences.USER_NUMBER));
    // UserName = (await getString(UserPreferences.USER_Name));
    // College = (await getString(UserPreferences.COLLEGE));
    mRootReference
        .child("AccessControl")
        .child(await getString(UserPreferences.USER_NUMBER))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("efgh ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        UserName = data["Name"];
        College = data["College"];
        Designation = data["Designation"];
        setState(() {});
      }
    });
  }

  initAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    _auth = FirebaseAuth.instance;
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges.listen((User? user) {
      setState(() {
        Uid = user?.uid ?? "";
      });
      print("...user id ${user?.uid}....");
    });
  }

  getSharPdata() async {

    CollegeU = (await getString(UserPreferences.COLLEGE));
    designationU = (await getString(UserPreferences.DESIGNATION));
  }
}
