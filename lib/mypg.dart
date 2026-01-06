import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_adventure/main.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            '마이페이지',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: kTextBlack,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: kCardYellow,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kInputBorder, width: 2),
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
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kTextBlack, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: kBgYellow,
                          child: Icon(
                            Icons.person,
                            size: 36,
                            color: kTextBlack,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.email?.split('@')[0] ?? 'User',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: kTextBlack,
                              ),
                            ),
                            const Text(
                              'Handong Student',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildMenuTile(Icons.history, '활동 내역'),
                const SizedBox(height: 12),
                _buildMenuTile(Icons.settings, '설정'),
                const SizedBox(height: 12),
                _buildMenuTile(Icons.help_outline, '도움말'),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  icon: const Icon(Icons.logout, color: Colors.grey),
                  label: const Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title) {
    return ListTile(
      tileColor: kWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kInputBorder, width: 2),
      ),
      leading: Icon(icon, color: kTextBlack, size: 26),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: kTextBlack,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
        size: 26,
      ),
    );
  }
}
