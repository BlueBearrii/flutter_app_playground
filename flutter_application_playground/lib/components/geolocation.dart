import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Geolocation extends StatefulWidget {
  @override
  _GeolocationState createState() => _GeolocationState();
}

class _GeolocationState extends State<Geolocation> {
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

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.done)
            return Center(
              child: Container(child: Text("${snapshot.data}")),
            );
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
