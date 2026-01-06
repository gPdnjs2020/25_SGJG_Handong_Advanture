import 'package:flutter/material.dart';
import 'package:handong_adventure/main.dart';
import 'package:handong_adventure/map.dart';
import 'package:handong_adventure/mypg.dart';
import 'package:handong_adventure/rank.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const MapPagePlaceholder(),
    const RankingPage(),
    const MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgYellow,
      body: SafeArea(
        bottom: false, // 하단 바 영역까지 확장
        child: Column(
          children: [
            Expanded(
              // 페이지 내용은 상단 노란 배경 + 중앙 연노랑 카드 구조를 가짐
              child: IndexedStack(index: _selectedIndex, children: _pages),
            ),
          ],
        ),
      ),
      // 하단 네비게이션 바 (SVG의 회색 바)
      bottomNavigationBar: Container(
        height: 70, // SVG 비율에 맞춤
        decoration: const BoxDecoration(color: kNavGrey),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.map, '홈'),
              _buildNavItem(1, Icons.emoji_events, '랭킹'),
              _buildNavItem(2, Icons.person, 'MY'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? kWhite : kTextBlack.withOpacity(0.5),
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? kWhite : kTextBlack.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
