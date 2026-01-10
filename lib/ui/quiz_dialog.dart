import 'package:flutter/material.dart';
import '../data/quiz_repository.dart';

Future<void> showQuizDialog(
  BuildContext context,
  Quiz quiz, {
  required void Function(bool correct, dynamic answer) onDone,
}) async {
  if (!context.mounted) return;

  if (quiz.type == 'mcq') {
    int? selected;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Quiz'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(quiz.question),
                const SizedBox(height: 12),
                ...List.generate(quiz.choices.length, (i) {
                  return RadioListTile<int>(
                    title: Text(quiz.choices[i]),
                    value: i,
                    groupValue: selected,
                    onChanged: (v) {
                      selected = v;
                      // Force rebuild
                      (ctx as Element).markNeedsBuild();
                    },
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final ok =
                    selected != null &&
                    quiz.correctIndex != null &&
                    selected == quiz.correctIndex;
                Navigator.pop(ctx);
                onDone(ok, selected);
              },
              child: const Text('제출'),
            ),
          ],
        );
      },
    );
  } else {
    final ctrl = TextEditingController();
    bool showedHint = false;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx2, setState) {
            return AlertDialog(
              title: const Text('Quiz'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(quiz.question),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(hintText: '답을 입력하세요'),
                  ),
                  if (showedHint && quiz.hintChosung != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '힌트: ${quiz.hintChosung}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx2),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final raw = ctrl.text.trim();
                    final normalized = raw.replaceAll(' ', '').toLowerCase();
                    final minLen = quiz.minLen;
                    bool ok = false;
                    if (normalized.length >= minLen) ok = true;
                    if (!ok && (quiz.answer != null)) {
                      final a = quiz.answer!.replaceAll(' ', '').toLowerCase();
                      if (normalized == a) ok = true;
                    }
                    if (!ok && quiz.aliases.isNotEmpty) {
                      for (var al in quiz.aliases) {
                        if (normalized ==
                            al.replaceAll(' ', '').toLowerCase()) {
                          ok = true;
                          break;
                        }
                      }
                    }

                    if (!ok && !showedHint && quiz.hintChosung != null) {
                      setState(() {
                        showedHint = true;
                      });
                      return;
                    }

                    Navigator.pop(ctx2);
                    onDone(ok, raw);
                  },
                  child: const Text('제출'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
