;;; System specific deft-directory location.
(eval-after-load "deft" '(setq deft-directory (concat (getenv "HOME") "/Dropbox/deft notes/")))

;;; ----------------------------------------------------------------------------
;;; Let's set up the some system variables
;;; ----------------------------------------------------------------------------

;; (setq exec-path (split-string (getenv "PATH") ":"))
;; (setq exec-path (append (list (concat (getenv "HOME") "/.gem/ruby/1.8/bin"))
;;                         (let ((brew-home "/usr/local"))
;;                           (list (concat brew-home "/bin")
;;                                 (concat brew-home "/sbin")))
;;                         exec-path))

;; (dolist (variable '("PATH" "EMACSPATH"))
;;   (setenv variable "")
;;   (dolist (value exec-path)
;;     (setenv variable
;;             (concat (getenv variable) value ":")))
;;   (setenv variable (substring (getenv variable) 0 -1)))

;; (setq exec-path (append (list (concat (getenv "HOME") "/.lein/bin")
;;                               (concat (getenv "HOME") "/bin")
;;                               (let ((brew-gnu-prefix (shell-command-to-string "brew --prefix coreutils")))
;;                                 (concat (substring brew-gnu-prefix 0 (1- (length brew-gnu-prefix))) "/libexec/gnubin")))
;;                         exec-path))

;; (dolist (variable '("PATH" "EMACSPATH"))
;;   (setenv variable "")
;;   (dolist (value exec-path)
;;     (setenv variable
;;             (concat (getenv variable) value ":")))
;;   (setenv variable (substring (getenv variable) 0 -1)))

;;; ----------------------------------------------------------------------------
;;; Start up default processes
;;; ----------------------------------------------------------------------------

(setq erc-nick "ttimvisher")

;;; Always run ERC on my mac.
(condition-case nil
    (erc :server "irc.freenode.net" :nick erc-nick)
  (error "Failed to connect to IRC!"))

