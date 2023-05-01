import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Screens/AdminScreen/admin_dashboard.dart';
import 'package:miniq/Screens/UserScreens/LoginScreen/login_screen.dart';
import 'package:miniq/Screens/bottom_navigation.dart';
import 'package:miniq/Screens/test_page.dart';
import 'package:miniq/Theme/theme.dart';
import 'package:miniq/functions/functions.dart';

import '../../Adminbottom_navigation.dart';

class SplashScreen extends StatefulWidget {
   SplashScreen({Key? key, }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkLogin(context);
    return Scaffold(
      // backgroundColor: MyColors.main1,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Container(
              child:Image(
                image: AssetImage('assets/letterblacknewcolor.png'),
                height: 270.0,
                width: 270.0,),
            ),
            SizedBox(height: 50),
            CircularProgressIndicator(color: Colors.white,)
          ],
        ),
      ),
    );
  }

  checkLogin(BuildContext context)async{
    if(await getBool(UserPreferences.IS_LOGIN)??false){
      if(await getString(UserPreferences.ACCESS_CODE)=="1"){
        Future.delayed(const Duration(milliseconds: 3000), () {
          callTo( BottomNavigation(), context);
        });
      }
      else if(await getString(UserPreferences.ACCESS_CODE)=="2"){
        Future.delayed(const Duration(milliseconds: 3000), () {
          callTo( AdminBottomNavigation(), context);
        });
      }
      else{
        print(await getString(UserPreferences.ACCESS_CODE));
      }
    }else{
      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
}
