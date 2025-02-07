import 'package:http/http.dart' as http;
// http package - https://pub.dev/packages/http/example
// https://pub.dev/packages/http

import 'dart:convert' as convert; //  for json conversion

// https://open-meteo.com/
// https://medium.com/@slamet/nested-json-in-dart-1517cfd07822

// https://api.open-meteo.com/v1/forecast
// ?latitude=52.52
// &longitude=13.41
// &current=temperature_2m,relative_humidity_2m
// &temperature_unit=fahrenheit
// &wind_speed_unit=mph
// &precipitation_unit=inch
// &forecast_days=1

Future<Map<String, dynamic>> callApi(
    {required String latitude, required String longitude}) async {
  //String resultString = 'none,none';
  //late dynamic itemCount;
  late Map<String, dynamic> jsonResponse;
  //late Map<String, dynamic> weatherInfo;

  Uri url = Uri.https(
    'api.open-meteo.com',
    'v1/forecast',
    {
      'latitude': latitude,
      'longitude': longitude,
      'current': 'temperature_2m,relative_humidity_2m',
      'forecast_days': '1',
      'temperature_unit': 'fahrenheit'
    },
  );

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    //TODO this branch doesnt return
  }

  // for debugging
  //print('From Call: ${jsonResponse['current']}');
  return jsonResponse;
}
