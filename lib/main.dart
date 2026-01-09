import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_page.dart';
import 'my_page.dart';

String userName = "user1";
int level = 1;
String studentNumber = "22000000";
int wholeRank = 300;
int levelRank = 300;
int pointMax = 1000;
int userPoint = 300;
double userProgress = userPoint / pointMax;
File? profileImage;

List<String> page = ["Home", "Rank!", "My Page"];
List<Image> image_level = [
  Image.asset('assets/seed.png'),
  Image.asset('assets/sprout.png'),
  Image.asset('assets/flower.png'),
];
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.gaeguTextTheme()),
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

class _HandongAdventureState extends State<HandongAdventure>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. 바깥쪽 테두리 (진한 노랑)
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFFF176),
              padding: const EdgeInsets.fromLTRB(24, 61, 24, 0),
              child: ClipRRect(
                // 3. 안쪽 화면의 모서리를 둥글게
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Scaffold(
                  backgroundColor: const Color(0xfffff9c4),
                  appBar: AppBar(
                    toolbarHeight: 90,
                    backgroundColor: const Color(0x0ffff9c4),
                    elevation: 0,
                    centerTitle: false,
                    title: _buildCustomTitle(),
                    bottom: _buildCustomBottomBar(),
                  ),

                  body: TabBarView(
                    controller: _tabController,
                    children: [HomePage(), RankPage(), MyPage()],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 59,
            color: const Color(0xff818181),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 50,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  "한동 어드벤처",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 90),
              Container(
                width: 114,
                height: 40,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    page[currentIndex],
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildCustomBottomBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(55),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Color(0xff613C2A),
              borderRadius: BorderRadius.circular(45),
              border: Border.all(color: Color(0xff613C2A), width: 2.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
              child: BottomNavigationBar(
                iconSize: 25,
                currentIndex: currentIndex,
                onTap: (newIndex) {
                  setState(() {
                    currentIndex = newIndex;
                    _tabController.animateTo(newIndex);
                  });
                },
                selectedItemColor: Color(0xffF9A825), // 선택된 아이콘 색상
                unselectedItemColor: Color(0xff613C2A), // 선택되지 않은 아이콘 색상
                showSelectedLabels: false, // 선택된 항목 label 숨기기
                showUnselectedLabels: false, // 선택되지 않은 항목 label 숨기기
                type: BottomNavigationBarType.fixed, // 선택시 아이콘 움직이지 않기
                backgroundColor: Color(0xffF9E9C8),
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.leaderboard),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: "",
                  ),
                ],
              ),
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
    return Scaffold(backgroundColor: Color(0xfffff9c4));
  }
}

// 개발자들에게 후원/피드백
/*
Scaffold(
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
*/

/*
bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
              child: BottomNavigationBar(
                iconSize: 25,
                currentIndex: currentIndex,
                onTap: (newIndex) {
                  setState(() {
                    currentIndex = newIndex;
                  });
                },
                selectedItemColor: Color(0xff008EFF), // 선택된 아이콘 색상
                unselectedItemColor: Colors.white, // 선택되지 않은 아이콘 색상
                showSelectedLabels: false, // 선택된 항목 label 숨기기
                showUnselectedLabels: false, // 선택되지 않은 항목 label 숨기기
                type: BottomNavigationBarType.fixed, // 선택시 아이콘 움직이지 않기
                backgroundColor: Colors.black,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.leaderboard),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: "",
                  ),
                ],
              ),
            ),
          ),
        ),
*/
