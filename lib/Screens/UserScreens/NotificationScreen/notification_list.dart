import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Screens/UserScreens/NotificationScreen/publish_notification.dart';
import 'package:chip_list/chip_list.dart';
import '../../../Contraints/user_preference.dart';
import '../../../Model/listdata_model.dart';
import '../../../Model/notification_model.dart';
import '../../../Theme/theme.dart';


class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<NotificationModel> notificationList = [];
  List<ListDataModel> datalist=[];

  int isColorSelected=0;

  String Uid='';
  String Designation = '';
  String access="Teacher";
  String access1="Admin";
  String College = '';
  String _categoryDpValue = 'General';
  String UserType='';
  String Status='';

  ListDataModel?selectedItem;


  void initState(){
    loadItem();
    getDataAccess();
    loadNotification(hashCode);
    checkRealtimeConnection();
    super.initState();
    // print("etetetettete${selectedItem}");

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
                        color: MyColors.Colorgreen3,),
                  ),
                ),
              ),

              Padding(
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



              UserType=="Hod"||UserType=="Principal"||UserType=="Publisher"||UserType=="OfficeStaff"?
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom:20.0,right:10),
                  child: SizedBox(
                    width: 145,
                    child:Status=="blocked"?Container():
                    MaterialButton(
                      height:45,
                      minWidth: 145,
                      color:MyColors.Colorgreen2,
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
                        Text("Publish new",style:TextStyle(fontSize: 15,color:Colors.white,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ),
                  ),
                ),
              ) :Container(),

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
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          child: ExpandableNotifier(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height:5),
                    Row(
                      children: [
                        SizedBox(width:5),
                        notificationList[index].ProfileImg!=""?
                        CachedNetworkImage(
                          imageUrl: notificationList[index].ProfileImg,
                          placeholder: (context, url) => const CircleAvatar(
                            backgroundColor: MyColors.ColorGreen1,
                            radius: 15,
                          ),
                          imageBuilder: (context, image) => CircleAvatar(
                            backgroundImage: image,
                            radius: 15,
                          ),
                        ):
                        CachedNetworkImage(
                          imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                          placeholder: (context, url) => const CircleAvatar(
                            backgroundColor: MyColors.ColorGreen1,
                            radius: 15,
                          ),
                          imageBuilder: (context, image) => CircleAvatar(
                            backgroundImage: image,
                            radius: 15,
                          ),
                        )
                        ,

                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width:width/1.5,
                                child: Text(notificationList[index].subject,
                                  style: TextStyle(
                                    fontSize: 16,
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
                                  color: MyColors.Colorgreen2,
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
                          iconSize: 15,
                          iconColor: Colors.grey,
                          headerAlignment: ExpandablePanelHeaderAlignment.center,
                          tapBodyToCollapse: true,
                        ),
                        header: Padding(
                            padding: EdgeInsets.only(left:5,right:5),
                            child: Text(
                              "Notification content",
                              style: TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                        collapsed: Text(notificationList[index].notificationContent,
                            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                            textAlign: TextAlign.justify,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        expanded: Column(
                          children: [
                            Text(notificationList[index].notificationContent,
                                 style: TextStyle(fontSize: 15, color: Colors.black),
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

  loadItem() async {

    mRootReference.child("AccessManagement").child("Designation").child(await getString(UserPreferences.DESIGNATION)).child("Notifications").onValue.listen((event) {
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

  loadNotification(int index) async {
    String NewItem="Designation";
    if(isColorSelected==0){
      NewItem=await getString(UserPreferences.DESIGNATION);
    }else{
      NewItem=datalist[index].id;
    }
    mRootReference.child("Notification").child(await getString(UserPreferences.COLLEGE)).child(NewItem).onValue.listen((event) {
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
          ProfileImg: value['UserProfileImage'],

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

  Widget AdaptorNew(int index){
    return Container(
      child: Center(
        child:Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: (){
              setState(() {
                isColorSelected=index;
                loadNotification(index);
                // getDataF1(index);
              });
            },
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
          ),
        ),),
    );
  }


}

