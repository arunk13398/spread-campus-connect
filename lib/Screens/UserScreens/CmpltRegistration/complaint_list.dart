import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/complaint_model.dart';
import '../../../Theme/theme.dart';
import 'Complaint_details.dart';
import 'complaint_registration.dart';
import 'package:firebase_database/firebase_database.dart';

class ComplaintList extends StatefulWidget {
  const ComplaintList({Key? key}) : super(key: key);

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ComplaintModel> ComplaintList = [];
  var size, height, width;
  String Uid = '';
  String username = '';
  bool isConnected = false;
  @override
  void initState() {
    // TODO: implement initState
    loadComplaint();
    checkRealtimeConnection();
    // getData();
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:10.0,top:15,bottom:20),
              child: Align(alignment: Alignment.topLeft,
                child: Text(
                  "Registered Complaints",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: Container(
                // height: 120,
                child: ListView.builder(
                  itemCount: ComplaintList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ComplaintListAdaptor(index);
                  },
                ),
              )

            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ComplaintRegistration()));
              },
                color: MyColors.Colorgreen3,
                minWidth: double.infinity,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text("Register new Complaint",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: MaterialButton(onPressed: () {
            //     // Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(
            //     //         builder: (context) =>
            //     //             ComplaintRegistration()));
            //   },
            //     color: Colors.blue,
            //     minWidth: double.infinity,
            //     height: 60,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(5)
            //     ),
            //     child: Text("Review complaint",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
  getData() async {
    Uid = (await getString(UserPreferences.USER_NUMBER));
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
  loadComplaint() {

    mRootReference.child("Complaints").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      ComplaintList.clear();
      data.forEach((key, value) {
        ComplaintList.add(ComplaintModel(
          id: key,
          rAdmNumber: value['AdmissionNo'],
          rClgNo: value['RegisterNo'],
          rCmptText: value['Complaint'],
          rDate: value['Date'],
          rMobNumber: value['MobileNumber'],
          rName: value['Name'],
          rSubject: value['Subject'],
          rTo: value['To'],
        ));
      });
      setState(() {});
    });
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

  Widget ComplaintListAdaptor(int index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border:Border.all(color: Colors.grey.shade300,width: 1,)
        ),
        child:Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                width: width / 1.1,
                child: Row(
                  children: [
                    SizedBox(width:15),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          "https://www.aais.com/hs-fs/hubfs/coming_soon_placeholder-01.jpg?width=4000&name=coming_soon_placeholder-01.jpg",
                          // list[index].imageUrl,
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(
                      width: width / 1.4,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5),
                            child: Text(ComplaintList[index].rSubject,
                                // list[index].username,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.start),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width / 1,
                child: Row(
                  children: [
                    SizedBox(width:15),
                    SizedBox(
                      width: width / 1.5,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:5.0,top:10),
                            child: Row(
                              children: [
                                Text("Posted to "),
                                Text(ComplaintList[index].rTo,style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 5),
                      child: Text(
                        "1 mint ago",
                        // list[index].username
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width / 1,
                child: Row(
                  children: [
                    SizedBox(width:15),
                    SizedBox(
                      width: width / 1.8,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:5.0,top:10),
                            child: Row(
                              children: [
                                Text("Date"),
                                Text(" 12/2/2022",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:5.0,top:3),
                            child: Row(
                              children: [
                                Text("Status :"),
                                Text("Progress",style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 5),
                        child: MaterialButton(onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ComplaintDetails(complaintModel: ComplaintList[index],)));
                        },
                          color: MyColors.Colorgreen2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text("Details",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
