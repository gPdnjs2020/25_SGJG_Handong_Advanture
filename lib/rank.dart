import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handong_adventure/main.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.emoji_events, color: kTextBlack, size: 30),
              SizedBox(width: 8),
              Text(
                '명예의 전당',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: kTextBlack,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: kCardYellow,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('score', descending: true)
                    .limit(50)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(
                      child: CircularProgressIndicator(color: kTextBlack),
                    );
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty)
                    return const Center(
                      child: Text(
                        '랭킹 데이터가 없습니다',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );

                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return _buildRankItem(index + 1, data);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem(int rank, Map<String, dynamic> data) {
    Color badgeColor = Colors.grey[400]!;
    if (rank == 1)
      badgeColor = kRankGold;
    else if (rank == 2)
      badgeColor = const Color(0xFFC0C0C0);
    else if (rank == 3)
      badgeColor = const Color(0xFFCD7F32);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kInputBorder, width: 2), // SVG border style
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              border: Border.all(color: kInputBorder, width: 1.5),
            ),
            child: Text(
              '$rank',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: kWhite,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'] ?? '알 수 없음',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kTextBlack,
                  ),
                ),
                Text(
                  data['studentId'] ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${data['score'] ?? 0} P',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: kRankGold,
            ),
          ),
        ],
      ),
    );
  }
}
