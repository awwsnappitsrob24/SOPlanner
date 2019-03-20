import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple[200],
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.image)),
                Tab(icon: Icon(Icons.card_giftcard)),
                Tab(icon: Icon(Icons.restaurant)),
                Tab(icon: Icon(Icons.mood)),
              ],
            ),
            title: Text('Welcome, Vivi!', style: TextStyle(color: Colors.yellow)),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              Icon(Icons.image),
              Icon(Icons.card_giftcard),
              Icon(Icons.restaurant),
              Icon(Icons.mood),
            ],
          ),
        ),
      ),
    );
  }
}