(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq-default inhibit-startup-screen t
              dafny-verification-backend 'server
              flycheck-z3-smt2-executable "~/MSR/z3/bin/z3"
              flycheck-dafny-executable "~/MSR/dafny/Binaries/dafny"
              flycheck-boogie-executable "~/MSR/boogie/Binaries/Boogie.exe"
              flycheck-inferior-dafny-executable "~/MSR/dafny/Binaries/dafny-server")

;; Font fallback
(when (functionp 'set-fontset-font)
  (set-face-attribute 'default nil :family "Ubuntu Mono")
  (dolist (ft (fontset-list))
    (set-fontset-font ft 'unicode (font-spec :name "Ubuntu Mono"))
    (set-fontset-font ft 'unicode (font-spec :name "Symbola monospacified for Ubuntu Mono") nil 'append)))

;; Basic usability
(xterm-mouse-mode)
(load-theme 'tango-dark t)
