import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab3/const.dart';
import 'package:lab3/model/config.dart';
import 'package:lab3/screen/loginpage.dart';
import 'package:lab3/screen/splashscreen.dart';
import 'package:ndialog/ndialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isChecked = false;
  bool _passwordVisible = true;
  String eula = "";

  late double screenHeight, screenWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [upperHalf(context), lowerHalf(context)],
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: kPrimayColor,
        ),
         Positioned(child:  const Text("Sign Up", style: TextStyle(fontSize: 40, fontFamily: 'League Spartan', color: Colors.white), textAlign: TextAlign.center,), top: screenHeight * 0.12, right: screenWidth/3.4,),
      ],
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 5),
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "Your name must be longer than 3 letters."
                              : null,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus);
                          },
                          controller: _nameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "Enter a valid email."
                              : null,
                          focusNode: focus,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus1);
                          },
                          controller: _emailditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(),
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        validator: (val) => validatePassword(val.toString()),
                        focusNode: focus1,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus2);
                        },
                        controller: _passEditingController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(),
                            labelText: 'Password',
                            icon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                        obscureText: _passwordVisible,
                      ),
                      TextFormField(
                        style: const TextStyle(),
                        textInputAction: TextInputAction.done,
                        validator: (val) {
                          validatePassword(val.toString());
                          if (val != _passEditingController.text) {
                            return "Password do not match!";
                          } else {
                            return null;
                          }
                        },
                        focusNode: focus2,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus3);
                        },
                        controller: _pass2EditingController,
                        decoration: InputDecoration(
                            labelText: 'Re-type Password',
                            labelStyle: const TextStyle(),
                            icon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                        obscureText: _passwordVisible,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: _showEULA,
                              child: const Text('Agree with terms.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                  fixedSize: Size(screenWidth / 1.5, 50)),
              child: const Text('Register', style: TextStyle(color: kTextColor),),
              onPressed: _registerAccountDialog,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Already Register? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    )),
                GestureDetector(
                  onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginPage()))
                  },
                  child: const Text(
                    "Login here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SplashPage()))
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5)),
                child: const Text(
                  "Continue as guest",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerAccountDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form first.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept the terms and conditions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUserAccount();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? validatePassword(String value) {
    // String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password.';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password.';
      } else {
        return null;
      }
    }
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
          ),
          content: SizedBox(
            height: screenHeight / 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  void _registerUserAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _name = _nameEditingController.text;
    String _email = _emailditingController.text;
    String _pass = _passEditingController.text;
    
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress.."),
        title: const Text("Registering..."));
    progressDialog.show();

    http.post(Uri.parse(Config.server + "/araoptical/php/register_user.php"),
        body: {
          "name": _name,
          "email": _email,
          "password": _pass
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  }
}
