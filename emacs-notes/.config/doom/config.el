;; FiraCode Nerd Font
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 22))

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-directory "~/roam/org"
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
;;    '(org-level-1 ((t (:height 1.4 :foreground "#51afef"))))
;;    '(org-level-2 ((t (:height 1.3 :foreground "#c678dd"))))
;;    '(org-level-3 ((t (:height 1.2 :foreground "#a9a1e1"))))
;;    '(org-level-4 ((t (:height 1.0 :foreground "#7cc3f3"))))
;;    '(org-level-5 ((t (:height 1.0 :foreground "#d499e5"))))
;;    '(org-level-6 ((t (:height 1.9 :foreground "#a8d7f7"))))
;;    '(org-level-7 ((t (:height 1.9 :foreground "#e2bbee"))))
;;    '(org-level-8 ((t (:height 1.9 :foreground "#dceffb"))))
;;    ;; Add more levels and colors as needed
;;    ))
 (setq org-emphasis-alist
  '(("*" (bold :slant italic :weight black :foreground "#1ABC9C" )) ; blue-green
    ("/" (italic :foreground "#F3CA40" ))
    ("_" (:underline t  )) ; light green
    ("=" (:foreground "#E74C3C")) ;red
    ("~" (:foreground "#53df83" )) ; lime green
    ("+" (:strike-through nil :foreground "#FFC300" )))) ;orange

(after! org
  (custom-set-faces
   ;; Font sizes and colors for Org mode headers using Doom One theme colors
   '(org-level-1 ((t (:height 1.4  :inherit outline-1 ultra-bold))))
   '(org-level-2 ((t (:height 1.3  :inherit outline-2 extra-bold))))
   '(org-level-3 ((t (:height 1.2  :inherit outline-3 bold))))
   '(org-level-4 ((t (:height 1.0  :inherit outline-4 semi-bold))))
   '(org-level-5 ((t (:height 1.0  :inherit outline-5 normal))))
   '(org-level-6 ((t (:height 0.9  :inherit outline-6 normal))))
   '(org-level-7 ((t (:height 0.9  :inherit outline-7 normal))))
   '(org-level-8 ((t (:height 0.9  :inherit outline-8 normal))))
   ;; Add more levels and colors as needed
   ))
        ;; Define function to set Doom One colors for Org mode headers
  ;; "Search org-roam directory using consult-ripgrep. With live-preview."
(defun org-search ()
  "Search org-files directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep-args "rg --null --ignore-case --type org --line-buffered --color=never --max-columns=500 --no-heading --line-number"))
    (consult-ripgrep org-directory)))

(after! org
  (map! :leader
        (:prefix ("n" . "notes")
          :desc "Org-grep/search" "g " #'org-search)))

(defun org-roam-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep-args "rg --null --ignore-case --type org --line-buffered --color=never --max-columns=500 --no-heading --line-number"))
    (consult-ripgrep org-roam-directory)))

;; Key binding setup
(after! org-roam
  (map! :leader
        (:prefix ("n" . "notes")
          :desc "Org-roam search" "r S" #'org-roam-search)))

  (defun org-make-olist (arg)
    (interactive "P")
    (let ((n (or arg 1)))
      (when (region-active-p)
        (setq n (count-lines (region-beginning)
                             (region-end)))
        (goto-char (region-beginning)))
      (dotimes (i n)
        (beginning-of-line)
        (insert (concat (number-to-string (1+ i)) ". "))
        (forward-line))))
(map! :leader
      :desc "Create a Numbered List"
      "C-|" #'org-make-olist )

(add-hook 'org-mode-hook 'org-superstar-mode)
 (add-hook 'org-mode-hook 'olivetti-mode)
 (setq olivetti-body-width 100)

(require 'org-superstar)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

;; This is usually the default, but keep in mind it must be nil
(setq org-hide-leading-stars nil)
;; This line is necessary.
(setq org-superstar-leading-bullet ?\s)
;; If you use Org Indent you also need to add this, otherwise the
;; above has no effect while Indent is enabled.
(setq org-indent-mode-turns-on-hiding-stars nil)

;; (setq org-superstar-headline-bullets-list '(" " " " "-" "·" "-" "·"))

;; Option 1: Per buffer
(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

;; Option 2: Globally
;; (with-eval-after-load 'org (global-org-modern-mode))

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
  (setq org-roam-directory "~/roam/")
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

(after! org
  (setq org-agenda-files
  '("~/roam/org/agenda.org")))

(after! org-agenda
(setq
   ;; org-fancy-priorities-list '("[A]" "[B]" "[C]")
   ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
   ;; org-fancy-priorities-list '("🔴" "🟡" "🟢")
   ;; org-fancy-priorities-list '("🔴" "🔵" "🟢")
   org-fancy-priorities-list '("🟥" "🟧" "🟨")
   org-priority-faces
   '((?A :foreground "#ff6c6b" :weight bold)
     (?B :foreground "#98be65" :weight bold)
     (?C :foreground "#c678dd" :weight bold))
   org-agenda-block-separator 8411)

(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (tags "PRIORITY=\"B\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Medium-priority unfinished tasks:")))
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))
          (tags "customtag"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Tasks marked with customtag:")))

          (agenda "")
          (alltodo ""))))))

(after! deft
(setq deft-directory "~/roam/"
;; (setq deft-directory "~/notes/"
      deft-extension '("txt" "org" "md")
      ;; deft-strip-summary-regexp "\\([\n ]\\|^#\\+[[:upper:][:lower:]_]+:.*$\\)"
      ;; deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
      deft-use-filename-as-title t
      deft-recursive t))

;; dired
(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump))

(after! dired
  (map! :map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file"           "d v" #'dired-view-file)

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
    (kbd "; e") 'epa-dired-do-encrypt))

;; Get file icons in dired
(add-hook 'dired-mode-hook 'nerd-icons-dired-mode)

;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

(defun my-dired-view-file ()
  (interactive)
  (dired-view-file)
  (local-set-key (kbd "<f5>") 'View-quit))

(after! dired
  (define-key dired-mode-map (kbd "<f5>") 'my-dired-view-file))

 (setq global-vi-tilde-fringe-mode nil ) ; removes the tildas

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t            ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…")              ; Unicode ellispis are nicer than "...", and also save /precious/ space

(display-time-mode 1)                             ; Enable time in the mode-line
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))                       ; On laptops it's nice to know how much power you have
(global-subword-mode 1)                           ; Iterate through CamelCase words
(setq-default line-spacing 5)
(remove-hook 'after-init-hook #'doom-modeline-mode)
(setq org-indent-indentation-per-level 4)

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

(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq font-lock-maximum-size 100000)
(setq font-lock-support-mode 'lazy-lock-mode)
;; Whether display the buffer name.
(setq doom-modeline-buffer-name t)

;; Toggle Evil mode with F9
(global-set-key (kbd "<f9>") 'evil-mode)

;; Remember and restore the last cursor location of opened files
(save-place-mode 1)

;; Don't pop up UI dialogs when prompting
(setq use-dialog-box nil)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; (setq display-line-numbers-type 'relative)

;; off
(setq display-line-numbers-type nil)

(setq shell-file-name (executable-find "fish"))

(use-package multi-vterm :ensure t)
;; Define keybindings for multi-vterm in Doom Emacs
(map! :leader
      (:prefix ("-" . "multi-vterm")
        :desc "Open multi-vterm" "t" #'multi-vterm
        :desc "Next vterm" "n" #'multi-vterm-next
        :desc "Previous vterm" "p" #'multi-vterm-prev))

;; (pixel-scroll-mode 1)
;; (good-scroll-mode 1)
(pixel-scroll-precision-mode 1)

;; (setq
;;  scroll-conservatively 1000                     ;; only 'jump' when moving this far
;;  scroll-margin 4                                ;; scroll N lines to screen edge
;;  scroll-step 1                                  ;; keyboard scroll one line at a time
;;  mouse-wheel-scroll-amount '(6 ((shift) . 1))   ;; mouse scroll N lines
;;  mouse-wheel-progressive-speed nil              ;; don't accelerate scrolling

;;  redisplay-dont-pause t                         ;; don't pause display on input

;;  ;; Always redraw immediately when scrolling,
;;  ;; more responsive and doesn't hang!
;;  fast-but-imprecise-scrolling nil
;;  jit-lock-defer-time 0
;;  )

        ;; scroll one line at a time (less "jumpy" than defaults)
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ; one line at a time
(setq mouse-wheel-progressive-speed nil)            ; don't accelerate scrolling
;; (setq-default smooth-scroll-margin 0)
;; (setq scroll-step 1
;;       scroll-margin 1
;;       scroll-conservatively 100000) ;100000

(setq which-key-use-C-h-commands 't)

;; (all-the-icons-dired-mode 1)

;; (setq doom-theme 'doom-one)
(setq doom-theme 'doom-henna)