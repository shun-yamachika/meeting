## orgファイルから研究ミーティング用のpdfファイルを生成したい

## リンク https://github.com/shun-yamachika/meeting

## 概要
研究室のミーティング資料をOrg-modeから電子情報通信学会形式のPDFに変換するためのリポジトリ。

## ディレクトリ構造

```
Mtg/
├── paper.org              # 研究報告用文書（Org-mode）
├── paper.pdf              # 生成されたPDF
├── poster.org             # ポスター用文書（Org-mode）
├── poster.pdf             # 生成されたPDF
├── ieicej.cls             # 電子情報通信学会 研究報告用LaTeXクラス
├── ieicejsp.cls           # 電子情報通信学会 学会誌用LaTeXクラス
├── bib/                   # 参考文献ファイル
└── figure/                # 図表ファイル
```

## 使い方

### PDF生成

1. Emacsで `paper.org` または `poster.org` を開く
2. `C-c C-e l p` を実行してPDF生成

### 必要な環境

- Emacs + org-mode
- LaTeX環境（platex, pbibtex, dvipdfmx）

### Emacs設定

`~/.emacs` に以下を追記（詳細は `EMACS_SETUP.md` 参照）：

```elisp
;; LaTeXコンパイラ設定
(setq org-latex-compiler "platex")
(setq org-latex-pdf-process
      '("platex -interaction=nonstopmode -output-directory=%o %f"
        "pbibtex %b"
        "platex -interaction=nonstopmode -output-directory=%o %f"
        "platex -interaction=nonstopmode -output-directory=%o %f"
        "dvipdfmx %b.dvi"))

;; 電子情報通信学会用クラス登録
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
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(setq org-latex-title-command "")
```
