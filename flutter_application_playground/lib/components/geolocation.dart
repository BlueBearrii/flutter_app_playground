import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Geolocation extends StatefulWidget {
  @override
  _GeolocationState createState() => _GeolocationState();
}

class _GeolocationState extends State<Geolocation> {
  bool isButtonDisable = false;
  double kxLatitude = 13.7204;
  double kxLongtitude = 100.4983;
  double _currentLatitude;
  double _currentLongtitude;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition().then((value) {
      //print("Latitude : ${value.latitude}");
      //print("Longtitude : ${value.longitude}");
      _currentLatitude = value.latitude;
      _currentLongtitude = value.longitude;

      return value;
    });
  }

  bool _checkCurrentLocationForAllowButton(data) {
    //print("_Current Position : ${double.parse(_currentLatitude.toStringAsFixed(4))} vs ${double.parse(kxLatitude.toStringAsFixed(4))}");
    //print("_Current Position : ${double.parse(_currentLongtitude.toStringAsFixed(4))} vs ${double.parse(kxLongtitude.toStringAsFixed(4))}");
    if (double.parse(_currentLatitude.toStringAsFixed(3)) !=
            double.parse(kxLatitude.toStringAsFixed(3)) &&
        double.parse(_currentLongtitude.toStringAsFixed(3)) !=
            double.parse(kxLongtitude.toStringAsFixed(3)))
      return false;
    else
      return true;
  }

  void _workplaceAttention() {
    // Use server time to protect cheat time in mobile
    var now = TimeOfDay.now();
    print(now);
    if (now.hour.toInt() >= 18) print("Check out on time");
    if (now.hour.toInt() < 18) print("Check out before time");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${snapshot.data}"),
                    RaisedButton(
                      onPressed:
                          _checkCurrentLocationForAllowButton(snapshot.data)
                              ? () {
                                  _workplaceAttention();
                                }
                              : null,
                      child: Text("Check-In"),
                    )
                  ],
                ));
          else if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Container(child: CircularProgressIndicator()),
            );
          else if (snapshot.connectionState == ConnectionState.none)
            return Center(
              child: Container(child: Text("Not response")),
            );

          return Container();
        },
      )),
    );
  }
}
