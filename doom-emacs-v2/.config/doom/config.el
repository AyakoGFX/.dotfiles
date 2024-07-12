;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-one)


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/.config/doom/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-directory "~/roam"
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ↴ " ; ⇩ ▼ ↴
        ;; org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("ddg" . "https://duckduckgo.com/?q=")
            ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-table-convert-region-max-lines 20000
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '((sequence
             "TODO(t)"           ; A task that is ready to be tackled
             "BLOG(b)"           ; Blog writing assignments
             "GYM(g)"            ; Things to accomplish at the gym
             "PROJ(p)"           ; A project that contains other tasks
             "VIDEO(v)"          ; Video assignments
             "WAIT(w)"           ; Something is holding up this task
             "|"                 ; The pipe necessary to separate "active" states and "inactive" states
             "DONE(d)"           ; Task has been completed
             "CANCELLED(c)" )))) ; Task has been cancelled
;; (after! org
;;   (custom-set-faces
;;    ;; Font sizes and colors for Org mode headers using Doom One theme colors
;;    '(org-level-1 ((t (:height 1.7 :foreground "#51afef"))))
;;    '(org-level-2 ((t (:height 1.6 :foreground "#c678dd"))))
;;    '(org-level-3 ((t (:height 1.5 :foreground "#a9a1e1"))))
;;    '(org-level-4 ((t (:height 1.4 :foreground "#7cc3f3"))))
;;    '(org-level-5 ((t (:height 1.3 :foreground "#d499e5"))))
;;    '(org-level-6 ((t (:height 1.3 :foreground "#a8d7f7"))))
;;    '(org-level-7 ((t (:height 1.2 :foreground "#e2bbee"))))
;;    '(org-level-8 ((t (:height 1.1 :foreground "#dceffb"))))
;;    ;; Add more levels and colors as needed
;;    ))


(after! org
  (custom-set-faces
   ;; Font sizes and colors for Org mode headers using Doom One theme colors
   '(org-level-1 ((t (:height 1.4  :inherit outline-1 ultra-bold))))
   '(org-level-2 ((t (:height 1.3  :inherit outline-2 extra-bold))))
   '(org-level-3 ((t (:height 1.2  :inherit outline-3 bold))))
   '(org-level-4 ((t (:height 1.1  :inherit outline-4 semi-bold))))
   '(org-level-5 ((t (:height 1.0  :inherit outline-5 normal))))
   '(org-level-6 ((t (:height 0.9  :inherit outline-6 normal))))
   '(org-level-7 ((t (:height 0.9  :inherit outline-7 normal))))
   '(org-level-8 ((t (:height 0.9  :inherit outline-8 normal))))
   ;; Add more levels and colors as needed
   ))
        ;; Define function to set Doom One colors for Org mode headers

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun dt/insert-auto-tangle-tag ()
  "Insert auto-tangle tag in a literate config."
  (interactive)
  (evil-org-open-below 1)
  (insert "#+auto_tangle: t ")
  (evil-force-normal-state))

(map! :leader
      :desc "Insert auto_tangle tag" "i a" #'dt/insert-auto-tangle-tag)

(after! org-roam
  (setq org-roam-directory "~/roam")
  (setq org-roam-completion-everywhere t)
  ;; (setq org-roam-graph-viewer "~/usr/bin/brave")
  ;; Additional keybinding in org-mode-map
  (map! :map org-mode-map
        ;; Use `C-M-i` for completion-at-point
        "C-M-i" #'completion-at-point)
  ;; Enable org-roam
  (org-roam-db-autosync-enable))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; Bind this to SPC n r I
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(map! :leader
      :prefix ("n" . "notes")
      :desc "Insert org-roam node" "r I" #'org-roam-node-insert-immediate)

;; Removing timestamp from filename
(after! org-roam
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "${slug}.org"
                              "#+title: ${title}\n")
           :unnarrowed t))))

(after! deft
(setq deft-directory "~/roam/"
      deft-extension '("txt" "org" "md")
      ;; deft-strip-summary-regexp "\\([\n ]\\|^#\\+[[:upper:][:lower:]_]+:.*$\\)"
      ;; deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
      deft-use-filename-as-title t
      deft-recursive t))

;; (beacon-mode 1)

(all-the-icons-dired-mode 1)

(setq display-line-numbers-type 'relative)

(setq shell-file-name (executable-find "fish"))

;; FiraCode Nerd Font
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 22))

;; Use Ctrl+hjkl to move between windows
(define-key evil-normal-state-map (kbd "C-h") #'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") #'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") #'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") #'evil-window-right)

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key [(meta k)]  'move-line-up)
(global-set-key [(meta j)]  'move-line-down)

;; dired
(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file"           "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Get file icons in dired
;;
;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(add-hook 'dired-mode-hook 'nerd-icons-dired-mode)
;;
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

;; Set the location of aspell executable
;; (setq ispell-program-name "aspell")
(setq ispell-program-name "hunspell")

;; Set the default dictionary
(setq ispell-dictionary "en_US")

;; (add-to-list 'default-frame-alist '(alpha-background . 90))

;; (custom-set-faces
;;  '(default ((t (:background "#171718")))))

;; Save what you enter into minibuffer prompts
;; (setq history-length 25)
;; (savehist-mode 1)

;; Remember and restore the last cursor location of opened files
(save-place-mode 1)

;; Don't pop up UI dialogs when prompting
(setq use-dialog-box nil)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

(setq bookmark-default-file "~/.config/doom/bookmarks")

(map! :leader
      (:prefix ("b". "buffer")
       :desc "List bookmarks"                          "L" #'list-bookmarks
       :desc "Set bookmark"                            "m" #'bookmark-set
       :desc "Delete bookmark"                         "M" #'bookmark-delete
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))

;; Disable org-appear-mode
(add-hook 'org-mode-hook #'org-appear-mode)
;; Set a higher garbage collection threshold (e.g., 100 MB)
(setq gc-cons-threshold (* 100 1024 1024))

;; Disable flycheck
;; (global-flycheck-mode -1)

;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 23))))
