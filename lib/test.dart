import 'package:cached_network_image/cached_network_image.dart';
import 'package:chip_list/chip_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestDemo extends StatefulWidget {
  const TestDemo({Key? key}) : super(key: key);

  @override
  State<TestDemo> createState() => _TestDemoState();
}

class _TestDemoState extends State<TestDemo> {

  // Initial Selected Value
  String dropdownvalue = 'designation';
  String dropdownvalue1 = 'Academic Year';
  String testValue ='Student';


  var usersList = ['designation', 'Student', 'Teacher', 'Non Teaching Staff', 'Other Employees', 'Alumni', 'Others',];

  var academicYear = ['Academic Year', 'First year','Second year', 'Third year', 'Fourth year',];

  var college = ['Govt engineering college Wayanad', 'Govt engineering college Idukki','Govt engineering college Palakkad','Govt engineering college Kannur','Govt engineering college Thrissor','Govt engineering college Thiruvananthapuram',];

  final List<String> _suggestion = ['Music', 'Dance', 'Film', 'Drawing', 'Friendship', 'Association', 'Association',];

  int _currentIndex = 0;

  var size,height,width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // controller: name,
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
                    // controller: number,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // controller: college,
                    inputFormatters: [
                      // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    ],
                    // controller: value.contactPerson,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'College',
                      hintText: 'College',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    autofocus: false,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width:5,),
                      Text("Select your designation ",),
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
                            value: dropdownvalue,
                            iconEnabledColor: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: usersList.map((String items) {
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
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width:5,),
                      Text("Select acadamic year ",),
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
                            value: dropdownvalue1,
                            iconEnabledColor: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: academicYear.map((String items) {
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
                                dropdownvalue1 = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(alignment: Alignment.centerLeft,
                      child: Text("Choose your interest,that will help in to the ",)),
                ),
                //
                //
                // const Text(
                //   'Using supportsMultiSelect - using border colors and text color',
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: ChipList(
                      listOfChipNames: _suggestion,
                      supportsMultiSelect: true,
                      activeBgColorList: const [Colors.blue],
                      inactiveBgColorList: const [Colors.white],
                      activeTextColorList: const [
                        // Colors.pink,
                        // Colors.yellow,
                        // Colors.green,
                        Colors.white
                      ],
                      inactiveTextColorList: [Theme.of(context).primaryColor],
                      listOfChipIndicesCurrentlySeclected: [0],
                      inactiveBorderColorList: [Colors.grey.shade300],
                      activeBorderColorList: const [
                        // Colors.pink,
                        // Colors.yellow,
                        // Colors.green,
                        Colors.blue
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15,top: 20,bottom: 20),
                  child: Container(
                    height: 50,
                    child: MaterialButton(
                      color: Colors.blue,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () async {
                        // await addCustomer().then((value) {
                        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        //     backgroundColor: Colors.white,
                        //     content: Text(
                        //       "Successful",
                        //       style: TextStyle(color: Colors.black),
                        //     ),
                        //   ));
                        //   finish(context);
                        // });
                      },
                      child: const Text("Register",style: TextStyle(color: Colors.white,fontSize: 20)),
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

}


