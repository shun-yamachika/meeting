; -*- Emacs-Lisp -*-

;; LaTeX export
(require 'ox-latex)
(setq org-export-default-language "ja")
(setq org-export-date-timestamp-format "%Y-%m-%d")
(setq org-export-with-sub-superscripts nil)

(add-to-list 'org-latex-classes 
	     '("jsarticle"
	       "\\documentclass[a4,dvipdfmx]{jsarticle}"
	       ("\\section{%s}" . "\\section*{%s}")
	       ("\\subsection{%s}" . "\\subsection*{%s}")
	       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	       ("\\paragraph{%s}" . "\\paragraph*{%s}")
	       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(setq org-latex-default-packages-alist
      '(("T1" "fontenc" t)
	("" "graphicx" t)
	("" "amsmath" t)
	("normalem" "ulem" t)
	("" "hyperref" nil)))

;; 英語スライドの場合はコメントアウト
(setq org-beamer-outline-frame-title "発表の内容")

;; override 'org-beamer-template
(defun org-beamer-template (contents info)
  "Return complete document string after Beamer conversion.
CONTENTS is the transcoded contents string.  INFO is a plist
holding export options."
  (let ((title (org-export-data (plist-get info :title) info)))
    (concat
     ;; 1. Time-stamp.
     (and (plist-get info :time-stamp-file)
	  (format-time-string "%% Created %Y-%m-%d %a %H:%M\n"))
     ;; 2. Document class and packages.
     (let* ((class (plist-get info :latex-class))
	    (class-options (plist-get info :latex-class-options))
	    (header (nth 1 (assoc class org-latex-classes)))
	    (document-class-string
	     (and (stringp header)
		  (if (not class-options) header
		    (replace-regexp-in-string
		     "^[ \t]*\\\\documentclass\\(\\(\\[[^]]*\\]\\)?\\)"
		     class-options header t nil 1)))))
       (if (not document-class-string)
	   (user-error "Unknown LaTeX class `%s'" class)
	 (org-latex-guess-babel-language
	  (org-latex-guess-inputenc
	   (org-element-normalize-string
	    (org-splice-latex-header
	     document-class-string
	     org-latex-default-packages-alist
	     org-latex-packages-alist nil
	     (concat (org-element-normalize-string
		      (plist-get info :latex-header))
		     (org-element-normalize-string
		      (plist-get info :latex-header-extra))
		     (plist-get info :beamer-header-extra)))))
	  info)))
     ;; 3. Insert themes.
     (let ((format-theme
	    (function
	     (lambda (prop command)
	       (let ((theme (plist-get info prop)))
		 (when theme
		   (concat command
			   (if (not (string-match "\\[.*\\]" theme))
			       (format "{%s}\n" theme)
			     (format "%s{%s}\n"
				     (match-string 0 theme)
				     (org-trim
				      (replace-match "" nil nil theme)))))))))))
       (mapconcat (lambda (args) (apply format-theme args))
		  '((:beamer-theme "\\usetheme")
		    (:beamer-color-theme "\\usecolortheme")
		    (:beamer-font-theme "\\usefonttheme")
		    (:beamer-inner-theme "\\useinnertheme")
		    (:beamer-outer-theme "\\useoutertheme"))
		  ""))
     ;; 4. Possibly limit depth for headline numbering.
     (let ((sec-num (plist-get info :section-numbers)))
       (when (integerp sec-num)
	 (format "\\setcounter{secnumdepth}{%d}\n" sec-num)))
     ;; Sep  3, 2018 by Hiroyuki Ohsaki
     ;; ;; 5. Author.
     ;; (let ((author (and (plist-get info :with-author)
     ;; 			(let ((auth (plist-get info :author)))
     ;; 			  (and auth (org-export-data auth info)))))
     ;; 	   (email (and (plist-get info :with-email)
     ;; 		       (org-export-data (plist-get info :email) info))))
     ;;   (cond ((and author email (not (string= "" email)))
     ;; 	      (format "\\author{%s\\thanks{%s}}\n" author email))
     ;; 	     (author (format "\\author{%s}\n" author))
     ;; 	     (t "\\author{}\n")))
     ;; ;; 6. Date.
     ;; (let ((date (and (plist-get info :with-date) (org-export-get-date info))))
     ;;   (format "\\date{%s}\n" (org-export-data date info)))
     ;; ;; 7. Title
     ;; (format "\\title{%s}\n" title)
     ;; 8. Hyperref options.
     (when (plist-get info :latex-hyperref-p)
       (format "\\hypersetup{\n  pdfkeywords={%s},\n  pdfsubject={%s},\n  pdfcreator={%s}}\n"
	       (or (plist-get info :keywords) "")
	       (or (plist-get info :description) "")
	       (if (not (plist-get info :with-creator)) ""
		 (plist-get info :creator))))
     ;; 9. Document start.
     "\\begin{document}\n\n"
     ;; 10. Title command.
     (org-element-normalize-string
      (cond ((string= "" title) nil)
	    ((not (stringp org-latex-title-command)) nil)
	    ((string-match "\\(?:[^%]\\|^\\)%s"
			   org-latex-title-command)
	     (format org-latex-title-command title))
	    (t org-latex-title-command)))
     ;; 11. Table of contents.
     (let ((depth (plist-get info :with-toc)))
       (when depth
	 (concat
	  (format "\\begin{frame}%s{%s}\n"
		  (org-beamer--normalize-argument
		   org-beamer-outline-frame-options 'option)
		  org-beamer-outline-frame-title)
	  (when (wholenump depth)
	    (format "\\setcounter{tocdepth}{%d}\n" depth))
	  "\\tableofcontents\n"
	  "\\end{frame}\n\n")))
     ;; 12. Document's body.
     contents
     ;; 13. Creator.
     (let ((creator-info (plist-get info :with-creator)))
       (cond
	((not creator-info) "")
	((eq creator-info 'comment)
	 (format "%% %s\n" (plist-get info :creator)))
	(t (concat (plist-get info :creator) "\n"))))
     ;; 14. Document end.
     "\\end{document}")))
