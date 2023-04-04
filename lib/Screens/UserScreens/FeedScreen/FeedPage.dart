import 'package:cached_network_image/cached_network_image.dart';
import 'package:chip_list/chip_list.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Model/feed_model.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/comment_view.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:miniq/functions/camera.dart';
import 'package:shimmer/shimmer.dart';

import '../../../functions/functions.dart';
import '../../bottom_navigation.dart';



class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<FeedModel> list = [];
  String numberId = '';
  String UserName = '';
  String UserName1 = '';
  String College = '';
  String Designation = '';
  bool isLiked = false;
  bool isConnected = false;
  var size, height, width;

  final List<String> _menuItems = [
    'Public',
    'Connections',
    'Club',
    'Event',
    'Other',
  ];

  int _currentIndex = 0;


  var top=0.0;
  late ScrollController _scrollController;

  @override void initState() {
    load();
    getDataF1();
    getData();
    checkRealtimeConnection();
    super.initState();
    _scrollController =  ScrollController();
    _scrollController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
        body:  Stack(
          children: [
            SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(backgroundColor: Colors.white,
                      pinned: true,
                      expandedHeight: 200,
                      flexibleSpace: LayoutBuilder(builder: (ctx,cons){
                        top=cons.biggest.height;
                        return FlexibleSpaceBar(
                          centerTitle: true,

                          title: AnimatedOpacity(
                            opacity: top <=100?1.0:0.0,
                            duration: Duration(milliseconds: 300),
                            child: Padding(
                              padding: const EdgeInsets.only(top:0.0),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:15.0),
                                  child: Text("Trending Feeds",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.black)),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            // showmodelBottomsheet()
                                            Camera()
                                        ));
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(color:Colors.blue,
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child:Icon(Icons.add,color: Colors.white,)
                                  ),
                                ),
                                SizedBox(width: 10,),
                                // ClipRRect(
                                //     borderRadius: BorderRadius.circular(100),
                                //     child: Image.network(
                                //       "https://www.aais.com/hs-fs/hubfs/coming_soon_placeholder-01.jpg?width=4000&name=coming_soon_placeholder-01.jpg",
                                //       // list[index].imageUrl,
                                //       height: 40,
                                //       width: 40,
                                //       fit: BoxFit.cover,
                                //     )),
                                // SizedBox(width:12),
                              ],),
                            ),
                          ),




                          background: Container(
                            color: Colors.transparent,
                            child: Container(
                              color:Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child:
                                          Column(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [Text(UserName, style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                            ),
                                              Text(College, style: TextStyle(color: Colors.grey, fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, bottom: 5, top: 20),
                                      child: Text("Trending Feeds",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40,
                                              color: Colors.black)),
                                    ),
                                    SizedBox(height: 30,),
                                    // Text('Using extraOnToggle: ${_menuItems[_currentIndex]}'),
                                    ChipList(
                                      padding: EdgeInsets.all(5),
                                      listOfChipNames: _menuItems,
                                      activeBgColorList: [Theme.of(context).primaryColor],
                                      inactiveBgColorList: const [Colors.white],
                                      activeTextColorList: const [Colors.white],
                                      inactiveTextColorList: [Colors.black],
                                      listOfChipIndicesCurrentlySeclected: [_currentIndex],
                                      inactiveBorderColorList:  [Colors.blue.shade200],
                                      extraOnToggle: (val) {
                                        _currentIndex = val;
                                        setState(() {
                                          load();
                                        });
                                      },
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },)
                  ),
                  SliverToBoxAdapter(
                      child:ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index)=> FeedAdaptor(index)
                      )

                      // isConnected==true?ListView.builder(
                      //     primary: false,
                      //     shrinkWrap: true,
                      //     itemCount: list.length,
                      //     itemBuilder: (BuildContext context, int index)=> FeedAdaptor(index)
                      // ):
                      // ListView.builder(
                      //     primary: false,
                      //     shrinkWrap: true,
                      //     itemCount: 3,
                      //     itemBuilder: (context, index) => getShimmerLoading())
                  )
                ],
              ),
            ),
            _buildfab(),
          ],
        )

    );
  }
  getDataF1() async {
    numberId = (await getString(UserPreferences.USER_NUMBER));
    UserName = (await getString(UserPreferences.USER_Name));
    // College = (await getString(UserPreferences.COLLEGE));
    mRootReference
        .child("AccessControl")
        .child(await getString(UserPreferences.USER_NUMBER))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("efgh ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        College = data["College"];
        Designation = data["Designation"];
        setState(() {});
      }
    });
  }

  getData() async {
    String id=College;
    String id1=Designation;
    mRootReference
        .child("UsersList")
        .child(id)
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(id1)
        .child("Profile")
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("abcd ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        UserName1 = data["Course"];
        setState(() {});
      }
    });

  }

  load() async {

    mRootReference.child("Feeds").child(_menuItems[_currentIndex]).onValue.listen((event) {
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

        ));
      });
      setState(() {});
    });
  }

  @override

  Widget FeedAdaptor(int index) {
    // int index  in function
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0,top:10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width / 1.1,
                        child: Row(
                          children: [
                            SizedBox(width:15),
                            CachedNetworkImage(
                              imageUrl: 'https://www.aais.com/hs-fs/hubfs/coming_soon_placeholder-01.jpg?width=4000&name=coming_soon_placeholder-01.jpg',
                              placeholder: (context, url) =>  CircleAvatar(
                                backgroundColor: Colors.blue.shade300,
                                radius: 22,
                              ),
                              imageBuilder: (context, image) => CircleAvatar(
                                backgroundImage: image,
                                radius: 22,
                              ),
                            ),
                            SizedBox(
                              width: width / 1.8,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 5),
                                    child: Text(
                                         list[index].userName,
                                        style: TextStyle(
                                            fontSize: 20,
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
                                          fontSize: 15,
                                          color: Colors.grey),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 5),
                              child: Text(
                                "1 min ago",
                                // list[index].username
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 5,top:10,bottom:5),
                        child: SizedBox(
                          width: width / 1.2,
                          child: Text(list[index].description,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child:
              CachedNetworkImage(
                imageUrl: list[index].imageUrl,
                placeholder: (context, url) =>
                    getShimmerLoading(),
                imageBuilder: (context, image) => ClipRRect(borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
        // height: 250,
               width: double.infinity,
               fit: BoxFit.fill,
               imageUrl: list[index].imageUrl,
               placeholder: (context, url) => getShimmerLoading(),),
                ),
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(20),
              //   child: CachedNetworkImage(
              //     // height: 250,
              //     width: double.infinity,
              //     fit: BoxFit.fill,
              //     imageUrl: list[index].imageUrl,
              //     placeholder: (context, url) => Center(
              //         child: CircularProgressIndicator(
              //           color: MyColors.Greencolor,
              //         )),
              //   ),
              // ),
            ),

            Padding(
              padding:  EdgeInsets.only(left: 5.0,top:5,bottom: 10),
              child: Row(
                children: [
                  SizedBox(width:20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border:Border.all(color: Colors.grey.shade300,width: 1,)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:10.0,right:10,top:3,bottom:3),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              child: Icon(Icons.favorite, color: MyColors.Blackcolor, size: 26,
                              )
                                  ),

                            SizedBox(width: 2,),
                            Text(
                              "12",
                              style:
                              TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(width:10),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommentViewScreen(
                                      feedModel: list[index])));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border:Border.all(color: Colors.grey.shade300,width: 1,)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:10.0,right:10,top:3,bottom:3),
                          child: Row(
                            children: [
                              Icon(Icons.chat_bubble_outline),
                              SizedBox(width: 2,),
                              Text(
                                "12",
                                style:
                                TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(width:10),
                  InkWell(
                    onTap: (){
                      print("desig dwerx ${Designation}");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border:Border.all(color: Colors.grey.shade300,width: 1,)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:10.0,right:10,top:3,bottom:3),
                          child: Icon(Icons.more_horiz),
                        )),
                  ),

                ],
              ),
            ),

          ],
        ),

        // SizedBox(height: 20,),
      ],
    );
  }

  Widget _buildfab(){
    final double defaultMargin=200;
    final double defaultStart=180;
    final double defaultEnd=defaultStart/2;

    double top =defaultMargin;
    double scale = 1.0;

    if(_scrollController.hasClients){
      double offset = _scrollController.offset;
      top-=offset;
      if(offset<defaultMargin-defaultStart){
        scale =1.0;
      }else if(offset<defaultStart-defaultEnd){
        scale =(defaultMargin-defaultEnd-offset)/defaultEnd;
      }else{
        scale=0.0;
      }
    }

    return Positioned(
        top: 41,
        right: 10,
        child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(scale),
            child: Row(
              children: [
                SizedBox(height: 40,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    // showmodelBottomsheet()
                                    Camera()
                            ));
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(color:Colors.blue,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child:Icon(Icons.add,color: Colors.white,)
                      ),
                    ),),
                SizedBox(width: 10,),

                CachedNetworkImage(
                  imageUrl: 'https://www.aais.com/hs-fs/hubfs/coming_soon_placeholder-01.jpg?width=4000&name=coming_soon_placeholder-01.jpg',
                  placeholder: (context, url) =>  CircleAvatar(
                    backgroundColor: Colors.blue.shade300,
                    radius: 22,
                  ),
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundImage: image,
                    radius: 22,
                  ),
                ),
              ],
            )));

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

  Shimmer getShimmerLoading(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade500,
      // enabled: _enabled,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:10.0,left:10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Container(
                        //   width: double.infinity,
                        //   height: 8.0,
                        //   color: Colors.white,
                        // ),

                        Container(
                          width: 150,
                          height: 12.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 60.0,
                          height: 12.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height:10),
            Container(
              width: double.infinity,
              height: 12.0,
              color: Colors.white,
            ),
            SizedBox(height:10),
            Container(
              width: double.infinity,
              height: 180.0,
              color: Colors.white,
            ),
            SizedBox(height: 5,),
            Container(
              width: double.infinity,
              height: 30.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }


}

