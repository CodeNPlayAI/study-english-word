// 単語モデル
class VocabularyWord {
  final String word;
  final String pronunciation;
  final String meaning;
  final String? etymology; // 語源
  final String? mnemonic; // 語呂合わせ
  final List<String> examples;
  final List<String> synonyms;
  final String category; // ジャンル（人工知能、神経生理学など）
  
  VocabularyWord({
    required this.word,
    required this.pronunciation,
    required this.meaning,
    this.etymology,
    this.mnemonic,
    required this.examples,
    required this.synonyms,
    required this.category,
  });
  
  factory VocabularyWord.fromMap(Map<String, dynamic> map) {
    return VocabularyWord(
      word: map['word'] as String,
      pronunciation: map['pronunciation'] as String,
      meaning: map['meaning'] as String,
      etymology: map['etymology'] as String?,
      mnemonic: map['mnemonic'] as String?,
      examples: (map['examples'] as List<dynamic>?)?.cast<String>() ?? [],
      synonyms: (map['synonyms'] as List<dynamic>?)?.cast<String>() ?? [],
      category: map['category'] as String? ?? '一般',
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'pronunciation': pronunciation,
      'meaning': meaning,
      'etymology': etymology,
      'mnemonic': mnemonic,
      'examples': examples,
      'synonyms': synonyms,
      'category': category,
    };
  }
}
