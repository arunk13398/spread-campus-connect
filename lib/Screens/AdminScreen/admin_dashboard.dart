import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../functions/functions.dart';
import '../../functions/widgets.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: InkWell(
        onLongPress: (){
          showAlertDialog(context);
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                   Column(
                     children: [
                       Text("User Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                       Text("Designation",style: TextStyle(fontSize: 14),),
                     ],
                   ),
                    Spacer(),
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
                Container(
                  height: 400,
                  width: 400,
                  child: ListView(scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: "https://cdn.wallpapersafari.com/35/69/w5tWPa.jpg",
                          placeholder: (context, url) =>
                              getShimmerLoading(),
                          imageBuilder: (context, image) => ClipRRect(borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: 300,
                              width: 250,
                              fit: BoxFit.cover,
                              imageUrl: "https://cdn.wallpapersafari.com/35/69/w5tWPa.jpg",
                              placeholder: (context, url) => getShimmerLoading(),),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: "https://images5.alphacoders.com/984/984315.jpg",
                          placeholder: (context, url) =>
                              getShimmerLoading(),
                          imageBuilder: (context, image) => ClipRRect(borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: 250,
                              width: 250,
                              fit: BoxFit.cover,
                              imageUrl: "https://images5.alphacoders.com/984/984315.jpg",
                              placeholder: (context, url) => getShimmerLoading(),),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: "https://th.bing.com/th/id/R.bde71b796a25c44a2e1355f040342fa0?rik=zhvRO1wm%2bA0y4w&riu=http%3a%2f%2fcdn.wallpapersafari.com%2f70%2f14%2fkISu7N.jpg&ehk=eq%2btIDiWfjMAGN7NdBwzwJzmh5R3OHVT2jCtRnxTP9g%3d&risl=&pid=ImgRaw&r=0",
                          placeholder: (context, url) =>
                              getShimmerLoading(),
                          imageBuilder: (context, image) => ClipRRect(borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: 250,
                              width: 250,
                              fit: BoxFit.cover,
                              imageUrl: "https://th.bing.com/th/id/R.bde71b796a25c44a2e1355f040342fa0?rik=zhvRO1wm%2bA0y4w&riu=http%3a%2f%2fcdn.wallpapersafari.com%2f70%2f14%2fkISu7N.jpg&ehk=eq%2btIDiWfjMAGN7NdBwzwJzmh5R3OHVT2jCtRnxTP9g%3d&risl=&pid=ImgRaw&r=0",
                              placeholder: (context, url) => getShimmerLoading(),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Align(alignment: Alignment.centerLeft,
                        child: Text("Explore more",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                    Spacer(),
                    Align(alignment: Alignment.centerRight,
                        child: Text("see all",style: TextStyle(fontSize: 18),)),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Container(
                            height: 83,
                            width:83,
                            decoration: BoxDecoration(
                              color: Colors.indigo[100],
                               borderRadius: BorderRadius.circular(10),
                            ),
                            child:Center(child: Icon(Icons.add_alarm_outlined,color: Colors.indigo,))
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
                          Container(
                            height: 83,
                            width:83,
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                               borderRadius: BorderRadius.circular(10),
                            ),
                            child:Center(child: Icon(Icons.add_alert_sharp,color: Colors.orange,))
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
                          Container(
                            height: 83,
                            width:83,
                            decoration: BoxDecoration(
                              color: Colors.lightGreenAccent[100],
                               borderRadius: BorderRadius.circular(10),
                            ),
                            child:Center(child: Icon(Icons.add_box_sharp,color: Colors.greenAccent,))
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("Notification"),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Container(
                            height: 83,
                            width:83,
                            decoration: BoxDecoration(
                              color: Colors.indigo[100],
                               borderRadius: BorderRadius.circular(10),
                            ),
                            child:Center(child: Icon(Icons.add_alarm_outlined,color: Colors.indigo,))
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("All feeds"),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      )),
    );
  }
}
