import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('명예의 전당'),
        backgroundColor: const Color(0xFF003E7E), // 한동 블루
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김 (탭바 사용 시)
      ),
      body: Column(
        children: [
          // 1. 상위 10명 리스트 (실시간 업데이트)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('score', descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                // 데이터 로딩 중
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // 에러 발생
                if (snapshot.hasError) {
                  return const Center(child: Text('랭킹을 불러오지 못했습니다.'));
                }

                final docs = snapshot.data!.docs;

                // 데이터가 없을 때
                if (docs.isEmpty) {
                  return const Center(child: Text('아직 랭킹 데이터가 없습니다.'));
                }

                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final name = data['name'] ?? '익명';
                    final studentId = data['studentId'] ?? '정보없음';
                    final score = data['score'] ?? 0;
                    final rank = index + 1;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      // 등수 아이콘 (1,2,3등은 트로피)
                      leading: _buildRankIcon(rank),
                      title: Text(
                        '$name ($studentId)',
                        style: TextStyle(
                          fontWeight: rank <= 3
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        '$score P',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF003E7E),
                        ),
                      ),
                      // 상위권은 배경색을 살짝 다르게
                      tileColor: rank <= 3 ? Colors.blue[50] : Colors.white,
                    );
                  },
                );
              },
            ),
          ),

          // 2. 내 순위 고정 바 (Bottom Fixed)
          const MyRankSection(),
        ],
      ),
    );
  }

  // 등수에 따른 아이콘 빌더
  Widget _buildRankIcon(int rank) {
    if (rank == 1) {
      return const Icon(
        Icons.emoji_events,
        color: Color(0xFFFFD700),
        size: 32,
      ); // Gold
    } else if (rank == 2) {
      return const Icon(
        Icons.emoji_events,
        color: Color(0xFFC0C0C0),
        size: 32,
      ); // Silver
    } else if (rank == 3) {
      return const Icon(
        Icons.emoji_events,
        color: Color(0xFFCD7F32),
        size: 32,
      ); // Bronze
    } else {
      return Container(
        width: 32,
        alignment: Alignment.center,
        child: Text(
          '$rank',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }
  }
}

// 하단 고정: 나의 랭킹 정보 위젯
class MyRankSection extends StatelessWidget {
  const MyRankSection({super.key});

  // 내 랭킹과 점수를 계산하는 함수
  Future<Map<String, dynamic>> _getMyRankData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    // 1. 내 정보(점수) 가져오기
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) return {};

    final myData = userDoc.data()!;
    final myScore = myData['score'] ?? 0;

    // 2. 나보다 점수 높은 사람 수 세기 (랭킹 계산)
    // Firestore의 count() 기능을 사용하여 효율적으로 계산
    final higherScoreCount = await FirebaseFirestore.instance
        .collection('users')
        .where('score', isGreaterThan: myScore)
        .count()
        .get();

    // 내 등수 = 나보다 점수 높은 사람 수 + 1
    final myRank = higherScoreCount.count! + 1;

    return {
      'rank': myRank,
      'score': myScore,
      'studentId': myData['studentId'] ?? '학번없음',
      'name': myData['name'] ?? '이름없음',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getMyRankData(),
      builder: (context, snapshot) {
        // 데이터 로딩 중이거나 없을 때
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            height: 80,
            color: Colors.grey[100],
            child: const Center(
              child: Text(
                '내 랭킹 정보를 불러오는 중...',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final data = snapshot.data!;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF003E7E), // 한동 블루 배경
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false, // 상단 노치 영역 무시 (하단에 붙을 거라)
            child: Row(
              children: [
                // 내 등수 표시 원
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${data['rank']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF003E7E),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // 이름과 학번
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '나의 순위',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${data['name']} (${data['studentId']})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // 내 점수 (노란색 강조)
                Text(
                  '${data['score']} P',
                  style: const TextStyle(
                    color: Color(0xFFFDB813), // 한동 옐로우 (포인트 컬러)
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
