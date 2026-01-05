import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final pw = _pwController.text.trim();
    final pwConfirm = _pwConfirmController.text.trim();

    print('--- 회원가입 시도 시작 ---'); // 로그 1
    print('입력된 정보: $id, $name');

    if (id.isEmpty || name.isEmpty || pw.isEmpty || pwConfirm.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 정보를 입력해주세요.')));
      return;
    }

    if (pw != pwConfirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }

    if (pw.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호는 6자리 이상이어야 합니다.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Auth 계정 생성 시도
      print('1. Firebase Auth 계정 생성 요청 중...');
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: '$id@handong.edu',
            password: pw,
          );
      print('>>> Auth 계정 생성 성공! UID: ${userCredential.user!.uid}');

      // 2. Firestore 저장 시도
      print('2. Firestore DB 저장 요청 중...');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'studentId': id,
            'name': name,
            'createdAt': DateTime.now().toIso8601String(), // 날짜 포맷 안전하게 변경
            'score': 0,
            'level': 1,
          });
      print('>>> Firestore 저장 성공!');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('회원가입 성공! 로그인되었습니다.')));
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // Auth 관련 에러 (비밀번호 약함, 이미 있는 아이디 등)
      print('!!! Auth 에러 발생: Code=${e.code}, Message=${e.message}');

      String message = '회원가입 실패: ${e.message}';
      if (e.code == 'weak-password') {
        message = '비밀번호가 너무 약합니다.';
      } else if (e.code == 'email-already-in-use') {
        message = '이미 가입된 학번입니다.';
      } else if (e.code == 'operation-not-allowed') {
        message = '이메일/비밀번호 로그인이 비활성화되어 있습니다. 콘솔 설정을 확인하세요.';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } on FirebaseException catch (e) {
      // Firestore 관련 에러 (권한 없음 등)
      print('!!! Firestore DB 에러 발생: Code=${e.code}, Message=${e.message}');

      String message = 'DB 저장 실패: ${e.message}';
      if (e.code == 'permission-denied') {
        message = '데이터베이스 권한이 없습니다. (Firestore 규칙을 확인하세요)';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      // 기타 알 수 없는 에러
      print('!!! 알 수 없는 에러 발생: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('알 수 없는 오류: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('--- 회원가입 시도 종료 ---');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '한동 어드벤처에\n오신 것을 환영합니다!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003E7E),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '학번 (8자리)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름 (닉네임)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pwController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호 (6자리 이상)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pwConfirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_clock),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003E7E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      '가입하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
