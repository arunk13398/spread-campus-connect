import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../Model/user_list_modal.dart';
import '../../../functions/functions.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {

  // String _academicDpValue = 'Club';
  // var _academicYear = ['User','Club', 'Reviewer','Publisher','Alumini','Admin',];
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  List<UserListModel> userlist = [];
  @override
  void initState() {
    load();
    // TODO: implement initState
    super.initState();
  }

  load() async {
    mRootReference.child("AccessControl").onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      userlist.clear();
      data.forEach((key, value) {
        userlist.add(UserListModel(
          id: key,
          userName: value['Name'],
          desigUser: value['Designation'],
          Phone: value['Phone'],
          College: value['College'],
          AccessName: value['AcessName'],
        ));
      });
      setState(() {});
    });
  }


  @override
  var size,height,width;
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  Scaffold (
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ListView.builder(
            itemCount: userlist.length,
            itemBuilder: (context, index) => UsersListview(index),),
        ),
      ),
    );
  }
  Widget UsersListview(int index){
    return Slidable(
      // enabled: false,
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(
            onDismissed: () {
              showAlertDialog(context);
            }),

        // All actions are defined in the children parameter.
        children: const [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: doNothing,
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        color:Colors.blue,
                        borderRadius: BorderRadius.circular(60)
                    ),child:Center(child: Text("AK",style:TextStyle(fontSize:20,color: Colors.white)))),
                SizedBox(width:15),
                SizedBox(
                  width: width/2.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userlist[index].userName,style:TextStyle(fontSize:18,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                      Text(userlist[index].desigUser,style:TextStyle(fontSize:16,color: Colors.grey)),
                      Text(userlist[index].College,style:TextStyle(fontSize:12,color: Colors.blue.shade200)),
                    ],
                  ),
                ),
                SizedBox(width:5),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         width: 0.3,
                //       )
                //   ),
                //   child: DropdownButtonHideUnderline(
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: SizedBox(
                //         height: 20,
                //         child: DropdownButton(
                //           value: _academicDpValue,
                //           iconEnabledColor: Colors.black,
                //           borderRadius: BorderRadius.circular(10),
                //           icon: const Icon(Icons.keyboard_arrow_down),
                //           items: _academicYear.map((String items) {
                //             return DropdownMenuItem(
                //               value: items,
                //               child: Padding(
                //                 padding: const EdgeInsets.only(left:10.0,right:10),
                //                 child: Text(items),
                //               ),
                //             );
                //           }).toList(),
                //           // After selecting the desired option,it will
                //           // change button value to selected value
                //           onChanged: (String? newValue) {
                //             setState(() {
                //               _academicDpValue = newValue!;
                //               print("asdfghjkl ${_academicDpValue}");
                //               print("asdfghjkl ${_academicYear}");
                //             });
                //           },
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(width:5),
                Container(
                  width:80,
                  decoration: BoxDecoration(
                      color:Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child:Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Active",style:TextStyle(fontSize:18,color: Colors.green,fontWeight: FontWeight.bold)),
                      )),
                ),
                Icon(Icons.more_vert)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 8,bottom: 0,top:10),
            child: Divider(height: 1,color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
void doNothing(BuildContext context) {}