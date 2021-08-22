import 'package:flutter/material.dart';
import 'package:safely_p/screens/widgets/widgets.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'widgets/widgets.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safely_p/services/services.dart';

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

  FirebaseAuthService auth = FirebaseAuthService();
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
                        .where('nearbyUsersUID', arrayContainsAny: [auth.uid])
                        .orderBy('timeStamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return NoRequests();
                      }
                      if (snapshot.connectionState == ConnectionState.active &&
                          !snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                      if (snapshot.data.docs.length == 0) {
                        return NoRequests();
                      }

                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              Timestamp time =
                                  snapshot.data.docs[index].data()['timeStamp'];
                              DateTime dt = time.toDate();

                              final DateFormat formatter =
                                  new DateFormat.yMMMMd('en_US');

                              String formatted = formatter.format(dt);
                              List colors = [
                                Colors.orange,
                                Colors.orangeAccent,
                              ];
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
                            }),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
