import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetgiftbox/screen/drawerscreen.dart';
import 'package:sweetgiftbox/screen/packagescreen.dart';
import '../config.dart';
import 'cartpage.dart';
import 'packagescreen.dart';
import '../model/user.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _titlecenter = "";
  List _packageList = [];
  late final double screenHeight, screenWidth;
  late SharedPreferences prefs;
  int cartitem = 0;
  String email = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _testasync();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              DrawerScreen(user: widget.user)))
                },
            icon: Icon(Icons.menu)),
        backgroundColor: Colors.pinkAccent,
        actions: [
          TextButton.icon(
              onPressed: () => {_goToCart()},
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              label: Text(
                "",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: size.height / 5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 242, 242, 242),
                            Color.fromARGB(255, 252, 244, 245),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 1.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: size.width / 2,
                              child: Image.asset(
                                'assets/images/love.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 50, left: 20),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Welcome to',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0, left: 20),
                                child: Text(
                                  '\t\tSweet GiftBox!',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 233, 107, 120),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 249, 114, 131),
                    ),
                  ),
                  Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '\tBox Color',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: size.height / 12,
                width: size.width / 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      height: size.height / 10,
                      width: size.width / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.white),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            width: 60,
                            child: Image.asset(
                              'assets/images/black.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text(
                              'Black Box',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      height: size.height / 10,
                      width: size.width / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.white),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            width: 50,
                            child: Image.asset(
                              'assets/images/brown.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text(
                              'Brown Box',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      height: size.height / 10,
                      width: size.width / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.white),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            width: 70,
                            child: Image.asset(
                              'assets/images/pink.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text(
                              'Pink Box',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\tBox Collection',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  TextButton(
                      child: Text('View all ',
                          style: TextStyle(
                              color: Color.fromARGB(255, 249, 114, 131),
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        viewAll();
                      })
                ],
              ),
              if (_packageList.isEmpty)
                Flexible(child: Center(child: Text(_titlecenter)))
              else
                Flexible(
                    child: ListView.builder(
                  itemCount: _packageList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                  color: Colors.black12)
                            ]),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    _packageList[index]['images'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_packageList[index]['packageSet'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Container(
                                        width: 200,
                                        child: Text(
                                            _packageList[index]['description'],
                                            style: TextStyle(fontSize: 13))),
                                    SizedBox(height: 25),
                                    Container(
                                      width: 200,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'RM ' +
                                                  double.parse(
                                                          _packageList[index]
                                                              ['price'])
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue)),
                                        ],
                                      ),
                                    ),
                                  ])
                            ]));
                  },
                ))
            ],
          ),
        ),
      ),
    );
  }

  String titleSub(String title) {
    if (title.length < 15) {
      return title.substring(0, 15) + "...";
    } else {
      return title;
    }
  }

  _loadProduct(String date_reg) {
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/loadproducts.php"),
        body: {"date_reg": date_reg}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No packages";
        _packageList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _packageList = jsondata["package"];
        _titlecenter = "";
      }
      setState(() {});
    });
  }

  _goToCart() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => CartPage(email: widget.user.email)));
  }

  void _loadCart() {
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/loadcartitem.php"),
        body: {"email": email}).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }

  Future<void> _testasync() async {
    await _loadProduct("all");
    _loadCart();
  }

  void viewAll() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => PackagePage(user: widget.user)));
  }
}
