import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/services.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:post/styles/styles.dart';
import 'package:post/assets/postLogo.dart';
import 'package:post/views/home/homeContract.dart';
import 'package:post/views/login/loginView.dart';
import 'package:post/views/home/homePresenter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:post/apiEndpoint.dart';
import 'package:post/util/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  static const String routeName = '/Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements HomeContract {
  int currentPage = 1;
  int logoTypeNum = 3;
  String userId, userName;
  DefaultCacheManager manager = new DefaultCacheManager();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HomePresenter _presenter;
  File file;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0Xffb6f492), Color(0xff338b93)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 50.0));

  @override
  void initState() {
    super.initState();
    _presenter = HomePresenter(this);
    getUserId();
    getUserName();
    print(userName);
  }

  Widget createImagePickerButton() {
    return RaisedButton(
      padding: EdgeInsets.all(7),
      color: style.primaryColor,
      onPressed: _choose,
      shape: CircleBorder(),
      child: Icon(
        Icons.camera_alt,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget createProfileImage() {
    return Stack(children: <Widget>[
      Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
              border: Border.all(width: 6, color: Colors.white),
              shape: BoxShape.circle),
          child: ClipOval(
              child: CachedNetworkImage(
            fit: BoxFit.fill,
            useOldImageOnUrlChange: true,
            imageUrl: ApiEndPoint.DOWNLOAD_PROFILE_IMAGE + userId + ".png",
            placeholder: (context, url) => Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(style.secondaryColor),
                )),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              size: 155,
              color: style.secondaryColor,
            ),
          ))),
      Positioned(
        bottom: 0,
        right: -20,
        child: createImagePickerButton(),
      ),
    ]);
  }

  Widget createLogOutButton() {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      color: Colors.red,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Text(
        'Log out',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: _presenter.logout,
    );
  }

  Widget createProfileWidget() {
    return Column(
      children: <Widget>[
        Container(
          child: createProfileImage(),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            userName,
            style: TextStyle(fontSize: 26),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: createLogOutButton(),
        )
      ],
    );
  }

  Widget createAppBar() {
    return PreferredSize(
      child: postLogo(logoTypeNum),
      preferredSize: Size(MediaQuery.of(context).size.width, 180),
    );
  }

  Widget createHomePage() {
    return Stack(children: <Widget>[
      Positioned(height: 200, top: 0, left: 0, right: 0, child: createAppBar()),
      Positioned(
        top: 110,
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Center(
              child: <Widget>[
            Text(
              'Search page still under developing',
            ),
            Text("Home page still under developing"),
            Container(
                transform: Matrix4.translationValues(0.0, -23.0, 0.0),
                child: createProfileWidget()),
          ].elementAt(currentPage)),
        ),
      )
    ]);
  }

  Widget createNavBar() {
    return FancyBottomNavigation(
      circleColor: style.secondaryColor,
      inactiveIconColor: style.secondaryColor,
      initialSelection: 1,
      tabs: [
        TabData(iconData: Icons.search, title: "Search"),
        TabData(iconData: Icons.home, title: "Home"),
        TabData(iconData: Icons.person, title: "Profile")
      ],
      onTabChangedListener: (position) {
        setState(() {
          logoTypeNum = (position == 1) ? 3 : 4;
          currentPage = position;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return Scaffold(
      body: createHomePage(),
      bottomNavigationBar: createNavBar(),
      key: _scaffoldKey,
    );
  }

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    _upload();
  }

  void _upload() {
    if (file == null) return;
    String base64Image = base64Encode(file.readAsBytesSync());
    print(base64Image);
    http.post(ApiEndPoint.UPLOAD_PROFILE_IMAGE, body: {
      "image": base64Image,
      "name": userId,
    }).then((res) {
      setState(() {
        manager.emptyCache();
        print(res.statusCode);
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void onLogoutSuccess() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(Login.routeName);
  }

  @override
  void showError(String message) {
    final snackBar = SnackBar(content: Text(message));

    _scaffoldKey.currentState.showSnackBar(snackBar);
    print("Error: $message");
  }

  void getUserId() async {
    userId = await Preferences.getId();
  }

  void getUserName() async {
    userName = await Preferences.getUserName();
  }
}
