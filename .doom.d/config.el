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
(setq doom-font (font-spec :family "DejaVuSansMono Nerd Font" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'visual)


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

(defun automated-commit ()
  (interactive)
  (magit-call-git "add" ".")
  (magit-call-git "commit" "-am" "Automated Commit")
  (magit-call-git "push")
  (magit-refresh))

(defun automated-pull ()
  (interactive)
  (magit-call-git "pull")
  (magit-refresh))

(map! (:leader
       (
        ;;:desc "darkroom-mode" :nv "t z" 'darkroom-mode

        :desc "project search" :nv "p R" #'+ivy/project-search

        :desc "Automatic Commit" :nv "g c c" 'automated-commit
        :desc "Pull" :nv "g c p" 'automated-pull
        :desc "Refresh" :nv "g r" 'magit-refresh

        :desc "elfeed" :nv "o e" 'elfeed

        (:desc "elfeed" :prefix "e"
         :desc "update" :nv "u" 'elfeed-update)

        (:desc "refrences" :prefix "m r"
         :desc "insert" :nv "i" 'org-ref-insert-link
         :desc "jump" :nv "m" 'org-ref-latex-click
         )
        )))



;; dvorak keybinds
(map! :nv "h" 'evil-next-visual-line)
(map! :nv "t" 'evil-previous-visual-line)
(map! :nv "n" 'evil-forward-char)
(map! :nv "d" 'evil-backward-char)
(map! :nv "k" 'evil-delete)
(map! :nv "K" 'evil-delete-line)

(map! :n "C-/" 'comment-line)

(defun evil-org-binds ()
  (evil-define-key 'normal evil-org-mode-map (kbd "d") nil)
  (evil-define-key 'normal evil-org-mode-map (kbd "k") #'evil-org-delete)
)

(add-hook 'evil-org-mode-hook 'evil-org-binds)

(defun my-hjkl-rotation (_mode mode-keymaps &rest _rest)
  (evil-collection-translate-key 'normal mode-keymaps
    "h" "j"
    "t" "k"
    "n" "l"
    "d" "h"
    "k" "d"
    ; edit them back
    "j" "h"
    "k" "t"
    "n" "l"
    "d" "h"
    "k" "d"
    ))

(add-hook 'evil-collection-setup-hook #'my-hjkl-rotation)

;; YASnippets
(after! yasnippet
  yas-global-mode)

;; org mode settings
(setq org-directory "~/Notes")
(setq org-startup-folded t)
(setq org-startup-with-inline-images 1)
(setq org-agenda-files (delete "~/Notes/.gitignore" (file-expand-wildcards "~/Notes/*")))

;;(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)
                           ;;(darkroom-mode)
;;                           ))

(add-hook 'org-mode-hook (text-scale-increase 1))

;;(add-hook 'after-save-hook (lambda () (when (eq major-mode 'org-mode) (automated-pull) (automated-commit))))

(add-hook 'org-agenda-mode-hook (lambda () (display-line-numbers-mode 0)))

(setq darkroom-text-scale-increase 1.5)
(setq doom-big-font-increment 3)
(setq org-support-shift-select t)

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

(setq org-startup-folded "fold")

;;(after! darkroom-mode
;;  (setq darkroom-margins 0)
;;  )

(after! org
  (setq org-todo-keywords '((sequence "TODO(t)" "EVENT(e)" "NEXT(N)" "PROGRESS(p)" "WAITING(w)" "|" "DONE(d)" "DELEGATED(D)" "CANCELLED(C)")))
  (setq  org-latex-pdf-process
         '("latexmk -pdf %f"))
  )

(after! writeroom-mode
  (setq +zen-text-scale 1.5)
)

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

(setq org-image-actual-width nil)

;; elfeed
(setq elfeed-feeds
      '(("http://feeds.bbci.co.uk/news/scotland/rss.xml" news)
        ("http://feeds.bbci.co.uk/news/video_and_audio/technology/rss.xml" tech news)
        ("https://www.theguardian.com/uk-news/rss" news)
        ("https://www.theguardian.com/uk/technology/rss" tech news)
        ("http://www.independent.co.uk/rss" news)
        ("http://www.tagesspiegel.de/contentexport/feed/politik" german politics news)
        ("http://www.tagesspiegel.de/contentexport/feed/berlin" german news)
        ("https://www.reddit.com/r/linux.rss" reddit linux)
        ("https://opensource.com/feed" opensource linux)
        ("https://itsfoss.com/feed/" itsfoss linux)
        ("http://feeds.feedburner.com/d0od" omgubuntu linux)
        ("https://feeds.feedburner.com/visualcapitalist" news school)
))

;; alert
(after! alert
  (setq alert-default-style 'notifications)
)

;; pdf-tools
(use-package! pdf-tools
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page))

(use-package! org-ref
  :init
;;  (setq org-latex-pdf-process
;;        '("pdflatex -interaction nonstopmode -output-directory %o %f"
;;          "bibtex %b"
;;          "pdflatex -interaction nonstopmode -output-directory %o %f"
;;          "pdflatex -interaction nonstopmode -output-directory %o %f"))
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  (setq bibtex-dialect 'biblatex)
)

(use-package! edit-server
  :config
  (setq edit-server-host "127.0.0.1:9292")
  :init
  (edit-server-start)
)

;; dired
(use-package! all-the-icons-dired
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)
(require 'smtpmail)

(setq +mu4e-backend 'offlineimap)

(set-email-account! "Gmail"
  '((mu4e-sent-folder       . "/Gmail/[Gmail].Sent Mail")
    (mu4e-drafts-folder     . "/Gmail/[Gmail].Drafts")
    (mu4e-trash-folder      . "/Gmail/[Gmail].Bin")
    (mu4e-refile-folder     . "/Gmail/[Gmail].All Mail")
    (smtpmail-smtp-user     . "twocap06@gmail.com")
  ))

(setq +mu4e-gmail-accounts '(("twocap06@gmail.com" . "/Gmail")))
;; don't need to run cleanup after indexing for gmail
(setq mu4e-index-cleanup nil
      ;; because gmail uses labels as folders we can use lazy check since
      ;; messages don't really "move"
      mu4e-index-lazy-check t)
(map! :map org-msg-edit-mode-map
        :desc "send" "C-c C-c" #'org-ctrl-c-ctrl-c
        :localleader
        :desc "send" "s" #'org-ctrl-c-ctrl-c)
(setq mu4e-compose--org-msg-toggle-next nil)
