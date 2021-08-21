import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'widgets/sidebarItems.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safely_p/services/geoFlutterFireService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

GeoFire geoFire = GeoFire();

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    geoFire.writeGeoPoint();
  }

  bool hasRequested = false;
  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    String formatter = DateFormat.yMMMMd('en_US').format(now);
    List<String> tokensList = [];

    return SideMenu(
      radius: BorderRadius.all(
        Radius.circular(1),
      ),
      closeIcon: Icon(LineAwesomeIcons.times, color: Colors.black, size: 35),
      key: _endSideMenuKey,
      background: Color(0xFFedeeef),
      type: SideMenuType.slide,
      menu: buildMenu(context, _endSideMenuKey),
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              final _state = _endSideMenuKey.currentState;

                              if (_state.isOpened)
                                _state.closeSideMenu();
                              else
                                _state.openSideMenu();
                            },
                            child: Icon(LineAwesomeIcons.bars,
                                color: Colors.white, size: 40),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15.0, top: 0),
                          child: Text(
                            "${DateFormat('EEEE').format(DateTime.now())}, $formatter",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "QuickSand",
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "All Help Requests",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "QuickSand",
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  StreamBuilder<QuerySnapshot<Map>>(
                      stream: FirebaseFirestore.instance
                          .collection('requests')
                          .where('nearbyUsersUID', arrayContainsAny: [
                            FirebaseAuth.instance.currentUser.uid
                          ])
                          .orderBy('timeStamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Column(
                              children: [
                                Image.asset('assets/images/nf.png',
                                    height: 250),
                                Text(
                                  "No requests found",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "QuickSand",
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                                ConnectionState.active &&
                            !snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              Timestamp time =
                                  snapshot.data.docs[index].data()['timeStamp'];
                              DateTime dt = time.toDate();

                              final DateFormat formatter =
                                  new DateFormat.yMMMMd('en_US');

                              String formatted = formatter.format(dt);

                              colors.shuffle();

                              return Container(
                                margin: EdgeInsets.only(
                                  bottom: 25,
                                ),
                                child: RequestCard(
                                  latitude: snapshot.data.docs[index]
                                      .data()['loc']['geopoint']
                                      .latitude
                                      .toString(),
                                  longitude: snapshot.data.docs[index]
                                      .data()['loc']['geopoint']
                                      .longitude
                                      .toString(),
                                  bgColor: colors[0],
                                  title: "On $formatted",
                                  description:
                                      "Help requested on $formatted at ${snapshot.data.docs[index].data()['address']}",
                                ),
                              );
                            });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List colors = [
  kOrangeColor,
  kBlueColor,
  kYellowColor,
];

class RequestCard extends StatelessWidget {
  String title;
  String description;
  String latitude;
  String longitude;
  Color bgColor;

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
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: kTitleTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            children: [
              Text(
                description,
                style: TextStyle(
                  color: kTitleTextColor.withOpacity(0.7),
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
