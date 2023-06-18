import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Model/CategoryListDataModel.dart';
import '../../../Model/listdata_model.dart';
import '../../../Theme/theme.dart';


class AddNewListPage extends StatefulWidget {
  const AddNewListPage({Key? key}) : super(key: key);

  @override
  State<AddNewListPage> createState() => _AddNewListPageState();
}

class _AddNewListPageState extends State<AddNewListPage> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  TextEditingController newListController = TextEditingController();
  TextEditingController CategoryItem = TextEditingController();
  TextEditingController SubCategoryItem = TextEditingController();
  TextEditingController NewSubCategoryItem = TextEditingController();

  final CategoryItem1 = TextEditingController();
  final CategoryItem2 = TextEditingController();


  List<ListDataModel> datalist=[];
  ListDataModel?selectedItem;

  List<CategoryListDataModel> Categorydatalist=[];
  CategoryListDataModel?CategoryselectedItems;

  bool isSwitchedCategoryItem = false;
  bool isSwitchedCategory = false;
  bool isSwitchedSubCategory = false;

  int isColorSelected=0;

  @override
  void initState() {
    loadNotification();
    CategoryloadNotification();
    // TODO: implement initState
    super.initState();
  }


  @override
  var size,height,width;
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  Scaffold(
      body: SafeArea(
        child:

        SingleChildScrollView(
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Category Management",
                      style: TextStyle(fontSize: 18,color:MyColors.Colorgreen3,fontWeight: FontWeight.bold),),
                  )),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: width/1.1,
                  height: 40,
                  decoration:BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.black38,
                          width: 1
                      )
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0,right:20),
                      child: DropdownButton<ListDataModel>(
                        value : selectedItem,
                        iconEnabledColor: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                        icon: const Icon(Icons.swap_vert),
                        onChanged:(ListDataModel? newValue){
                          setState((){
                            selectedItem = newValue;
                            CategoryloadNotification();
                            getDataF1(hashCode);
                          });

                        },
                        items: datalist.map<DropdownMenuItem<ListDataModel>>((ListDataModel value){
                          return DropdownMenuItem<ListDataModel>(
                              value: value,
                              child:Padding(
                                padding: const EdgeInsets.only(left:10.0,right:10),
                                child: Text(value.id),
                              )
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width:double.infinity,
                  height:50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: Categorydatalist.length,
                    itemBuilder: (context, index) => AdaptorNew(index),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Row(
                    children: [
                      Text("Add new Category",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Switch(
                          value: isSwitchedCategory,
                          onChanged: (value){
                            setState(() {
                              isSwitchedCategory = value;

                            });
                          }),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Row(
                    children: [
                      Text("sub Category Items",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Switch(
                          value: isSwitchedCategoryItem,
                          onChanged: (value){
                            setState(() {
                              isSwitchedCategoryItem = value;

                            });
                          }),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Row(
                    children: [
                      Text("sub Category access",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Switch(
                          value: isSwitchedSubCategory,
                          onChanged: (value){
                            setState(() {
                              isSwitchedSubCategory = value;

                            });
                          }),
                    ],
                  ),
                ),
              ),
              isSwitchedCategoryItem==true?Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: CategoryItem1,
                    enabled: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Category name',
                      hintText: 'Category name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    autofocus: false,
                  ),
                ),
                Padding(
                 padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: newListController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add new Item',
                    hintText: 'Add new Item',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  autofocus: false,
                ),
           ),
                Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: MaterialButton(
                   height: 50,
                   color: MyColors.Colorgreen3,
                   minWidth: double.infinity,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10.0)),
                   onPressed: () async {
                     await AddList(hashCode).then((value) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                         backgroundColor: Colors.grey,
                         content: Text(
                           "Successful",
                           style: TextStyle(color: Colors.black),
                         ),
                       ));
                       newListController.clear();
                       // description.clear();
                       // finish(context);
                     });
                   },
                   child: const Text("create new data list",style: TextStyle(color: Colors.white,fontSize: 20)),
                 ),
           ),
              ],
            ):Container(),
              isSwitchedCategory==true?Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Add item in to this category"),
                ),
                Padding(
                 padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: CategoryItem,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Category name',
                    hintText: 'Category name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  autofocus: false,
                ),
           ),
                Padding(
                 padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: SubCategoryItem,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sub Category item name',
                    hintText: 'Sub Category item name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  autofocus: false,
                ),
           ),
                Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: MaterialButton(
                   height: 50,
                   color: MyColors.Colorgreen3,
                   minWidth: double.infinity,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10.0)),
                   onPressed: () async {
                     await AddList(hashCode).then((value) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                         backgroundColor: Colors.grey,
                         content: Text(
                           "Successful",
                           style: TextStyle(color: Colors.black),
                         ),
                       ));
                       newListController.clear();
                       // description.clear();

                     });
                   },
                   child: const Text("create new data list",style: TextStyle(color: Colors.white,fontSize: 20)),
                 ),
           ),
              ],
                 ):Container(),
              isSwitchedSubCategory==true?Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Add item in to this category"),
                ),
                Padding(
                 padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: CategoryItem1,
                  enabled: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Category name',
                    hintText: 'Category name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  autofocus: false,
                ),
           ),
                Padding(
                 padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: CategoryItem2,
                  enabled: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sub Category item name',
                    hintText: 'Sub Category item name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  autofocus: false,
                ),
           ),
                Padding(
                 padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: NewSubCategoryItem,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'item name',
                    hintText: ' item name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  autofocus: false,
                ),
           ),



                Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: MaterialButton(
                   height: 50,
                   color: MyColors.Colorgreen3,
                   minWidth: double.infinity,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10.0)),
                   onPressed: () async {
                     await AddList(hashCode).then((value) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                         backgroundColor: Colors.grey,
                         content: Text(
                           "Successful",
                           style: TextStyle(color: Colors.black),
                         ),
                       ));
                       newListController.clear();
                       // description.clear();

                     });
                   },
                   child: const Text("create new data list",style: TextStyle(color: Colors.white,fontSize: 20)),
                 ),
           ),
              ],
                 ):Container(),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> AddList(int index) async {

    if(isSwitchedCategoryItem==true){
      if(selectedItem==null)return;
      HashMap<String, dynamic> data = HashMap<String, dynamic>();
      String id = newListController.text;
      data["id"] = newListController.text;
      await mRootReference.child("AccessManagement").child(selectedItem!.id).child(id).update(data);
      Future.delayed(const Duration(seconds: 1), () {
        // finishAccountCreation( AdminBottomNavigation(), context);
      });
    }else if(isSwitchedCategory==true){
      HashMap<String, dynamic> data = HashMap<String, dynamic>();
      String id = CategoryItem.text;
      String id1 = SubCategoryItem.text;
      data["id"] = SubCategoryItem.text;
      await mRootReference.child("AccessManagement").child(id).child(id1).update(data);
      Future.delayed(const Duration(seconds: 1), () {
        // finishAccountCreation( AdminBottomNavigation(), context);
      });
    }else if(isSwitchedSubCategory==true){
      HashMap<String, dynamic> data = HashMap<String, dynamic>();
      String id = CategoryItem1.text;
      String id1 = CategoryItem2.text;
      String id2 = NewSubCategoryItem.text;
      data["id"] = NewSubCategoryItem.text;
      await mRootReference.child("AccessManagement").child(id).child(id1).child(id2).update(data);
      // await mRootReference.child("AccessManagement").child(id).child(id1).remove(data);
      Future.delayed(const Duration(seconds: 1), () {
        // finishAccountCreation( AdminBottomNavigation(), context);
      });
    }
    else{}

  }

  loadNotification() {
    mRootReference.child("AccessManagement").onValue.listen((event) {
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

  CategoryloadNotification() {
if(selectedItem==null)return;
    mRootReference.child("AccessManagement").child(selectedItem!.id).onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map;
      Categorydatalist.clear();
      data.forEach((key, value) {
        Categorydatalist.add(
            CategoryListDataModel(id: key,));
      });
    });
  }

  getDataF1(int index) async {
    CategoryItem1.text=selectedItem!.id;
    mRootReference.child("AccessManagement").child(selectedItem!.id).child(Categorydatalist[index].id)
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        print("lllllllll ${value.snapshot.value}");
        Map<dynamic, dynamic> data = value.snapshot.value as Map;
        CategoryItem2.text = data["id"];

        setState(() {});
      }
    });
  }


  Widget AdaptorNew(int index){
    return Container(
      child: Center(
        child:Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onLongPress: (){
              DeleteAlert(context,index);
            },
            onTap: (){
              setState(() {
                isColorSelected=index;
                getDataF1(index);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: isColorSelected==index?MyColors.Colorgreen2:Colors.white,
                borderRadius: BorderRadius.circular(30)
              ),
                child: Padding(
                  padding: const EdgeInsets.only(left:15.0,right:15,top:7,bottom:7),
                  child: Text(Categorydatalist[index].id,
                    style: TextStyle(color: isColorSelected==index?Colors.white:Colors.black,fontSize: 16),),
                )),
          ),
        ),),
    );
  }

  DeleteAlert(BuildContext context,int index) {

    AlertDialog alert = AlertDialog(
      title: const Text("confirm"),
      content: const Text("Are you sure to delete"),
      actions: [
        TextButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () async {
            mRootReference
                .child("ListDemo").child(selectedItem!.id).child(Categorydatalist[index].id).remove();

            Navigator.of(context).pop();
          },
        ),

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

