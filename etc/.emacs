;;---------------------------------------------------------------------------
;; .emacs written by Edouard Gomez
;;
;; Any kind of copy/modification is allowed
;;
;; This .emacs file is valid for emacs >= 21
;;
;;---------------------------------------------------------------------------

;;---------------------------------------------------------------------------
;; Mes modes C suivant les projets
;;---------------------------------------------------------------------------

;; My standard C mode
;; Very basic
(defun my-c-mode ()
"Personal C mode flavor."
(interactive)
(c-set-style "K&R")
(setq c-basic-offset 4)
(setq indent-tabs-mode nil)
(turn-on-follow-mode)
(setq truncate-lines t)
(setq make-backup-files nil)
(setq column-number-mode t)
)

(defun rawstudio-c-mode ()
"C mode with defaults described in the rawstudio's CodingStyle."
(interactive)
(c-mode)
(message "Loading rawstudio-c-mode")
(setq mode-name "Rawstudio C")
(c-set-style "K&R")
(setq c-basic-offset 4)
(setq indent-tabs-mode t tab-width 4)
(turn-on-follow-mode)
(setq truncate-lines t)
(setq make-backup-files nil)
(setq column-number-mode t)
)

(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (message "Loading linux-c-mode")
  (setq mode-name "Linux Kernel C")
  (c-set-style "K&R")
  (setq c-basic-offset 8)
  (setq indent-tabs-mode t tab-width 8)
  (turn-on-follow-mode)
  (setq truncate-lines t)
  (setq make-backup-files nil)
  (setq column-number-mode t)
)

;; Bind icorrect C mode depending on the file location
(setq auto-mode-alist (cons '("/.*/rawstudio.*/.*\\.[ch]$" . rawstudio-c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("/.*/linux/.*\\.[ch]$" . linux-c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("/.*/r16dev\-lichee\-kernel/.*\\.[ch]$" . linux-c-mode) auto-mode-alist))

;; At least load the base c-mode customization with any c file
(add-hook 'c-mode-common-hook 'my-c-mode)

;;---------------------------------------------------------------------------
;; Ediff customization
;;---------------------------------------------------------------------------

(add-hook 'ediff-load-hook
	  '(lambda ()
	     (setq ediff-split-window-function 'split-window-horizontally)))

;;---------------------------------------------------------------------------
;; Modules path
;;---------------------------------------------------------------------------

;;(setq load-path (cons "~/.emacs.d/" load-path))

;;---------------------------------------------------------------------------
;; Writing mail with emacs
;;---------------------------------------------------------------------------

;; post.el is required (http://astro.utoronto.ca/~reid/mutt/)
;;(require 'post)

;; Add this hook to conform to RFC 1855 when writing emails
;;(add-hook 'post-mode-hook
;;	  '(lambda () (setq fill-column 72)))

;; Signature removing disabled
;;(setq post-kill-quoted-sig nil)

;;(setq auto-mode-alist (cons '(".*mutt.*$" . post-mode) auto-mode-alist))

;;---------------------------------------------------------------------------
;; Emacs' look (uses iso 15 for euro support)
;;---------------------------------------------------------------------------

(setq initial-frame-alist
      '(
	(width . 80)
	(height . 30)
	(cursor-color . "#ff0000")
	(cursor-type . box)
;;	(font . "-misc-fixed-medium-r-normal-*-14-*-*-*-c-*-*")
	(font . "Monospace 10")
	)
      )
(if window-system 
    (setq initial-frame-alist (cons '(background-color  . "#ddeedd") initial-frame-alist)))

(setq default-frame-alist initial-frame-alist)

;;---------------------------------------------------------------------------
;; Turn on the mouse's wheel
;;---------------------------------------------------------------------------

(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

;;---------------------------------------------------------------------------
;; The rest of the settings
;;---------------------------------------------------------------------------

;; No startup screen
(setq inhibit-startup-message t)

;; Pas de backups
(setq make-backup-files nil)

;; Highlight systematique
(global-font-lock-mode t)

;; No toolbar
(setq tool-bar-mode nil)

;; Higlight the selected region
(setq transient-mark-mode t)

;; Truncate the lines (on screen)
(setq truncate-lines t)

;; Line et column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; No scrollbars
(setq scroll-bar-mode nil)

;; No audio beep
(setq visible-bell t)

;; Time in the status bar
(display-time)

;; 24 hour format
(setq display-time-24hr-format t)

;; European environment
;;(set-language-environment 'Latin-9)
;;(set-keyboard-coding-system 'latin-1)
;;(set-terminal-coding-system 'latin-1)

;; spell is aspell
(setq-default ispell-program-name "aspell")

;; Bind f5 to 'set-justification-full' in text-mode
(add-hook 'text-mode-hook
	  '(lambda() (interactive)
	     (define-key text-mode-map [(f5)]
	       'set-justification-full)
	     ))

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Remove my email address function (useful when posting tla changelogs)
(defun wipe-my-email ()
  (interactive)
  (replace-match "Edouard Gomez <ed.gomez@free.fr>" "                                " )
)

; Make sure remote connections have backspace well defined
(global-set-key "\C-h" 'backward-delete-char)
