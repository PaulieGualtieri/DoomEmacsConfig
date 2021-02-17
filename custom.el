(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-custom-commands
   '(("N" "Agenda and all Next actions"
      ((agenda ""
               ((org-agenda-span 3)
                (org-agenda-start-day "0d")
                (org-agenda-start-on-weekday nil)))
       (todo "NEXT"
             ((org-agenda-view-columns-initially t))))
      nil)
     ("A" "Agenda and all actions"
      ((agenda "" nil)
       (todo "" nil))
      nil)))
 '(org-log-into-drawer t)
 '(org-log-reschedule 'time)
 '(org-refile-allow-creating-parent-nodes 'confirm)
 '(package-selected-packages '(org cmake-ide use-package rainbow-delimiters)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
