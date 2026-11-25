import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Theme/theme.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/listdata_model.dart';
import '../../../functions/functions.dart';
import '../../bottom_navigation.dart';
import 'complaint_list.dart';

class ComplaintRegistration extends StatefulWidget {
  const ComplaintRegistration({Key? key}) : super(key: key);

  @override
  State<ComplaintRegistration> createState() => _ComplaintRegistrationState();
}

class _ComplaintRegistrationState extends State<ComplaintRegistration> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  String _collegeDpValue = 'Office';
  var _college = ['Office', 'Hod','Principal','Admin',];
  String numberId = '';
  String UserName = '';
  String Department = '';
  String Designation = '';

  final RegName = TextEditingController();
  final RegMobNumber = TextEditingController();
  TextEditingController RegClgNo = TextEditingController();
  TextEditingController RegAdmNumber = TextEditingController();
  TextEditingController RegTo = TextEditingController();
  TextEditingController RegSubject = TextEditingController();
  TextEditingController RegCmptText = TextEditingController();
  List<ListDataModel> datalist=[];
  ListDataModel?selectedItem;

  @override void initState() {
    loadItem();
    getData();
    super.initState();
  }
  loadItem() async {
    mRootReference.child("AccessManagement").child("Complaint").onValue.listen((event) {
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
        datalist = _college.map((c) => ListDataModel(id: c)).toList();
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
    // size = MediaQuery.of(context).size;
    // height = size.height;width = size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //    backgroundColor: MyColors.theme1,
        //   title: Text("Register form"),
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Register form",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color:MyColors.Colorgreen3),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: RegName,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color:MyColors.Colorgreen3),
                      hintText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.6),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 13,
                    controller: RegMobNumber,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Mobile number',
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color:MyColors.Colorgreen3),
                      hintText: 'Mobile number',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.6),
                      ),
                    ),
                  ),
                ),

                Designation=="Student"?
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: RegClgNo,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'College register number',
                              hintText: 'College register number',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color:MyColors.Colorgreen3),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.6),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: RegAdmNumber,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'College admission number',
                              hintText: 'College admission number',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color:MyColors.Colorgreen3),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ):
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: RegClgNo,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'College Id proof no',
                      hintText: 'College Id proof no',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color:MyColors.Colorgreen3),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.black, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.6),
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    SizedBox(width:10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("To",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 300,
                        height: 55,
                        decoration:BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(5),
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
                                  // loadNotification();
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: RegSubject,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Subject header',
                      hintText: 'Subject header',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color:MyColors.Colorgreen3),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Complaint text",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:MyColors.Colorgreen3),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    child: TextFormField(
                      controller: RegCmptText,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Subject',
                        hintText: 'Subject',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color:MyColors.Colorgreen3),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.6),
                        ),
                      ),
                      maxLines: 100,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(
                        onPressed: () async {
                          await AddComplaint().then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: Colors.grey,
                              content: Text(
                                "Successful",
                                style: TextStyle(color: Colors.black),
                              ),
                            ));
                            ClearData();
                            // finish(context);
                          });
                        },
                        textColor: Colors.white,
                        color:MyColors.Colorgreen3,
                        minWidth: double.infinity,
                        height: 60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Text(
                          "Submit Complaint",
                          style: TextStyle(
                              fontSize: 18, color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  getData() async {
    RegMobNumber.text = (await getString(UserPreferences.USER_NUMBER)) ?? '';
    RegName.text = (await getString(UserPreferences.USER_Name)) ?? '';
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
        RegName.text = (data["Name"] ?? '').toString();
        Designation = (data["Designation"] ?? '').toString();
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  ClearData(){
     RegName.clear();
     RegMobNumber.clear();
     RegClgNo.clear();
     RegAdmNumber.clear();
     RegTo.clear();
     RegSubject.clear();
     RegCmptText.clear();

  }

  Future<void> AddComplaint() async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();

    String id1 = DateTime.now().millisecondsSinceEpoch.toString();
    // print("gggggggg"+imageUrl);
    String id = RegMobNumber.text;
    data["Id"] = RegMobNumber.text;
    data["Name"] = RegName.text;
    data["MobileNumber"] = RegMobNumber.text;

    if(Designation=="Student"){
      data["RegisterNo"] = RegClgNo.text;
      data["AdmissionNo"] = RegAdmNumber.text;
      data["IdProof"] = "0000";
    }else{
      data["IdProof"] = RegClgNo.text;
      data["RegisterNo"] = "NA0000";
      data["AdmissionNo"] = "NA0000";
    }

    data["To"] = selectedItem!.id;
    data["Subject"] = RegSubject.text;
    data["Complaint"] = RegCmptText.text;
    data["Status"] = "Processing";

    // data["UserName"] = username;
    data["Date"] = DateTime.now().toString();
    data["Time"] = DateTime.now().millisecondsSinceEpoch.toString();

    await mRootReference.child("Complaints").child(id).child(id1).update(data);
    await mRootReference.child("Complaints").child("AdminAccess").child(selectedItem!.id).child(id1).update(data);

  }
}

