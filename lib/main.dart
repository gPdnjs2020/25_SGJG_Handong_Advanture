import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handong_adventure/homepg.dart';
import 'package:handong_adventure/login.dart';
import 'firebase_options.dart';

// ================= 디자인 시스템 (SVG Exact Colors) =================
const Color kBgYellow = Color(0xFFFFF176); // 메인 배경
const Color kCardYellow = Color(0xFFFFF9C4); // 카드 배경 (연한 노랑)
const Color kNavGrey = Color(0xFF818181); // 하단 바 (회색)
const Color kTextBlack = Color(0xFF000000); // 텍스트 (검정)
const Color kInputBorder = Color(0xFF462C1C); // 입력창 테두리 (진한 갈색)
const Color kBlueBtn = Color(0xFF003E7E); // 버튼 (한동 블루)
const Color kRankGold = Color(0xFFF9A825); // 랭킹 골드
const Color kWhite = Colors.white;

const double kCardRadius = 24.0; // 카드 둥근 모서리

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handong Adventure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kBgYellow,
        scaffoldBackgroundColor: kBgYellow,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kBgYellow,
          primary: kTextBlack,
          surface: kCardYellow,
          background: kBgYellow,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',

        appBarTheme: const AppBarTheme(
          backgroundColor: kBgYellow,
          foregroundColor: kTextBlack,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: kTextBlack,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
          iconTheme: IconThemeData(color: kTextBlack),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kBlueBtn, // SVG: Blue Button
            foregroundColor: kWhite,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kWhite, // SVG: White Fill
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          // SVG: Stroke #462C1C width 2
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kInputBorder, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kInputBorder, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kBlueBtn, width: 2),
          ),
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
          labelStyle: const TextStyle(
            color: kTextBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) return const MainPage();
          return const LoginPage();
        },
      ),
    );
  }
}
