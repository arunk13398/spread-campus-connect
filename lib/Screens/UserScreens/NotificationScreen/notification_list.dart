import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Screens/UserScreens/NotificationScreen/publish_notification.dart';
import 'package:chip_list/chip_list.dart';
import '../../../Contraints/user_preference.dart';
import '../../../Model/notification_model.dart';


class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<NotificationModel> notificationList = [];

  String Uid='';
  String Designation = '';
  String access="Teacher";
  String College = '';
  String _categoryDpValue = 'General';
  var _category = ['Student', 'Teacher', 'NonTeachingStaff', 'OtherEmployees', 'Alumni', 'Others','General'];


  void initState(){
    getDataAccess();
    loadNotification();
    checkRealtimeConnection();
    super.initState();
}
  bool isConnected = false;
  var size,height,width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0,top:20,bottom:15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Notifications",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue),
                  ),
                ),
              ),
              // Text('Using extraOnToggle: ${_menuItems[_currentIndex]}'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: width/1.1,
                  height: 45,
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
                      padding: const EdgeInsets.only(left:12.0,right:20),
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
                              padding: const EdgeInsets.only(left:10.0,right:10),
                              child: Text(items),
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            _categoryDpValue = newValue!;
                            loadNotification();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child:
                Container(
                  // height: 120,
                  child: ListView.builder(
                    itemCount: notificationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return NotificationAdaptor(index);
                    },
                  ),
                )
                // isConnected==true?:Center(child:Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Image.asset("assets/wrong.jpg"),
                //     Text("No Internet")
                //   ],
                // ),)
              ),



              Designation==access?Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom:20.0,right:10),
                  child: SizedBox(
                    width: 145,
                    child: MaterialButton(
                      height:45,
                      minWidth: 145,
                      color:Colors.blue,
                      splashColor: Colors.green,
                     shape:RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(30)
                     ),
                     onPressed: (){
                       Navigator.push(context,
                           MaterialPageRoute(
                               builder: (context) => PublishNotification()));
                       // Navigator.of(context).deactivate();
                     },

                    child: Row(
                      children: [
                        Icon(Icons.notifications_none,color: Colors.white,), SizedBox(width: 6,),
                        Text("Publish new",style:TextStyle(fontSize: 17,color:Colors.white,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ),
                  ),
                ),
              ) :Container(),
              // Padding(
              //   padding: const EdgeInsets.only(bottom:20.0,right:20),
              //   child: Align(
              //     alignment: Alignment.bottomRight,
              //     child: Container(
              //       width:130,
              //         height: 40,
              //         decoration: BoxDecoration(color:Colors.blue,
              //           borderRadius: BorderRadius.circular(60),
              //         ),
              //         child:Row(
              //           children: [
              //             SizedBox(width: 10,),
              //             Icon(Icons.notifications_none,color: Colors.white,),
              //             Padding(
              //               padding: const EdgeInsets.only(left:6.0,right:10),
              //               child: Text("Publish new",style:TextStyle(fontSize: 17,color:Colors.white,fontWeight: FontWeight.bold)),
              //             )
              //           ],
              //         )
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }


  Widget NotificationAdaptor(int index) {
    // int index  in function
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5, bottom: 5),
      child: Card(
        color: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          child: ExpandableNotifier(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "https://th.bing.com/th/id/R.40deba34f6c2decf532724c4c03f4fc4?rik=DmIMwHsFZgTrNw&riu=http%3a%2f%2fimg.doooor.com%2fimg%2fforum%2f201412%2f02%2f141955p15dugfkga555fcf.jpg&ehk=WtRMuE8T84Y04XeZy%2fCihE5BF1EwBS9p9QoEqnvYHXA%3d&risl=&pid=ImgRaw&r=0",
                              height: 50,
                              width: 60,
                              fit: BoxFit.cover,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width:width/1.5,
                                child: Text(notificationList[index].subject,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                notificationList[index].designation,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ScrollOnExpand(
                      scrollOnExpand: true,
                      scrollOnCollapse: true,
                      child: ExpandablePanel(
                        theme: const ExpandableThemeData(
                          expandIcon: CupertinoIcons.arrow_down_right_arrow_up_left,
                          iconSize: 22,
                          iconColor: Colors.blue,
                          headerAlignment: ExpandablePanelHeaderAlignment.center,
                          tapBodyToCollapse: true,
                        ),
                        header: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Notification content",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                        collapsed: Text(
                            notificationList[index].notificationContent,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.justify,
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        expanded: Column(
                          children: [
                            Text(notificationList[index].notificationContent,
                                 style: TextStyle(fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.justify,
                                softWrap: false,
                                maxLines: 50,
                                overflow: TextOverflow.ellipsis),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                // child: Padding(
                                //   padding: const EdgeInsets.all(10.0),
                                //   child: Text("Pdf View",
                                //       style: TextStyle(
                                //           color: Colors.white,
                                //           fontWeight: FontWeight.bold)),
                                // ),
                              ),
                            )
                          ],
                        ),
                        builder: (_, collapsed, expanded) {
                          return Padding(
                            padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            child: Expandable(
                              collapsed: collapsed,
                              expanded: expanded,
                              theme: const ExpandableThemeData(crossFadePoint: 0),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }


  getDataAccess() async {
    // numberId = (await getString(UserPreferences.USER_NUMBER));
    // UserName = (await getString(UserPreferences.USER_Name));
    // College = (await getString(UserPreferences.COLLEGE));
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
        setState(() {});
      }
    });
  }
  loadNotification() {

    mRootReference.child("Notification").child("GECWayanad").child(_categoryDpValue).onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      notificationList.clear();
      data.forEach((key, value) {
        notificationList.add(NotificationModel(
          id: key,
          college: value['College'],
          designation: value['designation'],
          name: value['Name'],
          notificationContent: value['NotificationContent'],
          subject: value['Subject'],


          // rAdmNumber: value['AdmissionNo'],
          // rClgNo: value['RegisterNo'],
          // rCmptText: value['Complaint'],
          // rDate: value['Date'],
          // rMobNumber: value['MobileNumber'],
          // rName: value['Name'],
          // rSubject: value['Subject'],
          // rTo: value['To'],
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


}


// class PdfImageAdaptor extends StatelessWidget {
//   const PdfImageAdaptor({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network("https://th.bing.com/th/id/R.40deba34f6c2decf532724c4c03f4fc4?rik=DmIMwHsFZgTrNw&riu=http%3a%2f%2fimg.doooor.com%2fimg%2fforum%2f201412%2f02%2f141955p15dugfkga555fcf.jpg&ehk=WtRMuE8T84Y04XeZy%2fCihE5BF1EwBS9p9QoEqnvYHXA%3d&risl=&pid=ImgRaw&r=0",
//                       height: 80,width:80,
//                       fit: BoxFit.cover,)),
//                 Padding(
//                   padding: const EdgeInsets.only(left:10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Section infomation",style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),),
//                       SizedBox(height: 5,),
//                       Text("information of the content breifly",
//                         style: TextStyle(
//                           fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color:Colors.red,
//                           ),
//                           child:Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Text("View",style:TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold
//                             )),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

