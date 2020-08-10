;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Oscar Morris"
      user-mail-address "twocap06@gmail.com")

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "DejaVu Sans Mono" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


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
(defun my-hjkl-rotation (_mode mode-keymaps &rest _rest)
  (evil-collection-translate-key 'normal mode-keymaps
    "t" "j"
    "h" "k"
    "n" "l"
    "d" "h"
    ; edit them back
    ;"j" "t"
    ;"k" "h"
    ;"n" "l"
    ;"d" "h"
    ))

;; called after evil-collection makes its keybindings
(add-hook 'evil-collection-setup-hook #'my-hjkl-rotation)

(with-eval-after-load 'evil
  (define-key evil-normal-state-map "D" 'evil-delete-whole-line)

  ;; evil keybinds for dvorak (normal mode)
  (define-key evil-normal-state-map "h" 'evil-previous-visual-line)
  (define-key evil-normal-state-map "t" 'evil-next-visual-line)
  (define-key evil-normal-state-map "d" 'evil-backward-char)
  (define-key evil-normal-state-map "n" 'evil-forward-char)

  ;; evil keybinds for dvorak (visual mode)
  ;(define-key evil-visual-state-map "h" 'evil-previous-line)
  ;(define-key evil-visual-state-map "t" 'evil-next-line)
  ;(define-key evil-visual-state-map "d" 'evil-backward-char)
  ;(define-key evil-visual-state-map "n" 'evil-forward-char)

  ;;(define-key  "d" 'evil-backward-char)
  ;;(evil-define-key 'normal 'global (kbd "d") nil)
  ;;(evil-define-key 'normal org-mode-map (kbd "h") 'evil-previous-line)
  ;;(evil-define-key 'normal org-mode-map (kbd "t") 'evil-next-line)
  ;;(evil-define-key 'normal org-mode-map (kbd "n") 'evil-forward-char)
  ;;(evil-global-set-key 'normal (kbd "d") 'evil-backward-char)
  ;;(evil-define-key 'normal global-map (kbd "t") (kbd "j"))
  ;;(evil-define-key 'normal global-map (kbd "h") (kbd "k"))
  ;;(evil-define-key 'normal global-map (kbd "n") (kbd "l"))
)
;;(use-package darkroom
;;  :init
;;  (setq darkroom-text-scale-increase 0))

(map! (:leader
       (:desc "evil-window-up" :nv "w h" 'evil-window-up
        :desc "evil-window-down" :nv "w t" 'evil-window-down
        :desc "evil-window-left" :nv "w d" 'evil-window-left
        :desc "evil-window-right" :nv "w n" 'evil-window-right

        ;;:desc "darkroom-mode" :nv "t z" 'darkroom-mode
        )))
