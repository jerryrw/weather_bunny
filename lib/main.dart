//import 'dart:async';
//import 'dart:convert' as convert; //  for json conversion
import 'package:flutter/material.dart';
import 'getLocation.dart';
import 'callWeatherAPI.dart';

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
      title: 'Weather Bunny',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather Bunny Demo Page'),
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
  String lat = '0';
  String long = '0';
  String locationMessage =
      'Refresh for Weather'; // lat and long are null at startup

  Map<String, dynamic> jsonMap = {};
  String temperature = '0';
  String humidity = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              locationMessage, // lat and long as a string
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Temp: $temperature', // temp as a string
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Humidity: $humidity', // humidity as a string
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              child: Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                // side: BorderSide(color: Colors.yellow, width: 5),
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontStyle: FontStyle.normal),
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                shadowColor: Colors.lightBlue,
              ),
              onPressed: () {
                setState(() {
                  locationMessage = 'Updating';
                });
                getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';
                  //setState(() {

                  //locationMessage = 'Lat: $lat , Long: $long'; // for debugging
                  //});
                  callApi(latitude: lat, longitude: long)
                      .then((Map<String, dynamic> value) {
                    jsonMap = value;
                    //current: time, interval, temperature_2m, relative_humidity_2m
                    //print(jsonMap['current']); // for debugging
                    setState(() {
                      temperature =
                          jsonMap['current']['temperature_2m'].toString();
                      humidity =
                          jsonMap['current']['relative_humidity_2m'].toString();
                      locationMessage = ' ';
                    });
                    print('Temp: ${temperature} Humidity: ${humidity}');
                  });
                  print('Lat: ${lat}, Long: ${long}');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
