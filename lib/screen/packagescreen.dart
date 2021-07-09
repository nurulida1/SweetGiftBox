import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetgiftbox/screen/cartpage.dart';
import 'dart:convert';
import '../config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/user.dart';
import 'package:ndialog/ndialog.dart';

class PackagePage extends StatefulWidget {
  final User user;
  PackagePage({Key? key, required this.user}) : super(key: key);

  @override
  _PackagePageState createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  late double screenHeight, screenWidth;
  String _titlecenter = "Loading...";
  late List _packageList = [];
  late SharedPreferences prefs;
  int cartitem = 0;

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
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                backgroundColor: Colors.pinkAccent,
                title: Text('Package'),
                actions: [
                  TextButton.icon(
                      onPressed: () => {_goToCart()},
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      label: Text("",
                          style: TextStyle(color: Colors.white)))
                ]),
            body: Container(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                          child: _packageList == null
                              ? Flexible(
                                  child: Center(child: Container(height: 20.0)))
                              : Flexible(
                                  child: Center(
                                      child: ListView.builder(
                                          itemCount: _packageList.length,
                                          itemBuilder:
                                              (BuildContext ctxt, int index) {
                                            return Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 5,
                                                            offset:
                                                                Offset(0, 3),
                                                            color:
                                                                Colors.black12,
                                                          )
                                                        ]),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10.0),
                                                              width: 120,
                                                              height: 120,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  child: Image
                                                                      .network(
                                                                    _packageList[
                                                                            index]
                                                                        [
                                                                        'images'],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ))),
                                                          Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    _packageList[
                                                                            index]
                                                                        [
                                                                        'packageSet'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height: 5),
                                                                Container(
                                                                    width: 200,
                                                                    child: Text(
                                                                        _packageList[index]
                                                                            [
                                                                            'description'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13))),
                                                                SizedBox(
                                                                    height: 25),
                                                                Container(
                                                                    width: 200,
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                              'RM ' + double.parse(_packageList[index]['price']).toStringAsFixed(2),
                                                                              style: TextStyle(fontSize: 15, color: Colors.blue)),
                                                                          Container(
                                                                            child:
                                                                                FloatingActionButton(
                                                                              onPressed: () {
                                                                                _addtoCart(index);
                                                                              },
                                                                              tooltip: "Add to cart",
                                                                              child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
                                                                              elevation: 4.0,
                                                                              backgroundColor: Colors.pink[400],
                                                                            ),
                                                                          )
                                                                        ]))
                                                              ])
                                                        ])));
                                          }))))
                    ],
                  )),
            )));
  }

  String titleSub(String title) {
    if (title.length < 15) {
      return title.substring(0, 15) + "...";
    } else {
      return title;
    }
  }

 Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    widget.user.email = prefs.getString("email") ?? '';
    print(widget.user.email);
  } 

  void _loadPackage() {
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/loadproducts.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No packages";
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _packageList = jsondata["package"];
        setState(() {
          print(_packageList);
        });
      }
    });
  }

  _goToCart() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CartPage(email: widget.user.email)));
  }

  _addtoCart(int index) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("Add to cart"), title: Text("Progress..."));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    String id = _packageList[index]['id'];
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/insertcart.php"),
        body: {"email": widget.user.email, "id": id}).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadCart();
      }
    });
    progressDialog.dismiss();
  }

  void _loadCart() {
    print(widget.user.email);
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/loadcartitem.php"),
        body: {"email": widget.user.email}).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }

  Future<void> _testasync() async {
    await _loadPref();
    _loadPackage();
    _loadCart();
  }
}
