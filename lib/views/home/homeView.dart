import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:post/styles/styles.dart';
import 'package:post/assets/postLogo.dart';
import 'package:post/views/home/homeContract.dart';
import 'package:post/views/login/loginView.dart';
import 'package:post/views/home/homePresenter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:post/apiEndpoint.dart';

class Home extends StatefulWidget {
  static const String routeName = '/Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements HomeContract {
  int currentPage = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HomePresenter _presenter;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0Xffb6f492), Color(0xff338b93)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 50.0));

  @override
  void initState() {
    super.initState();
    _presenter = HomePresenter(this);
  }

  Widget createProfileImage() {
    return Container(
      width: 170,
      height: 170,

      decoration: BoxDecoration(border: Border.all(width: 3,color: style.secondaryColor),shape: BoxShape.circle),
        child: CachedNetworkImage(
          placeholder: (context, url) => Container(
            alignment: Alignment.center,
            child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(style.secondaryColor),)),
          errorWidget: (context, url, error) => Icon(
            Icons.person,
            size: 160,
            color: style.secondaryColor,
          ),
          imageUrl: ApiEndPoint.DOWNLOAD_PROFILE_IMAGE,
    ));
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          child: createProfileImage(),
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
      child: postLogo(3),
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
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Center(
              child: <Widget>[
            Text(
              'Search page still under developing',
            ),
            Text("Home page still under developing"),
            createProfileWidget(),
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
          currentPage = position;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return Scaffold(
      /* AppBar(
                    backgroundColor: style.accentColor,
                    title: Center(
                      child: Text(
                        "Post",
                        style: TextStyle(foreground: Paint()..shader = linearGradient,
                        fontSize: 46,
                        fontFamily: 'Lucida',
                        ),
                      ),
                    ),
                  ), */
      body: createHomePage(),
      bottomNavigationBar: createNavBar(),
      key: _scaffoldKey,
    );
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
}
