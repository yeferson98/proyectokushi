import 'package:kushi/user/model/model.google/user.location.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  UserLocation _currentLocation;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  Location location = Location();

  Future<UserLocation> getLocationUser() async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      getpermission();
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitud: userLocation.latitude,
        longitud: userLocation.longitude,
        status: 'false'
      );
      _preferences.setBool('permissionLocation', true);
    } catch (e) {
      _currentLocation=UserLocation(status: 'true');
      print('error al obtener la ubicación');
    }
    return  _currentLocation;
  }

  void getpermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
