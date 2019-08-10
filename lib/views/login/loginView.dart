import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:post/util/linePainter.dart';
import 'package:post/util/bubble_indication_painter.dart';
import 'package:post/views/login/loginContract.dart';
import 'package:post/util/preferences.dart';
import 'package:post/views/home/homeView.dart';
import 'package:post/views/login/loginPresenter.dart';
import 'package:post/assets/postLogo.dart';
import 'package:post/styles/styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:post/util/loadingIcon.dart';

class Login extends StatefulWidget {
  static String routeName = "/Login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> implements LoginContract {
  LoginPresenter _presenter;
  double ml = 50, mr = 50, mt = 250, mb = 700, logoHeight = 140;
  int logoType = 1;
  PageController _pageController;
  Color left = Colors.white;
  Color right = Colors.white;
  Color tabColor = style.primaryColor;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _presenter = LoginPresenter(this);
    splashTimeout();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  splashTimeout() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    String token = await Preferences.getToken();
    if (null == token || token.isEmpty) {
      updateUI();
    } else
      Navigator.of(context).pushReplacementNamed(Home.routeName);
  }

  updateUI() {
    setState(() {
      ml = 0;
      mr = 0;
      mt = 0;
      mb = 0;
      logoHeight = 220;
      logoType = 0;
    });
  }

  Widget createSignInEmailTextField() {
    return TextFormField(
        focusNode: myFocusNodeEmailLogin,
        controller: loginEmailController,
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        style: TextStyle(fontSize: 20.0, color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            Icons.email,
            color: style.primaryColor,
            size: 30.0,
          ),
          contentPadding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          hintText: "Email Address",
          hintStyle: TextStyle(fontSize: 22.0),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Email cannot be empty';
          } else {
            return validateEmail(value);
          }
        },
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(myFocusNodePasswordLogin);
        });
  }

  Widget createSignInPasswordTextField() {
    return TextFormField(
      focusNode: myFocusNodePasswordLogin,
      controller: loginPasswordController,
      obscureText: _obscureTextLogin,
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          Icons.lock,
          color: style.primaryColor,
          size: 30.0,
        ),
        contentPadding: EdgeInsets.fromLTRB(0, 8, 5, 0),
        hintText: "Password",
        hintStyle: TextStyle(fontSize: 22.0),
        suffixIcon: GestureDetector(
          onTap: _toggleLogin,
          child: Icon(
            _obscureTextLogin
                ? FontAwesomeIcons.eye
                : FontAwesomeIcons.eyeSlash,
            size: 20.0,
            color: style.primaryColor,
          ),
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Password cannot be empty';
        } else if (value.length < 6) {
          return 'Password length must be at least 6 characters';
        }
      },
    );
  }

  Widget createSignInPressedButton() {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Text(
        "Sign in",
        style: TextStyle(color: style.accentColor, fontSize: 21),
      ),
      color: style.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          showLoading();
          _presenter.login(
              loginEmailController.text, loginPasswordController.text);
        }
      },
    );
  }

  Widget createForgetPasswordButton() {
    return FlatButton(
      child: Text(
        "Forget password?",
        style: TextStyle(color: style.primaryColor, fontSize: 16),
      ),
      onPressed: () {},
    );
  }

  Widget createSignUpDisplayNameTextField() {
    return TextFormField(
        focusNode: myFocusNodeName,
        controller: signupNameController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(fontSize: 20.0, color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            Icons.person,
            color: style.secondaryColor,
            size: 30.0,
          ),
          contentPadding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          hintText: "Name",
          hintStyle: TextStyle(fontSize: 22.0),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'This field cannot be empty';
          }
        },
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(myFocusNodeEmail);
        });
  }

  Widget createSignUpEmailTextField() {
    return TextFormField(
        focusNode: myFocusNodeEmail,
        controller: signupEmailController,
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        style: TextStyle(fontSize: 20.0, color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            Icons.email,
            color: style.secondaryColor,
            size: 30.0,
          ),
          contentPadding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          hintText: "Email Address",
          hintStyle: TextStyle(fontSize: 22.0),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Email cannot be empty';
          } else {
            return validateEmail(value);
          }
        },
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(myFocusNodePassword);
        });
  }

  Widget createSignUpPasswordTextField() {
    return TextFormField(
      focusNode: myFocusNodePassword,
      controller: signupPasswordController,
      obscureText: _obscureTextSignup,
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          Icons.lock,
          color: style.secondaryColor,
          size: 30.0,
        ),
        contentPadding: EdgeInsets.fromLTRB(0, 8, 5, 0),
        hintText: "Password",
        hintStyle: TextStyle(fontSize: 22.0),
        suffixIcon: GestureDetector(
          onTap: _toggleSignup,
          child: Icon(
            _obscureTextLogin
                ? FontAwesomeIcons.eye
                : FontAwesomeIcons.eyeSlash,
            size: 20.0,
            color: style.secondaryColor,
          ),
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Password cannot be empty';
        } else if (value.length < 6) {
          return 'Password length must be at least 6 characters';
        }
      },
    );
  }

  Widget createSignUpPressedButton() {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Text(
        "Sign Up",
        style: TextStyle(color: style.accentColor, fontSize: 21),
      ),
      color: style.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          print(loginEmailController.text + loginPasswordController.text);
          showLoading();
          _presenter.signup(signupNameController.text,
              signupEmailController.text, signupPasswordController.text);
        }
      },
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 210.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Color(0x55777777),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(
            pageController: _pageController, tabColor: tabColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                    color: left,
                    fontSize: 19.0,
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                    color: right,
                    fontSize: 19.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createSignInPage(BuildContext context) {
    return ListView(
      /* physics: const NeverScrollableScrollPhysics(), */
      children: <Widget>[
        Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(25, 50, 25, 0),
            child: createSignInEmailTextField()),
        Container(
          margin: EdgeInsets.fromLTRB(25, 5, 25, 0),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 3),
            painter: linePainter(),
          ),
        ),
        Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: createSignInPasswordTextField()),
        Container(
          margin: EdgeInsets.fromLTRB(25, 12, 25, 0),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 3),
            painter: linePainter(),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(50, 40, 50, 0),
            height: 51,
            child: createSignInPressedButton()),
        Container(
          margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: createForgetPasswordButton(),
        )
      ],
    );
  }

  Widget _createSignUpPage(BuildContext context) {
    return ListView(
      /* physics: const NeverScrollableScrollPhysics(), */
      children: <Widget>[
        Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(25, 35, 25, 0),
            child: createSignUpDisplayNameTextField()),
        Container(
          margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 3),
            painter: linePainter(),
          ),
        ),
        Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
            child: createSignUpEmailTextField()),
        Container(
          margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 3),
            painter: linePainter(),
          ),
        ),
        Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(25, 12, 25, 0),
            child: createSignUpPasswordTextField()),
        Container(
          margin: EdgeInsets.fromLTRB(25, 7, 25, 0),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 3),
            painter: linePainter(),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(50, 30, 50, 0),
            height: 51,
            child: createSignUpPressedButton()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Form(
        key: _formKey,
        child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomPadding: true,
            body: ListView(
              //physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height >= 775.0
                          ? MediaQuery.of(context).size.height
                          : 775.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          AnimatedContainer(
                            child: postLogo(logoType),
                            duration: Duration(milliseconds: 1200),
                            width: double.maxFinite,
                            height: logoHeight,
                            margin: EdgeInsets.only(
                                left: ml, right: mr, top: mt, bottom: mb),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 26.0),
                            child: _buildMenuBar(context),
                          ),
                          Expanded(
                            flex: 2,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (i) {
                                if (i == 0) {
                                  setState(() {
                                    tabColor = style.primaryColor;
                                  });
                                } else if (i == 1) {
                                  setState(() {
                                    tabColor = style.secondaryColor;
                                  });
                                }
                              },
                              children: <Widget>[
                                new ConstrainedBox(
                                  constraints: const BoxConstraints.expand(),
                                  child: _createSignInPage(context),
                                ),
                                new ConstrainedBox(
                                  constraints: const BoxConstraints.expand(),
                                  child: _createSignUpPage(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void showLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                ColorLoader3(
                  dotRadius: 12,
                  radius: 35,
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    "Loading, please wait..",
                    style: TextStyle(fontSize: 19),
                  ),
                )
              ]));
        });
  }

  @override
  void onLoginSuccess() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(Home.routeName);
  }

  @override
  void onSignupSuccess() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(Home.routeName);
  }

  @override
  void showError(String message) {
    Navigator.of(context).pop();
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    print("Error: $message");
  }
}
