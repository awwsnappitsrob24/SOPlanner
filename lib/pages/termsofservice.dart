import 'package:flutter/material.dart';

class TermsOfServicePage extends StatefulWidget {  

  @override
  _TermsOfServiceState createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfServicePage> {

  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Terms of Service'),
        ), 
      )
    );
  }
}