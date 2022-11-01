import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
   const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();

}

class _FeedPageState extends State<FeedPage> {
  var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: height/12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:8.0,top: 8,bottom: 0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  //color: Colors.blue,
                                  height: 35,
                                  width: 35,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:  BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      topRight: Radius.circular(6),
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage('assets/Images/test2.jpg'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  children: [
                                    Text("John Martinez",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    Text("Center Park NYC"),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),

                            Icon(
                                Icons.more_vert,
                                size: 35,
                                color:Colors.black
                            ),
                          ],
                        ),
                      ),
                    ],

                  ),
                  Container(
                    height: height/2.3,
                    decoration:  const BoxDecoration(
                      borderRadius:  BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/Images/test2.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: height/12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:8.0,top: 8,bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                                Icons.favorite_border,
                                size: 35,
                                color:Colors.black
                            ),

                            SizedBox(width: 8,),
                            Icon(
                                Icons.chat_bubble_outline,
                                size: 35,
                                color:Colors.black
                            ),
                            SizedBox(width: 8,),
                            Icon(
                                Icons.near_me,
                                size: 35,
                                color:Colors.black
                            ),
                            Spacer(),
                            Text("102 Likes")
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}
