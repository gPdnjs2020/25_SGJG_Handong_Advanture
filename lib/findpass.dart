import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'handong_theme.dart';

class FindPassPage extends StatefulWidget {
  const FindPassPage({super.key});

  @override
  State<FindPassPage> createState() => _FindPassPageState();
}

class _FindPassPageState extends State<FindPassPage> {
  final _idController = TextEditingController();
  bool _isLoading = false;

  // 로고 SVG
  static const String _logoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="99" height="100" viewBox="0 0 99 100" fill="none">
  <path d="M32.1024 11.8222C32.3388 10.376 33.9989 9.66661 35.2075 10.4955L58.9171 26.7566C60.2179 27.6487 60.0222 29.6253 58.5717 30.2451L30.2248 42.3576C28.7743 42.9774 27.2107 41.7526 27.4652 40.1959L32.1024 11.8222Z" fill="#F9A825"/>
  <path d="M31.7226 87.3192C31.9589 88.7654 33.6191 89.4748 34.8276 88.6459L58.5372 72.3848C59.838 71.4927 59.6423 69.5161 58.1918 68.8963L29.845 56.7838C28.3945 56.164 26.8309 57.3888 27.0853 58.9455L31.7226 87.3192Z" fill="#F9A825"/>
  <path d="M10.4214 34.8291C9.5923 33.6208 10.3013 31.9605 11.7475 31.7238L40.12 27.0798C41.6767 26.825 42.9019 28.3883 42.2824 29.8389L30.1766 58.1887C29.5571 59.6393 27.5806 59.8355 26.6882 58.5349L10.4214 34.8291Z" fill="#F9A825"/>
  <path d="M11.8014 66.5143C10.3546 66.2814 9.64128 64.6229 10.4673 63.4125L26.6725 39.6646C27.5616 38.3617 29.5386 38.5527 30.1618 40.0018L42.3411 68.3201C42.9643 69.7691 41.7432 71.3356 40.1859 71.0848L11.8014 66.5143Z" fill="#F9A825"/>
  <path d="M66.4557 11.7524C66.2193 10.3062 64.5592 9.59679 63.3507 10.4256L39.641 26.6867C38.3402 27.5789 38.5359 29.5554 39.9864 30.1752L68.3333 42.2878C69.7838 42.9076 71.3474 41.6828 71.0929 40.1261L66.4557 11.7524Z" fill="#F9A825"/>
  <path d="M66.8355 87.2493C66.5992 88.6956 64.939 89.405 63.7305 88.5761L40.0209 72.315C38.7201 71.4228 38.9158 69.4463 40.3663 68.8265L68.7131 56.7139C70.1636 56.0942 71.7272 57.319 71.4728 58.8757L66.8355 87.2493Z" fill="#F9A825"/>
  <path d="M88.1367 34.7593C88.9658 33.551 88.2568 31.8907 86.8106 31.654L58.4381 27.01C56.8814 26.7552 55.6563 28.3185 56.2757 29.7691L68.3815 58.1189C69.001 59.5695 70.9775 59.7657 71.8699 58.465L88.1367 34.7593Z" fill="#F9A825"/>
  <path d="M86.7567 66.4445C88.2035 66.2116 88.9168 64.5531 88.0908 63.3426L71.8856 39.5948C70.9965 38.2919 69.0195 38.4829 68.3963 39.932L56.217 68.2502C55.5938 69.6993 56.8149 71.2657 58.3722 71.015L86.7567 66.4445Z" fill="#F9A825"/>
  <circle cx="49" cy="49" r="20" fill="white"/>
  <circle cx="42.5" cy="46.5" r="2.5" fill="#F9A825"/>
  <circle cx="55.5" cy="46.5" r="2.5" fill="#F9A825"/>
</svg>
''';

  Future<void> _sendPasswordResetEmail() async {
    if (_idController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('학번을 입력해주세요.')));
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: '${_idController.text.trim()}@handong.edu',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('학교 이메일로 비밀번호 재설정 링크를 보냈어요!')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = '이메일 전송 실패';
      if (e.code == 'user-not-found') {
        message = '가입되지 않은 학번이에요.';
      } else if (e.code == 'invalid-email') {
        message = '학번 형식이 올바르지 않아요.';
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      width: 286,
      height: 72,
      decoration: BoxDecoration(
        color: HandongColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HandongColors.brownBorder, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        style: HandongTextStyles.inputText.copyWith(
          fontSize: 18,
          color: HandongColors.textOrangeBody,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: HandongTextStyles.inputHint.copyWith(
            fontSize: 18,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HandongColors.yellowBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 412,
            height: 917,
            child: Stack(
              children: [
                // 메인 카드
                Positioned(
                  top: 61,
                  left: 24,
                  child: Container(
                    width: 364,
                    height: 856,
                    decoration: BoxDecoration(
                      color: HandongColors.yellowCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // 로고
                        Positioned(
                          top: 161,
                          left: 133,
                          child: SvgPicture.string(
                            _logoSvg,
                            width: 98.56,
                            height: 99.07,
                          ),
                        ),

                        // 타이틀
                        Positioned(
                          top: 282,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              '비밀번호 찾기',
                              style: HandongTextStyles.title.copyWith(
                                fontSize: 38,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        // 서브타이틀
                        Positioned(
                          top: 322,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              '학번을 알려줘!',
                              style: HandongTextStyles.subtitle.copyWith(
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        // 학번 입력
                        Positioned(
                          top: 400,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _buildInputField(
                              controller: _idController,
                              hintText: '학번 입력',
                            ),
                          ),
                        ),

                        // 전송 버튼
                        Positioned(
                          top: 520,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _isLoading
                                    ? null
                                    : _sendPasswordResetEmail,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 286,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: HandongColors.bluePoint,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          '전송하기!',
                                          style: HandongTextStyles.buttonText
                                              .copyWith(
                                                fontSize: 28,
                                                height: 1.2,
                                              ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 안내 문구
                        Positioned(
                          top: 620,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              '학교 이메일로 링크를 보내줄게!',
                              style: HandongTextStyles.smallLink.copyWith(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 뒤로가기 버튼
                Positioned(
                  top: 120,
                  left: 49,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 12.1,
                      height: 22,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: HandongColors.textGold,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
