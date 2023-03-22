import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../functions/functions.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: InkWell(
        onLongPress: (){
          showAlertDialog(context);
        },
        child: SizedBox(
          height: 100,
            width: 100,
            child: Center(child: Text("Update soon"))),
      )),
    );
  }
}
