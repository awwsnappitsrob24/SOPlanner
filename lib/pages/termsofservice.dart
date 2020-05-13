import 'package:flutter/material.dart';

class TermsOfServicePage extends StatefulWidget {  

  @override
  _TermsOfServiceState createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfServicePage> {

  final String title = "SOPLANNER TERMS AND CONDITIONS";
  final String update = "Last updated: May 12, 2020\n";
  final String instruction = "PLEASE READ THESE TERMS AND CONDITIONS CAREFULLY\n\n"; 
  final String agreementToTermsTitle = "AGREEMENT TO TERMS";
  final String agreementToTermsText = """These Terms and Conditions constitute a legally binding agreement made between you, whether personally or on behalf of an entity (“you”) and SOPlanner (“we,” “us” or “our”), concerning your access to and use of the application as well as any other media form, media channel, mobile website or mobile application related, linked, or otherwise connected thereto (collectively, the “App”). You agree that by accessing the App, you have read, understood, and agree to be bound by all of these Terms and Conditions Use. IF YOU DO NOT AGREE WITH ALL OF THESE TERMS and CONDITIONS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE APP AND YOU MUST DISCONTINUE USE IMMEDIATELY.

Supplemental terms and conditions or documents that may be posted on the App from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Terms and Conditions at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of these Terms and Conditions and you waive any right to receive specific notice of each such change. It is your responsibility to periodically review these Terms and Conditions to stay informed of updates. You will be subject to, and will be deemed to have been made aware of and to have accepted, the changes in any revised Terms and Conditions by your continued use of the App after the date such revised Terms are posted.  

The information provided on the App is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the App from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.""";

  final String intellectualRightsTitle = "\n\nINTELLECTUAL PROPERTY RIGHTS ";
  final String intellectualRightsText = """Unless otherwise indicated, the App is our proprietary property and all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics on the App (collectively, the “Content”) and the trademarks, service marks, and logos contained therein (the “Marks”) are owned or controlled by us or licensed to us, and are protected by copyright and trademark laws and various other intellectual property rights and unfair competition laws of the United States, foreign jurisdictions, and international conventions. The Content and the Marks are provided on the App “AS IS” for your information and personal use only. Except as expressly provided in these Terms of Use, no part of the App and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission. 

Provided that you are eligible to use the App, you are granted a limited license to access and use the App and to download or print a copy of any portion of the Content to which you have properly gained access solely for your personal, non-commercial use. We reserve all rights not expressly granted to you in and to the App, Content and the Marks. """;

  final String userRepTitle = "\n\nUSER REPRESENTATIONS ";
  final String userRepText = """By using the App, you represent and warrant that: [(1) all registration information you submit will be true, accurate, current, and complete; (2) you will maintain the accuracy of such information and promptly update such registration information as necessary;] (3) you have the legal capacity and you agree to comply with these Terms of Use; [(4) you are not under the age of 13;] (5) not a minor in the jurisdiction in which you reside[, or if a minor, you have received parental permission to use the App]; (6) you will not access the App through automated or non-human means, whether through a bot, script or otherwise; (7) you will not use the App for any illegal or unauthorized purpose; and (8) your use of the App will not violate any applicable law or regulation. 

If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the App (or any portion thereof).  """;

  final String userRegTitle = "\n\nUSER REGISTRATION ";
  final String userRegText = """You may be required to register with the App. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable.""";

  final String caliUsersTitle = "\n\nCALIFORNIA USERS AND RESIDENTS";
  final String caliUsersText = """If any complaint with us is not satisfactorily resolved, you can contact the Complaint Assistance Unit of the Division of Consumer Services of the California Department of Consumer Affairs in writing at 1625 North Market Blvd., Suite N 112, Sacramento, California 95834 or by telephone at (800) 952-5210 or (916) 445-1254. """;

  final String miscellaneousTitle = "\n\nMISCELLANEOUS";
  final String miscellaneousText = """These Terms of Use and any policies or operating rules posted by us on the App constitute the entire agreement and understanding between you and us. Our failure to exercise or enforce any right or provision of these Terms of Use shall not operate as a waiver of such right or provision. These Terms of Use operate to the fullest extent permissible by law. We may assign any or all of our rights and obligations to others at any time. We shall not be responsible or liable for any loss, damage, delay, or failure to act caused by any cause beyond our reasonable control. If any provision or part of a provision of these Terms of Use is determined to be unlawful, void, or unenforceable, that provision or part of the provision is deemed severable from these Terms of Use and does not affect the validity and enforceability of any remaining provisions. There is no joint venture, partnership, employment or agency relationship created between you and us as a result of these Terms of Use or use of the App. You agree that these Terms of Use will not be construed against us by virtue of having drafted them. You hereby waive any and all defenses you may have based on the electronic form of these Terms of Use and the lack of signing by the parties hereto to execute these Terms of Use. """;
              
  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Terms of Service'),
        ), 
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
            child : Column(
              children: <Widget>[
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center),
                Text(update),
                Text(instruction, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                Text(agreementToTermsTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(agreementToTermsText),
                Text(intellectualRightsTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(intellectualRightsText),
                Text(userRepTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(userRepText),
                Text(userRegTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(userRegText),
                Text(caliUsersTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(caliUsersText),
                Text(miscellaneousTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(miscellaneousText),
              ],
            )          
          ),
        )
      )
    );
  }
}