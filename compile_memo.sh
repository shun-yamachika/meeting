#!/bin/bash
# memo.orgからPDFを生成するスクリプト
platex -interaction=nonstopmode memo.tex
pbibtex memo
platex -interaction=nonstopmode memo.tex
platex -interaction=nonstopmode memo.tex
dvipdfmx memo.dvi
