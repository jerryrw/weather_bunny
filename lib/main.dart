import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//Geolocator video - https://www.youtube.com/watch?v=9v44lAagZCI&t=9s

import 'package:http/http.dart' as http;
//http package - https://pub.dev/packages/http/example

import 'dart:convert' as convert; //  for json conversion

// https://open-meteo.com/

// https://api.open-meteo.com/v1/forecast
// ?latitude=52.52
// &longitude=13.41
// &current=temperature_2m,
// relative_humidity_2m
// &temperature_unit=fahrenheit
// &wind_speed_unit=mph
// &precipitation_unit=inch
// &forecast_days=1

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // This widget is the home page of your application.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String lat;
  late String long;
  String locationMessage = 'None'; // lat and long are null at startup

  Future<Position> _getCurrentLocation() async {
    // start by making sure location services are on
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Service disabled');
    }

    // get permission from the user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied.');
        //TODO - need to fail gracefully somehow
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permenantly denied');
    }
    // actually get the position
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Lat and Long:',
            ),
            Text(
              locationMessage, // lat and long as a string
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation().then((value) {
            lat = '${value.latitude}';
            long = '${value.longitude}';
            setState(() {
              locationMessage = 'Lat: $lat , Long: $long';
            });
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
