import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Model/listdata_model.dart';
import '../../../Model/user_list_modal.dart';
import '../../../Theme/theme.dart';
import '../../../functions/functions.dart';
import '../../UserScreens/LoginScreen/login_screen.dart';
import '../../bottom_navigation.dart';

class AddNewListPage extends StatefulWidget {
  const AddNewListPage({Key? key}) : super(key: key);

  @override
  State<AddNewListPage> createState() => _AddNewListPageState();
}

class _AddNewListPageState extends State<AddNewListPage> {

  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  final databaseRef = FirebaseDatabase.instance.reference();

  List<ListDataModel> datalist = [];
  List <String> newitems = [];
  String newitem='';
  String _academicDpValue = 'Club';
  var _academicYear = ['User','Club', 'Reviewer','Publisher','Alumini','Admin',];
  TextEditingController newListController = TextEditingController();

  void initState() {
    load();
    getDataF1();
    // TODO: implement initState
    super.initState();
  }

  getDataF1() async {
    mRootReference
        .child("ListDemo").child("cse").once().then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        newitem=data['Text'];
        print("popopopopo-------------------- ${newitem}");
        setState(() {});
      }
    });
  }


  // void getItems() {
  //   databaseRef.child('items').once().then((DataSnapshot snapshot) {
  //     Map<dynamic, dynamic> values = snapshot.value;
  //     values.forEach((key, value) {
  //       items.add(value['name']);
  //     });
  //   });
  // }

  load() async {
    mRootReference.child("ListDemo").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      datalist.clear();
      data.forEach((key, value) {
        datalist.add(ListDataModel(
          id: key,
        ));
      });
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     body: SafeArea(
       child: Column(
       children: [
       Padding(
         padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: newListController,
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
    ),
         MaterialButton(
           color: MyColors.Colorgreen3,
           minWidth: double.infinity,
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(10.0)),
           onPressed: () async {
             await AddList().then((value) {
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
         MaterialButton(
           color: MyColors.Colorgreen3,
           minWidth: double.infinity,
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(10.0)),
           onPressed: () async {
             print("vvvvvvvvvv${newitem}");
           },
           child: const Text("test",style: TextStyle(color: Colors.white,fontSize: 20)),
         ),
         SizedBox(
           height: 200,
           child: ListView.builder(
             itemCount: datalist.length,
             itemBuilder: (context, index) => ListTile(
             leading: Text(datalist[index].id),
           ),),
         ),
         Container(
           decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
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
                   value: _academicDpValue,
                   iconEnabledColor: Colors.black,
                   borderRadius: BorderRadius.circular(10),
                   icon: const Icon(Icons.keyboard_arrow_down),
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
                       print("asdfghjkl ${_academicDpValue}");
                       print("asdfghjkl ${_academicYear}");
                     });
                   },
                 ),
               ),
             ),
           ),
         ),
       ],),
     ),
    );
  }
  Future<void> AddList() async {

    HashMap<String, dynamic> data = HashMap<String, dynamic>();
    String id = newListController.text;
    data["Text"] = newListController.text;
    await mRootReference.child("ListDemo").child(id).update(data);

    Future.delayed(const Duration(seconds: 1), () {
      finishAccountCreation( BottomNavigation(), context);
    });
  }
}
