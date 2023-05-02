import 'dart:collection';

import 'package:chip_list/chip_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniq/Screens/bottom_navigation.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:miniq/functions/functions.dart';

import 'login_screen.dart';

class UserRegistration extends StatefulWidget {
  String number;
   UserRegistration({Key? key,required this.number}) : super(key: key);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();


  // Initial Selected Value
  String _designationDpValue = 'Student';
  String _academicDpValue = 'First year';
  String _collegeDpValue = 'GECWayanad';
  String _departmentDpValue = 'Cs';
  String _courseDpValue = 'Btech';
  String _studentValue ='Student';
  String _alumniValue ='Alumni';
  bool _isChecked = true;

  var _usersList = ['Student', 'Teacher', 'NonTeachingStaff', 'OtherEmployees', 'Alumni', 'Others',];
  var _academicYear = ['First year','Second year', 'Third year', 'Fourth year',];
  var _department = ['Cs','Eee','Civil','Arch','Ec','Mech','Auto','Other'];
  var _course = ['Btech','Mtech','Other'];
  var _college = ['GECWayanad', 'GECIdukki','GECPalakkad','GECKannur','GECThrissor','GECThiruvananthapuram','Others'];
  final List<String> _suggestion = ['Music', 'Dance','literacy','Film', 'Drawing', 'Friendship','acting','coding','innovation','technology','sports',];


  // bool isChecked=false;
  TextEditingController name= TextEditingController();
  TextEditingController number= TextEditingController();
  TextEditingController college= TextEditingController();
  TextEditingController yearOfPassOut= TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child:

        // Column(
        //   children: [
        //     Expanded(
        //       child: Column(
        //         children: [
        //           Padding(
        //               padding: EdgeInsets.only(top: 16.0,bottom: 00),
        //               child: Image(
        //                 image: AssetImage('assets/r5.png'),
        //                 height: 250.0,
        //               )),
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: TextFormField(
        //               controller: name,
        //               inputFormatters: [
        //                 // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
        //               ],
        //               // controller: value.contactPerson,
        //               textInputAction: TextInputAction.next,
        //               keyboardType: TextInputType.name,
        //               decoration: const InputDecoration(
        //                 border: OutlineInputBorder(),
        //                 labelText: 'Name',
        //                 hintText: 'Name',
        //                 filled: true,
        //                 fillColor: Colors.white,
        //               ),
        //               autofocus: false,
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: TextFormField(
        //               enabled: false,
        //               controller: number,
        //               inputFormatters: [
        //                 FilteringTextInputFormatter.allow(RegExp('[0-9]'))
        //               ],
        //               // controller: value.contactPerson,
        //               textInputAction: TextInputAction.next,
        //               keyboardType: TextInputType.phone,
        //               decoration: const InputDecoration(
        //                 border: OutlineInputBorder(),
        //                 labelText: 'Contact Number',
        //                 hintText: 'Enter Contact Number',
        //                 filled: true,
        //                 fillColor: Colors.white,
        //               ),
        //               autofocus: false,
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: TextFormField(
        //               controller: college,
        //               inputFormatters: [
        //                 // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
        //               ],
        //               // controller: value.contactPerson,
        //               textInputAction: TextInputAction.next,
        //               keyboardType: TextInputType.name,
        //               decoration: const InputDecoration(
        //                 border: OutlineInputBorder(),
        //                 labelText: 'College',
        //                 hintText: 'College',
        //                 filled: true,
        //                 fillColor: Colors.white,
        //               ),
        //               autofocus: false,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(left:15.0,right: 15,top: 20,bottom: 20),
        //       child: Container(
        //         height: 50,
        //         child: MaterialButton(
        //           color: Colors.blue,
        //           minWidth: double.infinity,
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(10.0)),
        //           onPressed: () async {
        //             await addCustomer().then((value) {
        //               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //                 backgroundColor: Colors.white,
        //                 content: Text(
        //                   "Successful",
        //                   style: TextStyle(color: Colors.black),
        //                 ),
        //               ));
        //               finish(context);
        //             });
        //           },
        //           child: const Text("Register",style: TextStyle(color: Colors.white,fontSize: 20)),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Registration Form",
                            style: TextStyle(fontSize: 18,color:Colors.blue,fontWeight: FontWeight.bold),),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: name,
                        inputFormatters: [
                          // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        // controller: value.contactPerson,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          hintText: 'Name',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        autofocus: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: true,
                        controller: number,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        // controller: value.contactPerson,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contact Number',
                          hintText: 'Enter Contact Number',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        autofocus: false,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: TextFormField(
                    //     // controller: college,
                    //     inputFormatters: [
                    //       // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    //     ],
                    //     // controller: value.contactPerson,
                    //     textInputAction: TextInputAction.next,
                    //     keyboardType: TextInputType.name,
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       labelText: 'College',
                    //       hintText: 'College',
                    //       filled: true,
                    //       fillColor: Colors.white,
                    //     ),
                    //     autofocus: false,
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration:BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.black38,
                                width: 1
                            )
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // Initial Value
                            value: _collegeDpValue,
                            iconEnabledColor: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: _college.map((String items) {
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
                                _collegeDpValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width:5,),
                          Text("Select your designation ",style: TextStyle(color: Colors.black,fontSize: 16,)),
                          Spacer(),
                          Container(
                            width: 200,
                            height: 40,
                            decoration:BoxDecoration(
                                color:Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.black38,
                                    width: 1
                                )
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton(
                                  // Initial Value
                                  value: _designationDpValue,
                                  iconEnabledColor: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  // Array list of items
                                  items: _usersList.map((String items) {
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
                                      _designationDpValue = newValue!;
                                      print("asdfghjkl ${_designationDpValue}");
                                      print("asdfghjkl ${_studentValue}");
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                        ],
                      ),
                    ),

                    _designationDpValue==_studentValue?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width:5,),
                              Text("Select acadamic year ",style: TextStyle(color: Colors.black,fontSize: 16,)),
                              Spacer(),
                              Container(
                                width: 200,
                                height: 40,
                                decoration:BoxDecoration(
                                    color:Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.black38,
                                        width: 1
                                    )
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    // Initial Value
                                    value: _academicDpValue,
                                    iconEnabledColor: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    // Array list of items
                                    items: _academicYear.map((String items) {
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
                                        _academicDpValue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              SizedBox(width: 5,),
                              Text("Choose Course",style: TextStyle(color: Colors.black,fontSize: 16,)),
                              Spacer(),
                              Text("Select Department",style: TextStyle(color: Colors.black,fontSize: 16,)),
                              SizedBox(width: 10,),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width:5,),
                              // Text("Select your designation ",style: TextStyle(color: Colors.black,fontSize: 16,)),
                              Container(
                                width: 150,
                                height: 40,
                                decoration:BoxDecoration(
                                    color:Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.black38,
                                        width: 1
                                    )
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    // Initial Value
                                    value: _courseDpValue,
                                    iconEnabledColor: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    // Array list of items
                                    items: _course.map((String items) {
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
                                        _courseDpValue = newValue!;
                                        print("asdfghjkl ${_courseDpValue}");
                                        print("asdfghjkl ${_studentValue}");
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 150,
                                height: 40,
                                decoration:BoxDecoration(
                                    color:Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.black38,
                                        width: 1
                                    )
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    // Initial Value
                                    value: _departmentDpValue,
                                    iconEnabledColor: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    // Array list of items
                                    items: _department.map((String items) {
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
                                        _departmentDpValue = newValue!;
                                        print("asdfghjkl ${_departmentDpValue}");
                                        print("asdfghjkl ${_studentValue}");
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                            ],
                          ),
                        ],
                      ),
                    ):Container(),
                    _designationDpValue==_alumniValue?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: yearOfPassOut,
                        inputFormatters: [
                          // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        // controller: value.contactPerson,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Year of Passout Batch',
                          hintText: 'Examble : 2022',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        autofocus: false,
                      ),
                    ):Container(),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(alignment: Alignment.centerLeft,
                          child: Text("Choose your interest, That will help in to the ",style: TextStyle(color: Colors.grey,fontSize: 16,))),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: ChipList(
                          listOfChipNames: _suggestion,
                          supportsMultiSelect: true,
                          activeBgColorList: const [MyColors.Colorgreen3],
                          inactiveBgColorList:  [Colors.blue.shade50],
                          activeTextColorList: const [
                            // Colors.pink,
                            // Colors.yellow,
                            // Colors.green,
                            Colors.white
                          ],
                          inactiveTextColorList: [Theme.of(context).primaryColor],
                          listOfChipIndicesCurrentlySeclected: [6],
                          inactiveBorderColorList: [MyColors.Colorgreen3],
                          activeBorderColorList: const [
                            // Colors.pink,
                            // Colors.yellow,
                            // Colors.green,
                            MyColors.Colorgreen3
                          ],
                          // extraOnToggle: (val) {
                          //   _currentIndex = val;
                          //   print('Using extraOnToggle: ${_suggestion[_currentIndex]}');
                          //   setState(() {});
                          // },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("If any violations or any other inappropriate activities will found, we take the disciplinary actions and other procedures.",style:TextStyle(fontSize: 16,color: Colors.grey,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:5.0,right: 5,),
                      child: CheckboxListTile(
                        activeColor: MyColors.Colorgreen3,
                        title: Text("Agree the terms",style: TextStyle(color: Colors.black,fontSize: 18,),),
                        value: _isChecked,
                        onChanged: (val) {
                          setState(() {
                            _isChecked = val!;
                          });
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15,top: 20,bottom: 20),
              child: Container(
                height: 50,
                child: MaterialButton(
                  color: MyColors.Colorgreen3,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () async {
                    await addCustomer().then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.grey,
                        content: Text(
                          "Successful",
                          style: TextStyle(color: Colors.black),
                        ),
                      ));
                      // description.clear();
                      // finish(context);
                    });
                  },

                  // onPressed: () async {
                  //   await addCustomer().then((value) {
                  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //       backgroundColor: Colors.white,
                  //       content: Text(
                  //         "Successful",
                  //         style: TextStyle(color: Colors.black),
                  //       ),
                  //     ));
                  //     finish(context);
                  //   });
                  // },
                  child: const Text("Register",style: TextStyle(color: Colors.white,fontSize: 20)),
                ),
              ),
            ),
          ],
        )
      )
    );
  }

  Future<void> addCustomer() async {

    HashMap<String, dynamic> data = HashMap<String, dynamic>();
    String id = widget.number;
    String id1 = _collegeDpValue;
    String id2 = _designationDpValue;

    data["Id"] = id;
    data["Name"] = name.text;
    data["Phone"] = widget.number;
    data["CreatedBy"] = widget.number;
    data["College"] =_collegeDpValue;


    if( _designationDpValue==_studentValue){
      data["Designation"] =_designationDpValue;
      data["AcademicYear"] =_academicDpValue;
      data["Course"] =_courseDpValue;
      data["Department"] =_departmentDpValue;
    }else if(_designationDpValue==_alumniValue){
      data["Designation"] =_designationDpValue;
      data["yearOfPassOut"] =yearOfPassOut.text;
    }else{
      data["Designation"] =_designationDpValue;
    }
    data["TC"] =_isChecked;
    data["Date"] = DateTime.now().toString();
    data["AcessCode"] = '1';
    data["AcessName"] = 'Users';
    data["ImageUrl"] = 'https://th.bing.com/th/id/R.24d66af25476d7cf5702be09685c8304?rik=56f5Kkp5psyp1Q&riu=http%3a%2f%2fwww.healthline.com%2fhlcmsresource%2fimages%2fmedical-reviewer%2fplaceholder-man.png&ehk=uy%2f3eWPXRQPMjijrfL3A91H0eypL%2bHRS8y3cfO77RWA%3d&risl=&pid=ImgRaw&r=0';
    data["DateMillisecondsSinceEpoch"] = DateTime.now().millisecondsSinceEpoch.toString();

    HashMap<String, dynamic> access = HashMap<String, dynamic>();
    access["Name"] = name.text;
    access["Phone"] = id;
    access["AcessCode"] = '1';
    access["AcessName"] = 'Users';
    access["College"] =_collegeDpValue;
    access["Designation"] =_designationDpValue;
    await mRootReference.child("UsersList").child(id1).child(id).child(id2).update(data);

    await mRootReference.child("AccessControl").child(id).update(access);
    Future.delayed(const Duration(seconds: 1), () {
      finishAccountCreation( LoginScreen(), context);
    });
  }
}
