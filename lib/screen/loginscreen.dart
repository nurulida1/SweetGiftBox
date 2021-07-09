import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetgiftbox/model/user.dart';
import 'mainscreen.dart';
import 'registrationscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sweetgiftbox/config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late SharedPreferences prefs;
  late double screenHeight, screenWidth;
  bool _obscureText = true;
  late final ValueChanged<bool?>? onChanged;
  @override
  void initState() {
    loadPref();
    super.initState();
  }

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
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(70, 50, 70, 10),
                    child: Image.asset('assets/images/sweetgiftbox.png',
                        scale: 0.1)),
                Card(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: screenWidth / 200, top: screenHeight / 100),
                          child: Row(
                            children: [
                              Text(
                                'Welcome',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: screenWidth / 20),
                          child: Row(
                            children: [
                              Text(
                                'Sign in to your account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: 'Email',
                              icon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 15, 20, 15),
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
                        SizedBox(height: 15),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minWidth: screenWidth,
                          height: 50,
                          child: Text('LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: _onLogin,
                          color: Colors.pinkAccent,
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(top: screenHeight / 120.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14)),
                              SizedBox(width: 5),
                              GestureDetector(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue),
                                ),
                                onTap: _registerNewUser,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: (GestureDetector(
                                child: Text("Forgot Password?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        fontSize: 14,
                                        color: Colors.blue)),
                                onTap: _forgotPassword,
                              )),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _onLogin() async {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    http.post(
        Uri.parse(CONFIG.SERVER + "/272932/sweetgiftbox/php/login_user.php"),
        body: {"email": _email, "password": _password}).then((response) async {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Login Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('email', _emailController.text);
        List userdata = response.body.split(",");
        User user = User(
            email: _email,
            password: _password,
            name: userdata[1],
            date_reg: userdata[2],
            status: userdata[3]);
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user)));
      }
    });
  }

  void _registerNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => RegistrationScreen()));
  }

  void _forgotPassword() {
    TextEditingController _useremailcontroller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("FORGOT YOUR PASSWORD?"),
            content: Center(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  new Container(
                      height: 500,
                      child: Column(
                        children: [
                          Image.asset('assets/images/forgotpassword.png'),
                          SizedBox(height: 20),
                          Text(
                              "Not to worry, we got you! Let's get you a new password.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w300)),
                          SizedBox(height: 30),
                          Text("Enter your recovery email:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextField(
                            controller: _useremailcontroller,
                            decoration: InputDecoration(
                                labelText: 'Email', icon: Icon(Icons.email)),
                          )
                        ],
                      )),
                ],
              )),
            ),
            actions: [
              TextButton(
                child: Text("SUBMIT", style: TextStyle(fontSize: 16)),
                onPressed: () {
                  print(_useremailcontroller.text);
                  _resetPassword(_useremailcontroller.text.toString());
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text("CANCEL", style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _resetPassword(String emailreset) {
    http.post(
        Uri.parse(
            "https://nurulida1.com/272932/sweetgiftbox/php/forgot_password.php"),
        body: {"email": emailreset}).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "No email is found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Success reset password. Please check your email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  Future<void> storePref(bool value, String email, String password) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      return;
    } else {
      await prefs.setString("email", '');
      await prefs.setString("password", '');
      await prefs.setBool("rememberme", value);
      setState(() {
        _emailController.text = "";
        _passwordController.text = "";
      });
      return;
    }
  }

  Future<void> loadPref() async {
    prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email") ?? '';
    String _password = prefs.getString("password") ?? '';

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }

  void _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
