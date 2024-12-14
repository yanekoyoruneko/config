;;; init.el --- personal configuration                -*- lexical-binding: t; -*-
;;; Commentary:

;;            _____ __  __    _    ____ ____
;;           | ____|  \/  |  / \  / ___/ ___|
;;           |  _| | |\/| | / _ \| |   \___ \
;;           | |___| |  | |/ ___ \ |___ ___) |
;;           |_____|_|  |_/_/   \_\____|____/
;;
;;            Escape-Meta-Alt-Control-Shift

;;; Code:

;; SETUP
;;
(setq gc-cons-threshold most-positive-fixnum) ; fix gc
(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold (expt 2 23))))

(load "server")
(unless (server-running-p) (server-start))

(eval-when-compile
  (defun emacs-path (path) (expand-file-name path user-emacs-directory))
  (setq custom-file (emacs-path "custom.el"))
  (when (file-exists-p custom-file) (load custom-file)))

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa"  . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu"    . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package use-package
  :init
  (setq use-package-always-ensure t)
  (setq use-package-always-demand t)	; emacs server so load all at start
  (setq use-package-enable-imenu-support t))



;; UI
;;
(use-package delight)

(use-package emacs
  :custom
  (tramp-allow-unsafe-temporary-files t)
  (custom-enabled-themes '(modus-vivendi))
  (frame-title-format '("%b"))
  (menu-bar-mode nil)
  (tool-bar-mode nil)
  (inhibit-startup-screen t)
  (scroll-bar-mode nil)
  (global-hl-line-mode 't)
  (ring-bell-function 'ignore)
  (make-backup-files nil)
  (create-lockfiles nil)
  (display-line-numbers-type 'relative)
  :hook
  (prog-mode . display-line-numbers-mode)
  (prog-mode . prettify-symbols-mode))



;; BASIC
;;
(use-package emacs
  :delight
  (abbrev-mode " Abv" "abbrev")
  (subword-mode)
  :bind
  ("<f12>"   . modus-themes-toggle)
  ("M-i"     . imenu)
  ("C-c C-c" . compile)
  ("C-x C-k" . kill-current-buffer)
  ("C-c s"   . shell)
  ("C-c p"   . find-file-at-point)
  ("C-x C-k" . kill-this-buffer)
  ("C-x C-b" . ibuffer)
  ("C-?"     . undo-redo)
  ("C-/"     . undo-only)
  :custom
  (confirm-kill-processes nil)
  (vc-follow-symlinks t)
  (disabled-command-function nil)
  (browse-url-browser-function 'eww)	; usefull for hyperspec
  (global-subword-mode t)
  (delete-selection-mode t)
  (repeat-mode t)
  (savehist-mode t)
  (require-final-newline t)
  (save-place-mode t)
  (sentence-end-double-space nil)
  (global-auto-revert-mode t)
  (electric-pair-mode t)
  (tab-always-indent 'complete)
  (c-default-style "linux")
  :hook
  (before-save . delete-trailing-whitespace)
  (prog-mode   . abbrev-mode))



;; WINDOWS
(use-package windmove :config (windmove-default-keybindings))
(use-package winner   :config (winner-mode))



;; FILL
;;
(use-package emacs
  :delight
  (auto-fill-function " AF")
  :custom
  (fill-column 80)
  (comment-auto-fill-only-comments t)
  :hook
  (prog-mode   . display-fill-column-indicator-mode)
  (prog-mode   . auto-fill-mode))



;; MINIBUFFER
;;
(use-package minibuffer
  :ensure nil
  :custom
  (completions-format 'one-column)
  (completions-header-format nil)
  (completions-max-height 10)
  (completion-auto-select nil)
  (use-short-answers t)
  (enable-recursive-minibuffers t)
  (minibuffer-depth-indicate-mode t)
  (minibuffer-electric-default-mode t)
  (completion-show-help nil)
  (completions-detailed t)
  (completion-styles '(basic substring initials flex))
  (completion-category-overrides
   '((file (styles . (basic partial-completion)))
     (imenu (styles . (basic substring)))
     (eglot (styles . (emacs22 substring)))))
  :bind (:map completion-in-region-mode-map
	      ("C-n" . minibuffer-next-completion)
	      ("C-p" . minibuffer-previous-completion)
	      ("C-j" . minibuffer-choose-completion)
	      :map minibuffer-mode-map
	      ("C-n" . minibuffer-next-completion)
	      ("C-p" . minibuffer-previous-completion)))


(use-package icomplete
  :custom
  (fido-mode t)
  (fido-vertical-mode t))


;; RECENTF
;;
(use-package recentf
  :bind ("C-x C-r" . recentf-open-files)
  :custom (recentf-mode t))



;; EXPAND REGION
(use-package expand-region
  :bind ("M-2" . er/expand-region))


;; MAGIT
(use-package magit)


;; DIRED
;;
(use-package dired
  :ensure nil
  :bind ("C-x C-d" . dired)
  :custom
  (dired-dwim-target t)
  (dired-auto-revert-buffer t)
  (dired-listing-switches "-alh")
  :config
  (require 'dired-x))



;; IM BAD IN SPELING
;;
(use-package flyspell
  :bind
  ("C-c i b" . flyspell-buffer)
  ("C-c i f" . flyspell-mode)
  ;; :hook
  ;; (prog-mode . flyspell-prog-mode)
  ;; (text-mode . turn-on-flyspell)
  )


(use-package dabbrev
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :custom
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))


;; LSP
;;
(use-package eglot
  :delight (eldoc-mode nil "eldoc")
  :bind (:map eglot-mode-map
	      ("C-c C-d" . eldoc)
              ("C-c r"   . eglot-rename)
              ("C-c f"   . eglot-format-buffer))
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



;; IRC
;;
(use-package erc
  :custom
  (erc-server "irc.libera.chat")
  (erc-autojoin-mode t)
  (erc-user-full-name "yanekoYORUNEKO")
  (erc-nick "Yan3ku")
  (erc-autojoin-channels-alist '(("libera.chat" "#emacs")))
  (erc-kill-buffer-on-part t)
  (erc-join-buffer 'buffer)
  (erc-auto-query 'bury)
  :hook
  (erc-mode . erc-spelling-mode))


(use-package eww
  :custom (eww-auto-rename-buffer t))


;; LISP
;;
(use-package highlight-quoted
  :hook ((emacs-lisp-mode lisp-mode) . highlight-quoted-mode))

(use-package easy-escape
  :delight (easy-escape-minor-mode)
  :hook ((lisp-mode-hook emacs-lisp-mode) . easy-escape-minor-mode))

(use-package paredit
  :delight
  :hook (((emacs-lisp-mode lisp-mode sly-mode) . paredit-mode)
	 (sly-mrepl-mode . (lambda () (unbind-key "RET" 'paredit-mode-map)))))

(use-package rainbow-delimiters
  :hook
  ((emacs-lisp-mode ielm-mode lisp-interaction-mode lisp-mode slime-repl-mode) .
   rainbow-delimiters-mode))

(use-package aggressive-indent
  :hook ((emacs-lisp-mode lisp-mode) . aggressive-indent-mode))

(use-package sly
  :bind ("C-c C-z" . inferior-lisp)
  :custom
  (inferior-lisp-program "sbcl --noinform"))



;; OCAML
;;
(use-package utop
  :custom (utop-command "dune utop . -- -emacs")
  :hook   (tuareg-mode . utop-minor-mode))
(use-package merlin :hook (tuareg-mode . merlin-mode))
(use-package tuareg)


;;; init.el ends here
