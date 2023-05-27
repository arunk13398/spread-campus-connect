import 'package:flutter/material.dart';

import '../../../Theme/theme.dart';

class VerificationProcess extends StatelessWidget {
  const VerificationProcess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/officerGif.gif"),
            Text("Kindely hold and wait for verification",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: MyColors.Colorgreen3))
          ],
        ),
      ),
    );
  }
}
