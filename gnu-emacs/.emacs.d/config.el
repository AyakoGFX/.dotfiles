(use-package doom-themes
      :if window-system
      :ensure t
      :config
      (load-theme 'doom-molokai t)
      (doom-themes-org-config)
      (doom-themes-visual-bell-config)
      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (fringe-mode -1)
      (scroll-bar-mode -1))

(add-to-list 'default-frame-alist
	     '(font . "JetBrainsMono Nerd Font-19"))

;; (use-package spaceline
;; :ensure t
;; :config
;; (require 'spaceline-config)
;; (setq powerline-default-separator (quote arrow))
;; (spaceline-spacemacs-theme))
(use-package doom-modeline
  :ensure t
  :config
  (display-battery-mode 1)
  (setq doom-modeline-time-icon t)
  (setq doom-modeline-battery t)
  (setq doom-modeline-time t)
  :init
  (doom-modeline-mode 1))

;; (use-package fancy-battery
;; :ensure t
;; :init
;; (fancy-battery-mode 1)
;; (setq fancy-battery-show-percentage t))

(use-package dashboard
:ensure t
:config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.emacs.d/img/logo.svg")
  (setq dashboard-items '((recents  . 5)
			    (projects . 5)))
  (setq dashboard-banner-logo-title "I am just a coder for fun"))

(setq inhibit-startup-message t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq ring-bell-function 'ignore)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq make-backup-files t)
(setq auto-save-default t)

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package recentf
  :init
  (setq
    recentf-save-file "~/.emacs.d/.cache/recentf"
    recentf-max-saved-items 10000
    recentf-max-menu-items 5000
    )
  (recentf-mode 1)
  (run-at-time nil (* 5 60) 'recentf-save-list)
)

(use-package all-the-icons
  :ensure t
  :init)

   ;; (use-package all-the-icons-dired
     ;; :ensure t
     ;; :init (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

  (use-package treemacs-icons-dired
    :ensure t
    :if (display-graphic-p)
    :config (treemacs-icons-dired-mode))

(use-package all-the-icons-ibuffer
  :ensure t
  :init (all-the-icons-ibuffer-mode 1))

(defun my-line-save ()
  (interactive)
  (let ((l(substring (thing-at-point 'line)0 -1)))
    (kill-new l)
    (message "saved : %s" l)))
(local-set-key (kbd "C-c w") #'my-line-save)

;; Enable vertico
 (use-package compat
   :ensure t)

(use-package vertico
  :ensure t
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
   (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  ;; (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :ensure t
  :custom
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
		  (replace-regexp-in-string
		   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
		   crm-separator)
		  (car args))
	  (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
	'(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))

(setq read-file-name-completion-ignore-case t
    read-buffer-completion-ignore-case t
    completion-ignore-case t)

;; Optionally use the `orderless' completion style.
(use-package orderless			
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;;  (ido-mode 1)
;;  (setq ido-separator "\n")

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package vterm
  :ensure t
  :init
  (global-set-key (kbd "<s-return>") 'vterm))

(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-expert t)

(use-package vundo
  :commands (vundo)
  :ensure t
  :config
  ;; Take less on-screen space.
  (setq vundo-compact-display t)

  ;; Better contrasting highlight.
  (custom-set-faces
    '(vundo-node ((t (:foreground "#808080"))))
    '(vundo-stem ((t (:foreground "#808080"))))
    '(vundo-highlight ((t (:foreground "#FFFF00")))))

  ;; Use `HJKL` VIM-like motion, also Home/End to jump around.
  (define-key vundo-mode-map (kbd "l") #'vundo-forward)
  (define-key vundo-mode-map (kbd "<right>") #'vundo-forward)
  (define-key vundo-mode-map (kbd "h") #'vundo-backward)
  (define-key vundo-mode-map (kbd "<left>") #'vundo-backward)
  (define-key vundo-mode-map (kbd "j") #'vundo-next)
  (define-key vundo-mode-map (kbd "<down>") #'vundo-next)
  (define-key vundo-mode-map (kbd "k") #'vundo-previous)
  (define-key vundo-mode-map (kbd "<up>") #'vundo-previous)
  (define-key vundo-mode-map (kbd "<home>") #'vundo-stem-root)
  (define-key vundo-mode-map (kbd "<end>") #'vundo-stem-end)
  (define-key vundo-mode-map (kbd "q") #'vundo-quit)
  (define-key vundo-mode-map (kbd "C-g") #'vundo-quit)
  (define-key vundo-mode-map (kbd "RET") #'vundo-confirm))

(with-eval-after-load 'evil
  (evil-define-key 'normal 'global (kbd "C-M-u") 'vundo))

;; remap redo from C-M-_ to  C-x U 
  (global-set-key (kbd "C-x U") 'undo-redo)

;; Visiting the configuration
  (defun config-visit ()
    (interactive)
    (find-file "~/.emacs.d/config.org"))
  (global-set-key (kbd "C-c e") 'config-visit)

  ;; Toggle maximize buffer
  (defun toggle-maximize-buffer () "Maximize buffer"
	 (interactive)
	 (if (= 1 (length (window-list)))
	     (jump-to-register '_)
	   (progn
	     (set-register '_ (list (current-window-configuration)))
	     (delete-other-windows))))
  (global-set-key [(super shift return)] 'toggle-maximize-buffer) 

  ;;Always murder current buffer
  (defun kill-curr-buffer ()
    (interactive)
    (kill-buffer (current-buffer)))
  (global-set-key (kbd "C-x k") 'kill-curr-buffer)

  ;;  Kill whole word
  (defun kill-whole-word ()
    (interactive)
    (backward-word)
    (kill-word 1))
  (global-set-key (kbd "C-c w w") 'kill-whole-word)

  ;;  Copy whole line
  (defun copy-whole-line ()
    (interactive)
    (save-excursion
      (kill-new
       (buffer-substring
	(point-at-bol)
	(point-at-eol)))))
  (global-set-key (kbd "C-c w l") 'copy-whole-line)
  ;;Kill all buffers
  (defun kill-all-buffers ()
    (interactive)
    (mapc 'kill-buffer (buffer-list)))
  (global-set-key (kbd "C-M-s-k") 'kill-all-buffers)

  ;; comment and un comment
  ;; Comment and uncomment region with C-c c and C-c u
  (global-set-key (kbd "C-c c") 'comment-region)
  (global-set-key (kbd "C-c u") 'uncomment-region)

  ;; Optional: Use C-; to comment/uncomment
  (global-set-key (kbd "C-;") 'comment-line)

(use-package magit
  :ensure t
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  :bind
  ("C-c g g" . magit-status))
