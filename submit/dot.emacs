;; -*- Emacs-Lisp -*-
;;
;; Emacs設定ファイル for ieicej paper.org
;;
;; このファイルを ~/.emacs または ~/.emacs.d/init.el に追加してください
;;
;; 注意: ieicej.clsファイルが必要です
;; - 電子情報通信学会のWebサイトからダウンロード
;;   https://www.ieice.org/ken/info/tex_format.html
;; - ieicej/ディレクトリまたは~/texmf/tex/latex/ieicej/に配置
;;

;; org-mode LaTeX export設定
(require 'ox-latex)

;; ieicej document classの定義
;; ieicej.clsが見つからない場合のエラーはLaTeXコンパイル時に発生します
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

;; org-modeでの画像表示設定
(setq org-image-actual-width nil)

;; org-modeでのLaTeX数式プレビュー設定
(setq org-latex-create-formula-image-program 'dvipng)

;; ソースコードのシンタックスハイライト
(setq org-src-fontify-natively t)

;; exportで\maketitleを自動挿入しない（手動で配置するため）
(setq org-latex-title-command "")

;; LaTeXのカレントディレクトリでクラスファイルを探すように設定
;; これにより、ieicej.clsをローカルディレクトリに置いても動作します
(setq org-latex-pdf-process
      '("platex %f"
        "bibtex %b"
        "platex %f"
        "platex %f"
        "dvipdfmx %b.dvi"))
