import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pinput/pin_put/pin_put.dart';

import 'package:flutter/services.dart';
import 'widgets/widgets.dart';
import 'homeScreen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String name;
  OTPScreen({@required this.phone, @required this.name});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  void showInSnackBar({String value, Color color, int sec = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: color,
      duration: Duration(seconds: sec),
    ));
  }

  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    // color: const Color.fromRGBO(43, 46, 66, 1)
    //
    color: Color(0xFFFCF0E3),

    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              // ThemeColors.loginGradientStart,
              // ThemeColors.loginGradientEnd
              // Color(0xFFFCF0E3),
              // Color(0xFFFCF0E3),
              Color(0xFF0047ab),
              Color(0xFF4169e1)
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldkey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 5.0, left: 25.0, right: 25.0, bottom: 0),
                    child: Center(
                      child: Text(
                        "Verify your number.",
                        style: TextStyle(
                          letterSpacing: 0.5,
                          fontSize: 23.5,
                          fontFamily: "QuickSand",
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Image(
                      image: AssetImage(
                        "assets/images/otp.png",
                      ),
                      height: 350),
                ),
                Container(
                  // margin: EdgeInsets.all(25.0),
                  child: Center(
                    child: Text(
                      'Enter code sent to +91-${widget.phone}',
                      style: TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 20,
                        fontFamily: "QuickSand",
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PinPut(
                    fieldsCount: 6,
                    textStyle:
                        const TextStyle(fontSize: 25.0, color: Colors.black),
                    eachFieldWidth: 40.0,
                    eachFieldHeight: 55.0,
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    pinAnimationType: PinAnimationType.fade,
                    onSubmit: (pin) async {
                      try {
                        showInLoading(
                            color: Colors.blue,
                            value: "Signing in..",
                            context: context);

                        UserCredential user =
                            await FirebaseAuth.instance.signInWithCredential(
                          PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin),
                        );

                        await user.user.updateDisplayName(widget.name);

                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } catch (e) {
                        if (e is PlatformException) {
                          showInSnackBar(
                              value: "${e.message}", color: Colors.red, sec: 8);
                          return 0;
                        }

                        if (e is FirebaseAuthException) {
                          if (e.code == "quota-exceeded") {
                            showInSnackBar(
                                value:
                                    "SMS verification is not available right now.",
                                color: Colors.red,
                                sec: 6);
                            return 0;
                          }

                          showInSnackBar(
                              value: "${e.code}", color: Colors.red, sec: 8);
                          return 0;
                        }

                        showInSnackBar(
                            value:
                                "Unknown error occured. If persists, try signing in with Google or Email instead.",
                            color: Colors.red,
                            sec: 8);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white10,
                                Colors.white,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: 100.0,
                        height: 1.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Text(
                          "Or",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: "WorkSansMedium"),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white10,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: 100.0,
                        height: 1.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
