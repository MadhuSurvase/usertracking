// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// class TrackingScreen extends StatefulWidget {
//   @override
//   _TrackingScreenState createState() => _TrackingScreenState();
// }
//
// class _TrackingScreenState extends State<TrackingScreen> {
//   Position? _currentPosition;
//   Position? _designatedPosition;
//   final double proximityThreshold = 50.0; // Meters
//   String proximityMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _startTracking();
//   }
//
//   _startTracking() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled.');
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permissions are denied');
//         }
//       }
//
//       Geolocator.getPositionStream().listen((Position position) {
//         setState(() {
//           _currentPosition = position;
//         });
//         _checkProximity(position);
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   _checkProximity(Position position) {
//     if (_designatedPosition != null) {
//       double distanceInMeters = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         _designatedPosition!.latitude,
//         _designatedPosition!.longitude,
//       );
//
//       print('Distance to office: $distanceInMeters meters');
//
//       setState(() {
//         if (distanceInMeters <= proximityThreshold) {
//           proximityMessage = 'You are within 50 meters of the office.';
//         } else {
//           proximityMessage = 'You are more than 50 meters away from the office.';
//           _logout(); // Log out the user automatically if more than 50 meters away
//         }
//       });
//     }
//   }
//
//   _logout() {
//     print("Logging out user...");
//     Navigator.of(context).pushReplacementNamed('/login');
//   }
//
//   _setMockOfficeLocation() {
//     // Set office location to a known far-away location
//     setState(() {
//       _designatedPosition = Position(
//         latitude: _currentPosition!.latitude + 0.001, // Shift position by 0.001 degrees (approx 111 meters)
//         longitude: _currentPosition!.longitude,
//         timestamp: DateTime.now(),
//         accuracy: 1.0,
//         altitude: 0.0,
//         heading: 0.0,
//         speed: 0.0,
//         speedAccuracy: 1.0,
//         altitudeAccuracy: 1.0, // Added this required field
//         headingAccuracy: 1.0, // Added this required field
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Tracking')),
//       body: Center(
//         child: _currentPosition == null
//             ? Text('Loading...')
//             : _designatedPosition == null
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Setting office location...'),
//             ElevatedButton(
//               onPressed: () {
//                 _setMockOfficeLocation(); // Set mock office location more than 50 meters away
//               },
//               child: Text('Set Mock Office Location > 50m Away'),
//             ),
//           ],
//         )
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(proximityMessage),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TracingScreen extends StatefulWidget {
  @override
  _TracingScreenState createState() => _TracingScreenState();
}

class _TracingScreenState extends State<TracingScreen> {
  Position? _currentPosition;
  String _locationMessage = "Fetching location...";

  // Predefined office or client location (replace with actual coordinates)
  final double officeLatitude = 37.4219983;
  final double officeLongitude = -122.084;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Method to get the current location of the user
  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Location permissions are permanently denied.";
      });
      return;
    }

    // Get the current position
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;
        _locationMessage = "Location: Lat: ${position.latitude}, Long: ${position.longitude}";
        _checkLocationProximity(position.latitude, position.longitude);
      });
    });
  }

  // Check if the user is within 50 meters of the office/client location
  void _checkLocationProximity(double userLatitude, double userLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      userLatitude,
      userLongitude,
      officeLatitude,
      officeLongitude,
    );

    if (distanceInMeters <= 50) {
      setState(() {
        _locationMessage = "You are within 50 meters of the office.";
      });
      // Normal operations can continue
    } else {
      setState(() {
        _locationMessage = "You are beyond 50 meters. Logging out...";
      });
      // Automatically log out the user
      _logoutUser();
    }
  }

  // Logout method (replace with actual logout logic)
  void _logoutUser() {
    // Example: Navigate to login screen or remove user session
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracing Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _locationMessage,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text("Refresh Location"),
            ),
          ],
        ),
      ),
    );
  }
}
