# Emacs設定ガイド

このディレクトリのorg-modeファイルからPDFを生成するために必要なEmacs設定です。

## 必要な設定

以下の内容を `~/.emacs` または `~/.emacs.d/init.el` に追記してください。

### LaTeXクラスの定義

```elisp
;; org-latex-classes に電子情報通信学会のクラスを追加
(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
               '("ieicej"
                 "\\documentclass[technicalreport,dvipdfmx]{ieicej}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("ieicejsp"
                 "\\documentclass[twocolumn,a4paper,dvipdfmx]{ieicejsp}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

;; LaTeXコンパイラの設定
(setq org-latex-compiler "platex")
(setq org-latex-pdf-process
      '("platex %f"
        "platex %f"
        "bibtex %b"
        "platex %f"
        "platex %f"
        "dvipdfmx %b.dvi"))
```

## 使い方

### paper.org → paper.pdf

1. `submit/paper.org` をEmacsで開く
2. `C-c C-e l l` でLaTeXファイル(paper.tex)にエクスポート
3. 以下のコマンドでPDFを生成:
   ```bash
   cd submit
   platex paper.tex
   bibtex paper
   platex paper.tex
   platex paper.tex
   dvipdfmx paper.dvi
   ```

### poster.org → poster.pdf

1. `submit/poster.org` をEmacsで開く
2. `C-c C-e l l` でLaTeXファイル(poster.tex)にエクスポート
3. 以下のコマンドでPDFを生成:
   ```bash
   cd submit
   platex poster.tex
   bibtex poster
   platex poster.tex
   platex poster.tex
   dvipdfmx poster.dvi
   ```

## 必要なパッケージ

以下のLaTeXパッケージがシステムにインストールされている必要があります：

- TeXLive (platex, dvipdfmx, bibtexを含む)
- ieicej.cls, ieicejsp.cls (submitディレクトリに同梱)
- 標準的なLaTeXパッケージ (cite, insertfig, times, url, hyperref, graphicx)

## トラブルシューティング

### エクスポート時にクラスが見つからない場合

Emacsを再起動するか、以下のコマンドで設定を再読み込みしてください：
```
M-x eval-buffer
```

### 画像が表示されない場合

- EPSファイルは `submit/figure/` ディレクトリに配置されていることを確認してください
- dvipdfmxオプションが正しく設定されていることを確認してください
