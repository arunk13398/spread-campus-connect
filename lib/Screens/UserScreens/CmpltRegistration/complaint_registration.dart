import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Theme/theme.dart';

class ComplaintRegistration extends StatefulWidget {
  const ComplaintRegistration({Key? key}) : super(key: key);

  @override
  State<ComplaintRegistration> createState() => _ComplaintRegistrationState();
}

class _ComplaintRegistrationState extends State<ComplaintRegistration> {
  // var size,height,width;
  @override
  Widget build(BuildContext context) {
    // size = MediaQuery.of(context).size;
    // height = size.height;width = size.width;
    return Scaffold(
        backgroundColor: MyColors.Blackcolor,
        // appBar: AppBar(
        //    backgroundColor: MyColors.theme1,
        //   title: Text("Register form"),
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Register form",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: MyColors.Orangecolor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: MyColors.Whitecolor),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Name',
                      labelStyle: TextStyle(color: MyColors.Whitecolor),
                      hintStyle: TextStyle(color: MyColors.Orangecolor),
                      hintText: 'Name',
                      filled: true,
                      fillColor: MyColors.LightBlackcolor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: MyColors.Whitecolor),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Mobile number',
                      labelStyle: TextStyle(color: MyColors.Whitecolor),
                      hintStyle: TextStyle(color: MyColors.Orangecolor),
                      hintText: 'Mobile number',
                      filled: true,
                      fillColor: MyColors.LightBlackcolor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: MyColors.Whitecolor),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'College register number',
                      hintText: 'College register number',
                      filled: true,
                      fillColor: MyColors.LightBlackcolor,
                      labelStyle: TextStyle(color: MyColors.Whitecolor),
                      hintStyle: TextStyle(color: MyColors.Orangecolor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: MyColors.Whitecolor),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'College admission number',
                      hintText: 'College admission number',
                      filled: true,
                      fillColor: MyColors.LightBlackcolor,
                      labelStyle: TextStyle(color: MyColors.Whitecolor),
                      hintStyle: TextStyle(color: MyColors.Orangecolor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: MyColors.Whitecolor),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'To',
                      hintText: 'To',
                      filled: true,
                      fillColor: MyColors.LightBlackcolor,
                      labelStyle: TextStyle(color: MyColors.Whitecolor),
                      hintStyle: TextStyle(color: MyColors.Orangecolor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: MyColors.Whitecolor),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Subject',
                      hintText: 'Subject',
                      filled: true,
                      fillColor: MyColors.LightBlackcolor,
                      labelStyle: TextStyle(color: MyColors.Whitecolor),
                      hintStyle: TextStyle(color: MyColors.Orangecolor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: MyColors.LightBlackcolor, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Complaint text",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: MyColors.Orangecolor),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    child: TextFormField(
                      style: TextStyle(color: MyColors.Whitecolor),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Subject',
                        hintText: 'Subject',
                        filled: true,
                        fillColor: MyColors.LightBlackcolor,
                        labelStyle: TextStyle(color: MyColors.Whitecolor),
                        hintStyle: TextStyle(color: MyColors.Orangecolor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: MyColors.LightBlackcolor, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: MyColors.LightBlackcolor, width: 1.6),
                        ),
                      ),
                      maxLines: 100,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => HomeScreenBuyer()));
                        },
                        textColor: Colors.white,
                        color: MyColors.Orangecolor,
                        minWidth: double.infinity,
                        height: 60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(
                              fontSize: 18, color: MyColors.Blackcolor),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
