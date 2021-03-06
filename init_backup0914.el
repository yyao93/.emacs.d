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

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "http://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/") ;; update org in time
			 ("elpa" . "https://elpa.gnu.org/packages")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ;; helm or ivy

(use-package ivy
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

;; ;; better emacs help
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-function-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


;; Key Bindings
(global-set-key (kbd "C-x C-o") 'other-window)
(global-set-key (kbd "C-; s") 'shell)

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

;; latex
(exec-path-from-shell-initialize)
(use-package pdf-tools
      :ensure t
      :config
      (custom-set-variables
        '(pdf-tools-handle-upgrades nil)) ; Use brew upgrade pdf-tools instead.
     (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))
     (pdf-tools-install)

;; ;; Some setups for C++
;; auto complete
(use-package auto-complete)
(global-auto-complete-mode 1)

;; ardurio to C++ mode
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode))


;; org
(use-package org
  :config
  (setq org-agenda-files '("~/Org/Task.org"))
  (setq org-agenda-files '("~/Org/Birthday.org")))
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

; the clock history across Emacs Session
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

; auto complete some environment in emacs
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))




