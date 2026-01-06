import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ================= 피그마 디자인 토큰 (Colors & Styles) =================

class HandongColors {
  // 메인 컬러
  static const Color yellowBg = Color(0xFFFFF176); // 전체 배경색
  static const Color yellowCard = Color(0xFFFFF9C4); // 중앙 카드 배경

  // 포인트 컬러
  static const Color bluePoint = Color(0xFF003E7E); // 입력 완료 버튼 배경
  static const Color brownBorder = Color(0xFF462C1C); // 입력창 테두리

  // 텍스트 및 아이콘 컬러
  static const Color textBlack = Color(0xFF000000); // 타이틀
  static const Color textOrangeTitle = Color(0xFFF57F22); // 서브타이틀
  static const Color textOrangeBody = Color(0xFFFDBA74); // 힌트 텍스트, 비밀번호 찾기
  static const Color textGold = Color(0xFFF9A825); // 회원가입 텍스트, 아이콘
  static const Color inputBg = Color(0xFFFFFFFF); // 입력창 배경
}

class HandongTextStyles {
  // 타이틀 (42sp, Black)
  static TextStyle title = GoogleFonts.gaegu(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: HandongColors.textBlack,
    height: 22 / 42,
    letterSpacing: 0,
  );

  // 서브타이틀 (24sp, #F57F22)
  static TextStyle subtitle = GoogleFonts.gaegu(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: HandongColors.textOrangeTitle,
    height: 22 / 24,
  );

  // 입력창 힌트 (24sp, #FDBA74)
  static TextStyle inputHint = GoogleFonts.gaegu(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: HandongColors.textOrangeBody,
    height: 22 / 24,
  );

  // 입력 텍스트 (입력창 내부 실제 입력 글씨 - 힌트와 동일하게 설정하거나 검정으로 설정)
  static TextStyle inputText = GoogleFonts.gaegu(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: HandongColors.textBlack,
    height: 22 / 24,
  );

  // 버튼 텍스트 (28sp, White)
  static TextStyle buttonText = GoogleFonts.gaegu(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 22 / 28,
  );

  // 작은 텍스트 (비밀번호 찾기 - 20sp, #FDBA74)
  static TextStyle smallLink = GoogleFonts.gaegu(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: HandongColors.textOrangeBody,
    height: 22 / 20,
  );

  // 회원가입 텍스트 (20sp, #F9A825)
  static TextStyle signupLink = GoogleFonts.gaegu(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: HandongColors.textGold,
    height: 22 / 20,
  );
}
