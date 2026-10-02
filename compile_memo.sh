#!/bin/bash
# memo.orgからPDFを生成するスクリプト

# memo.org → memo.tex エクスポート
emacs --batch -Q \
  --eval "(require 'ox-latex)" \
  --eval "(add-to-list 'org-latex-classes '(\"IEEEtran\" \"\\\\documentclass[conference]{IEEEtran}\" (\"\\\\section{%s}\" . \"\\\\section*{%s}\") (\"\\\\subsection{%s}\" . \"\\\\subsection*{%s}\") (\"\\\\subsubsection{%s}\" . \"\\\\subsubsection*{%s}\")))" \
  --visit memo.org \
  --eval "(org-latex-export-to-latex)"

# Org's default LaTeX preamble loads graphicx without a DVI driver.
# Use dvipdfmx so PNG images can be included through platex -> dvipdfmx.
perl -0pi -e 's/\\usepackage\{graphicx\}/\\usepackage[dvipdfmx]{graphicx}/' memo.tex
perl -0pi -e 's/\n\\usepackage\[dvipdfmx\]\{graphicx\}(?=.*\n\\usepackage\[dvipdfmx\]\{graphicx\})//' memo.tex
perl -0pi -e 's/\\usepackage\{hyperref\}/\\usepackage[dvipdfmx]{hyperref}/g' memo.tex
perl -0pi -e 's/\\usepackage\{xcolor\}/\\usepackage[dvipdfmx]{xcolor}/g' memo.tex

platex -interaction=nonstopmode memo.tex
pbibtex memo
platex -interaction=nonstopmode memo.tex
platex -interaction=nonstopmode memo.tex
dvipdfmx memo.dvi
