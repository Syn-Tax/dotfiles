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
(setq doom-themes-neotree-file-icons t)

(setq-default frame-title-format '("Doom Emacs"))

(map! (:leader
       (
        :desc "darkroom-mode" :nv "t z" 'darkroom-mode
        :desc "increase text size" :nv "t d" 'text-scale-mode

        :desc "project search" :nv "p R" #'+ivy/project-search

        :desc "elfeed" :nv "o e" 'elfeed

        (:desc "elfeed" :prefix "e"
         :desc "update" :nv "u" 'elfeed-update)
        )))

;; org mode settings
(setq org-directory "~/Notes")
(setq org-agenda-files (file-expand-wildcards "~/Notes/*"))

(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)
                                    (darkroom-mode)))

(add-hook 'org-agenda-mode-hook (lambda () (display-line-numbers-mode 0)
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

(setq org-startup-folded "fold")

(after! org-agenda
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-compact-blocks t
        org-agenda-start-day nil ;; i.e. today
        org-agenda-span 3
        org-agenda-start-on-weekday nil
        org-agenda-entry-types '(:deadline :todo :scheduled)
        )
)

(use-package! org-checklist)

(use-package! org-wild-notifier)

(after! org-wild-notifier
  (org-wild-notifier-mode))

;; elfeed
(setq elfeed-feeds
      '(("http://feeds.bbci.co.uk/news/scotland/rss.xml" news)
        ("http://feeds.bbci.co.uk/news/video_and_audio/technology/rss.xml" tech news)
        ("https://www.theguardian.com/uk-news/rss" news)
        ("https://www.theguardian.com/uk/technology/rss" tech news)
        ("http://www.independent.co.uk/rss" news)))

;; alert
(after! alert
  (setq alert-default-style 'notifications)
)
