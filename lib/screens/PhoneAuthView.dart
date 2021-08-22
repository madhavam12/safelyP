import 'package:flutter/material.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import "otpScreen.dart";
import 'widgets/widgets.dart';
import 'package:flutter/services.dart';

import 'package:connection_verify/connection_verify.dart';

class PhoneAuthView extends StatelessWidget {
  final FocusNode phoneNumberFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final String number = '';
  @override
  Widget build(BuildContext context) {
    final FocusNode _nameFocus = FocusNode();
    final FocusNode _phoneFocus = FocusNode();
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [Color(0xFF0047ab), Color(0xFF4169e1)],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldkey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 25.0, left: 25.0, right: 25.0, bottom: 20),
                      child: Center(
                        child: Text(
                          "Let's setup your account.",
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
                          "assets/images/login.png",
                        ),
                        height: 250),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "Please enter your name and number to continue.",
                        style: TextStyle(
                          letterSpacing: 1.7,
                          fontFamily: "QuickSand",
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 18.0, right: 18.0, top: 18.0, bottom: 5.0),
                    child: TextField(
                      focusNode: _nameFocus,
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      onSubmitted: (String name) {
                        _nameFocus.unfocus();
                        FocusScope.of(context).requestFocus(_phoneFocus);
                      },
                      style: TextStyle(
                          fontSize: 17.5, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(fontSize: 18),
                        prefixIcon: Icon(LineAwesomeIcons.user),
                        filled: true,
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        fillColor: Color(0xFFf5f5f5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 18.0, right: 18.0, top: 0, bottom: 15.0),
                    child: TextField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      onSubmitted: (String number) async {
                        if (_nameController.text == "") {
                          showInSnackBar(
                              context: context,
                              value: "Please enter your name",
                              color: Colors.red,
                              sec: 5);

                          return 0;
                        }
                        if (_phoneController.text == "") {
                          showInSnackBar(
                              context: context,
                              value: "Please enter your phone number.",
                              color: Colors.red,
                              sec: 5);

                          return 0;
                        }
                        if (_phoneController.text != "" &&
                            _phoneController.text.length != 10) {
                          showInSnackBar(
                              context: context,
                              value: "Please enter a valid phone number.",
                              color: Colors.red,
                              sec: 5);

                          return 0;
                        }

                        if (!(await ConnectionVerify.connectionStatus())) {
                          showInSnackBar(
                              context: context,
                              value:
                                  "No Internet connection. Please connect to the internet and then try again.",
                              color: Colors.red);
                          return 0;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPScreen(
                                name: _nameController.text, phone: number),
                          ),
                        );

                        //
                      },
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        counterStyle: TextStyle(color: Colors.white),
                        prefix: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            '+91',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(15.0),
                        labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(fontSize: 18),
                        prefixIcon: Icon(LineAwesomeIcons.phone),
                        filled: true,
                        labelText: 'Phone Number',
                        hintText: 'Enter your number',
                        fillColor: Color(0xFFf5f5f5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
