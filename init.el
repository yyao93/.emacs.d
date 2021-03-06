;; Clean up the menu bar
(setq inhibit-startup-message t)
(scroll-bar-mode -1) ; disable visible scroll bar
(tool-bar-mode -1) ; disable toolbar
(tooltip-mode -1) ; disable tooltips
(set-fringe-mode 10) ; give some breathing room
;; toggle full screen
(set-frame-parameter nil 'fullscreen 'fullboth)
(menu-bar-mode -1) ; disable menubar
(load-theme 'tango-dark t)
;;(set-face-attribute 'default nil :font "monaco" :height 125)
(set-face-attribute 'default nil :height 125)

;; disable line numbers for some mode
(dolist (mode '(vterm-mode-hook
		treemacs-mode-hook
		shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "http://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/") ;; update org in time
			 ("gnu" . "http://elpa.gnu.org/packages/");; I am using this mirror to test spinner 1.7
			 ("elpa" . "https://elpa.gnu.org/packages"))) 

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper))
  :config
  (setq ivy-use-virtual-buffers t
	ivy-count-format "%d/%d ")
  (ivy-mode 1))
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; don't start searches with ^
;; (use-package helm
;;   :demand t
;;   :bind ("M-x" . helm-M-x)
;;   :config (helm-mode 1)
;;   )
;; (setq helm-display-function 'helm-display-buffer-in-own-frame)

;; fancy mode line
(use-package all-the-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 10)))

;; fancy theme
;;(use-package doom-themes)

;; line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
;; Disable line numbers for some modes:
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; rainbow in programming
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; which key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.2))
(global-set-key (kbd "C-h f") #'helpful-callable)

(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)
;; ;; better emacs help
;; (use-package helpful
;;   :custom
;;   (counsel-describe-function-function #'helpful-callable)
;;   (counsel-describe-function-function #'helpful-variable)
;;   :bind
;;   ([remap describe-function] . counsel-describe-function)
;;   ([remap describe-command] . helpful-command)
;;   ([remap describe-variable] . counsel-describe-variable)
;;   ([remap describe-key] . helpful-key))

;; Key Bindings
(global-set-key (kbd "C-x C-o") 'other-window)
(global-set-key (kbd "s-r") 'revert-buffer)

(global-set-key (kbd "C-; s") 'shell)

(global-set-key (kbd "C-; h") 'windmove-left)
(global-set-key (kbd "C-; l") 'windmove-right)
(global-set-key (kbd "C-; j") 'windmove-down)
(global-set-key (kbd "C-; k") 'windmove-up)

(global-set-key (kbd "C-; b") 'previous-buffer)
(global-set-key (kbd "C-; f") 'next-buffer)

(defun split-vertical-evenly ()
  (interactive)
  (command-execute 'split-window-vertically)
  (command-execute 'balance-windows))
(global-set-key (kbd "C-x 2") 'split-vertical-evenly)

(defun split-horizontal-evenly ()
  (interactive)
  (command-execute 'split-window-horizontally)
  (command-execute 'balance-windows))
(global-set-key (kbd "C-x 3") 'split-horizontal-evenly)
;; Hydra
;; auto pair
(electric-pair-mode 1)
(setq electric-pair-pairs
      '(
	(?\{ . ?\})))

;; Better comment
(use-package evil-nerd-commenter	
  :bind ("M-;" . evilnc-comment-or-uncomment-lines))

;; latex
(exec-path-from-shell-initialize) 
(use-package pdf-tools
  :ensure t
  :config
  (custom-set-variables
   '(pdf-tools-handle-upgrades nil)) ; Use brew upgrade pdf-tools instead.
  (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))
(pdf-tools-install)

;; org
(use-package org
  :config
  (setq org-agenda-files '("~/Org/Birthday.org"))
  (setq org-agenda-files '("~/Org/Task.org")))
(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("????????????:" "????????? :" "??? ??????:" "??? ??? :")))

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; the clock history across Emacs Session
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

(setq org-default-notes-file (concat org-directory "~/Org/Task.org"))
(setq org-html-html5-fancy t
      org-html-doctype "html5")

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)
   (python . t)))
(setq org-confirm-babel-evaluate nil) ;; not confirm before evaluate

;; auto complete some environment in emacs
(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

;; lsp mode
(defun yay/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . yay/lsp-mode-setup)
  :init
  ;;(setq lsp-keymap-prefix "C-c l")
  (setq lsp-keymap-prefix "s-l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode) ;; some binding here see Emacs from Scratch
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3")
  (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda ()
;; 			 (require 'lsp-pyright)
;; 			 (lsp-deferred)))
;;   :custom
;;   (python-shell-interpreter "python3"))

;; ;;(use-package python-mode
;; ;;  :ensure t
;; ;;  :hook (python-mode . lsp-deferred)
;; ;;  :custom
;; ;;  (python-shell-interpreter "python3"))

;;(require 'dap-python)
;; virtual environment
(add-hook 'python-mode-hook 'anaconda-mode)

(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
					   projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))

(require 'dap-lldb)

(use-package dired 
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump)))
  ;;:custom ((dired-listing-switches "-agho --group-directories-first")))
  ;; :config
  ;; (evil-collection-define-key 'normal 'dired-mode-map
  ;; 				  "h" 'dired-single-up-directory
  ;; 				  "l" 'dired-single-buffer))

;; (use-package dired
;;   :ensure nil
;;   :commands (dired dired-jump)
;;   :bind (("C-x C-j" . dired-jump))
;;   :custom ((dired-listing-switches "-agho --group-directories-first")))

(use-package vterm
  :ensure t
  :bind
  (("C-; v" . vterm)))

;; projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; git
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; ardurio to C++ mode
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode))
