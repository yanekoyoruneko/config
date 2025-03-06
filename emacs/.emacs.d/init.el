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
  (add-to-list 'load-path (emacs-path "lisp"))
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
  (menu-bar-mode t)
  (tool-bar-mode nil)
  (inhibit-startup-screen t)
  (scroll-bar-mode nil)
  (global-hl-line-mode 't)
  (ring-bell-function 'ignore)
  (make-backup-files nil)
  (create-lockfiles nil)
  (display-line-numbers-type 'relative)
  (column-number-mode t)
  :hook
  (prog-mode . display-line-numbers-mode)
  (prog-mode . prettify-symbols-mode))



;; BASIC
;;
(use-package emacs
  :delight
  (abbrev-mode " Abv" "abbrev")
  (subword-mode)
  :config
  (defun my-duplicate-line ()
    "Duplicate current line"
    (interactive)
    (let ((column (current-column)))
      (move-end-of-line 1)
      (newline)
      (copy-from-above-command)
      (move-beginning-of-line 1)
      (forward-char column)))
  (defun my-start-python-http-server ()
    (interactive)
    (shell-command "python3 -m http.server 3001 &"
                   "*Simple Python HTTP Server*"))
  (defun my-unfill-paragraph ()
    (interactive)
    (let ((fill-column most-positive-fixnum))
      (fill-paragraph)))
  (defun my-pretty-print-xml-region (begin end)
    "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
    (interactive "r")
    (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n") (setq end (1+ end)))
      (indent-region begin end))
    (message "Ah, much better!"))
  :bind
  ("<f12>"   . modus-themes-toggle)
  ("M-i"     . imenu)
  ("C-x C-k" . kill-current-buffer)
  ("C-c s"   . shell)
  ("C-c p"   . find-file-at-point)
  ("C-x C-k" . kill-this-buffer)
  ("C-x C-b" . ibuffer)
  ("C-?"     . undo-redo)
  ("C-/"     . undo-only)
  ("C-x p s" . my-start-python-http-server)
  ("C-,"     . my-duplicate-line)
  ("C-c M-q" . my-unfill-paragraph)
  :custom
  (nxml-slash-auto-complete-flag t)
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
  ;; (indent-tabs-mode nil)
  ;; (tab-width 4)
  ;; (c-basic-offset 4)
  ;; google formatting
  (load "google-c-style")
  (autoload 'google-set-c-style "google-c-style")
  (autoload 'google-make-newline-indent "google-c-style")
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  ;; (add-hook 'c-mode-common-hook 'google-make-newline-indent)
  :hook
  (before-save . delete-trailing-whitespace)
  (prog-mode   . abbrev-mode))



;;; COMPILE
(use-package compile
  :ensure nil
  :bind ("<f4>" . compile)
  :custom
  (compilation-scroll-output t)
  :init
  (require 'ansi-color)
  (defun colorize-compilation-buffer ()
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max))))
  :hook
  (compilation-filter . colorize-compilation-buffer))



;; WINDOWS
(use-package windmove :config (windmove-default-keybindings))
(use-package winner   :config (winner-mode))


;; (use-package corfu
;;   :ensure t
;;   :init
;;   (global-corfu-mode)  ;; Enable Corfu globally
;;   :custom
;;   (corfu-auto t)      ;; Automatically show completion popup
;;   (corfu-auto-delay 0.1) ;; Delay before showing completions
;;   (corfu-quit-no-match 'separator)
;;   (corfu-min-width 20) ;; Minimum width of completion popup
;;   (corfu-quit-at-boundary t)  ;; Don't close popup at buffer boundaries
;;   (corfu-preview-current t)     ;; Preview current completion
;;   :bind
;;   (:map corfu-map
;;         ("M-p" . corfu-scroll-up)    ;; Scroll up in completion list
;;         ("M-n" . corfu-scroll-down)  ;; Scroll down in completion list
;;         ("C-j" . corfu-select)       ;; Select current completion
;;         ("C-h" . corfu-doc)          ;; Show documentation in popup
;;         ("C-;" . corfu-clear)))   ;; Clear completions


(use-package emacs
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)
  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))


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
     (eglot (styles . (emacs22 substring))))))
;; :bind (:map completion-in-region-mode-map
;; 	      ("C-n" . minibuffer-next-completion)
;; 	      ("C-p" . minibuffer-previous-completion)
;; 	      ("C-j" . minibuffer-choose-completion)
;; 	      :map minibuffer-mode-map
;; 	      ("C-n" . minibuffer-next-completion)
;; 	      ("C-p" . minibuffer-previous-completion)))


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
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  (delete-by-moving-to-trash t)
  (dired-dwim-target t)
  (dired-auto-revert-buffer t)
  (dired-listing-switches "-alh --group-directories-first")
  (dired-kill-when-opening-new-dired-buffer t)
  (wdired-allow-to-change-permissions t)
  :config
  (require 'dired-x))

(use-package which-key
  :init
  (which-key-mode))

(use-package tramp
  :ensure nil
  :config
  (add-to-list 'tramp-connection-properties
               (list (regexp-quote "/ssh:") "remote-shell" "/bin/bash")))


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
;; (use-package eglot
;;   :delight (eldoc-mode nil "eldoc")
;;   :bind (:map eglot-mode-map
;; 	      ("C-c C-d" . eldoc)
;;               ("C-c r"   . eglot-rename)
;;               ("C-c f"   . eglot-format-buffer))
;;   :hook ((c-mode tuareg-mode python-mode java-mode) . eglot-ensure))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package cape
  :ensure t)

;; (defun my/eglot-capf ()
;;   (setq-local completion-at-point-functions
;;               (list (cape-super-capf
;;                      #'eglot-completion-at-point
;;                      (cape-company-to-capf #'company-yasnippet)))))

;; (add-hook 'eglot-managed-mode-hook #'my/eglot-capf)

(use-package lsp-mode
  :hook (java-mode . lsp)
  :ensure t)

(use-package company
  :ensure t)

(use-package lsp-java
  :ensure t)

(add-to-list 'load-path (emacs-path "lsp-docker"))
(require 'lsp-docker)
(defvar lsp-docker-client-packages
  '(lsp-css lsp-clients lsp-bash lsp-go lsp-pylsp lsp-html lsp-typescript
            lsp-terraform lsp-clangd))

(setq lsp-docker-client-configs
      '((:server-id bash-ls :docker-server-id bashls-docker :server-command "bash-language-server start")
        (:server-id clangd :docker-server-id clangd-docker :server-command "clangd")
        (:server-id css-ls :docker-server-id cssls-docker :server-command "css-languageserver --stdio")
        (:server-id gopls :docker-server-id gopls-docker :server-command "gopls")
        (:server-id html-ls :docker-server-id htmls-docker :server-command "html-languageserver --stdio")
        (:server-id pylsp :docker-server-id pyls-docker :server-command "pylsp")))

(require 'lsp-docker)
(lsp-docker-init-clients
 :path-mappings '(("/home/yan3k/doc" . "/projects"))
 :client-packages lsp-docker-client-packages
 :client-configs lsp-docker-client-configs)


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
