;;; <f1> should be the only way to access help, because C-h is better bound to backward-delete-char-untabify
(define-key isearch-mode-map (kbd "C-h") 'isearch-delete-char)

(defun timvisher/fix-smex ()
  (define-key ido-completion-map (kbd "<f1> f") 'smex-describe-function)
  (define-key ido-completion-map (kbd "<f1> w") 'smex-where-is)
  (define-key ido-completion-map (kbd "C-h") 'delete-backward-char))

(add-hook 'ido-setup-hook 'timvisher/fix-smex)

(define-key isearch-mode-map (kbd "<f1>") 'isearch-help-map)

;; magit needs to be at our finger tips

(global-set-key (kbd "C-c g") 'magit-status)

;;; smex… so good…

(global-set-key (kbd "M-x") 'smex)

;;; burry buffer should be readily availably

(global-set-key (kbd "C-c y") 'bury-buffer)
