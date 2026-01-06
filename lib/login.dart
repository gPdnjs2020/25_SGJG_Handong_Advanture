import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'handong_theme.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
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

  // 언어 설정 아이콘 SVG
  static const String _langIconSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 30 30" fill="none">
<path opacity="0.6" d="M26.4643 24.673C26.471 24.6629 26.481 24.6529 26.4877 24.6429C28.6808 22.0346 30 18.673 30 15C30 11.327 28.6808 7.9654 26.4911 5.35714C26.4844 5.3471 26.4743 5.3404 26.4676 5.33036C26.4308 5.28683 26.3973 5.24665 26.3605 5.20647C26.3471 5.18973 26.3337 5.17634 26.3203 5.1596L26.183 5.00223L26.1797 4.99888C26.1295 4.94196 26.0759 4.88504 26.0257 4.82812L26.0223 4.82478C25.9152 4.71094 25.808 4.5971 25.6975 4.48661L25.6942 4.48326L25.5335 4.32254L25.5234 4.3125C25.4732 4.26228 25.423 4.2154 25.3728 4.16853C25.356 4.15179 25.3393 4.13504 25.3192 4.1183C25.2857 4.08482 25.2522 4.05469 25.2188 4.02455C25.2087 4.01451 25.1953 4.00446 25.1853 3.99107C22.5134 1.51339 18.9342 0 15 0C11.0658 0 7.48661 1.51339 4.81138 3.99107C4.80134 4.00112 4.78795 4.01116 4.7779 4.02455C4.74442 4.05469 4.71094 4.08817 4.67745 4.12165C4.66071 4.13839 4.64397 4.15513 4.62388 4.17188C4.57366 4.21875 4.52344 4.26897 4.47321 4.31585L4.46317 4.32589L4.30246 4.48661L4.29911 4.48996C4.18862 4.60045 4.08147 4.71429 3.97433 4.82812L3.97098 4.83147C3.91741 4.88839 3.86719 4.94531 3.81696 5.00223L3.81362 5.00558C3.76674 5.0558 3.71987 5.10937 3.67634 5.16295C3.66295 5.17969 3.64955 5.19308 3.63616 5.20982C3.59933 5.25 3.56585 5.29353 3.52902 5.33371C3.52232 5.34375 3.51228 5.35045 3.50558 5.36049C1.3192 7.9654 0 11.327 0 15C0 18.673 1.3192 22.0346 3.50893 24.6429C3.51562 24.6529 3.52567 24.6629 3.53237 24.673L3.63616 24.7969C3.64955 24.8136 3.66295 24.827 3.67634 24.8438L3.81362 25.0011C3.81362 25.0045 3.81696 25.0045 3.81696 25.0078C3.86719 25.0647 3.91741 25.1217 3.97098 25.1752L3.97433 25.1786C4.08147 25.2924 4.18862 25.4062 4.29576 25.5167L4.29911 25.5201C4.35268 25.5737 4.4029 25.6272 4.45647 25.6775L4.46652 25.6875C4.57701 25.798 4.69085 25.9051 4.80469 26.0089C7.48661 28.4866 11.0658 30 15 30C18.9342 30 22.5134 28.4866 25.1886 26.0089C25.3027 25.9044 25.4143 25.7972 25.5234 25.6875L25.5335 25.6775C25.5871 25.6239 25.6406 25.5737 25.6908 25.5201L25.6942 25.5167C25.8047 25.4062 25.9118 25.2924 26.0156 25.1786L26.019 25.1752C26.0692 25.1183 26.1228 25.0647 26.173 25.0078C26.173 25.0045 26.1763 25.0045 26.1763 25.0011C26.2232 24.9509 26.2701 24.8973 26.3136 24.8438C26.327 24.827 26.3404 24.8136 26.3538 24.7969C26.3917 24.7565 26.4285 24.7152 26.4643 24.673ZM26.6016 19.8984C26.1395 20.99 25.5301 22.0011 24.7868 22.9185C23.9497 22.195 23.0344 21.5673 22.058 21.0469C22.4464 19.4766 22.6875 17.7522 22.7511 15.9375H27.5558C27.4554 17.3069 27.1339 18.6362 26.6016 19.8984ZM27.5558 14.0625H22.7511C22.6875 12.2478 22.4464 10.5234 22.058 8.95312C23.0391 8.4308 23.9531 7.80134 24.7868 7.08147C26.4026 9.07023 27.3691 11.5069 27.5558 14.0625ZM19.8984 3.39844C21.2277 3.96094 22.4364 4.73772 23.5011 5.7154C22.8826 6.24206 22.2168 6.71056 21.5123 7.11495C20.9866 5.60826 20.3136 4.29911 19.5301 3.25112C19.654 3.29799 19.7779 3.34821 19.8984 3.39844ZM16.865 26.856C16.5569 27.0971 16.2489 27.2812 15.9375 27.4051V21.1942C17.266 21.2869 18.5725 21.5827 19.8114 22.0714C19.5335 22.8951 19.2121 23.6551 18.8404 24.3415C18.2578 25.4263 17.5748 26.2935 16.865 26.856ZM18.8404 5.65848C19.2087 6.34821 19.5335 7.10826 19.8114 7.92857C18.5725 8.41727 17.266 8.71311 15.9375 8.8058V2.59821C16.2455 2.7221 16.5569 2.9029 16.865 3.14732C17.5748 3.70647 18.2578 4.57366 18.8404 5.65848ZM15.9375 19.3158V15.9375H20.8761C20.8225 17.4174 20.6384 18.8538 20.3304 20.2165L20.3203 20.2567C18.9152 19.7238 17.4375 19.4066 15.9375 19.3158ZM15.9375 14.0625V10.6842C17.471 10.5904 18.9442 10.2656 20.3203 9.7433L20.3304 9.78348C20.6384 11.1462 20.8225 12.5792 20.8761 14.0625H15.9375ZM14.0625 15.9375V19.3158C12.529 19.4096 11.0558 19.7344 9.67969 20.2567L9.66964 20.2165C9.36161 18.8538 9.17745 17.4208 9.12388 15.9375H14.0625ZM9.12388 14.0625C9.17745 12.5826 9.36161 11.1462 9.66964 9.78348L9.67969 9.7433C11.0558 10.2656 12.5257 10.5904 14.0625 10.6842V14.0625H9.12388ZM14.0625 21.1942V27.4018C13.7545 27.2779 13.4431 27.0971 13.135 26.8527C12.4252 26.2935 11.7388 25.423 11.1562 24.3382C10.7879 23.6484 10.4632 22.8884 10.1853 22.0681C11.4308 21.5792 12.7266 21.2879 14.0625 21.1942ZM14.0625 8.8058C12.734 8.71311 11.4275 8.41727 10.1886 7.92857C10.4665 7.10491 10.7879 6.34487 11.1596 5.65848C11.7422 4.57366 12.4252 3.70312 13.1384 3.14397C13.4464 2.9029 13.7545 2.71875 14.0658 2.59487V8.8058H14.0625ZM10.1016 3.39844C10.2254 3.34821 10.346 3.29799 10.4699 3.25112C9.68638 4.29911 9.01339 5.60826 8.48772 7.11495C7.7846 6.71317 7.1183 6.24442 6.49888 5.7154C7.56362 4.73772 8.77232 3.96094 10.1016 3.39844ZM3.39844 10.1016C3.86049 9.01005 4.46987 7.99888 5.21317 7.08147C6.04687 7.80134 6.96094 8.4308 7.94196 8.95312C7.55357 10.5234 7.3125 12.2478 7.24888 14.0625H2.4442C2.54464 12.6931 2.86607 11.3638 3.39844 10.1016ZM2.4442 15.9375H7.24888C7.3125 17.7522 7.55357 19.4766 7.94196 21.0469C6.96555 21.5673 6.05028 22.195 5.21317 22.9185C3.59742 20.9298 2.63092 18.4931 2.4442 15.9375ZM10.1016 26.6016C8.77232 26.0391 7.56362 25.2623 6.49888 24.2846C7.1183 23.7556 7.7846 23.2902 8.48772 22.885C9.01339 24.3917 9.68638 25.7009 10.4699 26.7489C10.346 26.702 10.2221 26.6518 10.1016 26.6016ZM19.8984 26.6016C19.7746 26.6518 19.654 26.702 19.5301 26.7489C20.3136 25.7009 20.9866 24.3917 21.5123 22.885C22.2154 23.2868 22.8817 23.7556 23.5011 24.2846C22.4423 25.2582 21.2236 26.042 19.8984 26.6016Z" fill="#F9A825"/>
</svg>
''';

  Future<void> _login() async {
    if (_idController.text.isEmpty || _pwController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('학번과 비밀번호를 모두 입력해주세요.')));
      }
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: '${_idController.text.trim()}@handong.edu',
        password: _pwController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? '로그인 실패')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 입력 필드 빌더 (286x72, Border 4px, Shadow)
  Widget _buildInputField({
    required TextEditingController controller,
    required bool obscureText,
    required String hintText,
  }) {
    return Container(
      width: 286,
      height: 72,
      decoration: BoxDecoration(
        color: HandongColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HandongColors.brownBorder,
          width: 4,
        ), // Border 4px
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          // 입력 글씨 색상 고정: HandongColors.textOrangeBody (#FDBA74)
          style: HandongTextStyles.inputText.copyWith(
            height: 1.2,
            color: HandongColors.textOrangeBody,
          ),
          textAlign: TextAlign.center,
          keyboardType: obscureText ? TextInputType.text : TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none, // TextField 자체 테두리 제거 (상자 두개 방지)
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            hintText: hintText, // 힌트 텍스트 (학번 적어줘!, 비밀번호 쉿!)
            hintStyle: HandongTextStyles.inputHint.copyWith(height: 1.2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 상대 좌표 계산을 위한 기준점 (박스 시작 위치)
    // Box Top: 61, Box Left: 24 (from design)

    return Scaffold(
      backgroundColor: HandongColors.yellowBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            // 전체 화면 크기 확보 (디자인 기준 412x917 비율 유지 노력)
            width: 412,
            height: 917,
            child: Stack(
              children: [
                // 1. 노란색 박스 (Main Container)
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
                    // 박스 내부 Stack
                    child: Stack(
                      children: [
                        // 언어 설정 버튼 (Top: 22 relative to box, Left: 20 padding)
                        // XML에는 좌표가 명확치 않으나, SignUp 텍스트(Top 22)와 대칭되게 배치
                        Positioned(
                          top: 22,
                          left: 24,
                          child: SvgPicture.string(
                            _langIconSvg,
                            width: 30,
                            height: 30,
                          ),
                        ),

                        // "혹시 처음이야?" (SignUp Link)
                        // Using Right alignment for better responsiveness and to avoid clipping
                        Positioned(
                          top: 22,
                          right: 20, // Adjusted padding from right
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: Text(
                              '혹시 처음이야?',
                              style: HandongTextStyles.signupLink.copyWith(
                                height: 1.2,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),

                        // 로고
                        // XML: Left 157 (screen) -> 133 (box)
                        // XML: Top 222 (screen) -> 161 (box)
                        Positioned(
                          top: 161,
                          left: 133,
                          child: SvgPicture.string(
                            _logoSvg,
                            width: 98.56,
                            height: 99.07,
                          ),
                        ),

                        // 타이틀 "한동 어드벤처"
                        // XML: Left 94 (screen) -> 70 (box)
                        // XML: Top 343 (screen) -> 282 (box)
                        Positioned(
                          top: 282,
                          left: 70,
                          child: SizedBox(
                            width: 225,
                            child: Text(
                              '한동 어드벤처',
                              style: HandongTextStyles.title.copyWith(
                                height: 1.2,
                              ), // height 조정
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        // 서브타이틀 "새내기 어서와!"
                        // Center alignment within the box
                        Positioned(
                          top: 318,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              '새내기 어서와!',
                              style: HandongTextStyles.subtitle.copyWith(
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        // 학번 입력 박스
                        // XML: Left 63 (screen) -> 39 (box)
                        // XML: Top 459 (screen) -> 398 (box)
                        Positioned(
                          top: 398,
                          left: 39,
                          child: _buildInputField(
                            controller: _idController,
                            obscureText: false,
                            hintText: '학번 적어줘!',
                          ),
                        ),

                        // 비밀번호 입력 박스
                        // XML: Left 63 -> 39 (box)
                        // XML: Top 556 -> 495 (box)
                        Positioned(
                          top: 495,
                          left: 39,
                          child: _buildInputField(
                            controller: _pwController,
                            obscureText: true,
                            hintText: '비밀번호 쉿!',
                          ),
                        ),

                        // 입력 완료 버튼
                        // XML: Left 63 -> 39 (box)
                        // XML: Top 668 -> 607 (box)
                        Positioned(
                          top: 607,
                          left: 39,
                          // InkWell을 사용하여 클릭 효과 및 동작 보장
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isLoading ? null : _login,
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
                                        '출발하기!',
                                        style: HandongTextStyles.buttonText
                                            .copyWith(height: 1.2),
                                      ),
                              ),
                            ),
                          ),
                        ),

                        // 비밀번호 찾기
                        // Center alignment within the box
                        Positioned(
                          top: 746,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                // 비밀번호 찾기 로직
                              },
                              child: Text(
                                '비밀번호 찾아줄게!',
                                style: HandongTextStyles.smallLink.copyWith(
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
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
