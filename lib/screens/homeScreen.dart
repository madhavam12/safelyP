import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'widgets/sidebarItems.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'constant.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        body: Container(
          margin: EdgeInsets.all(25),
          child: Column(
            children: [
              Text(
                "Your past help requests",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "QuickSand",
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 35),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map>>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .where('userId',
                            isEqualTo: FirebaseAuth.instance.currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("No requests");
                      }
                      if (snapshot.connectionState == ConnectionState.active &&
                          !snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
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
                                bgColor: colors[0],
                                title: "On $formatted",
                                description:
                                    "Requested help on $formatted when you were at ${snapshot.data.docs[index].data()['address']}",
                              ),
                            );
                          });
                    }),
              ),
            ],
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

  Color bgColor;

  RequestCard({this.title, this.description, this.bgColor});

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
          subtitle: Text(
            description,
            style: TextStyle(
              color: kTitleTextColor.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
