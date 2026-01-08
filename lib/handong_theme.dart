import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ================= 피그마 디자인 토큰 (Colors & Styles) =================

class HandongColors {
  // 메인 컬러
  static const Color yellowBg = Color(0xFFFFF176); // 배경색
  static const Color yellowCard = Color(0xFFFFF9C4); // 중앙 카드 배경

  // 포인트 컬러
  static const Color bluePoint = Color(0xFF003E7E); // 입력 완료 버튼 배경
  static const Color brownBorder = Color(0xFF462C1C); // 입력창 테두리 (#462C1C)
  static const Color greyBorder = Color(0xFF6B7280); // 랭킹 카드 테두리

  // 텍스트 및 아이콘 컬러
  static const Color textBlack = Color(0xFF000000); // 타이틀
  static const Color textPrimary = Color(0xFF1F2933); // 기본 텍스트
  static const Color textOrangeTitle = Color(0xFFF57F22); // 서브타이틀
  static const Color textOrangeBody = Color(0xFFFDBA74); // 힌트 텍스트
  static const Color textGold = Color(0xFFF9A825); // 회원가입 텍스트, 레벨/점수
  static const Color inputBg = Color(0xFFFFFFFF); // 입력창 배경
  static const Color textBrown = Color(0xFF613C2A); // 랭킹 텍스트

  // 랭킹 배경색
  static const Color rank1Bg = Color(0xFFECD224); // 1위
  static const Color rank2Bg = Color(0xFFD1D5DB); // 2위
  static const Color rank3Bg = Color(0xFFD08C60); // 3위
  static const Color rankMyBg = Color(0xFFF9E9C8); // 내 순위 / 4위~
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

  // 서브타이틀 (24sp)
  static TextStyle subtitle = GoogleFonts.gaegu(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: HandongColors.textOrangeTitle,
    height: 22 / 24,
  );

  // 입력창 힌트 (24sp)
  static TextStyle inputHint = GoogleFonts.gaegu(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: HandongColors.textOrangeBody,
    height: 22 / 24,
  );

  // 입력 텍스트
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

  // 작은 텍스트 (20sp)
  static TextStyle smallLink = GoogleFonts.gaegu(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: HandongColors.textOrangeBody,
    height: 22 / 20,
  );

  // 회원가입 텍스트 (20sp)
  static TextStyle signupLink = GoogleFonts.gaegu(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: HandongColors.textGold,
    height: 22 / 20,
  );

  // 언어 설정 텍스트 (32sp)
  static TextStyle languageText = GoogleFonts.gaegu(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: HandongColors.textBlack,
    height: 1.2,
  );

  // 랭킹 닉네임 (28sp)
  static TextStyle rankNickname = GoogleFonts.gaegu(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: HandongColors.textPrimary,
    letterSpacing: -0.5,
  );

  // 랭킹 정보 (16sp)
  static TextStyle rankInfo = GoogleFonts.gaegu(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: HandongColors.textBrown,
    letterSpacing: -0.32,
  );

  // 랭킹 리스트 닉네임 (20sp)
  static TextStyle rankListNickname = GoogleFonts.gaegu(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: HandongColors.textPrimary,
    letterSpacing: -0.32,
  );

  // 랭킹 리스트 정보 (14sp)
  static TextStyle rankListInfo = GoogleFonts.gaegu(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: HandongColors.textBrown,
    letterSpacing: -0.32,
  );
}
