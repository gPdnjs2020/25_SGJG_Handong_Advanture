import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(height: 100),
                  // 언어 변경
                  Row(
                    children: [
                      SizedBox(width: 280),
                      IconButton(
                        onPressed: () => _showLanguageDialog(), // 언어 팝업 호출
                        icon: Icon(
                          Icons.language,
                          size: 30,
                          color: Color(0xffF9A825),
                        ),
                      ),
                    ],
                  ),
                  // 개인 정보 변경
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 279,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color(0xffF9E9C8),
                          border: Border.all(
                            color: Color(0xff613C2A),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            SizedBox(
                              width: 110,
                              height: 110,
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
                                                  size: 110, // 부모 사이즈에 맞게 조절
                                                ),
                                      ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(width: 95),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      visualDensity: VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                      onPressed: () => _startEdit(),
                                      icon: Icon(Icons.settings),
                                      iconSize: 15,
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    userName,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'LV.$level $studentNumber',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -1.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 랭킹
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(35, 5, 0, 0),
                            width: 64,
                            height: 49,
                            decoration: BoxDecoration(
                              color: Color(0xffF9E9C8),
                              border: Border.all(
                                color: Color(0xff613C2A),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipOval(
                              child: Center(
                                child: Text(
                                  '랭킹',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                            width: 209,
                            height: 49,
                            decoration: BoxDecoration(
                              color: Color(0xffF9E9C8),
                              border: Border.all(
                                color: Color(0xff613C2A),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipOval(
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      '전체 랭킹              레벨 랭킹              현재 점수      ',
                                      style: TextStyle(
                                        fontSize: 6,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '$wholeRank등      $levelRank등      $userPoint등',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  Text(
                    '개발자 훈수두기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '0000000.hangdong.ac.kr',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF9A825),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70),
                  Container(
                    width: 277,
                    height: 50,
                    child: TextButton(
                      onPressed: (/*로그아웃시키기*/) => _showLogoutDialog(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xffFF4242),
                        side: const BorderSide(color: Colors.black, width: 2.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startEdit() async {
    // 팝업을 띄우고 결과가 올 때까지 기다립니다 (Map 형태로 여러 값을 받음)
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => MyEditDialog(
        initialName: userName,
        initialId: studentNumber,
        initialImage: profileImage,
      ),
    );

    // 결과값이 있으면 화면을 새로고침합니다.
    if (result != null) {
      setState(() {
        userName = result['name'];
        studentNumber = result['id'];
        profileImage = result['image'];
      });
    }
  }

  String selectedLanguage = "한국어"; // 기본값 설정

  void _showLanguageDialog() async {
    final result = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) =>
          LanguageEditDialog(initialLanguage: selectedLanguage),
    );

    if (result != null) {
      setState(() {
        selectedLanguage = result;
        print("선택된 언어: $selectedLanguage");
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xffF9E9C8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xff613C2A), width: 2),
        ),
        content: Text(
          selectedLanguage == '한국어'
              ? "로그아웃 하시겠습니까?"
              : "Are you sure you want to log out?",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 20), // 하단 여백 조절
        actions: [
          Row(
            children: [
              // 1. 아니오 버튼
              Expanded(
                child: SizedBox(
                  height: 45, // 높이를 고정해서 두 버튼 크기를 맞춤
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xff613C2A),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      selectedLanguage == '한국어' ? "아니오" : "No",
                      style: const TextStyle(
                        color: Color(0xff613C2A),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12), // 버튼 사이 간격
              // 2. 네 버튼
              Expanded(
                child: SizedBox(
                  height: 45, // 아니오 버튼과 동일한 높이
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF9A825),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      // 1. 현재 띄워져 있는 팝업(다이얼로그) 닫기
                      Navigator.pop(context);

                      try {
                        // 2. 실제 로그아웃 처리
                        await FirebaseAuth.instance.signOut();

                        // 3. 로그아웃 성공 후 로그인 페이지로 이동
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false, // 스택에 쌓인 모든 이전 화면 제거
                          );
                        }
                      } catch (e) {
                        // 에러 발생 시 처리
                        print("로그아웃 중 오류 발생: $e");
                      }
                    },
                    child: Text(
                      selectedLanguage == '한국어' ? "네" : "Yes",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyEditDialog extends StatefulWidget {
  final String initialName;
  final String initialId;
  final File? initialImage;

  MyEditDialog({
    required this.initialName,
    required this.initialId,
    this.initialImage,
  });

  @override
  _MyEditDialogState createState() => _MyEditDialogState();
}

class _MyEditDialogState extends State<MyEditDialog> {
  late TextEditingController nameController;
  late TextEditingController idController;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    idController = TextEditingController(text: widget.initialId);
    selectedImage = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xffF9E9C8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xff613C2A), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 프로필 이미지 선택 부분
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : null,
                      child: selectedImage == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildField("바꿀 닉네임을 적어줘!", nameController),
              const SizedBox(height: 10),
              _buildField("바꿀 학번을 적어줘!", idController),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "취소",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, {
                          'name': nameController.text,
                          'id': idController.text,
                          'image': selectedImage,
                        });
                      },
                      child: const Text(
                        "수정 완료",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xffF9A825),
          ),
        ),
        const SizedBox(height: 5),
        // 그림자를 담당하던 Container의 decoration을 제거하거나 단순화합니다.
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffF9E9C8),
          ),
          child: TextField(
            maxLength: 8,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              // 1. 평상시 테두리 (갈색)
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xff613C2A),
                  width: 1.5,
                ),
              ),
              // 2. 클릭(포커스) 시 테두리 (노란색)
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xffF9A825),
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LanguageEditDialog extends StatefulWidget {
  final String initialLanguage;
  const LanguageEditDialog({super.key, required this.initialLanguage});

  @override
  _LanguageEditDialogState createState() => _LanguageEditDialogState();
}

class _LanguageEditDialogState extends State<LanguageEditDialog> {
  // 선택 가능한 언어 목록
  final List<String> _languages = ["한국어", "English"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6, // 제목/버튼이 없으므로 더 작게 조정
          padding: const EdgeInsets.all(10), // 내부 여백 축소
          decoration: BoxDecoration(
            color: const Color(0xffF9E9C8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xff613C2A), width: 2),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xff613C2A), width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.initialLanguage, // 현재 언어 표시
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xff613C2A),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                items: _languages.map((String lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(
                      lang,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                // --- 여기서 핵심: 선택하자마자 결과를 가지고 팝업 닫기 ---
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    Navigator.pop(context, newValue); // 즉시 닫으며 값 전달
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
