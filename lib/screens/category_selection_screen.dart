import 'package:flutter/material.dart';
import 'word_list_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': '人工知能',
        'icon': Icons.psychology,
        'color': Colors.blue,
        'description': 'AI・機械学習・深層学習に関する専門用語',
        'wordCount': 10,
      },
      {
        'name': '神経生理学',
        'icon': Icons.science,
        'color': Colors.purple,
        'description': '脳科学・神経科学に関する専門用語',
        'wordCount': 10,
      },
      {
        'name': 'すべて',
        'icon': Icons.library_books,
        'color': Colors.green,
        'description': '全ジャンルの単語を学習',
        'wordCount': 20,
      },
    ];
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.school,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '語源で覚える英単語',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '学習したいジャンルを選択してください',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            // カテゴリー選択カード
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryCard(
                    context,
                    name: category['name'] as String,
                    icon: category['icon'] as IconData,
                    color: category['color'] as Color,
                    description: category['description'] as String,
                    wordCount: category['wordCount'] as int,
                  );
                },
              ),
            ),
            
            // フッター
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '専門分野に特化した語彙学習で効率的に英語力UP！',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryCard(
    BuildContext context, {
    required String name,
    required IconData icon,
    required Color color,
    required String description,
    required int wordCount,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WordListScreen(selectedCategory: name),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // アイコン部分
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // テキスト部分
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$wordCount単語',
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 矢印アイコン
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
