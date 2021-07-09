import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'packagescreen.dart';
import '../config.dart';
import 'dart:convert';
import '../model/package.dart';
import '../model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPackage extends StatefulWidget {
  final User user;

  SearchPackage({Key? key, required this.user}) : super(key: key);

  @override
  _SearchPackageState createState() => _SearchPackageState();
}

class _SearchPackageState extends State<SearchPackage> {
  String _titlecenter = "";
  int cartitem = 0;
  List _searchList = [];
  List _packageList = [];
  TextEditingController _srcController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _testasync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 1.0,
                          )
                        ]),
                    height: 50,
                    width: 390,
                    child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      controller: _srcController,
                      decoration: InputDecoration(
                        hintText: "\t\t\tSearch package",
                        prefixText: "\t\t\t\t",
                        suffixIcon: IconButton(
                          onPressed: () => {
                            _searchProduct(_srcController.text),
                          },
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (_searchList.isEmpty)
                Flexible(child: Center(child: Text(_titlecenter)))
              else
                Flexible(
                    child: ListView.builder(
                  itemCount: _searchList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          _displayPackage(index);
                        },
                        child: Container(
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
                                        _searchList[index]['images'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(_searchList[index]['packageSet'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 5),
                                        Container(
                                            width: 200,
                                            child: Text(
                                                _searchList[index]
                                                    ['description'],
                                                style:
                                                    TextStyle(fontSize: 13))),
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
                                                              _searchList[index]
                                                                  ['price'])
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue)),
                                              Container(
                                                child: FloatingActionButton(
                                                  onPressed: () {
                                                    _addtoCart(index);
                                                  },
                                                  tooltip: "Add to cart",
                                                  child: Icon(
                                                      Icons
                                                          .shopping_bag_outlined,
                                                      color: Colors.white),
                                                  elevation: 4.0,
                                                  backgroundColor:
                                                      Colors.pink[400],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ])
                                ])),
                      ),
                    );
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

  _searchProduct(String search) async {
    String search = _srcController.text.toString();
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/searchproduct.php"),
        body: {"packageSet": search}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "Sorry! No result found :(";
        _searchList = [];
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _searchList = jsondata["package"];
        _titlecenter = "";
      }
      setState(() {});
    });
  }

  Future<void> _testasync() async {
    await _searchProduct("");
  }

  void _displayPackage(int index) {
    Package package = new Package(
      id: _searchList[index]["id"],
      packageSet: _searchList[index]["package"],
      description: _searchList[index]["description"],
      quantity: _searchList[index]["quantity"],
      price: _searchList[index]["price"],
      date_reg: _searchList[index]["date_reg"],
      images: _searchList[index]["images"],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => PackagePage(user: widget.user)));
  }

  void _addtoCart(int index) async {
    String id = _packageList[index]['id'];
    print(widget.user.email);
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/insertcart.php"),
        body: {"id": id}).then((response) {
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
  }

  void _loadCart() {
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/loadcartitem.php"),
        body: {"email": widget.user.email}).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }
}
