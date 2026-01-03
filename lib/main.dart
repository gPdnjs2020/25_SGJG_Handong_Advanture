import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handong_adventure/firebase_options.dart';
import 'package:handong_adventure/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // 1. 플러터 엔진 초기화 및 파이어베이스 연결
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
        primaryColor: const Color(0xFF003E7E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003E7E),
          primary: const Color(0xFF003E7E),
        ),
        useMaterial3: true,
      ),
      // 앱 시작 시 로그인 상태 확인
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 이미 로그인되어 있다면 메인 페이지로, 아니면 로그인 페이지로
          if (snapshot.hasData) {
            return const MainPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(
      child: Text('여기에 지도가 들어갑니다 (Map)', style: TextStyle(fontSize: 24)),
    ),
    const Center(
      child: Text('랭킹 페이지 (Ranking)', style: TextStyle(fontSize: 24)),
    ),
    // 마이페이지는 별도 위젯으로 분리해서 사용자 이름 표시 가능
    const MyPagePlaceholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handong Adventure'),
        backgroundColor: const Color(0xFF003E7E),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // 로그아웃 버튼 (테스트용)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut(); // 로그아웃하면 자동으로 로그인 화면으로 감
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: '랭킹'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF003E7E),
        onTap: _onItemTapped,
      ),
    );
  }
}

// 마이페이지 임시 위젯 (사용자 정보 로딩 예시)
class MyPagePlaceholder extends StatelessWidget {
  const MyPagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자 정보 가져오기
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_circle, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            '환영합니다!\n학번: ${user?.email?.split('@')[0] ?? '정보 없음'}', // 이메일 앞부분(학번)만 표시
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
