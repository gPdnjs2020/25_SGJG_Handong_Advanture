// lib/map_quiz_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import 'zones.dart'; // BuildingZone, distanceMeters

class MapQuizPage extends StatefulWidget {
  const MapQuizPage({super.key});

  @override
  State<MapQuizPage> createState() => _MapQuizPageState();
}

class _MapQuizPageState extends State<MapQuizPage> {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _sub;

  LatLng? _me;

  // ✅ "지금 내 위치 기준" 테스트 존
  BuildingZone? _testZone;

  final TextEditingController _answerCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startLocation();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _answerCtrl.dispose();
    super.dispose();
  }

  Future<void> _startLocation() async {
    if (!await _ensurePermission()) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('위치 권한이 필요해요.')));
      }
      return;
    }

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _sub = Geolocator.getPositionStream(locationSettings: settings).listen((
      pos,
    ) {
      final me = LatLng(pos.latitude, pos.longitude);

      // ✅ 처음 위치 들어오는 순간 테스트 존 생성(현재 위치가 중심)
      if (_testZone == null) {
        _testZone = BuildingZone(
          id: 'test',
          name: '내 주변 테스트 존',
          center: me,
          radiusMeters: 30, // 필요하면 50으로 키워서 테스트
        );
      }

      setState(() => _me = me);

      // ✅ 카드 안 지도도 내 위치로 따라오게
      _mapController.move(me, 17);
    });
  }

  Future<bool> _ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    return perm != LocationPermission.denied &&
        perm != LocationPermission.deniedForever;
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
                        Text('Quiz!', style: gaegu(32)),
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
                    mapController: _mapController,
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
  final MapController mapController;
  final LatLng? me;
  final String question;
  final BuildingZone? testZone;

  const QuizMapCard({
    super.key,
    required this.mapController,
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
                        child: FlutterMap(
                          mapController: mapController,
                          options: const MapOptions(
                            initialCenter: LatLng(36.10310, 129.38820),
                            initialZoom: 16,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.example.handong_adventure',
                            ),

                            // ✅ 테스트 존 원 표시 (현재 위치 기준으로 생성됨)
                            if (testZone != null)
                              CircleLayer(
                                circles: [
                                  CircleMarker(
                                    point: testZone!.center,
                                    radius: testZone!.radiusMeters,
                                    useRadiusInMeter: true,
                                    color: Colors.green.withOpacity(0.12),
                                    borderColor: Colors.green,
                                    borderStrokeWidth: 2,
                                  ),
                                ],
                              ),

                            // ✅ 내 위치 마커
                            MarkerLayer(
                              markers: [
                                if (me != null)
                                  Marker(
                                    point: me!,
                                    width: 18,
                                    height: 18,
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
