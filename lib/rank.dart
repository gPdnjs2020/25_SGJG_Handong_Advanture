import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'handong_theme.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  // 내 정보 가져오기
  Future<Map<String, dynamic>> _getMyData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!userDoc.exists) return {};
    final myData = userDoc.data()!;
    final myScore = myData['score'] ?? 0;

    // 내 순위 계산
    final higherDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('score', isGreaterThan: myScore)
        .count()
        .get();

    return {
      'rank': higherDocs.count! + 1,
      'name': myData['name'] ?? '나',
      'score': myScore,
      'level': myData['level'] ?? 1,
      'studentId': myData['studentId'] ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF176),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: 412,
            height: 917, // 전체 디자인 높이 고정
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Color(0xFFFFF176)),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _getMyData(),
              builder: (context, mySnapshot) {
                final myData = mySnapshot.data;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('score', descending: true)
                      .limit(50)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs ?? [];
                    final Map<String, dynamic>? rank1 = docs.length > 0
                        ? docs[0].data() as Map<String, dynamic>
                        : null;
                    final Map<String, dynamic>? rank2 = docs.length > 1
                        ? docs[1].data() as Map<String, dynamic>
                        : null;
                    final Map<String, dynamic>? rank3 = docs.length > 2
                        ? docs[2].data() as Map<String, dynamic>
                        : null;

                    return Stack(
                      children: [
                        // 1. 메인 배경 박스 (연노랑) - Top 61
                        Positioned(
                          left: 24,
                          top: 61,
                          child: Container(
                            width: 364,
                            height: 856,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFFF9C4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),

                        // ==================== 헤더 ====================
                        Positioned(
                          left: 78,
                          top: 109,
                          child: Text(
                            '한동 어드벤처',
                            style: GoogleFonts.gaegu(
                              color: const Color(0xFF1F2933),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        // 장식용 점 3개
                        Positioned(
                          left: 38.71,
                          top: 107.71,
                          child: _buildDot(20.29, Colors.white),
                        ),
                        Positioned(
                          left: 44.29,
                          top: 115.32,
                          child: _buildDot(2.54, HandongColors.textGold),
                        ),
                        Positioned(
                          left: 50.89,
                          top: 115.32,
                          child: _buildDot(2.54, HandongColors.textGold),
                        ),
                        // 장식용 막대
                        Positioned(
                          left: 43.28,
                          top: 119.38,
                          child: Container(
                            width: 10.65,
                            height: 5.07,
                            decoration: BoxDecoration(
                              color: HandongColors.textGold,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Rank! 타이틀
                        Positioned(
                          left: 285,
                          top: 100,
                          child: Text(
                            'Rank!',
                            style: HandongTextStyles.title.copyWith(
                              fontSize: 32,
                            ),
                          ),
                        ),

                        // 로그아웃 버튼 (우측 상단 추가)
                        Positioned(
                          right: 40,
                          top: 80,
                          child: IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Color(0xFF613C2A),
                            ),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                            },
                          ),
                        ),

                        // ==================== 내 정보 섹션 (상단 카드) ====================
                        // 내 정보 박스 배경 (279x280) - Top 241
                        Positioned(
                          left: 68,
                          top: 241,
                          child: Container(
                            width: 279,
                            height: 280,
                            decoration: ShapeDecoration(
                              color: HandongColors.yellowBg,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: HandongColors.greyBorder,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        // 프로필 영역 (주황색 박스) - Top 249
                        Positioned(
                          left: 73.83,
                          top: 249,
                          child: Container(
                            width: 268.17,
                            height: 164,
                            decoration: ShapeDecoration(
                              color: HandongColors.rankMyBg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            // ★ 프로필 사진 왼쪽 배치 (Alignment.centerLeft 사용) ★
                            child: Align(
                              alignment: const Alignment(
                                -0.8,
                                0.0,
                              ), // 약간 왼쪽으로 치우치게
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.brown.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),

                        // 내 닉네임
                        Positioned(
                          left: 209,
                          top: 311,
                          child: SizedBox(
                            width: 134,
                            child: Text(
                              myData?['name'] ?? 'Nick name',
                              style: HandongTextStyles.rankNickname,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        // 내 레벨
                        Positioned(
                          left: 209,
                          top: 358,
                          child: Text(
                            'LV.${myData?['level'] ?? 1}',
                            style: HandongTextStyles.rankNickname.copyWith(
                              fontSize: 24,
                              color: HandongColors.textGold,
                            ),
                          ),
                        ),
                        // 내 점수
                        Positioned(
                          left: 270,
                          top: 357,
                          child: Text(
                            '${myData?['score'] ?? 0}점',
                            style: HandongTextStyles.rankNickname.copyWith(
                              fontSize: 24,
                              color: HandongColors.textGold,
                            ),
                          ),
                        ),

                        // ==================== 통계 텍스트 ====================
                        // 통계 박스 테두리 (아래쪽) - Top 420
                        Positioned(
                          left: 68,
                          top: 420,
                          child: Container(
                            width: 279,
                            height: 101,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: HandongColors.greyBorder,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 구분선들
                        Positioned(
                          left: 84.66,
                          top: 455,
                          child: Container(
                            width: 245.69,
                            height: 1,
                            color: HandongColors.greyBorder,
                          ),
                        ),
                        Positioned(
                          left: 84.66,
                          top: 485,
                          child: Container(
                            width: 245.69,
                            height: 1,
                            color: HandongColors.greyBorder,
                          ),
                        ),

                        // 전체 랭킹
                        Positioned(
                          left: 85,
                          top: 431,
                          child: SizedBox(
                            width: 244,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '전체 랭킹',
                                  style: HandongTextStyles.rankInfo.copyWith(
                                    fontSize: 12,
                                    color: HandongColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${myData?['rank'] ?? '-'}등',
                                  style: HandongTextStyles.rankInfo,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 레벨 랭킹
                        Positioned(
                          left: 85,
                          top: 462,
                          child: SizedBox(
                            width: 244,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '레벨 랭킹',
                                  style: HandongTextStyles.rankInfo.copyWith(
                                    fontSize: 12,
                                    color: HandongColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${myData?['rank'] ?? '-'}등',
                                  style: HandongTextStyles.rankInfo,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 현재 점수
                        Positioned(
                          left: 85,
                          top: 491,
                          child: SizedBox(
                            width: 244,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '현재 점수',
                                  style: HandongTextStyles.rankInfo.copyWith(
                                    fontSize: 12,
                                    color: HandongColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${myData?['score'] ?? 0}점',
                                  style: HandongTextStyles.rankInfo,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ==================== 랭킹 리스트 (1위부터 표시) ====================
                        // 리스트 시작 위치 (Top 545)
                        Positioned(
                          top: 545,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: ListView.builder(
                            // 하단 바(59px) + 여유 공간 확보하여 글씨가 회색 선 위에 뜨도록 함
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data =
                                  docs[index].data() as Map<String, dynamic>;
                              final int rank = index + 1;

                              // ★ 1위도 건너뛰지 않고 표시함 ★

                              // 색상 지정
                              Color rankColor = HandongColors.rankMyBg; // 4등 이후
                              if (rank == 1)
                                rankColor = HandongColors.rank1Bg; // 1등
                              else if (rank == 2)
                                rankColor = HandongColors.rank2Bg; // 2등
                              else if (rank == 3)
                                rankColor = HandongColors.rank3Bg; // 3등

                              return Center(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: _buildRankItem(
                                    rank: '$rank',
                                    name: data['name'] ?? 'Unknown',
                                    score: data['score'] ?? 0,
                                    level: data['level'] ?? 1,
                                    color: rankColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // 하단 회색 선 (네비게이션 바) - Top 858
                        Positioned(
                          left: 0,
                          top: 858,
                          child: Container(
                            width: 412,
                            height: 59,
                            color: const Color(0xFF818181),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildNavItem(Icons.map_rounded, '홈', false),
                                _buildNavItem(
                                  Icons.emoji_events_rounded,
                                  '랭킹',
                                  true,
                                ), // 현재 랭킹 페이지이므로 선택됨
                                _buildNavItem(
                                  Icons.person_rounded,
                                  'MY',
                                  false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(color: color, shape: const OvalBorder()),
    );
  }

  // 하단 내비게이션 아이템 빌더
  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    // 선택 여부에 따라 색상/투명도 조절
    final Color itemColor = isSelected
        ? Colors.white
        : Colors.white.withOpacity(0.5);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: itemColor, size: 24),
        Text(
          label,
          style: GoogleFonts.gaegu(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: itemColor,
          ),
        ),
      ],
    );
  }

  // 랭킹 리스트 아이템 빌더
  Widget _buildRankItem({
    required String rank,
    required String name,
    required int score,
    required int level,
    required Color color,
  }) {
    return SizedBox(
      width: 336, // 전체 너비
      height: 75,
      child: Stack(
        children: [
          // 2. 오른쪽 정보 박스 (Nick name, Lv, Score)
          Positioned(
            left: 87,
            top: 0,
            child: Container(
              width: 249,
              height: 75,
              decoration: ShapeDecoration(
                color: rank == '1'
                    ? HandongColors.rankMyBg
                    : HandongColors.rank2Bg.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 2,
                    color: HandongColors.textBrown,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  // Nickname
                  Positioned(
                    left: 20,
                    top: 17,
                    child: Text(
                      name,
                      style: HandongTextStyles.rankListNickname,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // LV & Score
                  Positioned(
                    left: 20,
                    top: 42,
                    child: Row(
                      children: [
                        Text(
                          'LV.$level',
                          style: HandongTextStyles.rankListInfo,
                        ),
                        const SizedBox(width: 22),
                        Text('$score점', style: HandongTextStyles.rankListInfo),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 1. 왼쪽 랭크 박스 (숫자)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 81,
              height: 75,
              decoration: ShapeDecoration(
                color: color,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 2,
                    color: HandongColors.textBrown,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                rank,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
