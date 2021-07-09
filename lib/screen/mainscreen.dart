import 'package:flutter/material.dart';
import 'package:sweetgiftbox/screen/feedpage.dart';
import 'package:sweetgiftbox/screen/homepage.dart';
import 'package:sweetgiftbox/screen/orders.dart';
import 'package:sweetgiftbox/screen/searchPackage.dart';
import '../model/user.dart';
import '../model/package.dart';

class MainScreen extends StatefulWidget {
  final User user;
  MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final Package package;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          HomePage(user: widget.user),
          SearchPackage(user: widget.user),
          FeedPage(user: widget.user),
          Orders(),
        ],
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              child: Container(
                  color: Colors.black26,
                  child: TabBar(
                    labelColor: Color(0xFFC41A3B),
                    unselectedLabelColor: Colors.white,
                    labelStyle: TextStyle(fontSize: 10.0),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.black54, width: 0.0),
                      insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                    ),
                    indicatorColor: Colors.black54,
                    tabs: <Widget>[
                      Tab(icon: Icon(Icons.home, size: 24.0), text: 'Home'),
                      Tab(icon: Icon(Icons.search, size: 24.0), text: 'Search'),
                      Tab(
                          icon: Icon(Icons.filter_none_rounded, size: 24.0),
                          text: 'Feed'),
                      Tab(
                          icon: Icon(Icons.view_list_outlined, size: 24.0),
                          text: 'My Order'),
                    ],
                    controller: _tabController,
                  )))),
    );
  }
}
