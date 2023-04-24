import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Contraints/user_preference.dart';
import 'package:miniq/Screens/AdminScreen/admin_dashboard.dart';
import 'package:miniq/Screens/bottom_navigation.dart';
import 'package:miniq/functions/functions.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:miniq/Screens/UserScreens/LoginScreen/user_registration.dart';

class OTPScreen extends StatefulWidget {
  String number;
  OTPScreen({Key? key,required this.number}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  TextEditingController currController = TextEditingController();
  String verificationId="";
  bool isLoading=true;
  @override
  initState() {
    super.initState();
    getOtp(context);

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body:!isLoading? Column(
        children: <Widget>[
          const Spacer(flex: 1),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 56.0),
                child: Text("Verifying your number !", style: TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 16.0, top: 8.0, right: 16.0),
                child: Text(
                  "Please type the verification code sent to",
                  style: TextStyle(
                      fontSize: 17.0, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 30.0, top: 5.0, right: 30.0),
                child: Text(
                  "",
                  style: TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.blue),
                  textAlign: TextAlign.center,),
              ),

              Padding(
                padding: EdgeInsets.only(top: 16.0,bottom: 00),
                child: Image(
                  image: AssetImage('assets/r3.png'),
                  height: 250.0,
              )),
            ],
          ),
          const Spacer(flex: 1,),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PinFieldAutoFill(
                codeLength: 6,
                focusNode: FocusNode(),
                keyboardType: TextInputType.number,
                autoFocus: true,
                controller: currController,
                currentCode: "",
                decoration:  BoxLooseDecoration(
                    textStyle: TextStyle(color: Colors.black),
                    radius: Radius.circular(5),
                    strokeColorBuilder: FixedColorBuilder(Colors.blue.shade200)),
                onCodeChanged: (pin) {
                  if (pin!.length == 6) {
                    matchOtp(context);
                  }
                },
              ),
            ),
          ),
          const Spacer(flex: 5),
        ],
      ):const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }


  Future matchOtp(BuildContext context) async{
    PhoneAuthCredential phoneAuthCredential;

    phoneAuthCredential= PhoneAuthProvider.credential(verificationId: verificationId, smsCode: currController.text);
    signInWithPhoneAuthCredential(phoneAuthCredential,context);
  }
  Future<void> listenOtp() async {
    SmsAutoFill().listenForCode;
  }
  void getOtp(BuildContext context) async{
    listenOtp();

    await firebaseAuth.verifyPhoneNumber(
      timeout: const Duration(seconds: 5),
      phoneNumber: "+91${widget.number}",
      verificationCompleted: (phoneAuthCredential) async {
      },
      verificationFailed: (verificationFailed) async {
        alertDialog(context, "Verification Failed", verificationFailed.message.toString());
      },
      codeSent: (id, resendingToken) async {
        verificationId = id;
        setState(() {
          isLoading=false;
          print("code sent");
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {

      },
    );

  }


  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential,BuildContext context) async {
    try {
      final authCredential = await firebaseAuth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        isLoading=true;
        String loginPh="+91${widget.number}";
        mRootReference.child('AccessControl').child(loginPh).once().then(( dataSnapshot){
          if(dataSnapshot.snapshot.exists){
            Map<dynamic, dynamic>loginData = dataSnapshot.snapshot.value as Map;
            if(loginData["AcessCode"].toString()=="1"){
              setBool(UserPreferences.IS_LOGIN,true);
              setString(UserPreferences.ACCESS_CODE,loginData["AcessCode"].toString());
              setString(UserPreferences.COLLEGE,loginData["College"].toString());
              setString(UserPreferences.DESIGNATION,loginData["Designation"].toString());
              setString(UserPreferences.USER_NUMBER,dataSnapshot.snapshot.key.toString());
              setString(UserPreferences.USER_Name,loginData["Name"].toString());
              setString(UserPreferences.USER_TYPE,loginData["AcessName"].toString());
              alertDialog(context,"Welcome ${loginData["Name"]}","You are successfully logged in");

              Future.delayed(const Duration(milliseconds: 1000), () {
                finishAccountCreation( BottomNavigation(), context);
              });
            }
            else if(loginData["AcessCode"].toString()=="2"){
              setBool(UserPreferences.IS_LOGIN,true);
              setString(UserPreferences.ACCESS_CODE,loginData["AcessCode"].toString());
              setString(UserPreferences.USER_NUMBER,dataSnapshot.snapshot.key.toString());
              setString(UserPreferences.COLLEGE,loginData["College"].toString());
              setString(UserPreferences.DESIGNATION,loginData["Designation"].toString());
              setString(UserPreferences.USER_Name,loginData["Name"].toString());
              setString(UserPreferences.USER_TYPE,loginData["AcessName"].toString());
              alertDialog(context,"Welcome ${loginData["Name"]}","You are successfully logged in");

              Future.delayed(const Duration(milliseconds: 1000), () {
                finishAccountCreation(const AdminDashboard(), context);
              });
            }
          }else{
            Future.delayed(const Duration(milliseconds: 1000), () {
              callNextReplacement(  UserRegistration(number: loginPh), context);
            });
          }
        });

      }
    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          e.message??"",
          style: const TextStyle(color: Colors.black),
        ),
      ));
    }
  }
}
