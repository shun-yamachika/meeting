# Emacs設定ガイド

このディレクトリのorg-modeファイルからPDFを生成するための設定です。

## 使い方

### paper.org → paper.pdf

1. `paper.org` をEmacsで開く
2. `C-c C-e l p` でPDF生成

### poster.org → poster.pdf

1. `poster.org` をEmacsで開く
2. `C-c C-e l p` でPDF生成


`~/.emacs`に以下を追記：

```elisp
;; LaTeXコンパイラの設定
(setq org-latex-compiler "platex")
(setq org-latex-pdf-process
      '("platex -interaction=nonstopmode -output-directory=%o %f"
        "pbibtex %b"
        "platex -interaction=nonstopmode -output-directory=%o %f"
        "platex -interaction=nonstopmode -output-directory=%o %f"
        "dvipdfmx %b.dvi"))

;; LaTeXクラスの定義
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
