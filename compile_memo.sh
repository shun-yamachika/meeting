#!/bin/bash
# memo.orgからPDFを生成するスクリプト

# memo.org → memo.tex エクスポート
emacs --batch -Q \
  --eval "(require 'ox-latex)" \
  --eval "(add-to-list 'org-latex-classes '(\"IEEEtran\" \"\\\\documentclass[conference]{IEEEtran}\" (\"\\\\section{%s}\" . \"\\\\section*{%s}\") (\"\\\\subsection{%s}\" . \"\\\\subsection*{%s}\") (\"\\\\subsubsection{%s}\" . \"\\\\subsubsection*{%s}\")))" \
  --visit memo.org \
  --eval "(org-latex-export-to-latex)"

platex -interaction=nonstopmode memo.tex
pbibtex memo
platex -interaction=nonstopmode memo.tex
platex -interaction=nonstopmode memo.tex
dvipdfmx memo.dvi
