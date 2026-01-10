import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  final String id;
  final String level; // newbie | returner | veteran
  final String type; // mcq | text
  final String question;
  final List<String> choices;
  final int? correctIndex;
  final List<String> acceptedAnswers;
  final int minAnswerLength;
  final String? hintInitials;
  final String? evidenceImageUrl;
  final List<String> tags;

  Quiz({
    required this.id,
    required this.level,
    required this.type,
    required this.question,
    this.choices = const [],
    this.correctIndex,
    this.acceptedAnswers = const [],
    this.minAnswerLength = 3,
    this.hintInitials,
    this.evidenceImageUrl,
    this.tags = const [],
  });

  factory Quiz.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Quiz(
      id: doc.id,
      level: (data['level'] as String?) ?? 'newbie',
      type: (data['type'] as String?) ?? 'text',
      question: (data['question'] as String?) ?? '',
      choices:
          (data['choices'] as List?)?.map((e) => e.toString()).toList() ?? [],
      correctIndex: (data['correctIndex'] is num)
          ? (data['correctIndex'] as num).toInt()
          : null,
      acceptedAnswers:
          (data['acceptedAnswers'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      minAnswerLength: (data['minAnswerLength'] is num)
          ? (data['minAnswerLength'] as num).toInt()
          : 3,
      hintInitials: data['hintInitials'] as String?,
      evidenceImageUrl: data['evidenceImageUrl'] as String?,
      tags: (data['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class QuizRepository {
  final FirebaseFirestore _fs;
  final Map<String, List<Quiz>> _cacheByLevel = {};

  QuizRepository({FirebaseFirestore? firestore})
    : _fs = firestore ?? FirebaseFirestore.instance;

  /// Fetch quizzes for a level and cache them. Returns number fetched.
  Future<int> _warmLevel(String level, {int limit = 200}) async {
    final q = await _fs
        .collection('quizzes')
        .where('level', isEqualTo: level)
        .where('active', isEqualTo: true)
        .limit(limit)
        .get();
    final list = q.docs.map((d) => Quiz.fromDoc(d)).toList();
    _cacheByLevel[level] = list;
    return list.length;
  }

  /// Public: getRandomQuiz
  Future<Quiz?> getRandomQuiz(String level, {Set<String>? excludeIds}) async {
    final cached = _cacheByLevel[level];
    if (cached == null || cached.isEmpty) {
      await _warmLevel(level);
    }
    final list = _cacheByLevel[level] ?? [];
    final filtered = (excludeIds == null || excludeIds.isEmpty)
        ? list
        : list.where((q) => !excludeIds.contains(q.id)).toList();
    if (filtered.isEmpty) return null;
    final r = Random();
    return filtered[r.nextInt(filtered.length)];
  }

  Future<Quiz?> getQuizById(String id) async {
    // try cache first
    for (var list in _cacheByLevel.values) {
      final idx = list.indexWhere((e) => e.id == id);
      if (idx != -1) return list[idx];
    }
    // fallback read
    final doc = await _fs.collection('quizzes').doc(id).get();
    if (!doc.exists) return null;
    return Quiz.fromDoc(doc as DocumentSnapshot<Map<String, dynamic>>);
  }

  Future<void> logAttempt({
    required String uid,
    required String zoneId,
    required String quizId,
    required bool correct,
    required String userAnswer,
    required String level,
  }) async {
    final ref = _fs.collection('users').doc(uid).collection('attempts').doc();
    await ref.set({
      'quizId': quizId,
      'zoneId': zoneId,
      'createdAt': FieldValue.serverTimestamp(),
      'correct': correct,
      'userAnswer': userAnswer,
      'level': level,
    });
  }
}
