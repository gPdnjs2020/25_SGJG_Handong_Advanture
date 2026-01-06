import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_adventure/main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwConfirmController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_pwController.text != _pwConfirmController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '${_idController.text.trim()}@handong.edu',
        password: _pwController.text.trim(),
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
            'studentId': _idController.text.trim(),
            'name': _nameController.text.trim(),
            'score': 0,
            'level': 1,
            'createdAt': DateTime.now().toIso8601String(),
          });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('회원가입 실패')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgYellow,
      body: Stack(
        children: [
          Positioned.fill(
            top: 60, // AppBar area
            bottom: 60,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: kCardYellow,
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: kTextBlack),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '환영합니다!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: kTextBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    _buildInput(_idController, '학번', Icons.badge),
                    const SizedBox(height: 16),
                    _buildInput(_nameController, '이름', Icons.face),
                    const SizedBox(height: 16),
                    _buildInput(
                      _pwController,
                      '비밀번호',
                      Icons.lock,
                      obscure: true,
                    ),
                    const SizedBox(height: 16),
                    _buildInput(
                      _pwConfirmController,
                      '비밀번호 확인',
                      Icons.check_circle,
                      obscure: true,
                    ),

                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      child: const Text('가입 완료'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60,
            child: Container(color: kNavGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: hint == '학번' ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: kTextBlack),
        ),
      ),
    );
  }
}
