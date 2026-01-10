import 'package:flutter/material.dart';
import '../services/quiz_repository.dart';

class QuizResult {
  final bool correct;
  final String answer;

  QuizResult({required this.correct, required this.answer});
}

Future<QuizResult?> showQuizDialog(BuildContext context, Quiz quiz) async {
  if (!context.mounted) return null;

  if (quiz.type == 'mcq') {
    int? selected;
    final res = await showDialog<QuizResult>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('퀴즈'),
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
                final ans = (selected == null) ? '' : quiz.choices[selected!];
                final ok =
                    selected != null &&
                    quiz.correctIndex != null &&
                    selected == quiz.correctIndex;
                Navigator.pop(ctx, QuizResult(correct: ok, answer: ans));
              },
              child: const Text('제출'),
            ),
          ],
        );
      },
    );
    return res;
  } else {
    final ctrl = TextEditingController();
    bool showedHint = false;
    final res = await showDialog<QuizResult>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx2, setState) {
            return AlertDialog(
              title: const Text('퀴즈'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(quiz.question),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(hintText: '답 입력'),
                  ),
                  if (showedHint && quiz.hintInitials != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '힌트: ${quiz.hintInitials}',
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
                    bool ok = false;
                    if (normalized.length >= (quiz.minAnswerLength)) ok = true;
                    if (!ok) {
                      for (var a in quiz.acceptedAnswers) {
                        if (normalized == a.replaceAll(' ', '').toLowerCase()) {
                          ok = true;
                          break;
                        }
                      }
                    }
                    if (!ok && !showedHint && quiz.hintInitials != null) {
                      setState(() => showedHint = true);
                      return;
                    }
                    Navigator.pop(ctx2, QuizResult(correct: ok, answer: raw));
                  },
                  child: const Text('제출'),
                ),
              ],
            );
          },
        );
      },
    );
    return res;
  }
}
