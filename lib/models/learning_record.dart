// 学習履歴モデル
class LearningRecord {
  final String word;
  int correctCount;
  int incorrectCount;
  DateTime lastReviewed;
  
  LearningRecord({
    required this.word,
    this.correctCount = 0,
    this.incorrectCount = 0,
    required this.lastReviewed,
  });
  
  int get totalAttempts => correctCount + incorrectCount;
  
  double get accuracyRate {
    if (totalAttempts == 0) return 0.0;
    return correctCount / totalAttempts;
  }
  
  factory LearningRecord.fromMap(Map<String, dynamic> map) {
    return LearningRecord(
      word: map['word'] as String,
      correctCount: map['correctCount'] as int? ?? 0,
      incorrectCount: map['incorrectCount'] as int? ?? 0,
      lastReviewed: DateTime.parse(map['lastReviewed'] as String),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
      'lastReviewed': lastReviewed.toIso8601String(),
    };
  }
}
