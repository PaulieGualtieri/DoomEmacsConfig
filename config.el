;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "monospace" :size 24 :weight 'semi-light))
;;(set-face-attribute 'default nil :font "Fira Code Retina" :height 180)
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

(use-package! org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("◼","◼","◼")))

(use-package! org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
(use-package! vterm
  :ensure t)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(use-package! lsp-metals)

(setq projectile-project-search-path '("~/programming/"))


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(require 'package)

;; Add melpa to your packages repositories
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; Enable defer and ensure by default for use-package
;; Keep auto-save/backup files separate from source code:  https://github.com/scalameta/metals/issues/1027
(setq use-package-always-defer t
      use-package-always-ensure t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Enable scala-mode for highlighting, indentation and motion commands
(use-package scala-mode
  :interpreter
    ("scala" . scala-mode))

;; Enable sbt mode for executing sbt commands
(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
   (setq sbt:program-options '("-Dsbt.supershell=false"))
)
;; command log mode

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook  (scala-mode . lsp)
         (lsp-mode . lsp-lens-mode)
  :config (setq lsp-prefer-flymake nil))

;; Add metals backend for lsp-mode
(use-package lsp-metals
  :config (setq lsp-metals-treeview-show-when-views-received t))

;; Enable nice rendering of documentation on hover
(use-package lsp-ui)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;;   to avoid odd behavior with snippets and indentation
(use-package yasnippet)

;; Add company-lsp backend for metals
(use-package company-lsp)

;; Use the Debug Adapter Protocol for running tests and debugging
(use-package posframe
  ;; Posframe is a pop-up tool that must be manually installed for dap-mode
  )
(use-package dap-mode
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode)
  )
(after! org
  (setq org-todo-keywords
        `((sequence  "REPEAT(r)" "TODO(t)" "NEXT(n)" "PROJ(p)"  "WAITING(w@/!)" "SOMEDAY(s)" "|" "DONE(d)" "CANCELLED(c)" "POSTPONED(p@/!)"))))
(after! org
  (setq org-tag-alist '((:startgroup . nil)
                        ("UNIVERSITY" . ?u)
                        ("WORKSTATION" . ?w)
                        ("PROJECT" . ?p)
                        ("CAPGEMINI" . ?c)
                        )))
(after! org
  (setq org-archive-location "%s_archive::"))
(setq org-columns-default-format
      "%25ITEM %TODO %3PRIORITY %SCHEDULED")

(defun org-focus-university() "Set focus to university related stuff(including bachelor's work)"
       (interactive)
       (setq org-agenda-files '("~/Dropbox/org/inzynierka.org" "~/Dropbox/org/university.org")))

(defun org-focus-all() "Set focus to all"
       (interactive)
       (setq org-agenda-files '("~/Dropbox/org/" "~/Dropbox/org/stuff/")))
(defun org-focus-programming() "Set focus to programming stuff only"
       (interactive)
       (setq org-agenda-files '("~/Dropbox/org/programmingStuff.org")))

(defun org-focus-capgemini() "Set focus to capgemini stuff only"
       (interactive)
       (setq org-agenda-files '("~/Dropbox/org/capgemini.org")))
(defun org-focus-private() "Set focus to private stuff"
       (interactive)
       (setq org-agenda-files '("~/Dropbox/org/trening.org" "~/Dropbox/org/linuxStuff.org" "~/Dropbox/org/emacs.org" "~/Dropbox/org/macStuff.org" "~/Dropbox/org/private.org" "~/Dropbox/org/house.org" "~/Dropbox/org/books.org" "~/Dropbox/org/food.org" "~/Dropbox/org/rozrywka.org")))


(use-package org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups '((:name "Today"
                                        :time-grid t
                                        :scheduled today)
                                  (:name "Due today"
                                        :deadline today)
                                  (:name "Important"
                                        :priority "A")
                                  (:name "Overdule"
                                        :deadline past)
                                  (:name "Due soon"
                                        :deadline future)
                                  (:name "Big Outcomes"
                                        :tag "bo")))
  :config
  (org-super-agenda-mode)
                    )

;; typescript
(require 'tide)

 (defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

