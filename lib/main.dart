<<<<<<< HEAD
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color haPrimaryColor = Color.fromARGB(255, 38, 103, 240); // 기본 색상 (파랑)

void main() {
  runApp(MyApp());
=======
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handong_adventure/login.dart';
import 'package:handong_adventure/rank.dart';
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
>>>>>>> main
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      debugShowCheckedModeBanner: false,
      home: HandongAdventure(),
    );
  }
}

int currentIndex = 0;

class HandongAdventure extends StatefulWidget {
  const HandongAdventure({super.key});

  @override
  State<HandongAdventure> createState() => _HandongAdventureState();
}

class _HandongAdventureState extends State<HandongAdventure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: 32), // 로고 만들어지면 바꾸기
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.person, color: Colors.black), // 마이페이지 버튼
          ),
        ],
        backgroundColor: Colors.white, // appbar 색상
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [HomePage(), RankPage(), SupportPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        selectedItemColor: haPrimaryColor, // 선택된 아이콘 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이콘 색상
        showSelectedLabels: false, // 선택된 항목 label 숨기기
        showUnselectedLabels: false, // 선택되지 않은 항목 label 숨기기
        type: BottomNavigationBarType.fixed, // 선택시 아이콘 움직이지 않기
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.paid), label: ""),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: haPrimaryColor,
      body: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  margin: EdgeInsets.all(0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Quiz1()),
                      );
                    },
                    child: Text(
                      'Lv1  새내기',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  margin: EdgeInsets.all(0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Quiz2()),
                      );
                    },
                    child: Text(
                      'Lv2  헌내기',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  margin: EdgeInsets.all(0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Quiz3()),
                      );
                    },
                    child: Text(
                      'Lv3  고인물',
                      style: TextStyle(fontSize: 25, color: Colors.black),
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
}

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '개발자들에게',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(onPressed: () {}, child: Text('커피 한잔 주기')),

                  SizedBox(height: 100),
                  ElevatedButton(onPressed: () {}, child: Text('독설 한번 하기')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Quiz1 extends StatefulWidget {
  const Quiz1({super.key});

  @override
  State<Quiz1> createState() => _Quiz1State();
}

class _Quiz1State extends State<Quiz1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('새내기 퀴즈', textAlign: TextAlign.center)],
        ),
      ),
    );
  }
}

class Quiz2 extends StatefulWidget {
  const Quiz2({super.key});

  @override
  State<Quiz2> createState() => _Quiz2State();
}

class _Quiz2State extends State<Quiz2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('헌내기 퀴즈', textAlign: TextAlign.center)],
        ),
      ),
    );
  }
}

class Quiz3 extends StatefulWidget {
  const Quiz3({super.key});

  @override
  State<Quiz3> createState() => _Quiz3State();
}

class _Quiz3State extends State<Quiz3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('고인물 퀴즈', textAlign: TextAlign.center)],
        ),
=======
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
          if (snapshot.hasData) return const RankingPage();
          return const LoginPage();
        },
>>>>>>> main
      ),
    );
  }
}
