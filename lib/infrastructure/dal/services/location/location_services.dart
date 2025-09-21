import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../daos/widgets/snackbar_widget.dart';

class LocationService {
  LocationService.init();

  static LocationService instance = LocationService.init();

  final Location _location = Location();

  Future<bool> checkForServiceAvailability() async {
    bool isEnabled = await _location.serviceEnabled();
    if (isEnabled) {
      return true;
    }
    isEnabled = await _location.requestService();
    if (isEnabled) {
      return true;
    }
    _showSnackbar("Service Disabled", "Location services are not enabled.");
    return false;
  }

  Future<bool> checkForPermission() async {
    PermissionStatus status = await _location.hasPermission();

    if (status == PermissionStatus.denied) {
      status = await _location.requestPermission();
      if (status == PermissionStatus.granted) {
        return true;
      }
      _showSnackbar("Permission Denied", "Location permission is denied.");
      return false;
    }

    if (status == PermissionStatus.deniedForever) {
      _showSnackbar("Permission Denied Forever",
          "Location permission is permanently denied.");
      return false;
    }

    return true;
  }

  Future<LocationData?> getUserLocation() async {
    if (!(await checkForServiceAvailability())) {
      return null;
    }

    if (!(await checkForPermission())) {
      return null;
    }
    try {
      final LocationData data = await _location.getLocation();
      return data;
    } catch (e) {
      _showSnackbar("Error", "Failed to get location: $e");
      return null;
    }
  }

  // Function to show the Snackbar using Get.snackbar
  void _showSnackbar(String title, String message) {
    SnackbarWidget(
      title: title,
      message: message,
      icon: Icons.location_on,
    );
  }
}
