import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// 요청/검증 흐름을 캡슐화한 유틸 함수
/// requireBackground = true 로 요청하면 백그라운드(Always) 권한을 추가로 시도합니다.
Future<bool> ensureLocationPermission(
  BuildContext context, {
  bool requireBackground = false,
}) async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    // 위치 서비스가 비활성화되어 있으면 사용자에게 설정으로 이동을 제안
    await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('위치 서비스 필요'),
        content: const Text('위치 서비스가 꺼져 있습니다. 기기 설정에서 위치 서비스를 켜주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Geolocator.openLocationSettings();
            },
            child: const Text('설정 열기'),
          ),
        ],
      ),
    );
    return false;
  }

  LocationPermission perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }

  if (perm == LocationPermission.deniedForever) {
    // 영구 거부: 앱 설정으로 유도
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('권한 필요'),
        content: const Text('위치 권한이 거부되어 있습니다. 앱 설정에서 권한을 허용해주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx, true);
              await Geolocator.openAppSettings();
            },
            child: const Text('설정 열기'),
          ),
        ],
      ),
    );

    return false;
  }

  // foreground 권한은 whileInUse 또는 always 가 허용인 경우 통과
  final hasForeground =
      perm == LocationPermission.whileInUse ||
      perm == LocationPermission.always;

  if (!hasForeground) return false;

  if (requireBackground) {
    // 백그라운드 권한이 필요한 경우 플랫폼별로 안내/요청
    if (Platform.isAndroid) {
      // Android: 항상 권한이 필요
      if (perm != LocationPermission.always) {
        final want = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('백그라운드 위치 권한'),
            content: const Text('앱이 백그라운드에서도 위치를 수집하려면 추가 권한이 필요합니다. 허용하시겠어요?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('아니요'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('허용'),
              ),
            ],
          ),
        );
        if (want == true) {
          final newPerm = await Geolocator.requestPermission();
          if (newPerm == LocationPermission.always) return true;
          // 여전히 안 되면 앱 설정으로 유도
          await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('권한 필요'),
              content: const Text('백그라운드 권한이 필요합니다. 앱 설정에서 권한을 허용해주세요.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await Geolocator.openAppSettings();
                  },
                  child: const Text('설정 열기'),
                ),
              ],
            ),
          );
          return false;
        }
        return false;
      }
      return true; // already always
    } else {
      // iOS: 백그라운드 권한(Always)은 별도 Info.plist 키 필요 -> 설정으로 유도
      if (perm != LocationPermission.always) {
        final go = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('백그라운드 위치 권한'),
            content: const Text('iOS에서는 백그라운드 위치 권한을 앱 설정에서 직접 활성화해야 합니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('설정 열기'),
              ),
            ],
          ),
        );
        if (go == true) await Geolocator.openAppSettings();
        return false;
      }
      return true;
    }
  }

  return true;
}

/// 현재 위치 서비스/권한 상태를 간단히 반환합니다.
Future<Map<String, dynamic>> getLocationStatus() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  final permission = await Geolocator.checkPermission();
  return {'serviceEnabled': serviceEnabled, 'permission': permission};
}
