import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  final String id;
  final String level; // newbie | hunn | pro
  final String type; // mcq | short
  final String question;
  final List<String> choices;
  final int? correctIndex;
  final String? answer;
  final List<String> aliases;
  final int minLen;
  final String? hintChosung;
  final String? evidenceUrl;
  final bool active;

  Quiz({
    required this.id,
    required this.level,
    required this.type,
    required this.question,
    this.choices = const [],
    this.correctIndex,
    this.answer,
    this.aliases = const [],
    this.minLen = 3,
    this.hintChosung,
    this.evidenceUrl,
    this.active = true,
  });

  factory Quiz.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data() ?? {};
    return Quiz(
      id: snap.id,
      level: data['level'] as String? ?? 'newbie',
      type: data['type'] as String? ?? 'short',
      question: data['question'] as String? ?? '',
      choices:
          (data['choices'] as List?)?.map((e) => e.toString()).toList() ?? [],
      correctIndex: (data['correctIndex'] is num)
          ? (data['correctIndex'] as num).toInt()
          : null,
      answer: data['answer'] as String?,
      aliases:
          (data['aliases'] as List?)?.map((e) => e.toString()).toList() ?? [],
      minLen: (data['minLen'] is num) ? (data['minLen'] as num).toInt() : 3,
      hintChosung: data['hintChosung'] as String?,
      evidenceUrl: data['evidenceUrl'] as String?,
      active: data['active'] is bool ? data['active'] as bool : true,
    );
  }

  Map<String, dynamic> toMap() => {
    'level': level,
    'type': type,
    'question': question,
    'choices': choices,
    'correctIndex': correctIndex,
    'answer': answer,
    'aliases': aliases,
    'minLen': minLen,
    'hintChosung': hintChosung,
    'evidenceUrl': evidenceUrl,
    'active': active,
  };
}

class QuizRepository {
  final FirebaseFirestore _fs;
  final Map<String, List<Quiz>> _cacheByLevel = {};
  final Map<String, DateTime> _lastWarm = {};

  QuizRepository({FirebaseFirestore? firestore})
    : _fs = firestore ?? FirebaseFirestore.instance;

  Future<void> warmUpCache({required String level, int limit = 200}) async {
    final key = level;
    final now = DateTime.now();
    final last = _lastWarm[key];
    if (last != null &&
        now.difference(last).inMinutes < 10 &&
        _cacheByLevel.containsKey(key))
      return;

    final q = await _fs
        .collection('quizzes')
        .where('active', isEqualTo: true)
        .where('level', isEqualTo: level)
        .limit(limit)
        .get();

    final quizzes = q.docs.map((d) => Quiz.fromFirestore(d)).toList();
    _cacheByLevel[key] = quizzes;
    _lastWarm[key] = now;
  }

  Quiz? pickRandom({required String level, Set<String>? excludeIds}) {
    final list = _cacheByLevel[level];
    if (list == null || list.isEmpty) return null;
    final filtered = (excludeIds == null || excludeIds.isEmpty)
        ? list
        : list.where((q) => !excludeIds.contains(q.id)).toList();
    if (filtered.isEmpty) return null;
    final r = Random();
    return filtered[r.nextInt(filtered.length)];
  }

  Future<void> logAttempt({
    required String uid,
    required String zoneId,
    required String quizId,
    required bool correct,
    required Map<String, dynamic> extra,
  }) async {
    final doc = _fs.collection('quiz_attempts').doc();
    await doc.set({
      'uid': uid,
      'zoneId': zoneId,
      'quizId': quizId,
      'correct': correct,
      'timestamp': FieldValue.serverTimestamp(),
      'extra': extra,
    });
  }
}
