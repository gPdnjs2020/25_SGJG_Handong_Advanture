import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color haPrimaryColor = Color.fromARGB(255, 38, 103, 240); // 기본 색상 (파랑)

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      ),
    );
  }
}
