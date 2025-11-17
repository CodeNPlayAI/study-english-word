import 'package:flutter/foundation.dart';
import '../models/vocabulary_word.dart';
import '../models/learning_record.dart';
import '../services/storage_service.dart';
import '../data/sample_words.dart';

class VocabularyProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<VocabularyWord> _words = [];
  List<LearningRecord> _records = [];
  
  List<VocabularyWord> get words => _words;
  List<LearningRecord> get records => _records;
  
  Future<void> loadData() async {
    _words = _storage.getAllWords();
    _records = _storage.getAllRecords();
    
    // 初回起動時にサンプルデータをロード
    if (_words.isEmpty) {
      await _loadSampleWords();
    } else if (_needsDataUpdate()) {
      // 古いデータ構造を検出した場合、クリアして再読み込み
      await _clearAllData();
      await _loadSampleWords();
    }
    
    notifyListeners();
  }
  
  // データ更新が必要かチェック（カテゴリー情報がない古いデータを検出）
  bool _needsDataUpdate() {
    if (_words.isEmpty) return false;
    // 新しいジャンルの単語（人工知能、神経生理学）が存在しなければ更新が必要
    final hasAIWords = _words.any((word) => word.category == '人工知能');
    final hasNeuroWords = _words.any((word) => word.category == '神経生理学');
    return !hasAIWords || !hasNeuroWords;
  }
  
  // データを強制的に再読み込み
  Future<void> reloadData() async {
    await _clearAllData();
    await _loadSampleWords();
    notifyListeners();
  }
  
  // すべてのデータをクリア
  Future<void> _clearAllData() async {
    final box = _storage.getVocabBox();
    await box.clear();
  }
  
  Future<void> _loadSampleWords() async {
    // すべてのジャンルの単語をロード
    final sampleWords = getSampleWords();
    for (final word in sampleWords) {
      await _storage.saveWord(word);
    }
    _words = _storage.getAllWords();
    notifyListeners();
  }
  
  // カテゴリー別の単語数を取得
  int getWordCountByCategory(String category) {
    if (category == 'すべて') {
      return _words.length;
    }
    return _words.where((word) => word.category == category).length;
  }
  
  Future<void> addWord(VocabularyWord word) async {
    await _storage.saveWord(word);
    _words = _storage.getAllWords();
    notifyListeners();
  }
  
  VocabularyWord? getWord(String word) {
    return _storage.getWord(word);
  }
  
  Future<void> recordAnswer(String word, bool isCorrect) async {
    await _storage.recordAnswer(word, isCorrect);
    _records = _storage.getAllRecords();
    notifyListeners();
  }
  
  LearningRecord? getLearningRecord(String word) {
    return _storage.getLearningRecord(word);
  }
  
  // 統計情報
  int get totalWords => _words.length;
  
  int get studiedWords => _records.length;
  
  int get totalCorrect => _records.fold(0, (sum, record) => sum + record.correctCount);
  
  int get totalIncorrect => _records.fold(0, (sum, record) => sum + record.incorrectCount);
  
  double get overallAccuracy {
    final total = totalCorrect + totalIncorrect;
    if (total == 0) return 0.0;
    return totalCorrect / total;
  }
}
