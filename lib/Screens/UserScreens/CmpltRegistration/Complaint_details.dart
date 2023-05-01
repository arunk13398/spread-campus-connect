import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../Model/complaint_model.dart';

class ComplaintDetails extends StatefulWidget {
  final ComplaintModel complaintModel;
  const ComplaintDetails({Key? key, required this.complaintModel}) : super(key: key);

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  var size,height,width;

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

  int _currentStep=0;


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
                          SizedBox(width:15),
                          CachedNetworkImage(
                            imageUrl: 'https://www.aais.com/hs-fs/hubfs/coming_soon_placeholder-01.jpg?width=4000&name=coming_soon_placeholder-01.jpg',
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
                                  padding: const EdgeInsets.only(left:5.0,top:10),
                                  child: Row(
                                    children: [
                                      Text("Posted to "),
                                      Text(widget.complaintModel.rTo,style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
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

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        child: Text(widget.complaintModel.rCmptText,style: TextStyle(fontSize: 18,height: 1.5),maxLines: 15,),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Attachments",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.attachment_sharp,color: Colors.blue,),
                        SizedBox(width: 5,),
                        Text("https//hsdv jhdjd dj jvh vajd dnv njan "),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(
                      children: [
                        Icon(Icons.attachment_sharp,color: Colors.blue,),
                        SizedBox(width: 5,),
                        Text("https//hsdv jhdjd dj jvh vajd dnv njan "),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left:5.0,top:3),
                      child: Row(
                        children: [
                          Text("Status :",style: TextStyle(fontSize: 17),),
                          Text("Progress",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      // width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border:Border.all(color: Colors.grey.shade300,width: 1,)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:20.0,right:20,top:10,bottom:10),
                          child: Text("Contact",style: TextStyle(fontWeight: FontWeight.bold),),
                        )),
                    SizedBox(height:10),
                    Text("Track Application Process",style: TextStyle(fontWeight: FontWeight.bold),),
                    Container(
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
                    ),
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
}
