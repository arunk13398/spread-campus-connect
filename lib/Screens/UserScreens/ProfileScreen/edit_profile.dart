import 'dart:collection';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniq/Theme/theme.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/listdata_model.dart';
import '../../../functions/functions.dart';
import '../../bottom_navigation.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ListDataModel> datalist=[];
  GlobalKey key = GlobalKey();
  ListDataModel?selectedItem;

  XFile? file;
  String imageUrl = '';
  String numberId='';
  String UserName='';
  String College='';
  String Designation='';
  String AccessName='';
  String Phone='';
  String access='';
  String UserType='';
  String Status='';

  bool _isChecked = false;
  bool _isChecked1 = false;

  var orientation, size, height, width;

  final UserNameController = TextEditingController();
  final UserDesignationController = TextEditingController();
  final UserCollegeController = TextEditingController();
  final UserNumberController = TextEditingController();


  @override
  void initState() {
    getDataF1();
    getdata();
    loadItem();
    getDataAccess();
    super.initState();
  }

  getDataAccess() async {
    College = (await getString(UserPreferences.COLLEGE));
    Designation = (await getString(UserPreferences.DESIGNATION));
    mRootReference
        .child("AccessControl")
        .child(await getString(UserPreferences.USER_NUMBER))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("fffffff ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        College = data["College"];
        Designation = data["Designation"];
        UserType = data["AcessName"];
        Status = data["Status"];
        setState(() {});
      }
    });
  }

  getDataF1() async {
    mRootReference
        .child("UsersList").child(await getString(UserPreferences.COLLEGE))
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(await getString(UserPreferences.DESIGNATION))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        UserCollegeController.text = data["College"];
        UserDesignationController.text = data["Designation"];
        UserNameController.text=data["Name"];
        UserNumberController.text = data["Phone"];
        AccessName = data["AcessName"];
        imageUrl=data['ImageUrl'];
        setState(() {});
      }
    });
  }

  loadItem() async {
    mRootReference.child("AccessManagement").child("Designation").child(await getString(UserPreferences.DESIGNATION)).child("Access").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      datalist.clear();
      data.forEach((key, value) {
        datalist.add(ListDataModel(
          id: key,
        ));
      });
      setState(() {});
    });
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
              children: [
                InkWell(
                  onTap: () async {

                    if(Status=="blocked"){
                      showAlertDialogBloked(context);
                    }else{
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
                      mRootReference.child('images').child('ProfileImage');

                      Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueFileName);
                      try {
                        await referenceImageToUpload
                            .putFile(File(file!.path));
                        imageUrl =
                        await referenceImageToUpload.getDownloadURL();
                      } catch (error) {}
                    }
                  },
                  child:
                  imageUrl!=""?CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => const CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 100,
                    ),
                    imageBuilder: (context, image) => CircleAvatar(
                      backgroundImage: image,
                      radius: 100,
                    ),
                  ):
                  CachedNetworkImage(
                    imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                    placeholder: (context, url) => const CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 100,
                    ),
                    imageBuilder: (context, image) => CircleAvatar(
                      backgroundImage: image,
                      radius: 100,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                      child: Align(alignment: Alignment.centerLeft,
                          child: Text("Personal details -",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey,fontSize: 17))),
                    ),
                    Spacer(),
                    Status=="blocked"?Container():
                    Container(
                      width:120,height:50,
                      child: CheckboxListTile(
                        activeColor: Colors.blue,
                        title: Text("Edit?",style: TextStyle( color: Colors.grey,fontSize: 14),),
                        value: _isChecked1,
                        onChanged: (val) {
                          setState(() {
                            _isChecked1 = val!;
                          });
                        },
                      ),
                    ),
                  ],
                ),


                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                  child: TextFormField(
                    enabled: _isChecked1,
                    controller: UserNameController,
                    decoration: InputDecoration(
                      border:  OutlineInputBorder(),
                      labelText: 'First name',
                      hintText: 'First name',
                      prefixIcon: Icon(Icons.person_outlined,
                          size: 20,
                          color: Colors.blue.shade300),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300, width: 1.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  Colors.green, width: 1.2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                  child: TextFormField(
                    enabled: _isChecked1,
                    controller: UserNumberController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Mobile number',
                      hintText: '+91 mobile number',
                      prefixIcon: Icon(Icons.call,
                          size: 20,
                          color: Colors.blue.shade300),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300, width: 1.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  Colors.green, width: 1.2),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                  child: TextFormField(
                    enabled: false,
                    controller: UserCollegeController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'College',
                      hintText: 'College',
                      prefixIcon: Icon(Icons.location_on_outlined,
                          size: 20,
                          color: Colors.blue.shade300),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300, width: 1.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  Colors.green, width: 1.2),
                      ),
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                  child: TextFormField(
                    enabled: false,
                    controller: UserDesignationController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'designation',
                      hintText: 'Designation',
                      prefixIcon: Icon(Icons.signpost_outlined,
                          size: 20,
                          color: Colors.blue.shade300),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade300, width: 1.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  Colors.green, width: 1.2),
                      ),
                    ),
                  ),
                ),
                _isChecked1==true?Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20, right: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: MaterialButton(
                        onPressed: () {
                          addCustomer();
                          print("gguuggugu${UserCollegeController.text}");
                        },
                        textColor: Colors.white,
                        color: MyColors.Colorgreen3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 18,color: Colors.white,),
                        )),
                  ),
                ):Container(),
                AccessName=="Admin"||access=="2"?
                Container():Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 5,),
                      child: CheckboxListTile(
                        activeColor: Colors.blue,
                        title: Text("Change to the Account access?",style: TextStyle( color: Colors.grey,fontSize: 14),),
                        value: _isChecked,
                        onChanged: (val) {
                          setState(() {
                            _isChecked = val!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:15,right: 15),
                      child: Text("wait until the admin verification, page have more than features and responsibilities to others",
                          style: TextStyle( color: Colors.grey,fontSize: 16),textAlign: TextAlign.center),
                    ),

                    _isChecked==true?Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Spacer(),
                              Text("Select your appropriate option"),
                              Spacer(),
                              Container(
                                width: 150,
                                height: 40,
                                decoration:BoxDecoration(
                                    color:Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: Colors.grey.shade50,
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
                                          // CategoryloadNotification();
                                          // getDataF1(hashCode);
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20, right: 20),
                          child: SizedBox(
                            width: 150,
                            height: 35.0,
                            child: MaterialButton(
                                onPressed: () async {
                                  await  PageRequest().then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      backgroundColor: Colors.greenAccent,
                                      content: Center(
                                        child: Text(
                                          "Successful",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ));
                                    // newListController.clear();
                                    // description.clear();

                                  });
                                },
                                // onPressed: () {
                                //   PageRequest();
                                //   print("gguuggugu${UserCollegeController.text}");
                                // },
                                textColor: Colors.white,
                                color: MyColors.Colorgreen3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Center(
                                  child: const Text(
                                    "Requst to admin",
                                    style: TextStyle(fontSize: 15,color: Colors.white,),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ):SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addCustomer() async {
    String id = await getString(UserPreferences.USER_NUMBER);
    String id1 = await getString(UserPreferences.DESIGNATION);
    String id2 = await getString(UserPreferences.COLLEGE);

    HashMap<String, dynamic> updateData = HashMap<String, dynamic>();
    updateData["Name"] = UserNameController.text;
    updateData["Phone"] = UserNumberController.text;
    updateData["College"] =UserCollegeController.text;
    updateData["Designation"] =UserDesignationController.text;
    updateData["ImageUrl"] = imageUrl;


    HashMap<String, dynamic> updateAcsessControl = HashMap<String, dynamic>();
    updateAcsessControl["Name"] = UserNameController.text;
    updateAcsessControl["Phone"] = UserNumberController.text;
    updateAcsessControl["College"] =UserCollegeController.text;
    updateAcsessControl["Designation"] =UserDesignationController.text;
    updateAcsessControl["ImageUrl"] = imageUrl;


    await mRootReference.child("UsersList").child(id2).child(id).child(id1).update(updateData);
    await mRootReference.child("AccessControl").child(id).update(updateAcsessControl);

    setString(UserPreferences.USER_Name,UserNameController.text.toString());
    setString(UserPreferences.COLLEGE,UserCollegeController.text.toString());
    setString(UserPreferences.DESIGNATION,UserDesignationController.text.toString());
    setString(UserPreferences.USER_NUMBER,UserNumberController.text.toString());


    Future.delayed(const Duration(seconds: 1), () {
      finishAccountCreation( BottomNavigation(), context);
    });
  }
  Future<void> PageRequest() async {

    String id = await getString(UserPreferences.USER_NUMBER);
    String id1 = await getString(UserPreferences.DESIGNATION);
    String id2 = await getString(UserPreferences.COLLEGE);

    HashMap<String, dynamic> updateData = HashMap<String, dynamic>();
    updateData["id"] = id;
    updateData["Name"] = UserNameController.text;
    updateData["Phone"] = UserNumberController.text;
    updateData["College"] =UserCollegeController.text;
    updateData["Designation"] =UserDesignationController.text;
    updateData["RequestTo"] =selectedItem!.id;
    updateData["ImageUrl"] = imageUrl;
    await mRootReference.child("PageRequest").child(id)
        // .child(id).child(id1)
        .update(updateData);
  }
  getdata() async {
    AccessName= await getString(UserPreferences.USER_Name);
    access=   await getString(UserPreferences.ACCESS_CODE);
  }
}
