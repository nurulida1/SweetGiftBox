import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'checkoutpage.dart';
import '../config.dart';

class CartPage extends StatefulWidget {
  final String email;

  CartPage({Key? key, required this.email}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _titlecenter = "Loading...";
  List _cartList = [];
  double _totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
            child: Column(
          children: [
            if (_cartList.isEmpty)
              Flexible(child: Center(child: Text("No item added in the cart")))
            else
              Flexible(
                  child: OrientationBuilder(builder: (context, orientation) {
                return GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1,
                    children: List.generate(_cartList.length, (index) {
                      return Padding(
                          padding: EdgeInsets.all(1),
                          child: Container(
                              child: Card(
                                  child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                      padding: EdgeInsets.all(2),
                                      height:
                                          orientation == Orientation.portrait
                                              ? 150
                                              : 150,
                                      width: orientation == Orientation.portrait
                                          ? 100
                                          : 150,
                                      child: Image.network(
                                        _cartList[index]['images'],
                                        fit: BoxFit.cover,
                                      ))),
                              Container(
                                  height: 100,
                                  child: VerticalDivider(color: Colors.grey)),
                              Expanded(
                                  flex: 6,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(_cartList[index]['packageSet'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 5),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text("\tChoose Box Color:",
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                  SizedBox(width: 5),
                                                  Material(
                                                      child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          onTap: () {},
                                                          splashColor:
                                                              Colors.blue,
                                                          highlightColor:
                                                              Colors.blue,
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ))),
                                                  SizedBox(width: 5),
                                                  Material(
                                                      child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          onTap: () {},
                                                          splashColor:
                                                              Colors.blue,
                                                          highlightColor:
                                                              Colors.blue,
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.pink,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ))),
                                                  SizedBox(width: 5),
                                                  Material(
                                                      child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          onTap: () {},
                                                          splashColor:
                                                              Colors.blue,
                                                          highlightColor:
                                                              Colors.blue,
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors.brown,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ))),
                                                ]),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.black,
                                                        ),
                                                        child: Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                        )),
                                                    onTap: () {
                                                      _modQty(
                                                          index, "removecart");
                                                    }),
                                                SizedBox(width: 10),
                                                Text(_cartList[index]['qty'],
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                SizedBox(width: 10),
                                                GestureDetector(
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.black,
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        )),
                                                    onTap: () {
                                                      _modQty(index, "addcart");
                                                    }),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                                "RM " +
                                                    (int.parse(_cartList[index]
                                                                ['qty']) *
                                                            double.parse(
                                                                _cartList[index]
                                                                    ['price']))
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16))
                                          ]))),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteCartDialog(index);
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ))));
                    }));
              })),
            Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.red,
                      height: 1,
                      thickness: 10.0,
                    ),
                    Text("TOTAL RM " + _totalprice.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {
                        _pay();
                      },
                      child: Text("CHECKOUT",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                    )
                  ],
                ))
          ],
        )));
  }

  _loadCart() {
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/loadcart.php"),
        body: {"email": widget.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No item";
        _cartList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _cartList = jsondata["cart"];

        _titlecenter = "";
        _totalprice = 0.0;
        for (int i = 0; i < _cartList.length; i++) {
          _totalprice = _totalprice +
              double.parse(_cartList[i]['price']) *
                  int.parse(_cartList[i]['qty']);
        }
      }
      setState(() {});
    });
  }

  Future<void> _modQty(int index, String s) async {
    int qty = int.parse(_cartList[index]['qty']);
    if (s == "addcart") {
      qty++;
    }
    if (s == "removecart") {
      qty--;
      if (qty == 0) {
        _deleteCart(index);
        return;
      }
    }
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("Update cart"), title: Text("Progress..."));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/updatecart.php"),
        body: {
          "email": widget.email,
          "op": s,
          "id": _cartList[index]['id'],
          "qty": _cartList[index]['qty']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Cart Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      progressDialog.dismiss();
    });
  }

  Future<void> _deleteCart(int index) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("Delete from cart"), title: Text("Progress..."));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/deletecart.php"),
        body: {
          "email": widget.email,
          "id": _cartList[index]['id']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      progressDialog.dismiss();
    });
  }

  void _pay() {
    if (_totalprice == 0.0) {
      Fluttertoast.showToast(
          msg: "Amount not payable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          builder: (context) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: new Text(
                    'Proceed with checkout?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckOutPage(
                                email: widget.email, total: _totalprice),
                          ),
                        );
                      },
                    ),
                    TextButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]),
          context: context);
    }
  }

  void _deleteCartDialog(int index) {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Delete from your cart?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteCart(index);
                    },
                  ),
                  TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }
}
