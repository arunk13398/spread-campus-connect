import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:miniq/Screens/AdminScreen/TestPagesAkshy/complaintregistration.dart';

import '../../../Model/feed_model.dart';
import '../../../Theme/theme.dart';
import '../../../functions/camera.dart';
import '../../../functions/functions.dart';
import '../../../functions/widgets.dart';

class FeedManagePage extends StatefulWidget {
  const FeedManagePage({Key? key}) : super(key: key);

  @override
  State<FeedManagePage> createState() => _FeedManagePageState();
}

class _FeedManagePageState extends State<FeedManagePage> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<FeedModel> list = [];
  String access="Teacher";
  String College = '';
  String _categoryDpValue = 'General';
  var _category = ['Student', 'Teacher', 'NonTeachingStaff', 'OtherEmployees', 'Alumni', 'Others','General'];


  void initState() {
    load();
    super.initState();
  }
  @override
  var size,height,width;
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.Colorgreen3,
          onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => Camera()));
        },
          child: Icon(Icons.camera_alt_outlined),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0,top:20,bottom:15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "All Feeds",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,),
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
                            // loadNotification();
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
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Adaptordesign(index);
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



              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom:20.0,right:10),
              //     child: SizedBox(
              //       width: 145,
              //       child: MaterialButton(
              //         height:45,
              //         minWidth: 145,
              //         color:MyColors.Colorgreen2,
              //         splashColor: Colors.green,
              //         shape:RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(30)
              //         ),
              //         onPressed: (){
              //           Navigator.push(context,
              //               MaterialPageRoute(
              //                   builder: (context) => Camera()));
              //           // Navigator.of(context).deactivate();
              //         },
              //
              //         child: Row(
              //           children: [
              //             Icon(Icons.camera_alt_outlined,color: Colors.white,), SizedBox(width: 6,),
              //             Text("Post Image",style:TextStyle(fontSize: 17,color:Colors.white,fontWeight: FontWeight.bold)),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }

  Widget Adaptordesign(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Container(
          width: width/1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Slidable(
                // enabled: false,
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),
                endActionPane:  ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: ( context) {
                        showAlertDialog(context,index);
                      },
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    child:CachedNetworkImage(
                      height: height/6,
                      width: width/2.10,
                      imageUrl: list[index].imageUrl,
                      placeholder: (context, url) =>
                          getShimmerLoading(),
                      imageBuilder: (context, image) => ClipRRect(borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: height/6,
                          width: width/2,
                          fit: BoxFit.cover,
                          imageUrl: list[index].imageUrl,
                          placeholder: (context, url) => getShimmerLoading(),),
                      ),
                    ),
                  ),
                ),
              ),
              // list[index].description
              SizedBox(
                width:width/2.32,
                height: height/6,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          list[index].profImg==''?
                          CachedNetworkImage(
                            imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                            placeholder: (context, url) =>  CircleAvatar(
                              backgroundColor: Colors.blue.shade300,
                              radius: 20,
                            ),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 20,
                            ),
                          ):
                          CachedNetworkImage(
                            imageUrl: list[index].profImg,
                            placeholder: (context, url) =>  CircleAvatar(
                              backgroundColor: Colors.blue.shade300,
                              radius: 20,
                            ),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 20,
                            ),
                          ),
                          SizedBox(
                            width:width/3.45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 5),
                                  child: Text(
                                      list[index].userName,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.start),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 5),
                                  child: Text(
                                    list[index].desigUser,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey),
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height/9.92,
                        child: Padding(
                          padding: const EdgeInsets.only(top:8.0),
                        child: Text( list[index].description,
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.justify,
                              softWrap: false,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  load() async {
    mRootReference.child("Feeds").child("Public").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      list.clear();
      data.forEach((key, value) {
        list.add(FeedModel(
          id: key,
          userName: value['UserName'],
          desigUser: value['Designation'],
          description: value['Description'],
          imageUrl: value['ImageUrl'],
          UpdatedTime: value['ImageUrlTime'],
          profImg: value['ProfileImage'],
        ));
      });
      setState(() {});
    });
  }
}
void doNothing(BuildContext context) {}
showAlertDialog(BuildContext context,int index) {
  AlertDialog alert = AlertDialog(
    title: const Text("Confirm delete"),
    content: const Text("Do you want to delete this post from entire Feeds"),
    actions: [
      TextButton(
        child: const Text("No"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: const Text("Yes"),
        onPressed: () {
          // mRootReference.child("Feeds").child("Public").child(list[index].id).remove();
          // list.removeAt(index);
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
