;;; .emacs --- personal configuration                -*- lexical-binding: t; -*-

;; Everyone is permitted to do whatever they like with this software
;; without limitation.  This software comes without any warranty
;; whatsoever, but with two pieces of advice:
;; - Be kind to yourself.
;; - Make good choices.

;;; Commentary:

;;            _____ __  __    _    ____ ____
;;           | ____|  \/  |  / \  / ___/ ___|
;;           |  _| | |\/| | / _ \| |   \___ \
;;           | |___| |  | |/ ___ \ |___ ___) |
;;           |_____|_|  |_/_/   \_\____|____/
;;
;;            Escape-Meta-Alt-Control-Shift

;;; Code:
;; SETUP ;;
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold (expt 2 23))))

(eval-when-compile
  (defun emacs-path (path) (expand-file-name path user-emacs-directory))
  (setq custom-file (emacs-path "custom.el"))
  (load custom-file))


(use-package use-package
  :init
  (setq use-package-always-ensure t)
  (setq use-package-enable-imenu-support t))


(use-package emacs			; basics
  :custom
  (frame-title-format '("%b"))
  (menu-bar-mode nil)
  (tool-bar-mode nil)
  (inhibit-startup-screen t)
  (scroll-bar-mode nil)
  (global-hl-line-mode t)
  (ring-bell-function 'ignore)
  (make-backup-files nil)
  (create-lockfiles nil))


(use-package emacs
  :bind
  ("<f12>"   . modus-themes-toggle)
  ("C-\\"    . indent-region)
  ("M-i"     . imenu)
  ("C-c C-c" . compile)
  ("C-x C-k" . kill-current-buffer)
  ("C-c p"   . find-file-at-point)
  ("C-x C-b" . ibuffer)
  ("C-x C-d" . dired)
  ("C-c C-d" . eldoc)
  ("C-x C-r" . recentf-open-files)
  ("C-?"     . undo-redo)
  ("C-/"     . undo-only)
  :config
  (windmove-default-keybindings)
  (winner-mode)
  :custom
  (vc-follow-symlinks t)
  (disabled-command-function nil)
  (custom-enabled-themes '(modus-vivendi))
  (browse-url-browser-function 'eww)	; usefull for hyperspec
  (global-subword-mode t)
  (fill-column 80)
  (delete-selection-mode t)
  (repeat-mode t)
  (comment-auto-fill-only-comments t)
  (recentf-mode t)
  (savehist-mode t)
  (require-final-newline t)
  (save-place-mode t)
  (sentence-end-double-space nil)
  (global-auto-revert-mode t)
  (electric-pair-mode t)
  (display-line-numbers-type 'relative)
  (tab-always-indent 'complete)
  (c-default-style "linux")
  (package-archives
   '(("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  :hook
  (before-save . delete-trailing-whitespace)
  (prog-mode   . display-line-numbers-mode)
  (prog-mode   . display-fill-column-indicator-mode)
  (prog-mode   . auto-fill-mode)
  (prog-mode   . prettify-symbols-mode)
  (prog-mode   . abbrev-mode))


(use-package minibuffer
  :ensure nil
  :custom
  (read-answer-short t)
  (use-short-answers t)
  (enable-recursive-minibuffers t)
  (minibuffer-depth-indicate-mode t)
  (minibuffer-electric-default-mode t)
  (completion-show-help nil)
  (completions-detailed t)
  (completions-max-height 6)
  (completion-styles '(basic substring initials flex))
  (completion-category-overrides
   '((file (styles . (basic partial-completion)))
     (imenu (styles . (basic substring)))
     (eglot (styles . (emacs22 substring))))))


(use-package icomplete
    :custom
    (fido-mode t)
    (fido-vertical-mode t))


(use-package dabbrev
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :custom
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))


(use-package erc
  :custom
  (erc-server "irc.libera.chat")
  ;; (erc-autojoin-mode t)
  (erc-user-full-name "Yanek Sakura")
  (erc-nick "Yan3ku")
  (erc-autojoin-channels-alist '(("libera.chat" "#emacs")))
  (erc-kill-buffer-on-part t)
  (erc-join-buffer 'buffer)
  (erc-auto-query 'bury)
  :hook
  (erc-mode . erc-spelling-mode))


(use-package flyspell
  :bind
  ("C-c i b" . flyspell-buffer)
  ("C-c i f" . flyspell-mode)
  ;; :hook
  ;; (prog-mode . flyspell-prog-mode)
  ;; (text-mode . turn-on-flyspell)
  )


(use-package eglot
  :bind (:map eglot-mode-map
              ("C-c r" . eglot-rename)
              ("C-c f" . eglot-format-buffer))
  :hook ((c-mode tuareg-mode python-mode) . eglot-ensure))


(use-package flymake
  :bind
  (("M-n" . flymake-goto-next-error)
   ("M-p" . flymake-goto-prev-error))
  ;; I cannot remember the names of the diagnostics commands
  :config
  (defalias 'list-issues     'flymake-show-buffer-diagnostics)
  (defalias 'list-all-issues 'flymake-show-project-diagnostics)
  :hook prog-mode)


;;;;;;;;
;; OCaml
;;;;;;;;
(use-package utop
  :custom (utop-command "dune utop . -- -emacs")
  :hook   (tuareg-mode . utop-minor-mode))
(use-package merlin :hook (tuareg-mode . merlin-mode))
(use-package tuareg)

;;;;;;;;
;; Lisp
;;;;;;;;
(use-package sly
  :custom
  (inferior-lisp-program "sbcl"))

(use-package rainbow-delimiters
  :hook
  ((emacs-lisp-mode ielm-mode lisp-interaction-mode lisp-mode slime-repl-mode) .
   rainbow-delimiters-mode))

;;; init.el ends here
