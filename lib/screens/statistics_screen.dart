import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vocabulary_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VocabularyProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('学習統計'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ヘッダー
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
                  const Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '総合成績',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '正解率 ${(provider.overallAccuracy * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 統計カード
            _buildStatCard(
              context,
              icon: Icons.book,
              title: '総単語数',
              value: '${provider.totalWords}',
              subtitle: '登録されている単語',
              color: Colors.blue,
            ),
            
            _buildStatCard(
              context,
              icon: Icons.school,
              title: '学習済み単語',
              value: '${provider.studiedWords}',
              subtitle: '${provider.totalWords > 0 ? ((provider.studiedWords / provider.totalWords * 100).toStringAsFixed(1)) : 0}% 完了',
              color: Colors.purple,
            ),
            
            _buildStatCard(
              context,
              icon: Icons.check_circle,
              title: '正解数',
              value: '${provider.totalCorrect}',
              subtitle: '累計正解回数',
              color: Colors.green,
            ),
            
            _buildStatCard(
              context,
              icon: Icons.cancel,
              title: '不正解数',
              value: '${provider.totalIncorrect}',
              subtitle: '累計不正解回数',
              color: Colors.red,
            ),
            
            _buildStatCard(
              context,
              icon: Icons.repeat,
              title: '総学習回数',
              value: '${provider.totalCorrect + provider.totalIncorrect}',
              subtitle: '正解 + 不正解',
              color: Colors.orange,
            ),
            
            const SizedBox(height: 24),
            
            // 学習のヒント
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '学習のヒント',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildHintItem('語源を理解することで、関連する単語も覚えやすくなります'),
                      _buildHintItem('語呂合わせは、視覚的なイメージと結びつけると効果的です'),
                      _buildHintItem('定期的な復習が記憶の定着に重要です'),
                      _buildHintItem('例文を音読することで、単語の使い方も身につきます'),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHintItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
