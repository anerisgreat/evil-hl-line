;;; evil-hl-line.el --- Change hl-line color based on evil state  -*- lexical-binding: t -*-

;; Copyright (C) 2026 Contributors

;; Author: Aner Zakobar <aner@zakobar.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (evil "1.14.0"))
;; Keywords: faces, convenience, evil
;; URL: https://github.com/anerisgreat/evil-hl-line

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; evil-hl-line changes the `hl-line' highlight color to reflect the
;; current evil state.  Each evil state (normal, insert, visual, etc.)
;; has a corresponding face whose background color can be customized.

;; Usage:
;;
;;   (require 'evil-hl-line)
;;   (evil-hl-line-mode 1)
;;
;; With use-package:
;;
;;   (use-package evil-hl-line
;;     :after evil
;;     :config (evil-hl-line-mode 1))
;;
;; Customize colors via `M-x customize-group RET evil-hl-line RET'
;; or by setting face attributes directly:
;;
;;   (set-face-background 'evil-hl-line-normal "LightGoldenrod1")

;;; Code:

(require 'hl-line)
(require 'evil)

(defgroup evil-hl-line nil
  "Change hl-line color based on evil state."
  :group 'evil
  :group 'hl-line
  :prefix "evil-hl-line-"
  :link '(url-link "https://github.com/anerisgreat/evil-hl-line"))

;;; Faces

(defface evil-hl-line-normal
  '((t :inherit hl-line :background "LightGoldenrod1" :extend t))
  "Face for hl-line in evil normal state."
  :group 'evil-hl-line)

(defface evil-hl-line-insert
  '((t :inherit hl-line :background "PaleGreen1" :extend t))
  "Face for hl-line in evil insert state."
  :group 'evil-hl-line)

(defface evil-hl-line-visual
  '((t :inherit hl-line :background "LightGray" :extend t))
  "Face for hl-line in evil visual state."
  :group 'evil-hl-line)

(defface evil-hl-line-replace
  '((t :inherit hl-line :background "LightPink" :extend t))
  "Face for hl-line in evil replace state."
  :group 'evil-hl-line)

(defface evil-hl-line-emacs
  '((t :inherit hl-line :background "LightBlue1" :extend t))
  "Face for hl-line in evil emacs state."
  :group 'evil-hl-line)

(defface evil-hl-line-motion
  '((t :inherit hl-line :background "LightCyan" :extend t))
  "Face for hl-line in evil motion state."
  :group 'evil-hl-line)

(defface evil-hl-line-operator
  '((t :inherit hl-line :background "sandy brown" :extend t))
  "Face for hl-line in evil operator state."
  :group 'evil-hl-line)

;;; Core

(defun evil-hl-line--set-state (face)
  "Set `hl-line-face' to FACE in the current buffer and refresh."
  (global-hl-line-unhighlight)
  (setq-local hl-line-face face)
  (global-hl-line-highlight))

(defun evil-hl-line--normal   () (evil-hl-line--set-state 'evil-hl-line-normal))
(defun evil-hl-line--insert   () (evil-hl-line--set-state 'evil-hl-line-insert))
(defun evil-hl-line--visual   () (evil-hl-line--set-state 'evil-hl-line-visual))
(defun evil-hl-line--replace  () (evil-hl-line--set-state 'evil-hl-line-replace))
(defun evil-hl-line--emacs    () (evil-hl-line--set-state 'evil-hl-line-emacs))
(defun evil-hl-line--motion   () (evil-hl-line--set-state 'evil-hl-line-motion))
(defun evil-hl-line--operator () (evil-hl-line--set-state 'evil-hl-line-operator))

;;; Minor mode

(defun evil-hl-line--add-hooks ()
  "Add evil state entry hooks."
  (add-hook 'evil-normal-state-entry-hook   #'evil-hl-line--normal)
  (add-hook 'evil-insert-state-entry-hook   #'evil-hl-line--insert)
  (add-hook 'evil-visual-state-entry-hook   #'evil-hl-line--visual)
  (add-hook 'evil-replace-state-entry-hook  #'evil-hl-line--replace)
  (add-hook 'evil-emacs-state-entry-hook    #'evil-hl-line--emacs)
  (add-hook 'evil-motion-state-entry-hook   #'evil-hl-line--motion)
  (add-hook 'evil-operator-state-entry-hook #'evil-hl-line--operator))

(defun evil-hl-line--remove-hooks ()
  "Remove evil state entry hooks."
  (remove-hook 'evil-normal-state-entry-hook   #'evil-hl-line--normal)
  (remove-hook 'evil-insert-state-entry-hook   #'evil-hl-line--insert)
  (remove-hook 'evil-visual-state-entry-hook   #'evil-hl-line--visual)
  (remove-hook 'evil-replace-state-entry-hook  #'evil-hl-line--replace)
  (remove-hook 'evil-emacs-state-entry-hook    #'evil-hl-line--emacs)
  (remove-hook 'evil-motion-state-entry-hook   #'evil-hl-line--motion)
  (remove-hook 'evil-operator-state-entry-hook #'evil-hl-line--operator))

;;;###autoload
(define-minor-mode evil-hl-line-mode
  "Change `hl-line' highlight color to reflect the current evil state.

When enabled, the current line highlight changes color as you
switch between evil states (normal, insert, visual, etc.)."
  :global t
  :group 'evil-hl-line
  (if evil-hl-line-mode
      (evil-hl-line--add-hooks)
    (evil-hl-line--remove-hooks)))

(provide 'evil-hl-line)
;;; evil-hl-line.el ends here
