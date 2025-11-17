import 'package:hive_flutter/hive_flutter.dart';
import '../models/vocabulary_word.dart';
import '../models/learning_record.dart';

class StorageService {
  static const String vocabBoxName = 'vocabulary';
  static const String recordsBoxName = 'learning_records';
  
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(vocabBoxName);
    await Hive.openBox<Map>(recordsBoxName);
  }
  
  // 単語データベース操作
  static Box<Map> get _vocabBox => Hive.box<Map>(vocabBoxName);
  
  Future<void> saveWord(VocabularyWord word) async {
    await _vocabBox.put(word.word.toLowerCase(), word.toMap());
  }
  
  VocabularyWord? getWord(String word) {
    final data = _vocabBox.get(word.toLowerCase());
    if (data == null) return null;
    return VocabularyWord.fromMap(Map<String, dynamic>.from(data));
  }
  
  List<VocabularyWord> getAllWords() {
    return _vocabBox.values
        .map((data) => VocabularyWord.fromMap(Map<String, dynamic>.from(data)))
        .toList();
  }
  
  // Boxを外部から取得できるようにする
  Box<Map> getVocabBox() {
    return _vocabBox;
  }
  
  // 学習履歴操作
  static Box<Map> get _recordsBox => Hive.box<Map>(recordsBoxName);
  
  Future<void> recordAnswer(String word, bool isCorrect) async {
    final recordData = _recordsBox.get(word.toLowerCase());
    LearningRecord record;
    
    if (recordData == null) {
      record = LearningRecord(
        word: word.toLowerCase(),
        lastReviewed: DateTime.now(),
      );
    } else {
      record = LearningRecord.fromMap(Map<String, dynamic>.from(recordData));
      record.lastReviewed = DateTime.now();
    }
    
    if (isCorrect) {
      record.correctCount++;
    } else {
      record.incorrectCount++;
    }
    
    await _recordsBox.put(word.toLowerCase(), record.toMap());
  }
  
  LearningRecord? getLearningRecord(String word) {
    final data = _recordsBox.get(word.toLowerCase());
    if (data == null) return null;
    return LearningRecord.fromMap(Map<String, dynamic>.from(data));
  }
  
  List<LearningRecord> getAllRecords() {
    return _recordsBox.values
        .map((data) => LearningRecord.fromMap(Map<String, dynamic>.from(data)))
        .toList();
  }
}
