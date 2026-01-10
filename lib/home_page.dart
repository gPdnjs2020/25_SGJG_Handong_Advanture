import 'package:flutter/material.dart';

import 'main.dart';
import 'quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 중앙
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
                  // 사용자 프로필
                  SizedBox(height: 10),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 테두리
                      Container(
                        width: 279,
                        height: 283,
                        decoration: BoxDecoration(
                          color: Color(0xffF9E9C8),
                          border: Border.all(
                            color: Color(0xff613C2A),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: ClipOval(
                                child: profileImage != null
                                    ? Image.file(
                                        profileImage!,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover, // 사진이 찌그러지지 않게 꽉 채움
                                      )
                                    : Image.asset(
                                        'assets/user_profile.png',
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.account_circle,
                                                  size: 150, // 부모 사이즈에 맞게 조절
                                                ),
                                      ),
                              ),
                            ),
                            // 사용자 이름
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // 사용자 레벨
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                    child: imageLevel[level - 1],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'LV.$level',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            // 레벨 진행도
                            SizedBox(
                              width: 131,
                              child: LinearProgressIndicator(
                                value: userProgress,
                                backgroundColor: Color(0xff003E7E),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xffF9A825),
                                ),
                                minHeight: 7,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '$userPoint/$pointMax',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // 퀴즈
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 테두리
                      Container(
                        width: 339,
                        height: 278,
                        decoration: BoxDecoration(
                          color: Color(0xffF9E9C8),
                          border: Border.all(
                            color: Color(0xff613C2A),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  color: Color(0xffF9E9C8),
                                  child: Text(
                                    "Quiz!",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // 새내기 버튼
                              Container(
                                width: 287,
                                height: 50,
                                margin: EdgeInsets.all(0),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Quiz1(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xff2EC4B6),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 12),
                                      Text(
                                        '새내기',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      SizedBox(width: 160),
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: imageLevel[0],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              // 헌내기 버튼
                              Container(
                                width: 287,
                                height: 50,
                                margin: EdgeInsets.all(0),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Quiz2(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xffF9A825),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 12),
                                      Text(
                                        '헌내기',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      SizedBox(width: 160),
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: imageLevel[1],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              // 고인물 튼
                              Container(
                                width: 287,
                                height: 50,
                                margin: EdgeInsets.all(0),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Quiz3(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xff003E7E),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 12),
                                      Text(
                                        '고인물',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      SizedBox(width: 160),
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: imageLevel[2],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
