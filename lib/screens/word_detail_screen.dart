import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vocabulary_word.dart';
import '../models/learning_record.dart';
import '../providers/vocabulary_provider.dart';
import 'word_edit_screen.dart';

class WordDetailScreen extends StatelessWidget {
  final VocabularyWord word;
  
  const WordDetailScreen({super.key, required this.word});
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VocabularyProvider>();
    final record = provider.getLearningRecord(word.word);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(word.word),
        elevation: 0,
        actions: [
          // 編集ボタン
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordEditScreen(word: word),
                ),
              );
              // 編集後に画面を更新
              if (result == true) {
                // Providerが自動的に更新するため、特別な処理は不要
              }
            },
            tooltip: '編集',
          ),
          // 学習統計アイコン
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: _buildStatsBadge(record),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー部分（単語名と統計）
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    word.word,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    word.pronunciation,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (record != null) _buildDetailedStats(record),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 意味
            _buildSection(
              context,
              icon: Icons.translate,
              title: '意味',
              content: word.meaning,
              color: Colors.blue,
            ),
            
            // 語源（あれば表示）
            if (word.etymology != null)
              _buildSection(
                context,
                icon: Icons.history_edu,
                title: '語源',
                content: word.etymology!,
                color: Colors.purple,
              ),
            
            // 語呂合わせ（あれば表示）
            if (word.mnemonic != null)
              _buildSection(
                context,
                icon: Icons.lightbulb,
                title: '覚え方（語呂合わせ）',
                content: word.mnemonic!,
                color: Colors.orange,
              ),
            
            // 類義語
            if (word.synonyms.isNotEmpty)
              _buildListSection(
                context,
                icon: Icons.compare_arrows,
                title: '類義語',
                items: word.synonyms,
                color: Colors.teal,
              ),
            
            // 例文
            if (word.examples.isNotEmpty)
              _buildExamplesSection(context, word.examples),
            
            const SizedBox(height: 24),
            
            // 正解・不正解ボタン
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        provider.recordAnswer(word.word, false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('不正解として記録しました'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('不正解', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        provider.recordAnswer(word.word, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('正解として記録しました！'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('正解', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsBadge(LearningRecord? record) {
    if (record == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '未学習',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '${record.correctCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.cancel, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '${record.incorrectCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDetailedStats(LearningRecord record) {
    final accuracy = (record.accuracyRate * 100).toStringAsFixed(0);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('正解', '${record.correctCount}', Colors.green),
          _buildStatItem('不正解', '${record.incorrectCount}', Colors.red),
          _buildStatItem('正解率', '$accuracy%', Colors.amber),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildListSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items
                    .map((item) => Chip(
                          label: Text(item),
                          backgroundColor: color.withValues(alpha: 0.1),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildExamplesSection(BuildContext context, List<String> examples) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.format_quote, color: Colors.indigo, size: 24),
                  SizedBox(width: 8),
                  Text(
                    '例文',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate((examples.length / 2).ceil(), (index) {
                final englishIndex = index * 2;
                final japaneseIndex = englishIndex + 1;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        examples[englishIndex],
                        style: const TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (japaneseIndex < examples.length)
                        Text(
                          examples[japaneseIndex],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
