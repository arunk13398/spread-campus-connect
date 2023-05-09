import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Contraints/user_preference.dart';
import '../../../Model/complaint_model.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import '../../AdminScreen/TestPagesAkshy/co.dart';
import '../../Adminbottom_navigation.dart';
import '../../bottom_navigation.dart';

class ComplaintDetails extends StatefulWidget {
  final ComplaintModel complaintModel;
  const ComplaintDetails({Key? key, required this.complaintModel}) : super(key: key);

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();

  var size,height,width;
  bool _isChecked=false;
  bool _isVerified=false;

  String numberId='';
  String UserName='';
  String College='';
  String Designation='';
  String imageUrl='';
  String access='';

  String ReviewMobileNumberData='';
  String ReviewDesignationData='';
  String ReviewDateData='';
  String ReviewerProfImgData='';
  String ComplaintReviewData='';
  String ReviewStatusData='';

  String _ReviewDpValue = 'Processing';
  var _ReviewList = ['Processing','Verified', 'Rejected','Waiting','Forwarded',];

  List<Step> stepList() => [
    Step(
      isActive: _currentStep==0,
      title: Text('Step1'),
      subtitle: Text('Processing'),
      label: Container(child:Text("hello")),
      content: Center(child: Text(''),),
    ),
    Step(
      isActive: _currentStep==1,
      title: Text('Step2'),
      subtitle: Text('Processing'),
      label: ColoredBox(color: Colors.tealAccent),
      content: Center(child: Text('bbbbb'),),
    ),
    Step(
      isActive: _currentStep==2,
      title: Text('Step3'),
      subtitle: Text('Processing'),
      label: Container(child:Text("kooo")),
      content: Center(child: Text('ccccc'),),
    ),
  ];
  TextEditingController ReviewComplaintText = TextEditingController();
  int _currentStep=0;

  @override
  void initState() {
    getDataF1();
    getReviewDetails();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left:15.0,right:15,top:10,bottom:10),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(widget.complaintModel.rSubject,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                    ),

                    SizedBox(
                      width: width / 1,
                      child: Row(
                        children: [
                          SizedBox(width:5),
                          imageUrl==''?
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
                            imageUrl: imageUrl,
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
                            width: width / 2,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0,top:0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Posted to "),
                                          Text(widget.complaintModel.rTo,style: TextStyle(fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Date"),
                                          Text(" 12/2/2022",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5),
                            child: Text(
                              "1 mint ago",
                              // list[index].username
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Divider(height: 0.5),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        child: Text(widget.complaintModel.rCmptText,style: TextStyle(fontSize: 18,height: 1.5),maxLines: 15,),
                      ),
                    ),
                    SizedBox(height: 20,),

                    Row(
                      children: [
                        Icon(Icons.attachment_sharp,color: Colors.blue,),
                        SizedBox(width: 5,),
                        Text("https//TestLinkForSpreadapplication"),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(
                      children: [
                        Icon(Icons.attachment_sharp,color: Colors.blue,),
                        SizedBox(width: 5,),
                        Text("https// TestLinkForSpreadapplication"),
                      ],
                    ),
                    SizedBox(height: 10,),
                    // Progress section


                    Designation=='Admin'||Designation=='Teacher'?

                    Container():
                    Column(
                      children: [
                        CheckboxListTile(
                          activeColor: Colors.blue,
                          title: Text("Track Application Process",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                          value: _isChecked,
                          onChanged: (val) {
                            setState(() {
                              _isChecked = val!;
                            });
                          },
                        ),
                        _isChecked==true?Container(
                          child: Stepper(
                            steps: stepList(),
                            onStepTapped: (int newIndex){
                              setState(() {
                                _currentStep = newIndex;
                              });
                            },
                            currentStep: _currentStep,
                            onStepContinue: (){
                              if(_currentStep!=2){
                                setState(() {
                                  _currentStep += 1;
                                });
                              }
                            },onStepCancel: (){
                            if(_currentStep!=0){
                              setState(() {
                                _currentStep -= 1;
                              });
                            }
                          },type: StepperType.vertical,
                          ),
                        ):Container(),
                      ],
                    ),



                    //Review section

                    ComplaintReviewData==""?Container():
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        Divider(height: 0.5),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Review Replay from ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(left:5.0,top:3),
                              child: Row(
                                children: [
                                  Text("Status : ",style: TextStyle(fontSize: 17),),
                                  Text(ReviewStatusData,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,
                                        color: ReviewStatusData=="Rejected"?Colors.red:Colors.black),),
                                ],
                              ),
                            ),
                            SizedBox(width:10),
                          ],
                        ),
                        SizedBox(height: 15,),
                        SizedBox(
                          width: width / 1,
                          child: Row(
                            children: [
                              ReviewerProfImgData==""?CachedNetworkImage(
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
                                imageUrl: ReviewerProfImgData,
                                placeholder: (context, url) =>  CircleAvatar(
                                  backgroundColor: Colors.blue.shade300,
                                  radius: 20,
                                ),
                                imageBuilder: (context, image) => CircleAvatar(
                                  backgroundImage: image,
                                  radius: 20,
                                ),
                              ),
                              // CachedNetworkImage(
                              //   imageUrl: ReviewerProfImgData,
                              //   placeholder: (context, url) =>  CircleAvatar(
                              //     backgroundColor: Colors.blue.shade300,
                              //     radius: 20,
                              //   ),
                              //   imageBuilder: (context, image) => CircleAvatar(
                              //     backgroundImage: image,
                              //     radius: 20,
                              //   ),
                              // ),
                              SizedBox(
                                width: width / 2.3,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:10.0,top:0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("Replay from : "),
                                              Text(widget.complaintModel.rTo,style: TextStyle(fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Date"),
                                              Text(" 12/2/2022",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                // width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border:Border.all(color: Colors.grey.shade300,width: 1,)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:20,right:20,top:10,bottom:10),
                                    child: Text("Contact authorizer",style: TextStyle(fontWeight: FontWeight.bold),),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height:20),
                        Divider(height: 0.5),
                        SizedBox(height:10),
                        Align(alignment: Alignment.centerLeft,
                            child: Text("Replay For Application",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17))),
                        SizedBox(height:10),
                      ],
                    ),

                    SizedBox(width:150,height:20,child: Divider(height: 1,)),

                    Text(ComplaintReviewData,style: TextStyle(fontSize: 17)),

                    Designation=='Admin'||Designation=='Teacher'?
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 5,top:10),
                            child: MaterialButton(onPressed: () {
                              setState(() {
                                _isVerified=true;
                              });

                            },
                              color: MyColors.Colorgreen2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text("Review Complaint",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )
                        ),
                        Spacer(),
                        _isVerified==true?
                        Padding(
                          padding: const EdgeInsets.only(right: 5,top:10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  width: 0.3,
                                )
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 20,
                                  child: DropdownButton(
                                    value: _ReviewDpValue,
                                    iconEnabledColor: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: _ReviewList.map((String items) {
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
                                        _ReviewDpValue = newValue!;
                                        print("asdfghjkl ${_ReviewDpValue}");
                                        print("asdfghjkl ${_ReviewList}");
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ):Container(),
                      ],
                    ):Container(),
                    _isVerified==true?Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:10),
                          child: Container(
                            height: 150,
                            child: TextFormField(
                              controller: ReviewComplaintText,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Review Content',
                                hintText: 'Review Content',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color:MyColors.Colorgreen3),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.6),
                                ),
                              ),
                              maxLines: 100,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top:10),
                            child: MaterialButton(
                                onPressed: () async {
                                  print("jjjjjjjjj${ReviewComplaintText}");
                                  await AddReviewComplaint().then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      backgroundColor: Colors.grey,
                                      content: Text(
                                        "Successful",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ));
                                    // ClearData();
                                    // finish(context);
                                  });
                                },
                                textColor: Colors.white,
                                color:MyColors.Colorgreen3,
                                minWidth: double.infinity,
                                height: 60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: const Text(
                                  "Submit Review",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                          ),
                        ),
                      ],
                    ):
                    Container(),
                  ],
                ),
                // MaterialButton(onPressed:(){},
                // child:Text("hello"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> AddReviewComplaint() async {
    HashMap<String, dynamic> data = HashMap<String, dynamic>();

    String id1 = DateTime.now().millisecondsSinceEpoch.toString();
    // print("gggggggg"+imageUrl);
    String id = widget.complaintModel.id;
    String id2 = widget.complaintModel.rMobNumber;
    data["Id"] = id;
    data["ReviewMobileNumber"] = numberId;
    data["ReviewDesignation"] = Designation;
    data["ReviewDate"] = id1;
    data["ReviewStatus"] = _ReviewDpValue;
    data["ReviewerProfImg"] = imageUrl;
    data["ComplaintReview"] = ReviewComplaintText.text;

    // data["UserName"] = username;
    data["Date"] = DateTime.now().toString();
    data["Time"] = DateTime.now().millisecondsSinceEpoch.toString();

    HashMap<String, dynamic> dataReview = HashMap<String, dynamic>();
    dataReview["Status"] = _ReviewDpValue;

    await mRootReference.child("Complaints").child(id2).child(id).child("Review").update(data);
    await mRootReference.child("Complaints").child(widget.complaintModel.rMobNumber).child(widget.complaintModel.id).update(dataReview);
    await mRootReference.child("Complaints").child("AdminAccess").child(widget.complaintModel.id).update(dataReview);

    Future.delayed(const Duration(seconds: 1), () {
      finishAccountCreation(Designation=='Admin'?AdminBottomNavigation():BottomNavigation(), context);
    });

    // await
    // referenceRoot.child("Test")
    //     .child("Images").push().update(data);
  }
  getDataF1() async {
    numberId = (await getString(UserPreferences.USER_NUMBER));
    UserName = (await getString(UserPreferences.USER_Name));
    College = (await getString(UserPreferences.COLLEGE));
    Designation = (await getString(UserPreferences.COLLEGE));
    mRootReference
        .child("UsersList").child(await getString(UserPreferences.COLLEGE))
        .child(await getString(UserPreferences.USER_NUMBER))
        .child(await getString(UserPreferences.DESIGNATION))
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        imageUrl=data['ImageUrl'];
        Designation= data['Designation'];
        setState(() {});
      }
    });
  }

  getReviewDetails() async {
    mRootReference
        .child("Complaints")
        .child(widget.complaintModel.rMobNumber)
        .child(widget.complaintModel.id).child("Review").once().then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        ReviewMobileNumberData=data['ReviewMobileNumber'];
        ReviewDesignationData=data['ReviewDesignation'];
        ReviewDateData=data['ReviewDate'];
        ReviewStatusData=data['ReviewStatus'];
        ReviewerProfImgData=data['ReviewerProfImg'];
        ComplaintReviewData=data['ComplaintReview'];
        print("popopopopo-------------------- ${ReviewStatusData}");
        setState(() {});
      }
    });
  }

}
