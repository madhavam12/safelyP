import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';

class RequestCard extends StatelessWidget {
  final String title;
  final String photoURL;
  final String description;
  final String latitude;
  final String longitude;

  final String time;

  RequestCard({
    this.title,
    this.photoURL,
    this.latitude,
    this.time,
    this.longitude,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$time",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          subtitle: Column(
            children: [
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(photoURL),
                      ),
                    ],
                  ),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 7.0,
                            ),
                          ],
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Open in maps",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "QuickSand",
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
