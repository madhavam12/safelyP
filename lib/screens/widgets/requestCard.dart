import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';

class RequestCard extends StatelessWidget {
  final String title;
  final String description;
  final String latitude;
  final String longitude;
  final Color bgColor;

  RequestCard(
      {this.title,
      this.latitude,
      this.longitude,
      this.description,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            children: [
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  String _url =
                      'https://www.google.com/maps/place/$latitude,$longitude';
                  await canLaunch(_url)
                      ? await launch(_url)
                      : Fluttertoast.showToast(
                          msg:
                              "No internet connection, please connect to the internet",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 5.0,
                        ),
                      ],
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "Open Maps",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "QuickSand",
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
