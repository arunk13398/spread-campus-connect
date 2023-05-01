import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Screens/UserScreens/LoginScreen/otp_screen.dart';
import 'package:miniq/Theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumber= TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Expanded(
            child: Column(
              children: <Widget>[
                const Spacer(),
                Image.asset("assets/letterblacknewcolor.png",height: 150,),
                SizedBox(height: 0,),
                const Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, top: 0.0, right: 16.0, bottom: 40),
                  child: Text(
                    "Tap to Join Us",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 9,
                        child: TextField(
                          controller: phoneNumber,
                          focusNode: FocusNode(),
                          maxLength: 10,
                          autofocus: true,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                          hintText: 'Enter Mobile number',),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, bottom: 10.0, left: 30, right: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: MaterialButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(number: phoneNumber.text,)));
                        },
                        textColor: Colors.white,
                        color: MyColors.Colorgreen3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Text(
                          "Get OTP",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
                Text(
                  "kindly enter your mobile number it will be used to enterly this application",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
              ],
            ),
          ),
        ));
  }
}
