import 'package:flutter/material.dart';

import '../../../Theme/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("assets/letterblacknewcolor.png",height: 100,)),
                Text("Mission Statement",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The page often begins with a concise mission statement that describes the core purpose and vision of the social media application. This statement may highlight the platform's goals, values, or the problem it aims to solve."),
                SizedBox(height: 10,),

                Text("Platform Overview",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The About page usually provides a general overview of the social media application, explaining what it offers and how it differs from other platforms. This section may emphasize the unique features, functionalities, or benefits that set it apart."),
                SizedBox(height: 10,),

                Text("Key Features",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The page may outline the main features and capabilities of the social media application. This can include content sharing, networking, messaging, privacy controls, personalization, or any other distinctive aspects that define the user experience"),
                SizedBox(height: 10,),

                Text("Target Audience",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text(" It's common for the About page to specify the target audience or user demographic the social media application caters to. This can include age groups, interests, professionals, creatives, or any other relevant segment."),
                SizedBox(height: 10,),

                Text("Value Proposition",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text(" The page often highlights the value or benefits users can derive from using the social media application. This may include connecting with like-minded individuals, staying updated on news and trends, fostering professional relationships, expressing creativity, or any other value proposition."),
                SizedBox(height: 10,),


                Text("Safety and Privacy",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text(" Given the importance of safety and privacy on social media platforms, the About page may include information about the measures taken to ensure user security. This can encompass features like account verification, content moderation policies, data protection, and user reporting mechanisms."),
                SizedBox(height: 10,),


                Text("Community Guidelines",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("The About page might provide an overview of the community guidelines or terms of service that users are expected to adhere to when using the platform. This section typically highlights policies related to appropriate content, respect for others, prohibited activities, and consequences for policy violations."),
                SizedBox(height: 10,),

                Text("Company Information",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text("In some cases, the About page may provide details about the company or organization behind the social media application. This can include information about the company's history, mission, team, partnerships, or any other relevant background information."),
                SizedBox(height: 10,),

                Text("Contact and Support",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                SizedBox(height: 6,),
                Text(" It's common for the About page to include contact information or links to support resources. This can include customer support channels, FAQs, help centers, or community forums where users can find assistance or provide feedback."),
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
