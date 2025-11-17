import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vocabulary_word.dart';
import '../providers/vocabulary_provider.dart';

class WordEditScreen extends StatefulWidget {
  final VocabularyWord word;
  
  const WordEditScreen({super.key, required this.word});
  
  @override
  State<WordEditScreen> createState() => _WordEditScreenState();
}

class _WordEditScreenState extends State<WordEditScreen> {
  late TextEditingController _wordController;
  late TextEditingController _pronunciationController;
  late TextEditingController _meaningController;
  late TextEditingController _etymologyController;
  late TextEditingController _mnemonicController;
  late TextEditingController _synonymsController;
  late TextEditingController _examplesController;
  late String _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.word.word);
    _pronunciationController = TextEditingController(text: widget.word.pronunciation);
    _meaningController = TextEditingController(text: widget.word.meaning);
    _etymologyController = TextEditingController(text: widget.word.etymology ?? '');
    _mnemonicController = TextEditingController(text: widget.word.mnemonic ?? '');
    _synonymsController = TextEditingController(text: widget.word.synonyms.join(', '));
    _examplesController = TextEditingController(text: widget.word.examples.join('\n'));
    _selectedCategory = widget.word.category.isEmpty ? '一般' : widget.word.category;
  }
  
  @override
  void dispose() {
    _wordController.dispose();
    _pronunciationController.dispose();
    _meaningController.dispose();
    _etymologyController.dispose();
    _mnemonicController.dispose();
    _synonymsController.dispose();
    _examplesController.dispose();
    super.dispose();
  }
  
  Future<void> _saveWord() async {
    if (_wordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('単語名は必須です'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final updatedWord = VocabularyWord(
      word: _wordController.text.trim(),
      pronunciation: _pronunciationController.text.trim(),
      meaning: _meaningController.text.trim(),
      etymology: _etymologyController.text.trim().isEmpty 
          ? null 
          : _etymologyController.text.trim(),
      mnemonic: _mnemonicController.text.trim().isEmpty 
          ? null 
          : _mnemonicController.text.trim(),
      synonyms: _synonymsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      examples: _examplesController.text
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      category: _selectedCategory,
    );
    
    await context.read<VocabularyProvider>().addWord(updatedWord);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('単語を保存しました！'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('単語の編集'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveWord,
            tooltip: '保存',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 注意書き
            Card(
              color: Colors.blue.withValues(alpha: 0.1),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '変更内容は自動的に保存されます',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // カテゴリー選択
            _buildCategoryDropdown(),
            
            // 単語名
            _buildTextField(
              controller: _wordController,
              label: '単語名',
              icon: Icons.text_fields,
              required: true,
            ),
            
            // 発音記号
            _buildTextField(
              controller: _pronunciationController,
              label: '発音記号',
              icon: Icons.record_voice_over,
              hint: '例: kǽndidèit, -dət',
            ),
            
            // 意味
            _buildTextField(
              controller: _meaningController,
              label: '意味',
              icon: Icons.translate,
              hint: '例: 候補者、応募者',
            ),
            
            // 語源
            _buildTextField(
              controller: _etymologyController,
              label: '語源（Etymology）',
              icon: Icons.history_edu,
              hint: '例: ラテン語 candidatus（白衣を着た）から...',
              maxLines: 3,
            ),
            
            // 語呂合わせ
            _buildTextField(
              controller: _mnemonicController,
              label: '覚え方（語呂合わせ）',
              icon: Icons.lightbulb,
              hint: '例: 「缶（can）を抱いて（di）出る（date）」→ 選挙活動...',
              maxLines: 3,
            ),
            
            // 類義語
            _buildTextField(
              controller: _synonymsController,
              label: '類義語',
              icon: Icons.compare_arrows,
              hint: 'カンマ区切りで入力（例: applicant, 応募者, 候補者）',
            ),
            
            // 例文
            _buildTextField(
              controller: _examplesController,
              label: '例文',
              icon: Icons.format_quote,
              hint: '1行に1文ずつ入力\n英文と和訳を交互に記入してください',
              maxLines: 8,
            ),
            
            const SizedBox(height: 24),
            
            // 保存ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveWord,
                icon: const Icon(Icons.save),
                label: const Text('保存', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
  
  Widget _buildCategoryDropdown() {
    final categories = ['人工知能', '神経生理学', '一般'];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.category,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'ジャンル',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }
}
