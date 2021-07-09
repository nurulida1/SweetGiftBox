import 'package:flutter/material.dart';
import 'package:sweetgiftbox/model/user.dart';
import 'package:sweetgiftbox/screen/mainscreen.dart';

class DrawerScreen extends StatefulWidget {
  final User user;
  DrawerScreen({Key? key, required this.user}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Colors.pinkAccent, Colors.pink])),
            child: Container(
              child: Column(
                children: <Widget>[
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/profile.png",
                          height: 70, width: 70),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.user.name,
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  )
                ],
              ),
            )),
        ListTile(
            title: Text("Home"),
            trailing: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: widget.user)));
            }),
        Divider(
          color: Colors.grey,
          height: 2,
        ),
        ListTile(
            title: Text("Messaging"),
            trailing: Icon(Icons.message_rounded),
            onTap: () {
              Navigator.pop(context);
            }),
        Divider(
          color: Colors.grey,
          height: 2,
        ),
        ListTile(
            title: Text("Setting"),
            trailing: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
            }),
        Divider(
          color: Colors.grey,
          height: 2,
        ),
        ListTile(
            title: Text("Logout"),
            trailing: Icon(Icons.lock),
            onTap: () {
              Navigator.pop(context);
            }),
        Divider(
          color: Colors.grey,
          height: 2,
        ),
      ],
    ));
  }
}
