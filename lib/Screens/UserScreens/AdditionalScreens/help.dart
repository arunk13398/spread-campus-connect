import 'package:flutter/material.dart';

import '../../../Theme/theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("assets/letterblacknewcolor.png",height: 100,)),
                Text("Account Setup and Management",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("This section provides step-by-step instructions on how to create an account, set up a profile, and manage account settings. It may cover topics such as changing usernames, updating personal information, password management, and account deletion."),
                SizedBox(height: 10,),

                Text("Privacy and Safety Controls",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("This part of the help page explains the tools and settings available to users for managing their privacy and safety on the platform. It may include instructions on blocking or reporting inappropriate content, managing comment filters, and customizing notification preferences."),
                SizedBox(height: 10,),

                Text("Troubleshooting and Technical Support",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The help page often includes a section dedicated to troubleshooting common issues that users may encounter. It may provide step-by-step solutions or offer links to additional resources such as troubleshooting guides, community forums, or customer support channels"),
                SizedBox(height: 10,),

                Text("Policies and Community Guidelines",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("This section outlines the platform's policies, terms of service, and community guidelines. It helps users understand what is acceptable behavior on the platform and the consequences for violating these guidelines"),
                SizedBox(height: 10,),

                Text("Contact and Support",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The help page typically provides contact information or links to support resources. This can include customer support email addresses, live chat options, or links to support forums where users can find assistance."),

                SizedBox(height: 50,),

                Text("Thankyou",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: MyColors.Colorgreen3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
