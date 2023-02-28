import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Theme/theme.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isChecked = true;

  var orientation, size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0',
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 60,
                        ),
                        imageBuilder: (context, image) => CircleAvatar(
                          backgroundImage: image,
                          radius: 60,
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: 115,
                        child: Icon(
                          Icons.linked_camera_sharp,
                          size: 35,
                          color:  MyColors.theme2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                  child: Align(alignment: Alignment.centerLeft,
                      child: Text("Personal details -", style: TextStyle(fontWeight: FontWeight.bold,color: MyColors.theme1,fontSize: 17))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                  child: Container(
                    width:width/1,
                    child: Row(
                      children: [
                        Container(
                          width:width/2,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'First name',
                              hintText: 'First name',
                              prefixIcon: Icon(Icons.person_outlined,
                                  size: 20,
                                  color: MyColors.theme2),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:  MyColors.theme2, width: 1.2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:  Colors.green, width: 1.2),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width:width/3.5,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'last name',
                              hintText: 'last name',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:  MyColors.theme2, width: 1.2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:  Colors.green, width: 1.2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Mobile number',
                      hintText: '+91 mobile number',
                      prefixIcon: Icon(Icons.call,
                          size: 20,
                          color: MyColors.theme2),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  MyColors.theme2, width: 1.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  Colors.green, width: 1.2),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'College',
                      hintText: 'College',
                      prefixIcon: Icon(Icons.location_on_outlined,
                          size: 20,
                          color: MyColors.theme2),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  MyColors.theme2, width: 1.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  Colors.green, width: 1.2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top:5,bottom:5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Semester',
                      hintText: 'Semester',
                      prefixIcon: Icon(Icons.signpost_outlined,
                          size: 20,
                          color: MyColors.theme2),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  MyColors.theme2, width: 1.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:  Colors.green, width: 1.2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20, right: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: MaterialButton(
                        onPressed: () {
                        },
                        textColor: Colors.white,
                        color: MyColors.theme3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 18,color: Colors.white,),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 5,),
                  child: CheckboxListTile(
                    activeColor: MyColors.theme2,
                    title: Text("Change to the page?",style: TextStyle(color: MyColors.theme1,fontSize: 14),),
                    value: _isChecked,
                    onChanged: (val) {
                      setState(() {
                        _isChecked = val!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15,right: 15),
                  child: Text("wait until the admin verification page have publish notifcation to others",style: TextStyle(color: MyColors.theme1,fontSize: 16),textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
