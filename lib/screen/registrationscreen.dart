import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'loginscreen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordControllera = new TextEditingController();
  TextEditingController _passwordControllerb = new TextEditingController();
  
  late double screenHeight, screenWidth;
  bool _obscureText = true;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.orange.shade200, Colors.pinkAccent],
        )),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(120, 50, 100, 10),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 15),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                  child: Column(
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            labelText: 'Name',
                            icon: Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32))),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32))),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordControllera,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: 'Password',
                            icon: Icon(Icons.lock),
                            suffix: InkWell(
                              onTap: _togglePass,
                              child: Icon(Icons.visibility),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32))),
                        obscureText: _obscureText,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordControllerb,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            labelText: 'Confirm your password',
                            icon: Icon(Icons.lock),
                            suffix: InkWell(
                              onTap: _togglePass,
                              child: Icon(Icons.visibility),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32))),
                        obscureText: _obscureText,
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  _onChange(value!);
                                },
                              ),
                              Text("I agree with ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16)),
                              GestureDetector(
                                onTap: _showEULA,
                                child: Text('Terms & conditions ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    )),
                              ),
                            ]),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          minWidth: screenWidth,
                          height: 50,
                          child: Text('SIGN UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: _onRegister,
                          color: Colors.pinkAccent[200]),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already Register? "),
                          GestureDetector(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent[200],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: _alreadyRegister,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  void _alreadyRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  void _onRegister() {
    String _name = _nameController.text.toString();
    String _email = _emailController.text.toString();
    String _passworda = _passwordControllera.text.toString();
    String _passwordb = _passwordControllerb.text.toString();

    if (_name.isEmpty ||
        _email.isEmpty ||
        _passworda.isEmpty ||
        _passwordb.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email or password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (!(_passworda == _passwordb)) {
      Fluttertoast.showToast(
          msg: "Re-password does not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (!validateEmail(_email)) {
      Fluttertoast.showToast(
          msg: "Check your email format",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (_passworda.length < 5) {
      Fluttertoast.showToast(
          msg: "Minimum password required 5 characters",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "You are required to accept terms",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Register new user"),
            content: Text("Are you sure?"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _registerUser(_name, _email, _passworda);
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _registerUser(String name, String email, String password) {
    http.post(
        Uri.parse(
            "https://nurulida1.com/272932/sweetgiftbox/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "password": password
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Registration Success." +
                "\nWe've sent a verification link to your email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 7,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
      } else {
        Fluttertoast.showToast(
            msg: "Registration failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        FocusScope.of(context).unfocus();
        _passwordControllerb.clear();
      }
    });
  }

  void _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$';
    RegExp regExp = new RegExp(pattern);
    print(regExp.hasMatch(value));
    return regExp.hasMatch(value);
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _showEULA() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("EULA"),
            content: new Container(
              height: screenHeight / 5,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: new SingleChildScrollView(
                      child: RichText(
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              text:
                                  "This End-User License Agreement is a legal agreement between you and Nurulida This EULA agreement governs your acquisition and use of our SWEETGIFTBOX software (Software) directly from Nurulida or indirectly through a Nurulida authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the SWEETGIFTBOX software. It provides a license to use the SWEETGIFTBOX software and contains warranty information and liability disclaimers. If you register for a free trial of the SWEETGIFTBOX software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the SWEETGIFTBOX software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Nurulida herewith regardless of whether other software is referred to or described herein. The terms also apply to any Nurulida updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for SWEETGIFTBOX. Nurulida shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Nurulida. Nurulida reserves the right to grant licences to use the Software to third parties")),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

