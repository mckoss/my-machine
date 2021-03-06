(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("." . "~/.emacs-backups"))))
 '(tab-width 2)
 '(default-fill-column 80)
 '(c-basic-offset 2)
 `(sh-basic-offset 2)
 '(column-number-mode t)
 '(default-input-method "latin-1-postfix")
 '(global-font-lock-mode t nil (font-lock))
 '(gud-gdb-command-name "gdb --annotate=1")
 '(inhibit-splash-screen t)
 '(large-file-warning-threshold nil)
 '(safe-local-variable-values (quote ((TeX-master . "Master"))))
 '(save-place t nil (saveplace))
 '(sentence-end-double-space nil)
 '(show-paren-mode t nil (paren))
 '(show-trailing-whitespace t)
 `(compile-command "run-tests")
 `(compilation-scroll-output t)
 `(split-width-threshold 140)
 )

(autoload 'longlines-mode "longlines.el"
 "Minor mode for automatically wrapping long lines." t)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching)

(setq-default indent-tabs-mode nil)
(add-hook 'write-file-hooks
         (lambda ()
           (if (not indent-tabs-mode)
               (untabify (point-min) (point-max)))
           (delete-trailing-whitespace)))

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq python-indent-offset 2)
            (setq tab-width 2)))

(add-hook 'js-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq js-indent-level 2)
            (setq tab-width 2)))

;; From http://stackoverflow.com/questions/92971/how-do-i-set-the-size-of-emacs-window
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
  (progn
    ;; use 120 char wide window for largeish displays
    ;; and smaller 80 column windows for smaller displays
    ;; pick whatever numbers make sense for you
    (if (> (x-display-pixel-width) 1280)
        (add-to-list 'default-frame-alist (cons 'width 120))
      (add-to-list 'default-frame-alist (cons 'width 80)))
    ;; for the height, subtract a couple hundred pixels
    ;; from the screen height (for panels, menubars and
    ;; whatnot), then divide by the height of a char to
    ;; get the height we want
    (add-to-list 'default-frame-alist
                 (cons 'height (/ (- (x-display-pixel-height) 200) (frame-char-height)))))))

(set-frame-size-according-to-resolution)

(defun scroll-up-one ()
  (interactive)
  (scroll-up 1))

(defun scroll-down-one ()
  (interactive)
  (scroll-down 1))

(global-set-key "\C-z" 'scroll-up-one)
(global-set-key "\M-z" 'scroll-down-one)

(defun increase-indent ()
  (interactive)
  (if (< (point) (mark))
      (exchange-point-and-mark))
  (indent-rigidly (mark) (point) 2))

(defun decrease-indent ()
  (interactive)
  (if (< (point) (mark))
      (exchange-point-and-mark))
  (indent-rigidly (mark) (point) -2))

(global-set-key "\M-[" 'decrease-indent)
(global-set-key "\M-]" 'increase-indent)

(global-set-key (kbd "C-x c") `compile)

(global-set-key (kbd "C-x SPC") 'fixup-whitespace)

; Run lint on the current file (should be saved).
; Adapted from http://xahlee.org/emacs/elisp_run_current_file.html
(defun lint-current-file ()
  (interactive)
  (let (extension-alist fname suffix progName cmdStr)
    (setq extension-alist
          '(
            ("py" . "check-py")
            ("js" . "jshint --reporter unix")
            ("html" . "tidy.py")
            ("go" . "go test -v")
            )
          )
    (setq fname (buffer-file-name))
    (setq suffix (file-name-extension fname))
    (setq progName (cdr (assoc suffix extension-alist)))
    (setq cmdStr (concat progName " \""   fname "\""))

    (if progName
        (compile cmdStr)
      (message "No recognized program file suffix for this file."))
    )
  )
(global-set-key (kbd "C-x C-l") 'lint-current-file)

(defun run-tests ()
  (interactive)
  (compile "run-tests")
)
(global-set-key (kbd "C-x T") 'run-tests)

; Pretty print the selected region (javascript only for now)
(defun pretty-print-region ()
  (interactive)
  (shell-command-on-region (mark) (point) "jspretty" t t))
(global-set-key [f8] 'pretty-print-region)

; Install additional emacs modes
(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'dart-mode)
(add-to-list 'auto-mode-alist '("\\.dart\\'" . dart-mode))

(require 'go-mode-load)
(add-hook 'before-save-hook 'gofmt-before-save)

(defun set-newline-and-indent()
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'go-mode-hook 'set-newline-and-indent)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . javascript-mode))
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
