(require 'package)
(setq package-enable-at-startup nil)
; Add Melpa as the default Emacs Package repository
; only contains a very limited number of packages
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

; Activate all the packages (in particular autoloads)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

; Install & init packages
(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package evil
  :ensure t
  :init
  (evil-mode 1))

(use-package evil-leader
  :ensure t
  :init
  (global-evil-leader-mode))

; autocomplete
(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode))

; project management
(use-package projectile
  :ensure t
  :init
  (projectile-mode 1))

; dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

; leader key
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "b" 'switch-to-buffer
  "w" 'save-buffer
  "o p" 'neotree-toggle
  "RET" 'helm-bookmarks
  "." 'helm-find-files
  "p" 'projectile-command-map)

; fonts & icons
(add-to-list 'default-frame-alist
	     '(font . "DejaVu Sans Mono-12"))

(use-package all-the-icons
  :ensure t)

; helm
(use-package helm
  :ensure t
  :config (helm-mode 1))

; neotree
(use-package neotree
  :ensure t)
(setq neo-theme 'icons)


(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
(evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
(evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
(evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)

; auto pairs
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)

; smooth scrolling
(setq scroll-step 1)

; stopping cursor blink
(blink-cursor-mode 0)

; line numbers
(setq display-line-numbers-type 'relative)

(global-display-line-numbers-mode)

; disabling useless ui
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

; colorscheme
(use-package one-themes
  :ensure t
  :init
  (load-theme 'one-dark t))

; powerline
(use-package powerline
  :ensure t
  :init
  (powerline-default-theme))

; evil keybinds for dvorak (normal mode)
(define-key evil-normal-state-map "h" 'evil-previous-line)
(define-key evil-normal-state-map "t" 'evil-next-line)
(define-key evil-normal-state-map "d" 'evil-backward-char)
(define-key evil-normal-state-map "n" 'evil-forward-char)

; transparency
(set-frame-parameter (selected-frame) 'alpha '(95 . 95))
(add-to-list 'default-frame-alist '(alpha . (95 . 95)))

; evil keybinds for dvorak (visual mode)
(define-key evil-visual-state-map "h" 'evil-previous-line)
(define-key evil-visual-state-map "t" 'evil-next-line)
(define-key evil-visual-state-map "d" 'evil-backward-char)
(define-key evil-visual-state-map "n" 'evil-forward-char)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (which-key powerline one-themes evil-leader))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
