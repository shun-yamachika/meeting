# IEICEJ論文をOrg-modeで執筆する方法

このディレクトリには、電子情報通信学会 研究報告をEmacs org-modeで執筆するためのテンプレートが含まれています。

## ファイル構成

- `paper.org` - org-mode形式の論文テンプレート
- `paper.tex` - 従来のLaTeX形式のテンプレート（既存）
- `dot.emacs` - Emacs設定ファイル（org-modeでieciejクラスを使うために必要）

## 前提条件

### IEICEクラスファイルのインストール

このテンプレートを使用するには、電子情報通信学会が提供する `ieicej.cls` ファイルが必要です。

**入手方法:**
1. 電子情報通信学会のWebサイトから `ieicej.cls` をダウンロード
   - https://www.ieice.org/ken/info/tex_format.html
2. ダウンロードしたファイルを以下のいずれかに配置:
   - `ieicej/` ディレクトリ（このディレクトリ内）
   - `~/texmf/tex/latex/ieicej/` (推奨)
   - システムのTeXディレクトリ

**配置例（推奨）:**
```bash
mkdir -p ~/texmf/tex/latex/ieicej
cp ieicej.cls ~/texmf/tex/latex/ieicej/
mktexlsr ~/texmf  # TeXのファイルデータベースを更新
```

## 初期設定

### 1. Emacsの設定

`dot.emacs` の内容を `~/.emacs` または `~/.emacs.d/init.el` に追加してください：

```bash
cat dot.emacs >> ~/.emacs
```

または、手動で `dot.emacs` の内容をコピーして貼り付けてください。

### 2. Emacsの再起動

設定を反映させるため、Emacsを再起動してください。

## 執筆ワークフロー

### 基本的な流れ

1. **org-modeで執筆**
   ```bash
   emacs paper.org
   ```

2. **便利な機能**
   - `C-c C-x C-v` - 画像をインライン表示
   - `C-c C-x C-l` - LaTeX数式をプレビュー表示
   - `M-q` - 段落を整形

3. **LaTeXへエクスポート**
   - `C-c C-e l l` - paper.texを生成
   - `C-c C-e l o` - paper.texを生成してPDFビューアで開く

4. **PDFをビルド**
   ```bash
   platex paper.tex
   bibtex paper
   platex paper.tex
   platex paper.tex
   dvipdfmx paper.dvi
   ```

### 画像を使用する場合

1. 画像ファイルを `figure/` ディレクトリに配置

2. バウンディングボックス情報を生成
   ```bash
   cd figure
   ebb *.jpg
   ebb *.png
   ```

3. org-modeファイルで画像を参照（LaTeX exportブロック内）
   ```org
   #+BEGIN_EXPORT latex
   \insertfig{figure/sample}{図のキャプション}{Figure caption}
   #+END_EXPORT
   ```

## Org-mode vs LaTeX

### Org-modeの利点

- 執筆中に画像や数式をプレビューできる
- プレーンテキストで読みやすい
- アウトライン編集が容易
- 見出しの折りたたみ/展開が簡単
- 最終段階までorgファイルで編集でき、体裁調整のみLaTeXで行う

### 注意点

- `\insertfig`、表、IEICEフォーマット固有のコマンドは `#+BEGIN_EXPORT latex` ... `#+END_EXPORT` で囲む必要がある
- 最終的な体裁調整はLaTeXファイルで行う
- 論文執筆の後期にLaTeXへエクスポートすることを推奨

## トラブルシューティング

### "unknown LaTeX class 'ieicej'" エラーが出る場合

**原因:** `ieicej.cls` ファイルが見つからない

**解決方法:**
1. 電子情報通信学会のWebサイトから `ieicej.cls` をダウンロード
   - https://www.ieice.org/ken/info/tex_format.html
2. ファイルを配置:
   ```bash
   # 方法1: このディレクトリに直接配置（簡単）
   cp ieicej.cls /home/shun/paper-templates/ieicej/

   # 方法2: ユーザーのTeXディレクトリに配置（推奨）
   mkdir -p ~/texmf/tex/latex/ieicej
   cp ieicej.cls ~/texmf/tex/latex/ieicej/
   mktexlsr ~/texmf  # TeXのファイルデータベースを更新
   ```
3. Emacsを再起動して再度エクスポート

### exportエラーが出る場合

- `dot.emacs` の設定が正しく読み込まれているか確認
- Emacsを再起動して設定を反映
- `M-x eval-buffer` で設定を再読み込み

### 画像が表示されない場合

- `ebb` コマンドで `.bb` ファイルが生成されているか確認
- 画像パスが正しいか確認

### 日本語が正しく処理されない場合

- platexでビルド時に `--kanji=utf8` オプションを使用
  ```bash
  platex --kanji=utf8 paper.tex
  ```

## 参考

詳しいorg-modeの使い方は `topic/README` も参照してください。


