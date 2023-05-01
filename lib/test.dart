import 'dart:collection';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'Contraints/user_preference.dart';
import 'functions/functions.dart';




class TestDemo extends StatefulWidget {

  TestDemo({Key? key, }) : super(key: key);

  @override
  State<TestDemo> createState() => _TestDemoState();
}

class _TestDemoState extends State<TestDemo> {




  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  bool isConnected = false;
  String Uid='';
  String College='';
  String designation='';
  TextEditingController college = TextEditingController();

  late FirebaseAuth _auth;
  late Stream<User?> _authStateChanges;

  bool isSwitchedCollege = false;
  bool isSwitchedUsers = false;
  bool isSwitchedDepartment = false;
  bool isSwitchedAcadamic = false;
  bool isSwitchedSuggestons = false;
  bool isLiked = false;

  initAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    _auth = FirebaseAuth.instance;
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges.listen((User? user) {

      setState(() {
        Uid = user?.uid??"";
      });
      print("...user id ${user?.uid}....");
    });
  }

  void initState() {
    super.initState();
    initAuth();
    checkRealtimeConnection();
    getSharPdata();
    AlertDialogAdd();
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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Uid                      :"+Uid,style: TextStyle(fontSize:13),),
                Text("College              :"+College,style: TextStyle(fontSize:13),),
                Text("designation       :"+ designation,style: TextStyle(fontSize:13),),
                Text(isConnected?"Network connected":"Network not connected",style: TextStyle(fontSize:13,),),
              ],
            ),
          ),
          drawer: Drawer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Category adding page"),
                  SizedBox(height:10),
                  Row(
                    children: [
                      Text("Add new College",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Switch(
                          value: isSwitchedCollege,
                          onChanged: (value){
                            setState(() {
                              isSwitchedCollege = value;});
                          }),
                    ],

                  ),

                  SizedBox(height:10),
                  Row(
                    children: [
                      Text("Add new College users",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Switch(
                          value: isSwitchedUsers,
                          onChanged: (value){
                            setState(() {
                              isSwitchedUsers = value;});
                          }),
                    ],
                  ),
                  SizedBox(height:10),
                  InkWell(
                    onLongPress: (){
                      AlertDialogAdd();
                    },
                    child: Row(
                      children: [
                        Text("Add new department",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        Spacer(),
                        Switch(
                            value: isSwitchedDepartment,
                            onChanged: (value){
                              setState(() {
                                isSwitchedDepartment = value;

                              });
                            }),
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  Row(
                    children: [
                      Text("Add new acadamic year",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Switch(
                          value: isSwitchedAcadamic,
                          onChanged: (value){
                            setState(() {
                              isSwitchedAcadamic = value;});
                          }),
                    ],
                  ),
                  SizedBox(height:10),
                  Row(
                    children: [
                      Text("Add new suggestions",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Switch(
                          value: isSwitchedSuggestons,
                          onChanged: (value){
                            setState(() {
                              isSwitchedSuggestons = value;
                            });
                          }),
                    ],
                  ),
                  SizedBox(height:10),
                  isSwitchedCollege||isSwitchedAcadamic||isSwitchedDepartment||isSwitchedSuggestons||isSwitchedUsers==true?AlertDialogAdd():Container()
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              LikeButton(
                size: 30,
                circleColor:CircleColor(start:Color(0xFF79D71E),end: Color(0xFFCEF894)),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: Color(0xFF79D71E),
                  dotSecondaryColor: Color(0xFFCEF894),

                ),

                likeBuilder: (bool isLiked){
                  return Icon(
                    isLiked ?Icons.favorite:Icons.favorite_border,
                    color:isLiked ? Colors.black:Colors.grey,
                    size:30,
                  );
                },

                likeCount: 10,
                countBuilder: (count,bool isLiked, String text){
                  var color = isLiked?Colors.indigo:Colors.orange;
                  Widget result;
                  if(isLiked==true){
                    HashMap<String, dynamic> data = HashMap<String, dynamic>();
                    // String id2= list[index].id;
                    // String id3= numberId;
                    // print("tutututu ${UserName}");
                    // data["UserName"] = UserName;
                    mRootReference.child('Likes').child("id3").update(data);
                  }
                  else{
                    HashMap<String, dynamic> data = HashMap<String, dynamic>();
                    // String id2= list[index].id;
                    // String id3= numberId;
                    // print("tutututu ${UserName}");
                    // data["UserName"] = UserName;
                    mRootReference.child('Likes').child("id3").remove();
                  }
                  if (count ==0 ){
                    result = Text("love",
                      style: TextStyle(color: color),);
                  }
                  else
                    result = Text(text,style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),);
                  print("tutututu ${result}");
                  return result;

                },
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isLiked=!isLiked;
                    HashMap<String, dynamic> data = HashMap<String, dynamic>();
                    String id3= Uid;
                    print("tutututu ${Uid}");
                    // data["UserName"] = UserName;
                    mRootReference.child('Likes').child(id3).update(data);
                  });
                },
                icon: isLiked?Icon(Icons.favorite):Icon(Icons.favorite_border),)
            ],
          ),
      ),
    );
  }


  getSharPdata() async {

    College = (await getString(UserPreferences.COLLEGE));
    designation = (await getString(UserPreferences.DESIGNATION));
  }


  AlertDialogAdd(){
    return  AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure to logout"),
      actions: [
        // TextButton(
        //   child: const Text("No"),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () {
          },
        ),

      ],
    );

    //   AlertDialog(
    //   title: const Text("Add new item"),
    //   content:  Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child:
    //
    //     TextFormField(
    //       controller: college,
    //       style: TextStyle(color: Colors.black),
    //       decoration: InputDecoration(
    //         border: const OutlineInputBorder(),
    //         labelText: 'Enter College',
    //         hintText: 'eg: GECWayand',
    //         filled: true,
    //         fillColor: Colors.white,
    //         labelStyle: TextStyle(color: Colors.black),
    //         hintStyle: TextStyle(color: Colors.blue),
    //         enabledBorder: OutlineInputBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //           borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
    //         ),
    //         focusedBorder: OutlineInputBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //           borderSide: BorderSide(
    //               color:Colors.grey, width: 1.6),
    //         ),
    //       ),
    //     ),
    //   ),
    //   actions: [
    //     TextButton(
    //       child: const Text("Yes"),
    //       onPressed: () {
    //         // mRootReference.child("Feeds").child("Public").child(list[index].id).remove();
    //         // list.removeAt(index);
    //       },
    //     ),
    //   ],
    // );

  }

  // Widget FeedAdaptor(int index) {
  //   // int index  in function
  //   return Column(
  //     children: [
  //       Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(left: 5.0,top:10),
  //             child: Row(
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     SizedBox(
  //                       width: width / 1.1,
  //                       child: Row(
  //                         children: [
  //                           SizedBox(width:15),
  //                           CachedNetworkImage(
  //                             imageUrl: 'https://www.aais.com/hs-fs/hubfs/coming_soon_placeholder-01.jpg?width=4000&name=coming_soon_placeholder-01.jpg',
  //                             placeholder: (context, url) =>  CircleAvatar(
  //                               backgroundColor: Colors.blue.shade300,
  //                               radius: 22,
  //                             ),
  //                             imageBuilder: (context, image) => CircleAvatar(
  //                               backgroundImage: image,
  //                               radius: 22,
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             width: width / 1.8,
  //                             child: Column(
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.start,
  //                               crossAxisAlignment:
  //                               CrossAxisAlignment.start,
  //                               children: [
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                       left: 10.0, right: 5),
  //                                   child: Text(
  //                                       list[index].userName,
  //                                       style: TextStyle(
  //                                           fontSize: 20,
  //                                           fontWeight: FontWeight.bold,
  //                                           color: Colors.black),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                       textAlign: TextAlign.start),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                       left: 10.0, right: 5),
  //                                   child: Text(
  //                                     list[index].desigUser,
  //                                     style: TextStyle(
  //                                         fontSize: 15,
  //                                         color: Colors.grey),
  //                                   ),
  //                                 ),
  //
  //                               ],
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(
  //                                 left: 10.0, right: 5),
  //                             child: Text(
  //                               "1 min ago",
  //                               // list[index].username
  //                               style: TextStyle(
  //                                   fontSize: 15,
  //                                   color: Colors.black),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //
  //                     Padding(
  //                       padding:
  //                       const EdgeInsets.only(left: 8.0, right: 5,top:10,bottom:5),
  //                       child: SizedBox(
  //                         width: width / 1.2,
  //                         child: Text(list[index].description,
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.bold
  //                             ),
  //                             overflow: TextOverflow.ellipsis,
  //                             maxLines: 1,
  //                             textAlign: TextAlign.start),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(5.0),
  //             child:
  //             CachedNetworkImage(
  //               imageUrl: list[index].imageUrl,
  //               placeholder: (context, url) =>
  //                   getShimmerLoading(),
  //               imageBuilder: (context, image) => ClipRRect(borderRadius: BorderRadius.circular(8),
  //                 child: CachedNetworkImage(
  //                   // height: 250,
  //                   width: double.infinity,
  //                   fit: BoxFit.fill,
  //                   imageUrl: list[index].imageUrl,
  //                   placeholder: (context, url) => getShimmerLoading(),),
  //               ),
  //             ),
  //             // ClipRRect(
  //             //   borderRadius: BorderRadius.circular(20),
  //             //   child: CachedNetworkImage(
  //             //     // height: 250,
  //             //     width: double.infinity,
  //             //     fit: BoxFit.fill,
  //             //     imageUrl: list[index].imageUrl,
  //             //     placeholder: (context, url) => Center(
  //             //         child: CircularProgressIndicator(
  //             //           color: MyColors.Greencolor,
  //             //         )),
  //             //   ),
  //             // ),
  //           ),
  //
  //           Padding(
  //             padding:  EdgeInsets.only(left: 5.0,top:5,bottom: 10),
  //             child: Row(
  //               children: [
  //                 SizedBox(width:20),
  //                 Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(30),
  //                         border:Border.all(color: Colors.grey.shade300,width: 1,)
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(left:10.0,right:10,top:3,bottom:3),
  //                       child: Row(
  //                         children: [
  //                           InkWell(
  //                               onTap: (){
  //                                 setState(() {
  //                                   isLiked = !isLiked;
  //                                 });
  //                               },
  //                               child: Icon(Icons.favorite, color: Colors.black, size: 26,
  //                               )
  //                           ),
  //
  //                           SizedBox(width: 2,),
  //                           Text(
  //                             "12",
  //                             style:
  //                             TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                     )),
  //                 SizedBox(width:10),
  //                 InkWell(
  //                   onTap: (){
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) =>
  //                                 CommentViewScreen(
  //                                     feedModel: list[index])));
  //                   },
  //                   child: Container(
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(30),
  //                           border:Border.all(color: Colors.grey.shade300,width: 1,)
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(left:10.0,right:10,top:3,bottom:3),
  //                         child: Row(
  //                           children: [
  //                             Icon(Icons.chat_bubble_outline),
  //                             SizedBox(width: 2,),
  //                             Text(
  //                               "12",
  //                               style:
  //                               TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                       )),
  //                 ),
  //                 SizedBox(width:10),
  //                 InkWell(
  //                   onTap: (){
  //                     print("desig dwerx ${Designation}");
  //                   },
  //                   child: Container(
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(30),
  //                           border:Border.all(color: Colors.grey.shade300,width: 1,)
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(left:10.0,right:10,top:3,bottom:3),
  //                         child: Icon(Icons.more_horiz),
  //                       )),
  //                 ),
  //
  //               ],
  //             ),
  //           ),
  //
  //         ],
  //       ),
  //
  //       // SizedBox(height: 20,),
  //     ],
  //   );
  // }

}

