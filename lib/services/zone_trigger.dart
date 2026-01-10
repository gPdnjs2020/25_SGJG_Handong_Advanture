import 'dart:async';

import 'package:latlong2/latlong.dart';
import '../zones.dart';

/// Simple zone enter detector with a 2-second dwell debounce.
class ZoneTrigger {
  final List<BuildingZone> zones;
  final void Function(String zoneId) onZoneEnter;
  final Map<String, _ZoneState> _states = {};
  final int dwellMs;

  ZoneTrigger({
    required this.zones,
    required this.onZoneEnter,
    this.dwellMs = 2000,
  }) {
    for (var z in zones) {
      _states[z.id] = _ZoneState();
    }
  }

  void onLocation(LatLng me) {
    // find zones we're inside
    final inside = <_Inside>[];
    for (var z in zones) {
      final d = distanceMeters(me, z.center);
      if (d <= z.radiusMeters) inside.add(_Inside(zone: z, dist: d));
    }

    if (inside.isEmpty) {
      // user is outside all zones: clear timers
      for (var st in _states.values) {
        st._clearTimer();
        st.isInside = false;
      }
      return;
    }

    // pick the nearest zone
    inside.sort((a, b) => a.dist.compareTo(b.dist));
    final target = inside.first.zone;
    final st = _states[target.id]!;

    if (!st.isInside) {
      // started entering - start dwell timer
      st.isInside = true;
      st._startTimer(dwellMs, () {
        // ensure still inside (we haven't been marked outside by an outside tick)
        if (st.isInside && !st.hasTriggered) {
          st.hasTriggered = true; // prevent re-trigger until exit
          onZoneEnter(target.id);
        }
      });
    }

    // mark other zones as outside
    for (var z in zones) {
      if (z.id != target.id) {
        final other = _states[z.id]!;
        other._clearTimer();
        other.isInside = false;
      }
    }
  }

  void markExited(String zoneId) {
    final st = _states[zoneId];
    if (st != null) {
      st.isInside = false;
      st.hasTriggered = false;
      st._clearTimer();
    }
  }
}

class _Inside {
  final BuildingZone zone;
  final double dist;
  _Inside({required this.zone, required this.dist});
}

class _ZoneState {
  bool isInside = false;
  bool hasTriggered = false;
  Timer? _timer;

  void _startTimer(int ms, void Function() cb) {
    _clearTimer();
    _timer = Timer(Duration(milliseconds: ms), cb);
  }

  void _clearTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
