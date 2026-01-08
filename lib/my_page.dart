import 'package:flutter/material.dart';

import 'main.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff9c4),
      body: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  // 언어 변경
                  Positioned(
                    left: 290,
                    child: IconButton(
                      onPressed: (/*언어 설정*/) {},
                      icon: Icon(
                        Icons.language,
                        size: 30,
                        color: Color(0xffF9A825),
                      ),
                    ),
                  ),
                  // 개인 정보 변경
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 279,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color(0xffF9E9C8),
                          border: Border.all(
                            color: Color(0xff613C2A),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/user_profile.png',
                                  height: 90,
                                  width: 90,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.account_circle,
                                        size: 90,
                                      ),
                                  alignment: Alignment.topRight,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: (/*정보 수정*/) {},
                                  icon: Icon(Icons.settings),
                                  alignment: Alignment.topRight,
                                ),
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  'LV.$level $studentNumber',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 랭킹
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(35, 5, 0, 0),
                            width: 64,
                            height: 49,
                            decoration: BoxDecoration(
                              color: Color(0xffF9E9C8),
                              border: Border.all(
                                color: Color(0xff613C2A),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipOval(
                              child: Center(
                                child: Text(
                                  '랭킹',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                            width: 209,
                            height: 49,
                            decoration: BoxDecoration(
                              color: Color(0xffF9E9C8),
                              border: Border.all(
                                color: Color(0xff613C2A),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipOval(
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      '전체 랭킹              레벨 랭킹              현재 점수      ',
                                      style: TextStyle(
                                        fontSize: 6,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '$wholeRank등      $levelRank등      $userPoint등',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  Text(
                    '개발자 훈수두기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '0000000.hangdong.ac.kr',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF9A825),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70),
                  Container(
                    width: 277,
                    height: 50,
                    child: TextButton(
                      onPressed: (/*로그아웃시키기*/) {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xffFF4242),
                        side: const BorderSide(color: Colors.black, width: 2.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
