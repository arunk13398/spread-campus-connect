import 'package:flutter/material.dart';

import '../../../Theme/theme.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("assets/letterblacknewcolor.png",height: 100,)),
                Text("Personal Information Collection",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text(" The privacy policy should explain what types of personal information the social media application collects from its users. This may include information provided during the registration process (e.g., name, email address, username), as well as data collected during usage (e.g., posts, photos, location information)"),
                SizedBox(height: 10,),

                Text("Information Usage",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The policy should outline how the social media application uses the collected personal information. This may include purposes such as account management, providing the requested services, personalization, communication, analytics, and targeted advertising. It should also mention whether the information is shared with third parties."),
                SizedBox(height: 10,),

                Text("Privacy Settings",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text(" The policy should describe the privacy settings available to users and how they can control the visibility of their personal information and posts within the social media application. This may include options to adjust account settings, choose who can see specific content, and manage data sharing preferences."),
                SizedBox(height: 10,),

                Text("Data Sharing and Third Parties",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The policy should clarify whether the social media application shares users' personal information with third parties and, if so, the types of organizations it shares data with (e.g., advertisers, service providers) and the purpose of sharing."),
                SizedBox(height: 10,),

                Text("Security Measures",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text(" The privacy policy should mention the security measures in place to protect users' personal information from unauthorized access, disclosure, or alteration. It may include encryption protocols, access controls, and regular security assessments."),
                SizedBox(height: 10,),


                Text("User Rights",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The privacy policy should outline users' rights regarding their personal information, such as the right to access, correct, or delete their data. It should also provide information on how users can exercise these rights."),
                SizedBox(height: 10,),


                Text("Updates to the Privacy Policy",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The policy should indicate that it may be subject to updates and explain how users will be notified of any material changes to the privacy practices."),
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
