import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handong_adventure/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isLoading = false; // 로딩 상태 표시용

  // 로그인 처리 함수
  Future<void> _tryLogin() async {
    final inputId = _idController.text.trim();
    final inputPw = _pwController.text.trim();

    if (inputId.isEmpty || inputPw.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('학번과 비밀번호를 모두 입력해주세요.')));
      return;
    }

    setState(() {
      _isLoading = true; // 로딩 시작
    });

    try {
      // Firebase Auth 로그인 시도
      // 학번만 입력받지만, Firebase는 이메일 형식이 필요하므로 뒤에 가짜 도메인을 붙임
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: '$inputId@handong.edu',
        password: inputPw,
      );

      // 성공 시 StreamBuilder가 감지하여 자동으로 메인 페이지로 넘어갑니다.
      // 따라서 별도의 Navigator 코드가 필요 없습니다.
    } on FirebaseAuthException catch (e) {
      String message = '로그인에 실패했습니다.';
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        message = '존재하지 않는 학번이거나 비밀번호가 틀렸습니다.';
      } else if (e.code == 'invalid-email') {
        message = '학번 형식이 올바르지 않습니다.';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // 로딩 종료
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.school, size: 80, color: Color(0xFF003E7E)),
            const SizedBox(height: 16),
            const Text(
              'HANDONG\nADVENTURE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003E7E),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 40),

            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '학번 (Student ID)',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pwController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호 (Password)',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // 로그인 버튼 (로딩 중이면 뺑글이 표시)
            ElevatedButton(
              onPressed: _isLoading ? null : _tryLogin,
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
                      'START',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('처음 오셨나요? 회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
