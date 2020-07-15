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
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  )

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

; better bullets in org mode
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(defun my-hjkl-rotation (_mode mode-keymaps &rest _rest)
  (evil-collection-translate-key 'normal mode-keymaps
    "t" "j"
    "h" "k"
    "n" "l"
    "d" "h"
    ; edit them back
    "j" "t"
    "k" "h"
    "n" "l"
    "d" "h"
    ))

;; called after evil-collection makes its keybindings
(add-hook 'evil-collection-setup-hook #'my-hjkl-rotation)

(evil-collection-init)

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  (setq which-key-enable-extended-define-key t))

(use-package general :ensure t
  :config
  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'override
   :prefix "SPC"

   ; basic commands
   "RET" 'helm-bookmarks
   "s" 'save-buffer
   "." 'helm-find-files

   ; buffer commands
   "b b" 'switch-to-buffer
   "b n" 'create-file-buffer
   "b k" 'kill-buffer
   "b p" 'previous-buffer

   ; window commands
   "w v" 'split-window-vertically
   "w h" 'split-window-horizontally

   ; open commands
   "o p" 'neotree-toggle
   "o f" 'open-file
   "o d" 'dired
   "o m" 'mu4e
   ))

(which-key-add-key-based-replacements
  ; Simple command names
  "SPC ." "find files"
  "SPC RET" "Bookmarks"
  "SPC s" "Save Buffer"

  ; buffer command names
  "SPC b" "Buffer"
  "SPC b n" "New Buffer"
  "SPC b k" "Kill Buffer"
  "SPC b b" "Switch Buffer"
  "SPC b p" "Previous Buffer"

  ; Window command names
  "SPC w" "Window"
  "SPC w v" "Split Vertically"
  "SPC w h" "Split Horizontally"
  
  ; open commands
  "SPC o p" "Neotree toggle"
  "SPC o f" "Open Files"
  "SPC o d" "Open Dired"
  "SPC o" "Open"
  "SPC o m" "Open mu4e"
  )

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

; highlight current line
(global-hl-line-mode 1)

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

; evil keybinds for dvorak (dired)
;(use-package dired
;  :config
;  (evil-define-key 'normal dired-mode-map "h" 'dired-previous-line)
;  (evil-define-key 'normal dired-mode-map "t" 'dired-next-line)
;  (evil-define-key 'normal dired-mode-map "n" 'dired-open-file)
;  (evil-define-key 'normal dired-mode-map "d" 'dired-up-directory))

;(use-package mu4e
;  :config
;  (evil-define-key 'normal mu4e-headers-mode-map "h" 'prev-line)
;  (evil-define-key 'normal mu4e-headers-mode-map "t" 'next-line))

; transparency
(set-frame-parameter (selected-frame) 'alpha '(95 . 95))
(add-to-list 'default-frame-alist '(alpha . (95 . 95)))

; evil keybinds for dvorak (visual mode)
(define-key evil-visual-state-map "h" 'evil-previous-line)
(define-key evil-visual-state-map "t" 'evil-next-line)
(define-key evil-visual-state-map "d" 'evil-backward-char)
(define-key evil-visual-state-map "n" 'evil-forward-char)

; mu4e settings
(require 'mu4e)
; tell mu4e where my Maildir is
(setq mu4e-maildir "/home/oscar/Maildir")
; tell mu4e how to sync email
(setq mu4e-get-mail-command "/usr/local/bin/mbsync -a")

(setq user-mail-address "twocap06@gmail.com")

; taken from mu4e page to define bookmarks
(add-to-list 'mu4e-bookmarks
            '("size:5M..500M"       "Big messages"     ?b))

; mu4e requires to specify drafts, sent, and trash dirs
; a smarter configuration allows to select directories according to the account (see mu4e page)
(setq mu4e-drafts-folder "/acc1-gmail/drafts")
(setq mu4e-sent-folder "/acc1-gmail/sent")
(setq mu4e-trash-folder "/acc1-gmail/trash")

; use msmtp
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq sendmail-program "/usr/local/bin/msmtp")
; tell msmtp to choose the SMTP server according to the from field in the outgoing email
(setq message-sendmail-extra-arguments '("--read-envelope-from"))
(setq message-sendmail-f-is-evil 't)

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
