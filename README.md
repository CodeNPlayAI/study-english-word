# 語源で覚える英単語アプリ

[![Flutter](https://img.shields.io/badge/Flutter-3.35.4-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

専門分野に特化した英単語学習アプリ。語源や語呂合わせを活用して、効率的に語彙力を向上させます。

## ✨ 主な機能

### 📚 ジャンル選択
- **🤖 人工知能**: AI・機械学習・深層学習に関する専門用語（10単語）
- **🧠 神経生理学**: 脳科学・神経科学に関する専門用語（10単語）
- **📖 すべて**: 全ジャンルの単語を学習

### 🎯 学習機能
- **語源学習**: 単語のルーツを理解して記憶に定着
- **語呂合わせ**: 視覚的イメージで楽しく覚える
- **例文表示**: 英語＋日本語訳で実用的な使い方を学習
- **類義語**: 関連する単語も一緒に習得

### 📊 学習管理
- **学習履歴の記録**: 正解・不正解を自動記録
- **統計表示**: 正解率、学習進捗を可視化
- **単語編集**: 語源や語呂合わせを自由に編集可能
- **新規追加**: オリジナルの単語を追加

## 🎓 収録単語例

### 人工知能ジャンル
- algorithm（アルゴリズム）
- neural network（ニューラルネットワーク）
- transformer（トランスフォーマー）
- backpropagation（誤差逆伝播法）
- overfitting（過学習）
- etc.

### 神経生理学ジャンル
- hippocampus（海馬）
- neuron（神経細胞）
- synapse（シナプス）
- dendrite（樹状突起）
- action potential（活動電位）
- etc.

## 🚀 技術スタック

- **Flutter 3.35.4**: クロスプラットフォームUIフレームワーク
- **Dart 3.9.2**: プログラミング言語
- **Hive**: 高速ローカルストレージ
- **Provider**: 状態管理
- **Material Design 3**: モダンなUI/UX

## 📱 対応プラットフォーム

- ✅ Android
- ✅ Web
- ⚠️ iOS (要設定)

## 🛠️ セットアップ

### 前提条件
- Flutter SDK 3.35.4以上
- Dart SDK 3.9.2以上

### インストール手順

```bash
# リポジトリをクローン
git clone https://github.com/CodeNPlayAI/study-english-word.git
cd study-english-word

# 依存関係のインストール
flutter pub get

# Webで実行
flutter run -d chrome

# Androidで実行
flutter run
```

## 🎨 アプリ構造

```
lib/
├── data/               # 単語データ
│   ├── ai_words.dart          # 人工知能ジャンル
│   ├── neuroscience_words.dart # 神経生理学ジャンル
│   └── sample_words.dart      # データ統合
├── models/            # データモデル
│   ├── vocabulary_word.dart   # 単語モデル
│   └── learning_record.dart   # 学習履歴モデル
├── providers/         # 状態管理
│   └── vocabulary_provider.dart
├── screens/           # 画面
│   ├── category_selection_screen.dart  # ジャンル選択
│   ├── word_list_screen.dart          # 単語リスト
│   ├── word_detail_screen.dart        # 単語詳細
│   ├── word_edit_screen.dart          # 単語編集
│   └── statistics_screen.dart         # 統計表示
├── services/          # サービス
│   └── storage_service.dart   # Hive操作
└── main.dart          # エントリーポイント
```

## 🧠 記憶科学に基づく設計

このアプリは、海馬CA1ニューロンの記憶符号化に関する神経科学の知見を活用しています：

- **語源理解**: 意味的関連付けによる記憶定着
- **語呂合わせ**: 視覚的イメージングによる記憶強化
- **反復学習記録**: 記憶定着の可視化
- **例文提示**: 文脈的記憶の強化

## 📝 ライセンス

MIT License

## 👨‍💻 開発者

**Professor** - AI研究者・大学教授  
専門分野: 海馬機能、AI応用神経科学、データセントリックAI

## 🤝 コントリビューション

プルリクエストを歓迎します！バグ報告や機能要望は、Issuesでお知らせください。

## 📧 お問い合わせ

プロジェクトに関するご質問は、GitHubのIssuesでお願いします。

---

**Made with ❤️ by Professor**
