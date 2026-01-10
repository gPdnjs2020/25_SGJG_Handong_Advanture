// lib/map_quiz_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart' as naver;
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import 'zones.dart'; // BuildingZone, distanceMeters
import 'location_permissions.dart';

// Quiz modules (new services/widgets)
import 'package:firebase_auth/firebase_auth.dart';
import 'services/quiz_repository.dart';
import 'services/zone_trigger.dart';
import 'widgets/quiz_dialog.dart';

class MapQuizPage extends StatefulWidget {
  const MapQuizPage({super.key});

  @override
  State<MapQuizPage> createState() => _MapQuizPageState();
}

class _MapQuizPageState extends State<MapQuizPage> {
  // Naver map controller (typed when available)
  naver.NaverMapController? _naverController;
  StreamSubscription<Position>? _sub;

  LatLng? _me;

  // Overlay references (create once, update frequently)
  naver.NMarker? _meMarker;
  naver.NCircleOverlay? _zoneOverlay;

  // Quiz components
  final _quizRepo = QuizRepository();
  ZoneTrigger? _zoneTrigger;
  final _zones = <BuildingZone>[];
  final _recentQuizIds = <String>[]; // keep last 10
  bool _quizOpen = false;
  String _userLevel = 'newbie'; // TODO: replace with real user profile


  // ✅ "지금 내 위치 기준" 테스트 존
  BuildingZone? _testZone;

  final TextEditingController _answerCtrl = TextEditingController();

  bool _isTracking = false; // 위치 스트리밍 상태

  // 권한 상태 표시용
  LocationPermission? _permission;
  bool _serviceEnabled = false;

  Future<void> _refreshPermissionState() async {
    final m = await getLocationStatus();
    if (mounted) {
      setState(() {
        _serviceEnabled = m['serviceEnabled'] as bool;
        _permission = m['permission'] as LocationPermission;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // post-frame에서 권한을 확인해서 위치 추적 시작
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshPermissionState();
      final ok = await ensureLocationPermission(context);
      await _refreshPermissionState();
      // warm up quiz cache
      await _quizRepo.warmUpCache(level: _userLevel);

      // create engine with current zones (for now include _testZone if not null)
      final zones = <BuildingZone>[];
      if (_testZone != null) zones.add(_testZone!);
      // TODO: later replace with real list of zones fetched from backend or static file
      _zoneEngine = ZoneTriggerEngine(zones: zones, onEnter: (zone) async {
        await _onZoneEnter(zone);
      });

      if (ok) {
        _startLocation();
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _answerCtrl.dispose();
    super.dispose();
  }

  Future<void> _startLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('위치 서비스가 꺼져 있어요.')));
      }
      return;
    }

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _sub = Geolocator.getPositionStream(locationSettings: settings).listen(
      (pos) {
        final me = LatLng(pos.latitude, pos.longitude);

        // ✅ 처음 위치 들어오는 순간 테스트 존 생성(현재 위치가 중심)
        if (_testZone == null) {
          _testZone = BuildingZone(
            id: 'test',
            name: '내 주변 테스트 존',
            center: me,
            radiusMeters: 30, // 필요하면 50으로 키워서 테스트
          );

          // register in zones list and create trigger
          if (_zones.every((z) => z.id != _testZone!.id)) _zones.add(_testZone!);
          if (_zoneTrigger == null) {
            _zoneTrigger = ZoneTrigger(zones: _zones, onZoneEnter: (zoneId) async {
              await _onZoneEnter(zoneId);
            });
          }
        } else {
          // keep test zone center in sync with first location logic (optional)
          _testZone = BuildingZone(
            id: _testZone!.id,
            name: _testZone!.name,
            center: me,
            radiusMeters: _testZone!.radiusMeters,
          );
          // update zones list center
          final idx = _zones.indexWhere((z) => z.id == _testZone!.id);
          if (idx != -1) _zones[idx] = _testZone!;
        _updateMapOverlays();

        // Notify zone trigger
        if (_zoneTrigger != null && _me != null) {
          _zoneTrigger!.onLocation(_me!);
        }

        // ✅ 카드 안 지도도 내 위치로 따라오게
        if (_naverController != null) {
          try {
            final update = naver.NCameraUpdate.scrollAndZoomTo(
              target: naver.NLatLng(me.latitude, me.longitude),
              zoom: 17,
            );
            _naverController!.updateCamera(update);
          } catch (e) {
            // ignore camera update errors
          }
        }
      },
      onError: (e) {
        // 위치 스트리밍 오류 처리
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('위치 업데이트 오류: $e')));
        }
      },
    );
  }

  Future<bool> _ensurePermissionSimple() async {
    // 기존 로직을 사용해야 하는 곳을 위한 간단한 검사
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    return perm != LocationPermission.denied &&
        perm != LocationPermission.deniedForever;
  }

  // Called when the native map has been created. Create any initial overlays here.
  Future<void> _onMapCreated(naver.NaverMapController controller) async {
    _naverController = controller;

    // add overlays for existing state
    try {
      await _updateMapOverlays();
    } catch (e) {
      // ignore
    }

    // If we already have a location, focus camera
    if (_me != null) {
      try {
        final update = naver.NCameraUpdate.scrollAndZoomTo(
          target: naver.NLatLng(_me!.latitude, _me!.longitude),
          zoom: 17,
        );
        await controller.updateCamera(update);
      } catch (e) {}
    }
  }

  // Update map overlays (markers/circles) using typed plugin API: create once and update.
  Future<void> _updateMapOverlays() async {
    final ctrl = _naverController;
    if (ctrl == null) return;

    // Update / create user location marker
    if (_me != null) {
      final pos = naver.NLatLng(_me!.latitude, _me!.longitude);
      if (_meMarker == null) {
        _meMarker = naver.NMarker(id: 'me', position: pos);
        try {
          await ctrl.addOverlay(_meMarker!);
        } catch (e) {
          // fail silently but keep the reference to attempt updates later
        }
      } else {
        try {
          _meMarker!.setPosition(pos);
        } catch (e) {}
      }
    }

    // Update / create zone circle
    if (_testZone != null) {
      final center = naver.NLatLng(_testZone!.center.latitude, _testZone!.center.longitude);
      if (_zoneOverlay == null) {
        _zoneOverlay = naver.NCircleOverlay(
          id: 'testZone',
          center: center,
          radius: _testZone!.radiusMeters,
          color: Colors.green.withOpacity(0.12),
          outlineColor: Colors.green,
          outlineWidth: 2,
        );
        try {
          await ctrl.addOverlay(_zoneOverlay!);
        } catch (e) {}
      } else {
        try {
          _zoneOverlay!.setCenter(center);
          _zoneOverlay!.setRadius(_testZone!.radiusMeters);
        } catch (e) {}
      }
    }
  }

  void _onSubmitAnswer() {
    final ans = _answerCtrl.text.trim();

    if (_me == null || _testZone == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('위치를 아직 못 잡았어. 잠깐만!')));
      return;
    }

    final d = distanceMeters(_me!, _testZone!.center);
    final inside = d <= _testZone!.radiusMeters;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'ZONE TEST',
          style: GoogleFonts.gaegu(fontWeight: FontWeight.w700),
        ),
        content: Text(
          '존: ${_testZone!.name}\n'
          '거리: ${d.toStringAsFixed(1)} m\n\n'
          '${inside ? "✅ 존 안에 있음!" : "❌ 존 밖"}\n\n'
          '입력: $ans',
          style: GoogleFonts.gaegu(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '확인',
              style: GoogleFonts.gaegu(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onZoneEnter(String zoneId) async {
    if (!mounted) return;
    if (_quizOpen) return; // prevent reentry

    final exclude = Set<String>.from(_recentQuizIds);
    final quiz = await _quizRepo.getRandomQuiz(_userLevel, excludeIds: exclude);
    if (quiz == null) return;

    // push id to recent list
    _recentQuizIds.insert(0, quiz.id);
    if (_recentQuizIds.length > 10) _recentQuizIds.removeLast();

    _quizOpen = true;
    try {
      final res = await showQuizDialog(context, quiz);
      if (res == null) return;

      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
      await _quizRepo.logAttempt(uid: uid, zoneId: zoneId, quizId: quiz.id, correct: res.correct, userAnswer: res.answer, level: quiz.level);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.correct ? '정답입니다!' : '오답입니다!')));
      }

      // Mark zone as exited so next entry can trigger again
      _zoneTrigger?.markExited(zoneId);
    } finally {
      _quizOpen = false;
    }
  }

  // 권한 라벨/색상 헬퍼
  String _permissionLabel() {
    if (!_serviceEnabled) return '서비스 OFF';
    switch (_permission) {
      case LocationPermission.denied:
        return '권한: 거부';
      case LocationPermission.deniedForever:
        return '권한: 영구거부';
      case LocationPermission.whileInUse:
        return '권한: 사용 중 허용';
      case LocationPermission.always:
        return '권한: 항상 허용';
      case LocationPermission.unableToDetermine:
        return '권한: 알수없음';
      default:
        return '권한: 미확인';
    }
  }

  Color _permissionColor() {
    if (!_serviceEnabled) return Colors.grey.shade400;
    switch (_permission) {
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        return Colors.red.shade300;
      case LocationPermission.whileInUse:
        return Colors.orange.shade300;
      case LocationPermission.always:
        return Colors.green.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 피그마 스타일용 공통 텍스트 스타일
    TextStyle gaegu(double size, {FontWeight w = FontWeight.w700, Color? c}) {
      return GoogleFonts.gaegu(
        fontSize: size,
        fontWeight: w,
        color: c ?? const Color(0xFF1F2933),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF176), // 바깥 노랑
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 412, // 피그마 프레임 폭
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 상단 라인
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('한동 어드벤처', style: gaegu(16)),
                        Row(
                          children: [
                            Text('Quiz!', style: gaegu(32)),
                            const SizedBox(width: 12),

                            // 백그라운드 권한 요청 버튼
                            ElevatedButton(
                              onPressed: () async {
                                final ok = await ensureLocationPermission(
                                  context,
                                  requireBackground: true,
                                );
                                await _refreshPermissionState();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      ok
                                          ? '백그라운드 권한이 허용되었습니다.'
                                          : '백그라운드 권한이 필요합니다.',
                                    ),
                                  ),
                                );
                                // 권한 생기면 위치 추적 시작
                                if (ok && !_isTracking) {
                                  _startLocation();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003E7E),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Text(
                                '백그라운드 권한 요청',
                                style: gaegu(
                                  12,
                                  w: FontWeight.w700,
                                  c: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // 권한 상태 표시 배지
                            GestureDetector(
                              onTap: () async {
                                // 탭하면 상세 상태 다이얼로그와 재요청/설정 열기 옵션을 표시
                                final p = _permission;
                                if (p == LocationPermission.deniedForever) {
                                  final go = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('권한 영구 거부'),
                                      content: const Text(
                                        '앱 설정에서 위치 권한을 허용해주세요.',
                                      ),
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
                                } else {
                                  final retry = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('권한 상태'),
                                      content: Text(
                                        '현재 상태: ${_permissionLabel()}. 권한을 다시 요청할까요?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('아니요'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: const Text('요청'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (retry == true) {
                                    await ensureLocationPermission(context);
                                    await _refreshPermissionState();
                                    if (!_isTracking &&
                                        (_permission ==
                                                LocationPermission.whileInUse ||
                                            _permission ==
                                                LocationPermission.always)) {
                                      _startLocation();
                                    }
                                  }
                                }
                              },
                              child: Chip(
                                label: Text(_permissionLabel()),
                                backgroundColor: _permissionColor(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 1 + 답을 맞춰봐!
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _BoxLabel(width: 51, text: '1', style: gaegu(32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _BoxLabel(
                            width: double.infinity,
                            text: '답을 맞춰봐!',
                            style: gaegu(16),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ✅ 피그마 카드(지도 들어갈 자리)
                  QuizMapCard(
                    onMapCreated: _onMapCreated,
                    me: _me,
                    question: '한동대에서 가장 코딩을 잘 하는 사람은?',
                    // 테스트 존 원을 “내 위치 기준”으로 표시
                    testZone: _testZone,
                  ),

                  const SizedBox(height: 18),

                  // 입력 박스
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _AnswerField(
                      controller: _answerCtrl,
                      hintStyle: gaegu(16),
                      textStyle: gaegu(16),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 버튼
                  SizedBox(
                    width: 170,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003E7E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _onSubmitAnswer,
                      child: Text(
                        '정답 결정하기',
                        style: GoogleFonts.gaegu(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 디버그(원하면 삭제 가능)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _me == null
                            ? 'Locating...'
                            : 'lat: ${_me!.latitude.toStringAsFixed(5)}, lon: ${_me!.longitude.toStringAsFixed(5)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuizMapCard extends StatelessWidget {
  final void Function(naver.NaverMapController)? onMapCreated;
  final LatLng? me;
  final String question;
  final BuildingZone? testZone;

  const QuizMapCard({
    super.key,
    this.onMapCreated,
    required this.me,
    required this.question,
    required this.testZone,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 333,
      height: 372,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9E9C8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 2, color: const Color(0xFF613C2A)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          // NaverMap widget (flutter_naver_map). Replace Stack overlays with plugin API as needed.
                          child: naver.NaverMap(
                            initialCameraPosition: naver.CameraPosition(
                              target: naver.NLatLng(36.10310, 129.38820),
                              zoom: 16,
                            ),
                            onMapCreated: (controller) => onMapCreated?.call(controller),
                          ),
                  Container(height: 2, color: const Color(0xFF613C2A)),

                  // 하트 바
                  const SizedBox(
                    height: 88,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite, size: 36, color: Colors.red),
                          SizedBox(width: 42),
                          Icon(Icons.favorite, size: 36, color: Colors.red),
                          SizedBox(width: 42),
                          Icon(Icons.favorite, size: 36, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 말풍선
              Positioned(
                left: 24,
                top: 14,
                right: 24,
                child: _SpeechBubble(text: question),
              ),

              // 느낌표 버튼
              Positioned(
                right: 24,
                top: 110,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          '힌트',
                          style: GoogleFonts.gaegu(fontWeight: FontWeight.w700),
                        ),
                        content: Text(
                          '지도에서 특정 지점을 찾아봐!',
                          style: GoogleFonts.gaegu(fontWeight: FontWeight.w700),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              '닫기',
                              style: GoogleFonts.gaegu(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const _HintIcon(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  final String text;
  const _SpeechBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(2),
        ),
        border: Border.all(width: 2, color: const Color(0xFF613C2A)),
      ),
      child: Text(
        text,
        style: GoogleFonts.gaegu(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: const Color(0xFF1F2933),
        ),
      ),
    );
  }
}

class _HintIcon extends StatelessWidget {
  const _HintIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF176),
        shape: BoxShape.circle,
        border: Border.all(width: 1.5, color: Colors.black),
      ),
      alignment: Alignment.center,
      child: const Text('!', style: TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}

class _BoxLabel extends StatelessWidget {
  final double width;
  final String text;
  final TextStyle style;

  const _BoxLabel({
    required this.width,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: 51,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9E9C8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 2, color: const Color(0xFF613C2A)),
      ),
      child: Text(text, style: style),
    );
  }
}

class _AnswerField extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle hintStyle;
  final TextStyle textStyle;

  const _AnswerField({
    required this.controller,
    required this.hintStyle,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9E9C8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 2, color: const Color(0xFF613C2A)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '생각나는 정답을 적어 봐!',
          hintStyle: hintStyle,
        ),
        style: textStyle,
      ),
    );
  }
}
