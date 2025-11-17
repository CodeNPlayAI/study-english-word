import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vocabulary_provider.dart';
import '../models/vocabulary_word.dart';
import 'word_detail_screen.dart';
import 'word_edit_screen.dart';
import 'statistics_screen.dart';
import 'category_selection_screen.dart';

class WordListScreen extends StatefulWidget {
  final String selectedCategory;
  
  const WordListScreen({super.key, this.selectedCategory = 'すべて'});
  
  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  String _searchQuery = '';
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VocabularyProvider>();
    
    // カテゴリーと検索でフィルタリング
    var filteredWords = provider.words;
    
    // カテゴリーフィルター
    if (widget.selectedCategory != 'すべて') {
      filteredWords = filteredWords
          .where((word) => word.category == widget.selectedCategory)
          .toList();
    }
    
    // 検索フィルター
    if (_searchQuery.isNotEmpty) {
      filteredWords = filteredWords
          .where((word) =>
              word.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              word.meaning.contains(_searchQuery))
          .toList();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('語源で覚える英単語', style: TextStyle(fontSize: 18)),
            Text(
              widget.selectedCategory,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.category),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CategorySelectionScreen(),
              ),
            );
          },
          tooltip: 'ジャンル変更',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // 新規単語追加
          final newWord = VocabularyWord(
            word: '',
            pronunciation: '',
            meaning: '',
            examples: [],
            synonyms: [],
            category: widget.selectedCategory != 'すべて' 
                ? widget.selectedCategory 
                : '一般',
          );
          
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WordEditScreen(word: newWord),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('新規追加'),
      ),
      body: Column(
        children: [
          // 検索バー
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '単語を検索...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 統計情報
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      '総単語数',
                      '${provider.totalWords}',
                      Icons.book,
                    ),
                    _buildStatCard(
                      '学習済み',
                      '${provider.studiedWords}',
                      Icons.school,
                    ),
                    _buildStatCard(
                      '正解率',
                      '${(provider.overallAccuracy * 100).toStringAsFixed(0)}%',
                      Icons.trending_up,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 単語リスト
          Expanded(
            child: filteredWords.isEmpty
                ? const Center(
                    child: Text(
                      '単語が見つかりません',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredWords.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final word = filteredWords[index];
                      final record = provider.getLearningRecord(word.word);
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(record),
                            child: Text(
                              word.word.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            word.word,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word.pronunciation,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                word.meaning,
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (record != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildMiniStat(
                                      Icons.check_circle,
                                      '${record.correctCount}',
                                      Colors.green,
                                    ),
                                    const SizedBox(width: 12),
                                    _buildMiniStat(
                                      Icons.cancel,
                                      '${record.incorrectCount}',
                                      Colors.red,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WordDetailScreen(word: word),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(record) {
    if (record == null) return Colors.grey;
    if (record.accuracyRate >= 0.8) return Colors.green;
    if (record.accuracyRate >= 0.5) return Colors.orange;
    return Colors.red;
  }
  
  Widget _buildMiniStat(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
