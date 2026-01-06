import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'handong_theme.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  // 간단한 프로필 아이콘 SVG
  static const String _profileSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 80 80" fill="none">
  <circle cx="40" cy="40" r="38" fill="white" stroke="#462C1C" stroke-width="4"/>
  <path d="M40 22C34.4772 22 30 26.4772 30 32C30 37.5228 34.4772 42 40 42C45.5228 42 50 37.5228 50 32C50 26.4772 45.5228 22 40 22Z" fill="#F9A825" stroke="#462C1C" stroke-width="3"/>
  <path d="M20 66C20 54.9543 28.9543 46 40 46C51.0457 46 60 54.9543 60 66" stroke="#462C1C" stroke-width="4" stroke-linecap="round"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    // 현재 로그인된 사용자 정보 가져오기
    final user = FirebaseAuth.instance.currentUser;
    final String studentId = user?.email?.split('@')[0] ?? '22300000';

    return Scaffold(
      backgroundColor: HandongColors.yellowBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 412, // 디자인 기준 너비
            child: Stack(
              children: [
                // 1. 노란색 박스 (Main Container)
                // 로그인 페이지와 동일한 위치(top: 61, left: 24)에 배치
                Positioned(
                  top: 61,
                  left: 24,
                  child: Container(
                    width: 364,
                    height: 856,
                    decoration: BoxDecoration(
                      color: HandongColors.yellowCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),

                        // 타이틀
                        Text(
                          '마이페이지',
                          style: HandongTextStyles.title,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '내 정보 관리',
                          style: HandongTextStyles.subtitle,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 48),

                        // 프로필 섹션
                        SvgPicture.string(_profileSvg, width: 80, height: 80),
                        const SizedBox(height: 16),
                        Text(
                          studentId,
                          style: HandongTextStyles.title.copyWith(fontSize: 32),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '한동대학교 학생',
                          style: HandongTextStyles.smallLink,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 60),

                        // 메뉴 버튼 1 (활동 내역)
                        _buildMenuButton('활동 내역', () {}),

                        const SizedBox(height: 24),

                        // 메뉴 버튼 2 (설정)
                        _buildMenuButton('설정', () {}),

                        const SizedBox(height: 60),

                        // 로그아웃 버튼
                        GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            // 로그아웃 되면 자동으로 StreamBuilder에 의해 로그인 페이지로 전환됨
                          },
                          child: Container(
                            width: 286,
                            height: 72,
                            decoration: BoxDecoration(
                              color: HandongColors.bluePoint,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '로그아웃',
                              style: HandongTextStyles.buttonText.copyWith(
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 메뉴 버튼 위젯 (입력창과 동일한 스타일)
  Widget _buildMenuButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 286,
        height: 72,
        decoration: BoxDecoration(
          color: HandongColors.inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: HandongColors.brownBorder, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: HandongTextStyles.inputText.copyWith(height: 1.2),
        ),
      ),
    );
  }
}
