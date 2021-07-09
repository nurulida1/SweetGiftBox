import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import 'addFeedPage.dart';
import '../model/user.dart';

class FeedPage extends StatefulWidget {
  final User user;
  const FeedPage({Key? key, required this.user}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late double screenHeight;
  late double screenWidth;
  late List _feedList = [];
  late SharedPreferences prefs;
  String _titlecenter = 'No feedback';
  final df = new DateFormat('dd-MM-yyyy');
  Color _iconColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _testasync();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.menu),
        backgroundColor: Colors.pinkAccent,
        title: Text('Feedback', style: TextStyle(letterSpacing: 3)),
      ),
      body: Container(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Container(
                    child: _feedList == null
                        ? Flexible(
                            child: Center(
                                child: Container(child: Text(_titlecenter))))
                        : Flexible(
                            child: Center(
                                child: ListView.builder(
                                    itemCount: _feedList.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return Card(
                                        child: Container(
                                            height: 400,
                                            color: Colors.white,
                                            child: Column(children: <Widget>[
                                              ListTile(
                                                  leading: CircleAvatar(
                                                      child: Image.asset(
                                                        "assets/images/profile.png",
                                                      ),
                                                      backgroundColor:
                                                          Colors.white54),
                                                  title: Text(widget.user.name),
                                                  subtitle: Text(df.format(
                                                      DateTime.parse(_feedList[
                                                              index]
                                                          ['date_created'])))),
                                              ListTile(
                                                title: Text(
                                                    _feedList[index]
                                                        ['feed_descript'],
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                              ),
                                              SizedBox(height: 15),
                                              Expanded(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  _feedList[
                                                                          index]
                                                                      [
                                                                      'feed_image']),
                                                              fit: BoxFit
                                                                  .scaleDown)))),
                                              SizedBox(height: 14),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Row(children: <Widget>[
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons.thumb_up),
                                                          color: _iconColor,
                                                          tooltip: 'Like',
                                                          onPressed: () {
                                                            setState(() {
                                                              if (_iconColor ==
                                                                  Colors.grey) {
                                                                _iconColor =
                                                                    Colors.blue;
                                                              } else {
                                                                _iconColor =
                                                                    Colors.grey;
                                                              }
                                                            });
                                                          }),
                                                      SizedBox(width: 8),
                                                      Text("Like",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey))
                                                    ]),
                                                    Row(children: <Widget>[
                                                      Icon(Icons.comment,
                                                          color: Colors.grey),
                                                      SizedBox(width: 8),
                                                      Text("Comment",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey))
                                                    ]),
                                                    Row(children: <Widget>[
                                                      Icon(Icons.share,
                                                          color: Colors.grey),
                                                      SizedBox(width: 8),
                                                      Text("Share",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey))
                                                    ])
                                                  ]),
                                              SizedBox(height: 12),
                                            ])),
                                      );
                                    }))))
              ]))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => AddFeedScreen(
                        user: widget.user,
                      )));
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    widget.user.email = prefs.getString("email") ?? '';
    print(widget.user.email);
  }

  void _loadFeed() {
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/loadfeed.php"),
        body: {}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No Feed";
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _feedList = jsondata["feed"];
        setState(() {
          print(_feedList);
        });
      }
    });
  }

  Future<void> _testasync() async {
    await _loadPref();
    _loadFeed();
  }
}
