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
(setq doom-themes-neotree-enable-file-icons t)

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

;; keybinds
(map! :nv "C-/" #'comment-or-uncomment-region)

(with-eval-after-load 'evil-maps
  (map! :nv "D" #'evil-delete-whole-line)

  (map! :nv "d" #'evil-backward-char
        :nv "h" #'evil-previous-line
        :nv "t" #'evil-next-line
        :nv "n" #'evil-forward-char)

  (map! :after evil-org
        :map evil-org-mode-map
        :n "d" nil)

 )

(map! (:leader
       (:desc "evil-window-up" :nv "w h" 'evil-window-up
        :desc "evil-window-down" :nv "w t" 'evil-window-down
        :desc "evil-window-left" :nv "w d" 'evil-window-left
        :desc "evil-window-right" :nv "w n" 'evil-window-right

        :desc "darkroom-mode" :nv "t z" 'darkroom-mode
        :desc "increase text size" :nv "t d" 'text-scale-mode

        :desc "project search" :nv "p R" #'+ivy/project-search
        )))

;; org mode settings
(setq org-directory "~/Notes")
(setq org-agenda-files (file-expand-wildcards "~/Notes/*"))

(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)
                                    (darkroom-mode)))

(setq darkroom-text-scale-increase 1.5)
(setq doom-big-font-increment 3)

;; todo keyword settings
(use-package! hl-todo
    :hook ((prog-mode . hl-todo-mode)
         (org-mode . hl-todo-mode))
    :config
    (setq hl-todo-highlight-punctuation ":"
          hl-todo-keyword-faces
          `(("TODO" . "#dc752f")
            ("EVENT" . "#d493ed")
            ("NEXT" . "#dc752f")
            ("PROGRESS" . "#4f97d7")
            ("WAITING" . "#4f97d7")
            ("CANCELLED" . "#f2241f")
            ("DONE" . "#86dc2f")
            ("DELEGATED" . "#86dc2f")
            ("FIXME" . "#dc752f")
            ("HACK" . "#b1951d")
            ("NOTE" . "#b1951d")
            ("TEMP" . "#b1951d")
            )))
(after! org
  (setq org-todo-keywords '((sequence "TODO(t)" "EVENT(e)" "NEXT(N)" "PROGRESS(p)" "WAITING(w)" "|" "DONE(d)" "DELEGATED(D)" "CANCELLED(C)")))

)

;; org-super-agenda
(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-compact-blocks t
        org-agenda-start-day nil ;; i.e. today
        org-agenda-span 14
        org-agenda-start-on-weekday nil)
  (setq org-super-agenda-groups '((:name "Today"
                                   :scheduled today)
                                  (:name "Due Today"
                                   :deadline today)
                                  (:name "Important"
                                   :priority "A")
                                  (:name "Overdue"
                                   :deadline past)
                                  (:name "Due Soon"
                                   :deadline future)
                                  (:name "Soon"
                                   :scheduled future)
                                  (:name "Waiting..."
                                   :todo "WAITING")))
  :config
  (org-super-agenda-mode)
  )
