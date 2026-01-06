import 'package:flutter/material.dart';
import 'package:handong_adventure/main.dart';

class MapPagePlaceholder extends StatelessWidget {
  const MapPagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            '캠퍼스 맵',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: kTextBlack,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: kCardYellow,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: kWhite,
                    shape: BoxShape.circle,
                    border: Border.all(color: kTextBlack, width: 2),
                  ),
                  child: const Icon(
                    Icons.map_rounded,
                    size: 80,
                    color: kTextBlack,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '지도 기능 준비중입니다!',
                  style: TextStyle(
                    color: kTextBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
