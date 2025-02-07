import 'package:geolocator/geolocator.dart';
// Geolocator video - https://www.youtube.com/watch?v=9v44lAagZCI&t=9s
// https://pub.dev/packages/geolocator

Future<Position> getCurrentLocation() async {
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
