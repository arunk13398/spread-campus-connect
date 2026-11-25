import 'dart:collection';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Screens/bottom_navigation.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:shimmer/shimmer.dart';

import '../Model/listdata_model.dart';
import '../Screens/Adminbottom_navigation.dart';
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
  bool _isChecked = false;
  XFile? file;

  TextEditingController description = TextEditingController();
  TextEditingController PostLinkUrl = TextEditingController();
  String numberId = "";
  String UserName = "";
  String imageUrl = '';
  String College = '';
  String Designation = '';
  String designationU = '';
  String CollegeU = '';
  String Uid = '';
  String ProfileImage='';
  late FirebaseAuth _auth;
  late Stream<User?> _authStateChanges;

  bool isConnected = false;
  bool _isUploading = false;
  List<ListDataModel> datalist=[];
  ListDataModel?selectedItem;


  String _categoryDpValue = 'Public';
  var _category = [
    'Public',
    'Connections',
  ];

  @override
  void initState() {
    super.initState();
    loadNotification();
    //_read_onechld();
    getSharPdata();
    checkRealtimeConnection();
    getDataF1();
    // print("desig dwerx ${UserName}");
  }

  loadNotification() async {
    final designation = await getString(UserPreferences.DESIGNATION);
    if (designation == null || designation.toString().isEmpty) {
      datalist = [ListDataModel(id: 'All')];
      selectedItem ??= datalist.first;
      if (mounted) setState(() {});
      return;
    }
    mRootReference
        .child("AccessManagement")
        .child("Designation")
        .child(designation)
        .child("Camera")
        .onValue
        .listen((event) {
      datalist.clear();
      final raw = event.snapshot.value;
      if (raw is Map<dynamic, dynamic>) {
        raw.forEach((key, value) {
          datalist.add(ListDataModel(
            id: key.toString(),
          ));
        });
      }
      if (datalist.isEmpty) {
        datalist.add(ListDataModel(id: 'All'));
      }
      if (selectedItem == null ||
          !datalist.any((item) => item.id == selectedItem!.id)) {
        selectedItem = datalist.first;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  (file != null || imageUrl != "")
                      ? InkWell(
                          onTap: () => showAlertDialogCamera(context),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (file != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(file!.path),
                                      width: double.infinity,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  CachedNetworkImage(
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                    imageUrl: imageUrl,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const SizedBox(
                                      height: 300,
                                      child: Center(
                                          child: Icon(Icons.broken_image)),
                                    ),
                                  ),
                                if (_isUploading)
                                  Container(
                                    height: 300,
                                    color: Colors.black26,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                    child: InkWell(
                      onTap: (){
                        showAlertDialogCamera(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            height:300,
                            width:double.infinity,
                            color:Colors.grey[200],
                          child:Center(child: Text("Select Image")),
                        ),
                      ),
                    ),
                  ),
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
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 180,
                              height: 40,
                              decoration:BoxDecoration(
                                  color:Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: Colors.black38,
                                      width: 1
                                  )
                              ),
                              child: DropdownButtonHideUnderline(
                                child: Padding(
                                  padding: const EdgeInsets.only(left:20.0,right:20),
                                  child: DropdownButton<ListDataModel>(
                                    value : selectedItem,
                                    iconEnabledColor: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    icon: const Icon(Icons.swap_vert),
                                    onChanged:(ListDataModel? newValue){
                                      setState((){
                                        selectedItem = newValue;
                                      });

                                    },
                                    items: datalist.map<DropdownMenuItem<ListDataModel>>((ListDataModel value){
                                      return DropdownMenuItem<ListDataModel>(
                                          value: value,
                                          child:Padding(
                                            padding: const EdgeInsets.only(left:10.0,right:10),
                                            child: Text(value.id),
                                          )
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),



                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     height: 45,
                          //     width: 120,
                          //     decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(30),
                          //         border:
                          //             Border.all(color: Colors.black38, width: 1)),
                          //     child: ListView.builder(
                          //       scrollDirection: Axis.horixontal,
                          //       itemCount: datalist.length,
                          //       itemBuilder: (context, index) => ListChange(index),
                          //     )
                          //
                          //     // DropdownButtonHideUnderline(
                          //     //   child: Padding(
                          //     //     padding:
                          //     //         const EdgeInsets.only(left: 12.0, right: 20),
                          //     //     child: DropdownButton(
                          //     //       // Initial Value
                          //     //       value: _categoryDpValue,
                          //     //       iconEnabledColor: Colors.black,
                          //     //       borderRadius: BorderRadius.circular(30),
                          //     //       // Down Arrow Icon
                          //     //       icon: const Icon(Icons.swap_vert),
                          //     //       // Array list of items
                          //     //       items: _category.map((String items) {
                          //     //         return DropdownMenuItem(
                          //     //           value: items,
                          //     //           child: Padding(
                          //     //             padding: const EdgeInsets.only(
                          //     //                 left: 10.0, right: 10),
                          //     //             child: Text(items),
                          //     //           ),
                          //     //         );
                          //     //       }).toList(),
                          //     //       // After selecting the desired option,it will
                          //     //       // change button value to selected value
                          //     //       onChanged: (String? newValue) {
                          //     //         setState(() {
                          //     //           _categoryDpValue = newValue!;
                          //     //         });
                          //     //       },
                          //     //     ),
                          //     //   ),
                          //     // ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 0,),

                    Designation=='Teacher'||designationU=='Admin'?Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:0.0,right: 5,),
                          child: CheckboxListTile(
                            activeColor: Colors.blue,
                            title: Text("Provide any Post register links",style: TextStyle( color: Colors.black,fontSize: 15),),
                            value: _isChecked,
                            onChanged: (val) {
                              setState(() {
                                _isChecked = val!;
                              });
                            },
                          ),
                        ),
                        _isChecked==true?Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: PostLinkUrl,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Paste link',
                              hintText: 'https:// Post link',
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
                        ):Container(),
                      ],
                    ):Container(),]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: MaterialButton(
                  color: MyColors.Colorgreen3,
                  minWidth: double.infinity,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    "submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),

                  onPressed: () async {
                    if (_isUploading) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please wait for image upload to finish"),
                      ));
                      return;
                    }
                    if (file == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please select an image"),
                      ));
                    } else if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Image upload failed. Enable Firebase Storage for this project."),
                      ));
                    } else if (selectedItem == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please select where to publish"),
                      ));
                    } else {
                      add().then((value) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.grey,
                          content: Text(
                            "Successful",
                            style: TextStyle(color: Colors.black),
                          ),
                        ));
                        description.clear();
                      });
                    }
                  },
                  // _reference.add(dataToSend);
                ),
              ),
            ],
          ),


    ));
  }


  void checkRealtimeConnection() {
    Connectivity().onConnectivityChanged.listen((my_result) {
      if (my_result.contains(ConnectivityResult.mobile) ||
          my_result.contains(ConnectivityResult.wifi)) {
        print("connected");
        setState(() {
          isConnected = true;
        });
      } else if (my_result.contains(ConnectivityResult.none) ||
          my_result.isEmpty) {
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
                            fontSize: 13,)),
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
                                    fontSize: 13,),
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
                                    fontSize: 13, ),
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
    String subId = selectedItem!.id;
    print("gggggggg" + imageUrl);
    data["id"]=id;
    data["Description"] = description.text;
    data["ImageUrl"] = imageUrl;
    data['UserName'] = UserName;
    data['Designation'] = designationU;
    data['ProfileImage'] = ProfileImage;
    data['ToPublish'] = selectedItem!.id;
    data['RegisterLink'] = PostLinkUrl.text;
    data["Date"] = DateTime.now().toString();
    data["Phone"]=await getString(UserPreferences.USER_NUMBER);
    data["College"]=await getString(UserPreferences.COLLEGE);
    data["ImageUrlTime"] = DateTime.now().millisecondsSinceEpoch.toString();

    await mRootReference
        .child("Feeds")
        .child(subId)
        .child(id)
        .update(data);
    HashMap<String, dynamic> PostLink = HashMap<String, dynamic>();
    PostLink["id"]=id;
    PostLink["Description"] = description.text;
    PostLink["ImageUrl"] = imageUrl;
    PostLink['ToPublish'] = selectedItem!.id;
    await mRootReference
        .child("UsersList")
        .child(await getString(UserPreferences.COLLEGE))
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(await getString(UserPreferences.DESIGNATION))
        .child('Post').child(id).update(PostLink);

    Future.delayed(const Duration(seconds: 1), () {
      finishAccountCreation(designationU=='Admin'?AdminBottomNavigation():BottomNavigation(), context);
    });

    // await
    // referenceRoot.child("Test")
    //     .child("Images").push().update(data);
  }

  getDataF1() async {
    final college = await getString(UserPreferences.COLLEGE);
    final number = await getString(UserPreferences.USER_NUMBER);
    final designation = await getString(UserPreferences.DESIGNATION);
    if (college == null || number == null || designation == null) return;
    mRootReference
        .child("UsersList")
        .child(college)
        .child(number)
        .child(designation)
        .once()
        .then((value) {
      if (value.snapshot.exists && value.snapshot.value is Map) {
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        UserName = (data["Name"] ?? '').toString();
        College = (data["College"] ?? '').toString();
        Designation = (data["Designation"] ?? '').toString();
        ProfileImage = (data['ImageUrl'] ?? '').toString();
        if (mounted) {
          setState(() {});
        }
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

  Future<void> _pickAndCropImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: MyColors.Colorgreen3,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (cropped == null) return;

    if (!mounted) return;
    setState(() {
      file = XFile(cropped.path);
      imageUrl = '';
      _isUploading = true;
    });

    final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final referenceImageToUpload =
        FirebaseStorage.instance.ref().child('images').child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(cropped.path));
      final url = await referenceImageToUpload.getDownloadURL();
      if (!mounted) return;
      setState(() {
        imageUrl = url;
        _isUploading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
      });
      alertDialog(
        context,
        "Upload Failed",
        "Could not upload image to Firebase Storage: $error",
      );
    }
  }

  void showAlertDialogCamera(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Photo",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Choose how you want to upload an image",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                dialogOptionRow(
                  icon: Icons.camera_alt_outlined,
                  title: "Take a Photo",
                  subtitle: "Capture using device camera",
                  onTap: () async {
                    Navigator.of(dialogContext).pop();
                    await _pickAndCropImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 10),
                dialogOptionRow(
                  icon: Icons.photo_library_outlined,
                  title: "Choose from Gallery",
                  subtitle: "Pick an image from your photos",
                  onTap: () async {
                    Navigator.of(dialogContext).pop();
                    await _pickAndCropImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget ListChange(int index){
    return Container(
      child:Padding(
        padding: const EdgeInsets.only(left:15.0,right:15,top:10,bottom:10),
        child:  Text(datalist[index].id,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
      ),
    );
  }

}
