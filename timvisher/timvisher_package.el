;;; ----------------------------------------------------------------------------
;;; Let's set up elpa, because it makes Emacs a more civilized place to live.
;;; ----------------------------------------------------------------------------

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/")
             t)
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar timvisher/my-packages '(ag
                                better-defaults
                                dash
                                dash-functional
                                deft
                                elisp-slime-nav
                                expand-region
                                ;; TODO Try helm out in a few months when it's a little more stable.
                                ;; helm
                                idle-highlight-mode
                                ido-ubiquitous
                                magit
                                markdown-mode
                                paredit
                                pbcopy
                                sensitive
                                smartparens
                                smex
                                textmate
                                ;; todochiku
                                vimgolf
                                wgrep
                                yasnippet))

(defun timvisher/install-package-list (package-list)
  (dolist (p package-list)
    (when (not (package-installed-p p))
      (package-install p))))

;; (timvisher/install-package-list timvisher/my-packages)

