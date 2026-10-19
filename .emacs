;; CustomFile
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; EzLifeFeatures
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq backward-delete-char-untabify-method 'nil)
(setq-default c-basic-offset 4)
(electric-pair-mode 1)
(defun my-insert-tab-literal ()
  (interactive)
  (insert "\t"))
(defun my-smart-tab-handler ()
  (interactive)
  (if (derived-mode-p 'python-mode 'python-ts-mode)
			(insert-char ?\s 4)
		(my-insert-tab-literal)))
(global-set-key (kbd "TAB") #'my-smart-tab-handler)

;; TreeSitter
(setq exec-path (append '("C:/w64devkit/bin" "C:/Program Files/Git/bin") exec-path))
(setenv "PATH" (concat "C:\\w64devkit\\bin;C:\\Program Files\\Git\\bin;" (getenv "PATH")))
(setq treesit-language-source-alist
      '((go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
        (gomod "https://github.com/camdencheek/tree-sitter-go-mod" "v1.0.2")
        (python "https://github.com/tree-sitter/tree-sitter-python" "v0.20.4")))
(use-package treesit-auto
  :ensure t
  :config
  (global-treesit-auto-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("/go\\.mod\\'" . go-mod-ts-mode))

;; Eglot
(use-package eglot
  :ensure nil
  :commands (eglot eglot-ensure)
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect 0)
  :hook
  ((python-mode . eglot-ensure)
   (python-ts-mode . eglot-ensure)
   (go-mode . eglot-ensure)
   (go-ts-mode . eglot-ensure)
   (protobuf-mode . eglot-ensure)
   (dart-mode . eglot-ensure)))

;; ProtobufFeatures
(use-package protobuf-mode
  :ensure t
  :mode "\\.proto\\'"
  :hook
  (protobuf-mode . (lambda ()
                     (setq-local indent-tabs-mode nil)
                     (setq-local tab-width 2)
                     (setq-local c-basic-offset 2))))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(protobuf-mode . ("buf" "lsp" "serve"))))

;; GolangFeatures
(defun my-go-indent-style ()
  (setq-local indent-tabs-mode t)
  (setq-local tab-width 4)
  (setq-local go-ts-mode-indent-offset 4))
(use-package go-mode
  :ensure t
  :mode "\\.go\\'"
  :custom
  (gofmt-command "goimports")
  :hook
  (go-mode . (lambda ()
               (my-go-indent-style)
               (add-hook 'before-save-hook #'gofmt-before-save nil t))))
(use-package go-ts-mode
  :ensure nil
  :mode "\\.go\\'"
  :custom
  (gofmt-command "goimports")
  :hook
  (go-ts-mode . (lambda ()
                  (my-go-indent-style)
                  (add-hook 'before-save-hook #'gofmt-before-save nil t))))

;; PythonFreatures
(setq completion-cycle-threshold 3)

;; Dart LSP
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(dart-mode . ("dart" "language-server" "--client-id" "emacs.eglot-dart"))))

;; Dart
(use-package dart-mode
  :ensure t
  :mode "\\.dart\\'"
  :hook
  (dart-mode . (lambda ()
                 (setq-local indent-tabs-mode nil)
                 (setq-local tab-width 2)
                 (setq-local c-basic-offset 2))))

;; DiscordActivity
(use-package elcord
  :ensure t
  :commands elcord-mode
  :init
  (elcord-mode 1))

;; Optimize&Appearance
(use-package mode-line-bell
  :ensure t
  :config
  (mode-line-bell-mode 1))
(setq native-comp-async-report-warnings-errors 'silent)
(setq byte-compile-warnings '(not unresolved))
(setq read-process-output-max (* 1024 1024))
(setq-default bidi-display-reordering nil)
(setq frame-resize-pixelwise t)
(setq default-frame-alist
      '((fullscreen . maximized)
	(vertical-scroll-bars . nil)
	(horizontal-scroll-bars . nil)
	(drag-internal-border . t)))
(setq-default cursor-type 'hbar)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(column-number-mode 1)
(setq inhibit-startup-screen t)
(setq mouse-highlight nil)
(setq make-pointer-invisible t)

;; Theme
(load-theme 'omtose-darker t)
;; CustomFile
(load (expand-file-name "time-in-emacs.el" user-emacs-directory) nil t)
(load custom-file 'noerror)
(put 'upcase-region 'disabled nil)
