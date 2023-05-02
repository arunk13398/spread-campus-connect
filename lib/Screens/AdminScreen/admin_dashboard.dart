import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Contraints/user_preference.dart';
import '../../Model/feed_model.dart';
import '../../functions/functions.dart';
import '../../functions/widgets.dart';
import 'AdmAccessList/access_request_page.dart';
import 'AdmUsersList/user_list_page.dart';
import 'AdmAddNewList/AddNewListPage.dart';
import 'AdmFeedsManage/FeedManagePage.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<FeedModel> list = [];
 String username='';
 String access = "";
  @override
  void initState() {
    load();
    getdata();
    super.initState();
  }

  getdata() async {
    username= await getString(UserPreferences.USER_Name);
    access=   await getString(UserPreferences.ACCESS_CODE);
  }

  @override
  var size,height,width;
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(

      body: Center(child: InkWell(
        onLongPress: (){
          // showAlertDialog(context);
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                     Column(
                       children: [
                         Text(username,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                         Text("Designation",style: TextStyle(fontSize: 14),),
                       ],
                     ),
                      Spacer(),
                      InkWell(
                        onTap: (){
                          print("mruuuuuuuuuu${access }");
                          // showAlertDialog(context);
                        },
                        child: CachedNetworkImage(
                          imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                          placeholder: (context, url) =>  CircleAvatar(
                            backgroundColor: Colors.blue.shade300,
                            radius: 22,
                          ),
                          imageBuilder: (context, image) => CircleAvatar(
                            backgroundImage: image,
                            radius: 22,
                          ),
                        ),
                      ),
                    ],

                  ),
                  SizedBox(height: 20,),
                  Align(alignment: Alignment.centerLeft,
                      child: Text("Discover",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),)),
                  SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: 400,
                    child: ListView(scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("new",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        ),
                        SizedBox(width: 20,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("public",style: TextStyle(fontSize: 20),),
                        ),
                        SizedBox(width: 20,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Connections",style: TextStyle(fontSize: 20),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width:380,
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) => AdminHomeFeed(index),),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Align(alignment: Alignment.centerLeft,
                          child: Text("Explore more",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                      // Spacer(),
                      // Align(alignment: Alignment.centerRight,
                      //     child: Text("see all",style: TextStyle(fontSize: 18),)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width:width/1,
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>FeedManagePage()));


                                },
                                child: Container(
                                    height: 83,
                                    width:83,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:Center(child: Icon(Icons.account_tree_sharp,color: Colors.blue,size: 35))
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("All feeds"),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserListPage()));
                                },
                                child: Container(
                                    height: 83,
                                    width:83,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:Center(child: Icon(Icons.person_search_sharp,color: Colors.indigo,size: 35))
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("User list"),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccessRequestPage()));
                                },
                                child: Container(
                                    height: 83,
                                    width:83,
                                    decoration: BoxDecoration(
                                      color: Colors.orange[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:Center(child: Icon(Icons.manage_accounts_rounded,color: Colors.orange,size: 35,))
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("access list"),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>AddNewListPage()));
                                },

                                child: Container(
                                    height: 83,
                                    width:83,
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreenAccent[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:Center(child: Icon(Icons.add_box_sharp,color: Colors.greenAccent,size: 32))
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Item List"),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      )),
    );
  }

  Widget AdminHomeFeed(int index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(

            child:CachedNetworkImage(
              height: 380,
              width: 250,
              imageUrl: list[index].imageUrl,
              placeholder: (context, url) =>
                  getShimmerLoading(),
              imageBuilder: (context, image) => ClipRRect(borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  height: 380,
                  width: 250,
                  fit: BoxFit.cover,
                  imageUrl: list[index].imageUrl,
                  placeholder: (context, url) => getShimmerLoading(),),
              ),
            ),
          ),
         Positioned(
           bottom: 5,
           child: Container(
             color: Colors.black26,
             // height: 380,
               width: 250,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(list[index].description,style: TextStyle(color: Colors.white),
                     maxLines: 15,
                     overflow: TextOverflow.ellipsis),
               ),),
         ),
        ],
      ),
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
          toPublish: value['ToPublish'],
          // ToPublish:  value['ToPublish'],
        ));
      });
      setState(() {});
    });
  }


}
