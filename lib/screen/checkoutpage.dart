import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetgiftbox/model/delivery.dart';
import 'payment.dart';
import '../model/user.dart';
import 'package:sweetgiftbox/screen/mappage.dart';

class CheckOutPage extends StatefulWidget {
  final String email;
  final double total;

  CheckOutPage({Key? key, required this.email, required this.total})
      : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  int _radioValue = 0;
  String _delivery = "Pickup";
  bool _statusdel = false;
  bool _statuspickup = true;
  String _selectedtime = "10.00 A.M";
  String _curtime = "";
  String _name = "Click to set";
  String _phone = "Click to set";
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();
  TextEditingController _userloctctrl = new TextEditingController();
  String address = "";
  late double screenHeight, screenWidth;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    final now = new DateTime.now();
    _curtime = DateFormat("Hm").format(now);
    int cm = _convMin(_curtime);
    _selectedtime = _minToTime(cm);
    _loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final now = new DateTime.now();
    String today = DateFormat('hh:mm a').format(now);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.pinkAccent,
        title: Text("CHECKOUT"),
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          Expanded(
            flex: 7,
            child: ListView(padding: EdgeInsets.only(top: 0), children: [
              Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(children: [
                        SizedBox(height: 10),
                        Text("CUSTOMER DETAILS",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text("Email: ",
                                    style: TextStyle(fontSize: 15))),
                            Container(
                                height: 20,
                                child: VerticalDivider(
                                  color: Colors.grey,
                                )),
                            Expanded(
                              flex: 7,
                              child: Text(widget.email,
                                  style: TextStyle(fontSize: 15)),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text("Name: ",
                                    style: TextStyle(fontSize: 15))),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                  onTap: () => {nameDialog()},
                                  child: Text(_name,
                                      style: TextStyle(fontSize: 15))),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text("Phone: ",
                                    style: TextStyle(fontSize: 15))),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                  onTap: () => {phoneDialog()},
                                  child: Text(_phone,
                                      style: TextStyle(fontSize: 15))),
                            )
                          ],
                        )
                      ]))),
              Divider(
                color: Colors.grey,
                height: 2,
              ),
              Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        children: [
                          Text("DELIVERY METHOD",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Pickup", style: TextStyle(fontSize: 15)),
                              new Radio(
                                value: 0,
                                groupValue: _radioValue,
                                onChanged: (int? value) {
                                  _handleRadioValueChange(value);
                                },
                              ),
                              Text("Delivery", style: TextStyle(fontSize: 15)),
                              new Radio(
                                  value: 1,
                                  groupValue: _radioValue,
                                  onChanged: (int? value) {
                                    _handleRadioValueChange(value);
                                  })
                            ],
                          )
                        ],
                      ))),
              Divider(
                color: Colors.grey,
                height: 2,
              ),
              Visibility(
                  visible: _statuspickup,
                  child: Container(
                      margin: EdgeInsets.all(2),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Column(children: [
                            Text("PICKUP TIME",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            Container(
                              margin: EdgeInsets.all(5),
                              width: 300,
                              child: Text(
                                  "Pickup time daily from 10.00 A.M to 6.00 P.M",
                                  style: TextStyle(fontSize: 15)),
                            ),
                            Row(children: [
                              Expanded(flex: 3, child: Text("Current Time: ")),
                              Container(
                                  height: 20,
                                  child: VerticalDivider(color: Colors.grey)),
                              Expanded(
                                flex: 7,
                                child: Text(today),
                              )
                            ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Text("Set Pickup Time: ",
                                          style: TextStyle(fontSize: 15))),
                                  Container(
                                      height: 20,
                                      child:
                                          VerticalDivider(color: Colors.grey)),
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                          child: Row(children: [
                                        Text(_selectedtime),
                                        Container(
                                            child: IconButton(
                                                iconSize: 32,
                                                icon: Icon(Icons.timer),
                                                onPressed: () =>
                                                    {_selectTime(context)}))
                                      ])))
                                ])
                          ])))),
              Visibility(
                  visible: _statusdel,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(children: [
                            Text("DELIVERY ADDRESS",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Row(children: [
                              Expanded(
                                  flex: 6,
                                  child: Column(children: [
                                    TextField(
                                      controller: _userloctctrl,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter address'),
                                      keyboardType: TextInputType.multiline,
                                      minLines: 4,
                                      maxLines: 4,
                                    )
                                  ])),
                              Container(
                                  height: 120,
                                  child: VerticalDivider(color: Colors.grey)),
                              Expanded(
                                  flex: 4,
                                  child: Column(children: [
                                    Container(
                                        width: 150,
                                        child: ElevatedButton(
                                            onPressed: () =>
                                                {_getUserCurrentLoc()},
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.pinkAccent,
                                            ),
                                            child: Text("Location",
                                                style:
                                                    TextStyle(fontSize: 15)))),
                                    Divider(
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                                    Container(
                                        width: 150,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              Delivery _del =
                                                  await Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                builder: (context) => MapPage(),
                                              ));
                                              print(address);
                                              setState(() {
                                                _userloctctrl.text =
                                                    _del.address;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.pinkAccent,
                                            ),
                                            child: Text("Map",
                                                style:
                                                    TextStyle(fontSize: 15))))
                                  ]))
                            ])
                          ])))),
              Divider(
                color: Colors.grey,
                height: 2,
              ),
              Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text("ADDITIONAL INFORMATION",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Any notes to be written on the giftbox?"),
                            ],
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _noteController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Write a notes'),
                            keyboardType: TextInputType.multiline,
                            minLines: 5,
                            maxLines: 5,
                          ),
                        ],
                      ))),
              SizedBox(height: 15),
              Divider(
                color: Colors.grey,
                height: 2,
              ),
              SizedBox(height: 70),
              Container(
                  child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Total: RM ' + widget.total.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 10.0),
                    Container(
                      width: screenWidth / 2.5,
                      child: ElevatedButton(
                          onPressed: () {
                            _payDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink,
                          ),
                          child: Center(
                            child: Text('PAY NOW',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                          )),
                    ),
                  ],
                ),
              ])),
            ]),
          ),
        ],
      ),
    );
  }

  void _payDialog() {
    int _phone = int.parse(_phoneController.text);
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Proceed to pay RM ' + widget.total.toStringAsFixed(2) + "?",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      User _user = new User(
                        email: widget.email,
                        name: _name,
                        password: '',
                        date_reg: '',
                        status: '',
                      );
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Payment(
                              user: _user, total: widget.total, phone: _phone),
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

  int _convMin(String c) {
    var val = c.split(":");
    int h = int.parse(val[0]);
    int m = int.parse(val[1]);
    int tmin = (h * 60) + m;
    return tmin;
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name") ?? 'Click to set';
    _phone = prefs.getString("phone") ?? 'Click to set';
    setState(() {});
  }

  String _minToTime(int min) {
    var m = min + 30;
    var d = Duration(minutes: m);
    List<String> parts = d.toString().split(':');
    String tm = '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    return DateFormat.jm().format(DateFormat("hh:mm").parse(tm));
  }

  void nameDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Insert Name: ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Enter Name'),
                    keyboardType: TextInputType.name,
                  ),
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _name = _nameController.text;
                      prefs = await SharedPreferences.getInstance();
                      await prefs.setString("name", _name);
                      setState(() {});
                    },
                  ),
                ]),
        context: context);
  }

  void phoneDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Your Phone Number:',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextField(
                    controller: _phoneController,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Enter Name'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _phone = _phoneController.text;

                      prefs = await SharedPreferences.getInstance();
                      await prefs.setString("phone", _phone);

                      setState(() {});
                    },
                  ),
                ]),
        context: context);
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value!;
      switch (_radioValue) {
        case 0:
          _delivery = "Pickup";
          _statusdel = false;
          _statuspickup = true;
          setPickupExt();
          break;
        case 1:
          _delivery = "Delivery";
          _statusdel = true;
          _statuspickup = false;
          break;
      }
      print(_delivery);
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
    final now = new DateTime.now();
    print("NOW: " + now.toString());
    String year = DateFormat('y').format(now);
    String month = DateFormat('M').format(now);
    String day = DateFormat('d').format(now);

    String _hour, _minute, _time = "";
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute;
        _selectedtime = _time;
        _curtime = DateFormat("Hm").format(now);

        _selectedtime = formatDate(
            DateTime(int.parse(year), int.parse(month), int.parse(day),
                selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        int ct = _convMin(_curtime);
        int st = _convMin(_time);
        int diff = st - ct;
        if (diff < 30) {
          Fluttertoast.showToast(
              msg: "Invalid time selection",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          _selectedtime = _minToTime(ct);
          setState(() {});
          return;
        }
      });
  }

  _getUserCurrentLoc() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("Searching address"), title: Text("Locating..."));
    progressDialog.show();
    await _determinePosition().then((value) => {_getPlace(value)});
    setState(
      () {},
    );
    progressDialog.dismiss();
  }

  void setPickupExt() {
    final now = new DateTime.now();
    _curtime = DateFormat("Hm").format(now);
    int cm = _convMin(_curtime);
    _selectedtime = _minToTime(cm);
    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _getPlace(Position pos) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    address = name +
        "," +
        subLocality +
        ",\n" +
        locality +
        "," +
        postalCode +
        ",\n" +
        administrativeArea +
        "," +
        country;
    _userloctctrl.text = address;
  }
}
