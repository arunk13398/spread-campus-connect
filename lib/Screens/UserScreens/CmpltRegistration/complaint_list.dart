import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../../Contraints/user_preference.dart';
import '../../../Model/complaint_model.dart';
import '../../../Model/listdata_model.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import 'Complaint_details.dart';
import 'complaint_registration.dart';
import 'package:firebase_database/firebase_database.dart';

class ComplaintList extends StatefulWidget {
   ComplaintList({Key? key,}) : super(key: key);
  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<ComplaintModel> ComplaintList = [];
  List<ComplaintModel> ComplaintListReview = [];
  List<ListDataModel> datalist=[];
  List<ListDataModel> datalistAccess=[];


  var size, height, width;
  String Uid = '';
  String username = '';
  bool isConnected = false;

  String numberId='';
  String UserName='';
  String College='';
  String Designation='';
  String imageUrl='';
  String access='';
  String UserType='';
  String Status='';

  String checkData='';

  int isColorSelected=0;


  @override
  void initState() {
    getDataAccess();
    loadItem();
    loadItemAccess();
    if(isColorSelected==0){
      loadComplaint2();
    }else{
      loadComplaint1();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return
      Scaffold(
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

            if(UserType=="Principal"||UserType=="Hod"||UserType=="Admin"||UserType=="Hos"||UserType=="OfficeStaff"||UserType=="Reviewer")Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height:50,width:width/1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: datalist.length,
                  itemBuilder: (context, index) => AdaptorNew(index),
                ),
              ),
            ),

            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: ComplaintList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ComplaintListAdaptor(index);
                  },
                ),
              )

            ),
            Designation=='Alumni'||Status=="blocked"?Container():Padding(
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
                child: Text("Register any Complaint",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadComplaint1() async {
    Designation = await getString(UserPreferences.DESIGNATION);
    numberId = await getString(UserPreferences.USER_NUMBER);
    // UserType = (await getString(UserPreferences.ACCESSTYPE));
    mRootReference.child("Complaints").child(numberId).onValue.listen((event) {
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
          rStatus: value['Status'],
        ));
      });
      setState(() {});
    });
  }



  loadComplaint2() async {

    Designation = await getString(UserPreferences.DESIGNATION);
    UserType = (await getString(UserPreferences.ACCESSTYPE));

    print("testing usertype****************${UserType}");
    mRootReference.child("Complaints").child("AdminAccess").child(UserType).onValue.listen((event) {
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
          rStatus: value['Status'],
        ));
      });
      setState(() {});
    });


  }

  Widget ComplaintListAdaptor(int index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          print("testing designation${Designation}");
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:Border.all(color: Colors.grey.shade300,width: 1,)
          ),
          child:Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                SizedBox(
                  width: width / 1.1,
                  child: Row(
                    children: [
                      // SizedBox(width:5),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            "https://www.aais.com/hs-fs/hubfs/coming_soon_placeholder-01.jpg?width=4000&name=coming_soon_placeholder-01.jpg",
                            // list[index].imageUrl,
                            height: 30,
                            width: 30,
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
                      SizedBox(width:5),
                      SizedBox(
                        width: width / 1.4,
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:5.0,top:10),
                              child: Row(
                                children: [
                                  Text("Posted from "),
                                  Text(ComplaintList[index].rName,style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
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
                      SizedBox(width:5),
                      SizedBox(
                        width: width / 1.55,
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
                                  Text(ComplaintList[index].rStatus,
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        color: ComplaintList[index].rStatus=="Rejected"?Colors.red:Colors.black),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5),
                          child: MaterialButton(
                            onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ComplaintDetails(complaintModel: ComplaintList[index],)));
                          },
                            color: MyColors.Colorgreen2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
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
      ),
    );
  }

  getDataAccess() async {
    College = (await getString(UserPreferences.COLLEGE));
    // UserType = (await getString(UserPreferences.ACCESSTYPE));
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
        numberId =data["Phone"];
        setState(() {});
      }
    });
  }


  loadItem() async {
    mRootReference.child("AccessManagement").child("ComplaintAccess").onValue.listen((event) {
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

  loadItemAccess() async {
    mRootReference.child("AccessManagement").child("Complaint").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      datalistAccess.clear();
      data.forEach((key, value) {
        datalistAccess.add(ListDataModel(
          id: key,
        ));
      });
      setState(() {});
    });
  }

  Widget AdaptorNew(int index){
    return InkWell(
      onTap: (){
        setState(() {
         if( datalist[index].id=="ToReview"){
           loadComplaint2();
         }else{
           loadComplaint1();

         }
          isColorSelected=index;
        });
      },

      child: Container(
        child: Center(
          child:Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                decoration: BoxDecoration(
                    color: isColorSelected==index?MyColors.Colorgreen2:Colors.white,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:15.0,right:15,top:7,bottom:7),
                  child: Text(datalist[index].id,
                    style: TextStyle(color: isColorSelected==index?Colors.white:Colors.black,fontSize: 16),),
                )),
          ),),
      ),
    );
  }

}
