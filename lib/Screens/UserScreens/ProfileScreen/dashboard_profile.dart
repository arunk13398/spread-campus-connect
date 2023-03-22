import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Screens/UserScreens/ProfileScreen/profile_page.dart';

import '../../../functions/functions.dart';
import 'edit_profile.dart';
import 'gallery.dart';

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({Key? key}) : super(key: key);

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dashboard",style: TextStyle(fontSize: 30),),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                            'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                            placeholder: (context, url) => const CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 60,
                            ),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 60,
                            ),
                          ),
                          SizedBox(width: 20,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Arun kenedy",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                              Text("College name",style: TextStyle(fontSize: 16,color: Colors.grey),),
                              SizedBox(height: 5,),
                              MaterialButton(onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfile()));
                              },
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Text("Edit profile",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border:Border.all(color: Colors.grey.shade300,width: 1,)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
                            child: Text("Personal information",style: TextStyle(fontWeight: FontWeight.bold),),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Gallery()));
                        },
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:Border.all(color: Colors.grey.shade300,width: 1,)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
                              child: Text("Image collection",style: TextStyle(fontWeight: FontWeight.bold),),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border:Border.all(color: Colors.grey.shade300,width: 1,)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
                            child: Text("about",style: TextStyle(fontWeight: FontWeight.bold),),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border:Border.all(color: Colors.grey.shade300,width: 1,)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
                            child: Text("Privacy policy",style: TextStyle(fontWeight: FontWeight.bold),),
                          )),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0,bottom:20,left:8,right: 8),
                child: InkWell(
                  onTap: (){
                    showAlertDialog(context);
                  },
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:Border.all(color: Colors.grey.shade300,width: 1,)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:10.0,right:10,top:15,bottom:15),
                        child: Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
