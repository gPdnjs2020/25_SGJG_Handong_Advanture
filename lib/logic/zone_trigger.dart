import 'package:latlong2/latlong.dart';
import '../zones.dart';

class ZoneState {
  bool lastInside = false;
  DateTime? lastTriggeredAt;
}

class ZoneTriggerEngine {
  final List<BuildingZone> zones;
  final void Function(BuildingZone zone) onEnter;
  final Map<String, ZoneState> _state = {};
  final int cooldownSeconds;

  ZoneTriggerEngine({
    required this.zones,
    required this.onEnter,
    this.cooldownSeconds = 60,
  }) {
    for (var z in zones) {
      _state[z.id] = ZoneState();
    }
  }

  void onLocation(LatLng me) {
    // Determine which zones the user is inside
    final insideZones = <_InsideInfo>[];
    for (var z in zones) {
      final d = distanceMeters(me, z.center);
      final inside = d <= z.radiusMeters;
      if (inside) insideZones.add(_InsideInfo(zone: z, distance: d));
    }

    if (insideZones.isEmpty) {
      // update states to reflect outside
      for (var z in zones) {
        _state[z.id]?.lastInside = false;
      }
      return;
    }

    // pick nearest
    insideZones.sort((a, b) => a.distance.compareTo(b.distance));
    final target = insideZones.first.zone;
    final st = _state[target.id]!;

    final now = DateTime.now();
    final wasInside = st.lastInside;
    final cooldownPassed =
        st.lastTriggeredAt == null ||
        now.difference(st.lastTriggeredAt!).inSeconds >= cooldownSeconds;

    if (!wasInside && cooldownPassed) {
      // edge: outside -> inside
      st.lastTriggeredAt = now;
      onEnter(target);
    }

    // update boolean states: only target is lastInside true
    for (var z in zones) {
      _state[z.id]?.lastInside = z.id == target.id;
    }
  }
}

class _InsideInfo {
  final BuildingZone zone;
  final double distance;
  _InsideInfo({required this.zone, required this.distance});
}
