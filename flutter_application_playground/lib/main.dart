import 'package:flutter/material.dart';
import 'package:flutter_application_playground/components/camera.dart';
import 'package:flutter_application_playground/components/geolocation.dart';
import 'package:flutter_application_playground/components/own_my_camera.dart';

void main() {
  runApp(OwnMyCamera());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Container()));
  }
}
