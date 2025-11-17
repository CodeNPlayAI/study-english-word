import '../models/vocabulary_word.dart';
import 'ai_words.dart';
import 'neuroscience_words.dart';

List<VocabularyWord> getSampleWords() {
  // すべてのジャンルの単語を統合
  return [
    ...getAIWords(),
    ...getNeuroscienceWords(),
  ];
}

// ジャンル別に単語を取得
List<VocabularyWord> getWordsByCategory(String category) {
  if (category == '人工知能') {
    return getAIWords();
  } else if (category == '神経生理学') {
    return getNeuroscienceWords();
  }
  return getSampleWords();
}

// 利用可能なカテゴリー一覧
List<String> getAvailableCategories() {
  return ['人工知能', '神経生理学', 'すべて'];
}

// 後方互換性のため残しておく（旧データ）
// ignore: unused_element
List<VocabularyWord> _getLegacyWords() {
  return [
    VocabularyWord(
      word: 'candidate',
      pronunciation: 'kǽndidèit, -dət',
      meaning: '候補者、応募者',
      etymology: 'ラテン語 candidatus（白衣を着た）から。古代ローマでは立候補者が白い toga（トーガ）を着ていたことに由来。',
      mnemonic: '「缶（can）を抱いて（di）出る（date）」→ 選挙活動で缶ジュースを配る候補者のイメージ',
      examples: [
        'When did they start interviewing candidates?',
        '彼らはいつ応募者を面接し始めたのですか。',
        'We have four strong candidates.',
        '有力な候補者が4人います。',
      ],
      synonyms: ['applicant', '応募者', '候補者'],
      category: '一般',
    ),
    VocabularyWord(
      word: 'memory',
      pronunciation: 'méməri',
      meaning: '記憶、思い出',
      etymology: 'ラテン語 memoria（記憶力）から。mem-（心に留める）+ -ory（名詞語尾）。',
      mnemonic: '「目も（me）もり（mory）もり思い出す」→ 目も心も記憶でいっぱいのイメージ',
      examples: [
        'She has a good memory for faces.',
        '彼女は顔を覚えるのが得意だ。',
        'These photos bring back happy memories.',
        'これらの写真は幸せな思い出を呼び起こす。',
      ],
      synonyms: ['recollection', 'remembrance', '記憶'],
      category: '一般',
    ),
    VocabularyWord(
      word: 'hippocampus',
      pronunciation: 'hìpəkǽmpəs',
      meaning: '海馬（脳の記憶を司る部位）',
      etymology: 'ギリシャ語 hippos（馬）+ kampos（海の怪物）から。形状がタツノオトシゴに似ていることに由来。',
      mnemonic: '「ヒッポ（hippo = カバ）がキャンパス（campus）で記憶テスト」→ 大学で記憶力を試される海馬のイメージ',
      examples: [
        'The hippocampus plays a crucial role in memory formation.',
        '海馬は記憶形成において重要な役割を果たす。',
        'Damage to the hippocampus can result in memory loss.',
        '海馬の損傷は記憶喪失を引き起こす可能性がある。',
      ],
      synonyms: ['海馬', 'memory center'],
      category: '神経生理学',
    ),
    VocabularyWord(
      word: 'neuron',
      pronunciation: 'n(j)úːrɑn',
      meaning: '神経細胞、ニューロン',
      etymology: 'ギリシャ語 neuron（神経、腱）から。nerve（神経）と同じ語源。',
      mnemonic: '「ニュー（new）論（ron）」→ 新しい論文を書く時、神経細胞（ニューロン）がフル回転するイメージ',
      examples: [
        'Neurons transmit information through electrical signals.',
        'ニューロンは電気信号を通じて情報を伝達する。',
        'The human brain contains billions of neurons.',
        '人間の脳には数十億のニューロンが含まれている。',
      ],
      synonyms: ['nerve cell', '神経細胞'],
      category: '神経生理学',
    ),
    VocabularyWord(
      word: 'encode',
      pronunciation: 'enkóud',
      meaning: '符号化する、記号化する',
      etymology: 'en-（～の中に）+ code（符号）。情報を符号の形に変換すること。',
      mnemonic: '「円（en）でコード（code）を包む」→ 情報を暗号で包んで符号化するイメージ',
      examples: [
        'The brain encodes memories in neural patterns.',
        '脳は記憶を神経パターンで符号化する。',
        'This software can encode video files efficiently.',
        'このソフトウェアは動画ファイルを効率的に符号化できる。',
      ],
      synonyms: ['encrypt', 'convert', '符号化'],
      category: '人工知能',
    ),
    VocabularyWord(
      word: 'research',
      pronunciation: 'rɪsə́ːrtʃ',
      meaning: '研究、調査',
      etymology: 're-（再び）+ search（探す）。何度も繰り返し探求すること。',
      mnemonic: '「リサーチ」→ そのまま日本語でも使われる外来語',
      examples: [
        'His research focuses on artificial intelligence.',
        '彼の研究は人工知能に焦点を当てている。',
        'They conducted extensive research on brain function.',
        '彼らは脳機能について広範な研究を行った。',
      ],
      synonyms: ['study', 'investigation', '研究'],
      category: '一般',
    ),
    VocabularyWord(
      word: 'pattern',
      pronunciation: 'pǽtərn',
      meaning: 'パターン、型、模様',
      etymology: 'ラテン語 patronus（守護者、模範）から。模範となる型や形式。',
      mnemonic: '「パタン（patan）」→ ドアを開けるパタンという音のように、繰り返される形や模様',
      examples: [
        'Scientists discovered a new pattern in neural activity.',
        '科学者たちは神経活動における新しいパターンを発見した。',
        'This fabric has a beautiful floral pattern.',
        'この布地には美しい花柄のパターンがある。',
      ],
      synonyms: ['design', 'model', '模様', 'パターン'],
      category: '一般',
    ),
    VocabularyWord(
      word: 'transform',
      pronunciation: 'trænsfɔ́ːrm',
      meaning: '変換する、変形する',
      etymology: 'trans-（向こう側へ）+ form（形）。形を別のものに変えること。',
      mnemonic: '「トランス（trans = 超えて）フォーム（form = 形）」→ 形を超えて別の形に変わる',
      examples: [
        'AI can transform how we process information.',
        'AIは私たちの情報処理方法を変革できる。',
        'The data was transformed into a visual format.',
        'データは視覚的な形式に変換された。',
      ],
      synonyms: ['convert', 'change', '変換', '変形'],
      category: '人工知能',
    ),
  ];
}
