import 'dart:collection';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Screens/bottom_navigation.dart';
import 'package:miniq/Theme/theme.dart';
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

  TextEditingController description = TextEditingController();
  String numberId = "";
  String username = "";
  String imageUrl = '';
  @override
  void initState() {
    super.initState();
    //_read_onechld();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Blackcolor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
              child: Text("Uplord Image",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.Whitecolor)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 5, bottom: 5),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: description,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter the description',
                  hintText: 'description',
                  prefixIcon:
                      Icon(Icons.image, size: 20, color: MyColors.Orangecolor),
                  filled: true,
                  fillColor: MyColors.LightBlackcolor,
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: MyColors.Orangecolor, width: 1.2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.2),
                  ),
                ),
              ),
            ),

            Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    cameraAccess();
                  },
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: MyColors.LightBlackcolor,
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
                            color: MyColors.Whitecolor),
                      )
                    ],
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () {
                    galleryAccess();
                  },
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: MyColors.LightBlackcolor,
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
                            color: MyColors.Whitecolor),
                      )
                    ],
                  ),
                )),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
              child: MaterialButton(
                color: MyColors.Orangecolor,
                minWidth: double.infinity,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  "submit",
                  style: TextStyle(fontSize: 18),
                ),

                onPressed: () async {
                  await add().then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: MyColors.Greencolor,
                      content: Text(
                        "Successful",
                        style: TextStyle(color: Colors.black),
                      ),
                    ));
                    description.clear();
                    // finish(context);
                  });
                },
                // _reference.add(dataToSend);
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: MaterialButton(
            //     minWidth: double.infinity,
            //     height: 50,
            //     color: MyColors.theme3,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10.0)),
            //     child:Text("Uploard Image",style: TextStyle(color: Colors.white),),
            //     onPressed: (){
            //       showmodelBottomsheet();
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Future<void> showmodelBottomsheet() {
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
                            cameraAccess();
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: MyColors.theme3,
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
                            galleryAccess();
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: MyColors.theme3,
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

  Future<void> galleryAccess() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');
    if (file == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference mRootReference = FirebaseStorage.instance.ref();
    Reference referenceDirImages = mRootReference.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  Future<void> cameraAccess() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    print('${file?.path}');
    if (file == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference mRootReference = FirebaseStorage.instance.ref();
    Reference referenceDirImages = mRootReference.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  Future<void> add() async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    // String id = numberId;
    print("gggggggg" + imageUrl);
    data["UserName"] = data["Description"] = description.text;
    data["ImageUrl"] = imageUrl;
    data["Date"] = DateTime.now().toString();
    data["ImageUrlTime"] = DateTime.now().millisecondsSinceEpoch.toString();

    await mRootReference
        .child("Feeds")
        .child(id)
        // .child('Images')
        .update(data);

    // await
    // referenceRoot.child("Test")
    //     .child("Images").push().update(data);
  }

  void finish(context) {
    // Navigator.push(
    // context, MaterialPageRoute(builder: (context) => BottomNavigation()));
    Navigator.pop(context);
  }

  getData() async {
    numberId = (await getString(UserPreferences.USER_NUMBER));
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
}
