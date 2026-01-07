import 'dart:math';
import 'package:latlong2/latlong.dart';

class BuildingZone {
  final String id;
  final String name;
  final LatLng center;
  final double radiusMeters;

  const BuildingZone({
    required this.id,
    required this.name,
    required this.center,
    required this.radiusMeters,
  });
}

double distanceMeters(LatLng a, LatLng b) {
  const r = 6371000.0;
  final dLat = _deg2rad(b.latitude - a.latitude);
  final dLon = _deg2rad(b.longitude - a.longitude);
  final lat1 = _deg2rad(a.latitude);
  final lat2 = _deg2rad(b.latitude);

  final h =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);

  return 2 * r * atan2(sqrt(h), sqrt(1 - h));
}

double _deg2rad(double deg) => deg * (pi / 180.0);
