import 'package:geolocator/geolocator.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'firestoreDatabaseService.dart';
import 'package:geocoder/geocoder.dart' as coder;
import 'package:safely_p/services/firebaseMessagingService.dart';
import 'package:safely_p/models/boothModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeoFire {
  //creates instance of geoflutterfire
  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;

  Stream<List<DocumentSnapshot>> stream; //stream which yields neabry docs

  Future<Stream> triggerBoothsStream() async {
    // triggers the stream
    Position pos = await _determinePosition();
    GeoFirePoint center =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);

    var collectionReference = _firestore.collection('pinkBooths');
    double radius = 5;
    String field = 'position';
    stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);

    return stream;
  }

  writeGeoPoint() async {
    //writes the current user's loc to firestore
    try {
      FireMessage fcm = FireMessage();
      String token = await fcm.deviceToken;
      Position pos = await _determinePosition();
      Firestore db = Firestore();

      String address = await _getLocalityName(pos);

      GeoFirePoint loc =
          geo.point(latitude: pos.latitude, longitude: pos.longitude);

      await db.writeLoc(
        booth: BoothModel(
            phone: FirebaseAuth.instance.currentUser.phoneNumber,
            deviceToken: token,
            address: address,
            name: FirebaseAuth.instance.currentUser.displayName,
            userId: FirebaseAuth.instance.currentUser.uid,
            loc: loc.data),
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return e;
    }
  }

  _getLocalityName(Position pos) async {
    //returns the addressline
    final coordinates = coder.Coordinates(pos.latitude, pos.longitude);
    var addresses =
        await coder.Geocoder.local.findAddressesFromCoordinates(coordinates);

    return addresses.first.addressLine;
  }

  Future<Position> _determinePosition() async {
    //requests and determines user's locations
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
