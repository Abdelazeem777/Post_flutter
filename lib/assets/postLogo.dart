import 'package:flutter/material.dart';
import 'package:post/styles/styles.dart';
import 'package:flutter/services.dart';

class postLogo extends StatefulWidget {
  bool type;
  @override
  _postLogoState createState() => _postLogoState();
  postLogo(this.type);
}

class _postLogoState extends State<postLogo> {
  var borderType;
  

  Widget build(BuildContext context) {
    if (widget.type) {
      borderType = BorderRadius.all(
        Radius.circular(30),
      );
      
    } else {
      borderType = BorderRadius.only(
        bottomLeft: Radius.circular(100),
        bottomRight: Radius.circular(100),
      );
      
    }
    SystemChrome.setEnabledSystemUIOverlays([]);
    return AnimatedContainer(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(right: 18),
      child: Text(
        "Post",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 90,
          fontFamily: 'Lucida',
          color: style.accentColor,
        ),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: borderType,
        gradient: LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [/* Color(0Xff845EC2), Color(0xffD65DB1), Color(0xffFF6F91), Color(0xffFF9671), Color(0xffFFC75F), Color(0xffF9F871) */
     /*  Color(0Xff01CD3F), Color(0xff00C07A), Color(0xff00AFAE), Color(0xff009BD5), Color(0xff0083E5), Color(0xff0067DB) */
      Color(0Xffb6f492), Color(0xff338b93)
      /* Color(0Xfff2709c), Color(0xffff9472) */
      /* Color(0XffE6A200), Color(0xff8BA221), Color(0xff369450), Color(0xff007D6D) */
     /* Color(0Xff004c4c), Color(0xff006666), Color(0xff008080), Color(0xff66b2b2), Color(0xffb2d8d8) */
     /* Color(0xff006666), Color(0xff008080), Color(0xff66b2b2), Color(0xffb2d8d8) */
     /* Color(0Xff011f4b), Color(0xff03396c), Color(0xff005b96), Color(0xff6497b1), Color(0xffb3cde0)*/
      /*  Color(0xff3d84a8), Color(0xff46cdcf), Color(0xffabedd8) */
       /* Color(0xffe4f9f5), Color(0xff30e3ca), Color(0xff11999e),Color(0xff40514e) */
       /* Color(0xffe86ed0), Color(0xffb1e8ed) */ 
     ]),
      ),
      duration: Duration(milliseconds: 1500),
    );
  }
}
