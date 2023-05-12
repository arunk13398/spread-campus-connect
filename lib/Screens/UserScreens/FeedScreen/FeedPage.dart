import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chip_list/chip_list.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Model/feed_model.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/comment_view.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:miniq/functions/camera.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../Model/access_model.dart';




class FeedPage extends StatefulWidget {
  const FeedPage({Key? key,}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<FeedModel> list = [];
  // List<LikeModel> likelist=[];
  String numberId = '';
  String UserName = '';
  String UserName1 = '';
  String College = '';
  String Designation = '';
  String Phone = '';
  String UidLike = '';
  String UidName = '';
  String ProfimageUrl = '';


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
                                      decoration: BoxDecoration(
                                        color:MyColors.Colorgreen3,
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child:Icon(Icons.add,color: Colors.white,)
                                  ),
                                ),
                                SizedBox(width: 10,),
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
                                      padding: EdgeInsets.all(10),
                                      listOfChipNames: _menuItems,
                                      activeBgColorList: [MyColors.Colorgreen2],
                                      inactiveBgColorList: const [Colors.white],
                                      activeTextColorList: const [Colors.white],
                                      inactiveTextColorList: [Colors.black],
                                      listOfChipIndicesCurrentlySeclected: [_currentIndex],
                                      inactiveBorderColorList:  [MyColors.Colorgreen2],
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
                          itemBuilder: (BuildContext context, int index)=> AdaptorNew(index)
                      )

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
    mRootReference
        .child("UsersList").child(await getString(UserPreferences.COLLEGE))
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(await getString(UserPreferences.DESIGNATION))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        College = data["College"];
        Designation = data["Designation"];
        Phone =data['Phone'];
        ProfimageUrl=data['ImageUrl'];
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
          profImg: value['ProfileImage'],
          toPublish: value['ToPublish'],
          RegisterLink: value['RegisterLink']
          // ToPublish: value['ToPublish'],
        ));
      });
      setState(() {});
    });
  }


  @override
  Widget AdaptorNew(int index){
    return Container(
      child:ExpandableNotifier(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[

                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: true,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(

                      // expandIcon: CupertinoIcons.arrow_down_right_arrow_up_left,
                      // iconSize: 22,
                      // iconColor: Colors.blue,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: SizedBox(
                      width: width / 1.5,
                      child: Row(
                        children: [
                          SizedBox(width:0),
                          list[index].profImg==''?
                          CachedNetworkImage(
                            imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                            placeholder: (context, url) =>  CircleAvatar(
                              backgroundColor: Colors.blue.shade300,
                              radius: 22,
                            ),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 22,
                            ),
                          ):
                          CachedNetworkImage(
                            imageUrl: list[index].profImg,
                            placeholder: (context, url) =>  CircleAvatar(
                              backgroundColor: Colors.blue.shade300,
                              radius: 22,
                            ),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 22,
                            ),
                          ),
                          Container(
                            // color:Colors.red,
                            width: width / 2.1,
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
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 5),
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
                    collapsed: Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text(list[index].description,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.justify,
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text(list[index].description,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.justify,
                          softWrap: false,
                          maxLines: 50,
                          overflow: TextOverflow.ellipsis),
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
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child:
                  list[index].imageUrl!=""?CachedNetworkImage(
                    imageUrl: list[index].imageUrl,
                    placeholder: (context, url) =>
                        getShimmerLoading(),
                    imageBuilder: (context, image) => ClipRRect(borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        // height: 250,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        imageUrl: list[index].imageUrl,
                        placeholder: (context, url) => getShimmerLoading(),),
                    ),
                  ):getShimmerLoading(),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 0.0,top:10,bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(width:0),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border:Border.all(color: Colors.grey.shade300,width: 1,)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right:10,top:3,bottom:3),
                            child: Row(
                              children: [
                                LikeButton(
                                  size: 25,
                                  circleColor:CircleColor(start:Color(0xFF79D71E),end: Color(0xFFCEF894)),
                                  bubblesColor: BubblesColor(
                                      dotPrimaryColor: Color(0xFF79D71E),
                                      dotSecondaryColor: Color(0xFFCEF894),
                                  ),
                                  likeBuilder: (bool isLiked){
                                    return Icon(
                                      isLiked ?Icons.favorite:Icons.favorite_border,
                                      color:isLiked ? Colors.black:Colors.grey,
                                      size:25,
                                    );
                                  },
                                  likeCount: 10,
                                  countBuilder: (count,bool isLiked, String text){
                                    var color = isLiked?Colors.indigo:Colors.orange;
                                    Widget result;

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

                          //       IconButton(
                          //       onPressed: () {
                          // if(isLiked==true){
                          // HashMap<String, dynamic> data = HashMap<String, dynamic>();
                          // String id= numberId;
                          // data["UserName"] = UserName;
                          // data["Id"] = numberId;
                          // mRootReference.child('Likes').child(id).remove();
                          // }else{
                          // HashMap<String, dynamic> data = HashMap<String, dynamic>();
                          // String id= numberId;
                          // data["UserName"] = UserName;
                          // data["LikeId"] = numberId;
                          // mRootReference.child('Likes').child(id).update(data);
                          //   }
                          // setState(() {
                          //   isLiked=!isLiked;
                          //    });
                          // },
                          //   icon: isLiked?Container(height: 20,
                          //       child: Icon(Icons.favorite)):
                          //   Container(height: 20,
                          //       child: Icon(Icons.favorite_border)),)


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
                                          feedModel: list[index],)));
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
                          showAlertDialogMore(context,);
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
                      SizedBox(width:10),
                      list[index].RegisterLink!=""?
                    Container(
                      width: width/2.7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border:Border.all(color: Colors.grey.shade300,width: 1,)
                        ),
                        child: InkWell(
                          onTap: ()  {
                            final url = list[index].RegisterLink;
                            openBrowserUrl(url: url,inApp: true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right:10,top:5,bottom:5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.ads_click,size: 20,),
                                SizedBox(width:15),
                                Text("Apply",style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                        )):Container(),
                    ],
                  ),
                ),

              ],
            ),
          )),
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
                          decoration: BoxDecoration(
                            color:MyColors.Colorgreen3,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child:Icon(Icons.add,color: Colors.white,)
                      ),
                    ),),
                SizedBox(width: 10,),

                ProfimageUrl==''?
                CachedNetworkImage(
                  imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                  placeholder: (context, url) =>  CircleAvatar(
                    backgroundColor: Colors.blue.shade300,
                    radius: 22,
                  ),
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundImage: image,
                    radius: 22,
                  ),
                ):CachedNetworkImage(
                  imageUrl: ProfimageUrl,
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

  Future<void> addLike() async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();

    // String id1 = list[index].id
    String id2 = Phone;
    String id1 = DateTime.now().millisecondsSinceEpoch.toString();
    await mRootReference.child('Feeds').child('Public').child(id2).child('Comments').child(id1).update(data);

    // HashMap<String, dynamic> data = HashMap<String, dynamic>();
    // String id2= list[index].id;
    // String id3= numberId;
    // print("tutututu ${UserName}");
    // data["UserName"] = UserName;
    // mRootReference.child('Feeds').child('Public').child(id2).child('Likes').child(id3).update(data);
    //
  }

  showAlertDialogMore(BuildContext context) {

    AlertDialog alert = AlertDialog(
      title: const Text("More options",style: TextStyle(fontSize: 16,color: MyColors.Colorgreen3,fontWeight: FontWeight.bold),),
      content: Container(
        height:100,
        width: 80,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Report",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
              SizedBox(height: 5,),
              InkWell(
                onTap: (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("About",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
              SizedBox(height: 5,),
              InkWell(
                onTap: (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("help",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
              SizedBox(height: 5,),

            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Container(
              decoration: BoxDecoration(
                  color:MyColors.Colorgreen3,
                  borderRadius: BorderRadius.all(
                      Radius.circular(30)
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:15.0,right:15,top:8,bottom:8),
                child: const Text("Close",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color:Colors.white)),
              )),
          onPressed: () {
            Navigator.of(context).pop();
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

  newLike(){
    if(isLiked==true){
      HashMap<String, dynamic> data = HashMap<String, dynamic>();
      String id3= numberId;
      print("tutututu ${UserName}");
      data["UserName"] = UserName;
      mRootReference.child('Likes').child(id3).update(data);
    }
    else{
      HashMap<String, dynamic> data = HashMap<String, dynamic>();
      String id3= numberId;
      print("tutututu ${UserName}");
      data["UserName"] = UserName;
      mRootReference.child('Likes').child(id3).remove();
    }

  }
}

// _launchUrl(int index) async {
//   const url = 'https://www.google.com';
//   final uri = Uri.parse(url);
//   if(await canLaunchUrl(uri))
//     await launchUrl(uri);
//   else
//     throw "empty url";
// }

Future openBrowserUrl({
  required String url,
  bool inApp = false,
}) async {
  if(await canLaunch(url)){
    await launch(url,
        forceWebView: inApp,
        enableJavaScript: true,
        forceSafariVC: inApp);
  }
}