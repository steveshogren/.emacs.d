(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(require 'info)
(add-to-list 'Info-directory-list (concat (getenv "HOME") "/.emacs.d/info"))

(require 'dired-x)

(setq send-mail-function 'mailclient-send-it)
(setq message-send-mail-function 'message-send-mail-with-mailclient)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar timvisher/my-packages '(clojure-mode
                      ;; clojure-test-mode
                      deft
                      elein
                      elisp-slime-nav
                      furl
                      idle-highlight-mode
                      ido-ubiquitous
                      magit
                      markdown-mode
                      maxframe
                      smex
                      paredit
                      find-file-in-project
                      starter-kit
                      starter-kit-bindings
                      starter-kit-eshell
                      starter-kit-lisp
                      textmate
                      vimgolf))

(dolist (p timvisher/my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-to-list 'load-path "~/.emacs.d/site-lisp")

(eval-after-load 'winner
  (global-set-key (kbd "C-c [") 'winner-undo))
(eval-after-load 'winner
  (global-set-key (kbd "C-c ]") 'winner-redo))

(eval-after-load "markdown"
  '(define-key markdown-mode-map (kbd "C-j") 'markdown-enter-key))

(eval-after-load "deft"
  '(defun timvisher/journal ()
     "Grab a new deft file and populate it with a joural entry for right now"
     (interactive)
     (select-frame-set-input-focus (make-frame))
     (deft-new-file)
     (visual-line-mode 1)
     (insert "journal entry " (format-time-string "%Y%m%d%H%M%S") "

")
     (local-set-key (kbd "C-c C-q") 'delete-frame)))

(defun timvisher/copy-buffer-and-kill-frame ()
  (interactive)
  (kill-ring-save (point-min) (point-max))
  (delete-frame))

(eval-after-load "deft"
  '(defun timvisher/kill-ring-deft ()
     "Make a new deft file and yank the kill ring into it"
     (interactive)
     (select-frame-set-input-focus (make-frame))
     (deft-new-file)
     (visual-line-mode 1)
     (yank)
     (goto-char (point-min))
     (insert "

")
     (goto-char (point-min))
     (local-set-key (kbd "C-c C-q") 'timvisher/copy-buffer-and-kill-frame)))

(defun timvisher/lein-server ()
  (interactive)
  (let* ((process-name "lein-server")
         (process (get-process process-name))
         (current-directory default-directory)
         (lein-home (locate-dominating-file default-directory "project.clj")))
    (progn
      (if process (delete-process process))
      (cd lein-home)
      (start-process process-name "*lein server*" "lein" "ring" "server")
      (cd current-directory))))

(defun timvisher/position-in-line ()
  (save-excursion
    (let ((current-position (point)))
      (beginning-of-line)
      (- current-position (point)))))

(defun timvisher/drag-up ()
  (interactive)
  (let ((timvisher/position-in-line (timvisher/position-in-line)))
    (beginning-of-line)
    (kill-visual-line 1)
    (previous-line)
    (yank)
    (beginning-of-line)
    (previous-line)
    (goto-char (+ (point) timvisher/position-in-line))))

(defun timvisher/drag-down ()
  (interactive)
  (let ((timvisher/position-in-line (timvisher/position-in-line)))
    (beginning-of-line)
    (kill-visual-line)
    (next-line)
    (yank)
    (previous-line)
    (goto-char (+ (point) timvisher/position-in-line))))

;; Yegge
(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((not (= (count-windows) 2)) (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1)))))

;; Yegge
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; Yegge
(defun move-buffer-file (dir)
  "Moves both current buffer and file it's visiting to DIR."
  (interactive "DNew directory: ")
  (let* ((name (buffer-name))
         (filename (buffer-file-name))
         (dir
          (if (string-match dir "\\(?:/\\|\\\\)$")
              (substring dir 0 -1) dir))
         (newname (concat dir "/" name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (progn
        (copy-file filename newname 1)
        (delete-file filename)
        (set-visited-file-name newname)
        (set-buffer-modified-p nil)
        t))))
(global-set-key (kbd "<M-s-down>") 'timvisher/drag-down)
(global-set-key (kbd "<M-s-up>") 'timvisher/drag-up)

;; aliases

(defalias 'qrr 'query-replace-regexp) ;; Yegge
(defalias 's 'ispell)
(defalias 'mdf 'timvisher/kill-ring-deft)

;; keys

(defun kmacro-edit-lossage ()
  "Edit most recent 300 keystrokes as a keyboard macro."
  (interactive)
  (kmacro-push-ring)
  (edit-kbd-macro 'view-lossage))

(global-set-key (kbd "M-h") 'backward-kill-word)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-h") 'backward-delete-char-untabify)

(defun timvisher/map-custom-paredit-keys ()
  (define-key paredit-mode-map (kbd "C-h") 'paredit-backward-delete)
  (define-key paredit-mode-map (kbd "M-h") 'paredit-backward-kill-word)
  (define-key paredit-mode-map (kbd "{") 'paredit-open-curly)
  (define-key paredit-mode-map (kbd "}") 'paredit-close-curly)
  (define-key paredit-mode-map (kbd "[") 'paredit-open-square)
  (define-key paredit-mode-map (kbd "]") 'paredit-close-square))

(defun timvisher/turn-on-eldoc () (eldoc-mode 1))

(defun timvisher/turn-on-clojure-test () (clojure-test-mode 1))

(defun timvisher/turn-on-elein ()
  (unless (featurep 'elein)
    (require 'elein)))

(eval-after-load 'paredit
  '(timvisher/map-custom-paredit-keys))

(eval-after-load 'clojure-mode
  '(add-hook 'clojure-mode-hook 'timvisher/turn-on-eldoc))
(eval-after-load 'clojure-mode
  '(add-hook 'clojure-mode-hook 'timvisher/turn-on-elein))
;;; Sadly clojure-test-mode currently requires slime which messes with clojure-jack-in. Figure this out at some point.
;; (eval-after-load 'clojure-mode '(add-hook 'clojure-mode-hook 'timvisher/turn-on-clojure-test))

(defun timvisher/fix-slime-repl-lisp-indent-function () (setq lisp-indent-function 'clojure-indent-function))
(defun timvisher/fix-slime-repl-syntax-table () (set-syntax-table clojure-mode-syntax-table))
(defun timvisher/turn-on-paredit () (paredit-mode 1))

(defun timvisher/fix-slime-repl ()
  (add-hook 'slime-repl-mode-hook 'timvisher/fix-slime-repl-lisp-indent-function)
  (add-hook 'slime-repl-mode-hook 'timvisher/fix-slime-repl-syntax-table)
  (add-hook 'slime-repl-mode-hook 'timvisher/turn-on-paredit))

(eval-after-load 'slime
  '(timvisher/fix-slime-repl))

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.todo$" . org-mode))

(global-set-key (kbd "<f1> r") 'info-emacs-manual)

(put 'set-goal-column 'disabled nil)

(setq whitespace-style '(trailing
                         space-before-tab
                         face
                         indentation
                         space-after-tab))

;;; Make re-builder copy just the text without the `"` characters.
(defun reb-copy ()
  "Copy current RE into the kill ring for later insertion."
  (interactive)

  (reb-update-regexp)
  (let ((re (with-output-to-string
              (print (reb-target-binding reb-regexp)))))
    (kill-new (substring re 2 (- (length re) 2)))
    (message "Regexp copied to kill-ring")))

(defun timvisher/turn-on-textmate-mode ()
  (textmate-mode 1))

(defun timvisher/turn-on-subword-mode ()
  (subword-mode 1))

(add-hook 'prog-mode-hook 'hs-minor-mode)
(add-hook 'prog-mode-hook 'timvisher/turn-on-textmate-mode)
(add-hook 'prog-mode-hook 'glasses-mode)
(add-hook 'prog-mode-hook 'whitespace-mode)
(add-hook 'applescript-mode-hook 'run-prog-mode-hook)
(remove-hook 'text-mode-hook 'turn-on-auto-fill)
(remove-hook 'text-mode-hook 'turn-on-flyspell)
(remove-hook 'prog-mode-hook 'esk-local-comment-auto-fill)
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)
(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'text-mode-hook 'whitespace-mode)

(fset 'vimgolf-harvest
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217788 25 67108896 134217790 23 134217788 67108896 5 134217847 1 19 115 116 97 114 116 32 102 105 108 101 1 16 134217848 97 112 45 116 45 102 13 118 105 109 9 21 24 113 32 25 46 112 114 101 115 101 110 116 97 116 105 111 110 46 109 100 13 14 14 14 19 101 110 100 32 102 105 108 101 1 134217848 97 112 45 116 45 102 13 118 105 109 9 21 24 113 9 134217832 134217832 115 116 97 114 116 46 21 24 113 13 134217848 97 112 45 116 45 102 13 118 105 109 9 21 24 113 9 119 111 114 107 46 21 24 113 13 14 14 67108896 134217790 134217848 97 112 45 116 45 102 13 118 105 109 9 21 24 113 9 101 110 100 46 21 24 113 13 134217788 82 101 115 101 97 114 99 104 32 86 105 109 71 111 108 102 32 105 110 32 69 109 97 99 115 32 48 21 24 113 32 5 32 35 64 119 101 98 32 64 104 111 109 101 32 104 116 116 112 58 47 47 118 105 109 103 111 108 102 134217826 106 46 109 112 47 5 48 21 24 113 1 11 11 25 25 25 16 16 134217828 82 101 99 111 114 100 14 1 134217828 80 117 98 108 105 115 104 134217788 67108896 14 14 14 134217848 97 112 45 116 45 98 13 118 105 109 103 9 13] 0 "%d")) arg)))

;;; If you get the dreaded ~/.emacs.d/server is not safe error on
;;; Windows. ~/.emacs.d/server -> Properties -> Security -> Advanced
;;; -> Owner and then set it to you.
(require 'server)
(unless (server-running-p) (server-start))

(maximize-frame)

;;; Customizations

;;; Make system and user specific emacs temp files
(setq eshell-history-file-name (concat (getenv "HOME") "/.emacs.d/eshell/" system-name "-history"))

(setq redisplay-dont-pause t)
(put 'narrow-to-region 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(backup-directory-alist (\` (("." \, (concat (getenv "HOME") "/.emacs.d/" system-name "-backups")))))
 '(c-mode-common-hook (quote (timvisher/turn-on-subword-mode)))
 '(column-number-mode t)
 '(css-indent-offset 3)
 '(custom-enabled-themes (quote (solarized-light)))
 '(custom-safe-themes (quote ("91f2c4c623100a649cde613e8336eaa2ee144104" "62b81fe9b7d13eef0539d6a0f5c0c37170c9e248" "5600dc0bb4a2b72a613175da54edb4ad770105aa" "0174d99a8f1fdc506fa54403317072982656f127" default)))
 '(custom-theme-directory "~/.emacs.d/site-lisp/themes")
 '(deft-directory "")
 '(deft-extension "md")
 '(deft-text-mode (quote markdown-mode))
 '(dired-dwim-target t)
 '(dired-recursive-copies (quote always))
 '(dired-recursive-deletes (quote always))
 '(dired-use-ls-dired (quote unspecified))
 '(elein-lein "lein")
 '(erc-autojoin-channels-alist (quote (("freenode.net" "#clojure" "#emacs"))))
 '(erc-autojoin-delay 30)
 '(erc-autojoin-mode t)
 '(erc-autojoin-timing (quote ident))
 '(erc-email-userid "tim.visher@gmail.com")
 '(erc-enable-logging (quote erc-log-all-but-server-buffers))
 '(erc-log-channels-directory "~/Dropbox/log")
 '(erc-log-mode t)
 '(erc-log-write-after-insert t)
 '(erc-nick "timvisher")
 '(erc-nick-notify-cmd "notify")
 '(erc-nickserv-passwords (quote ((freenode (("timvisher" . "rideon"))))))
 '(erc-prompt-for-nickserv-password nil)
 '(erc-prompt-for-password nil)
 '(erc-save-queries-on-quit t)
 '(erc-services-mode t)
 '(erc-user-full-name "Tim Visher")
 '(find-ls-option (quote ("-print0 | xargs -0 ls -ld" . "-ld")))
 '(global-hl-line-mode nil)
 '(grep-find-ignored-directories (quote ("SCCS" "RCS" "CVS" "MCVS" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "target")))
 '(grep-find-template "find . <X> -type f <F> -exec grep <C> -nH <R> {} ;")
 '(ido-ubiquitous-command-exceptions (quote (unhighlight-regexp)))
 '(ido-ubiquitous-mode t)
 '(indent-tabs-mode nil)
 '(inferior-lisp-program "lein repl")
 '(inhibit-startup-screen nil)
 '(js-indent-level 2)
 '(mouse-avoidance-mode (quote banish) nil (avoid))
 '(save-place-file (concat (getenv "HOME") "/.emacs.d/" system-name ".places"))
 '(sentence-end-double-space nil)
 '(solarized-contrast (quote high))
 '(sql-ms-options (quote ("-w" "15000" "-n")))
 '(sql-ms-program "osql")
 '(tab-width 2)
 '(text-mode-hook (quote (whitespace-mode text-mode-hook-identify)))
 '(transient-mark-mode nil)
 '(user-mail-address "tim.visher@gmail.com")
 '(visual-line-fringe-indicators (quote (left-curly-arrow right-curly-arrow)))
 '(winner-dont-bind-my-keys t)
 '(winner-mode t nil (winner)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-item-highlight ((t (:inherit hl-line))))
 '(whitespace-indentation ((t (:inherit highlight :foreground "#e9e2cb"))))
 '(widget-field ((t (:inherit hl-line :box (:line-width 1 :color "#52676f"))))))
(put 'upcase-region 'disabled nil)
