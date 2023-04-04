import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Contraints/user_preference.dart';




class TestDemo extends StatefulWidget {

  TestDemo({Key? key, }) : super(key: key);

  @override
  State<TestDemo> createState() => _TestDemoState();
}

class _TestDemoState extends State<TestDemo> {




  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  bool isConnected = false;
  String Uid='';
  String College='';
  String designation='';


  late FirebaseAuth _auth;
  late Stream<User?> _authStateChanges;


  initAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    _auth = FirebaseAuth.instance;
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges.listen((User? user) {

      setState(() {
        Uid = user?.uid??"";
      });
      print("...user id ${user?.uid}....");
    });
  }

  void initState() {
    super.initState();
    initAuth();
    checkRealtimeConnection();
    getSharPdata();
  }

  void checkRealtimeConnection() {
    Connectivity().onConnectivityChanged.listen((my_result) {
      if (my_result == ConnectivityResult.mobile ||
          my_result == ConnectivityResult.wifi) {
        print("connected");
        setState(() {
          isConnected = true;
        });
      } else if (my_result == ConnectivityResult.none) {
        print("not connected");
        setState(() {
          isConnected = false;
        });
      }
    });
  }


  List<Step> stepList() => [
    Step(
      isActive: _currentStep==0,
      title: Text('Step1'),
      subtitle: Text('Processing'),
      label: Container(child:Text("hello")),
      content: Center(child: Text(''),),
    ),
    Step(
      isActive: _currentStep==1,
      title: Text('Step2'),
      subtitle: Text('Processing'),
      label: ColoredBox(color: Colors.tealAccent),
      content: Center(child: Text('bbbbb'),),
    ),
    Step(
      isActive: _currentStep==2,
      title: Text('Step3'),
      subtitle: Text('Processing'),
      label: Container(child:Text("kooo")),
      content: Center(child: Text('ccccc'),),
    ),
  ];

  int _currentStep=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Uid                      :"+Uid,style: TextStyle(fontSize:13),),
              Text("College              :"+College,style: TextStyle(fontSize:13),),
              Text("designation       :"+ designation,style: TextStyle(fontSize:13),),
              Text(isConnected?"Network connected":"Network not connected",style: TextStyle(fontSize:13,),),
            ],
          ),
        ),
        body: Stepper(
          steps: stepList(),
          onStepTapped: (int newIndex){
            setState(() {
              _currentStep = newIndex;
            });
          },
          currentStep: _currentStep,
          onStepContinue: (){
            if(_currentStep!=2){
              setState(() {
                _currentStep += 1;
              });
            }
          },onStepCancel: (){
          if(_currentStep!=0){
            setState(() {
              _currentStep -= 1;
            });
          }
        },type: StepperType.vertical,
        ),
    );
  }





  getSharPdata() async {

    College = (await getString(UserPreferences.COLLEGE));
    designation = (await getString(UserPreferences.DESIGNATION));
  }
}

