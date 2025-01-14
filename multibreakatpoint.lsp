;;;=========================================================================
;;; MULTIBREAKATPOINT Command
;;; Autore: Antonio Demarcus
;;; Version: 2.0
;;; Data: 14/01/2025
;;; 
;;; Comando per dividere una linea che interseca un altra linea o piu linee con qualsiasi angolazione 
;;; e in più punti usando le intersezioni
;;;=========================================================================

(defun C:multibreakatpoint ( / ss pt error oldos mainline lastent)
  ; Gestione errori
  (setq error *error*)
  (defun *error* (msg)
    (if (/= "Function cancelled" msg)
      (prompt (strcat "\nErrore: " msg))
    )
    (setq *error* error)
    (princ)
  )
  
  ; Crea layer per i punti di riferimento se non esiste
  (if (null (tblsearch "LAYER" "BREAK_POINTS"))
    (command "._LAYER" "M" "BREAK_POINTS" "C" "1" "" "")
  )
  
  ; Salva layer corrente
  (setq oldlayer (getvar "CLAYER"))
  
  ; Seleziona la linea da dividere
  (prompt "\nSeleziona la linea da dividere: ")
  (if (setq mainline (entsel))
    (progn
      (setq lastent (car mainline))
      
      ; Loop principale
      (while (setq pt (getpoint "\nSeleziona punto di intersezione o INVIO per uscire: "))
        ; Esegui il break
        (command "_BREAK" lastent pt pt)
        
        ; Aggiorna l'entità per il prossimo break
        (setq lastent (entlast))
        
        ; Inserisci punto di riferimento
        (command "._LAYER" "S" "BREAK_POINTS" "")
        (command "_POINT" pt)
        (command "._LAYER" "S" oldlayer "")
      )
    )
  )
  
  ; Ripristina il layer originale
  (command "._LAYER" "S" oldlayer "")
  
  (princ "\nComando completato.")
  (princ)
)

;;;=========================================================================
;;; Caricamento completato
;;;=========================================================================
(princ "\nComando multibreakatpoint caricato correttamente.")
(princ "\nAutore: Antonio Demarcus")
(princ "\nVersione: 2.0")
(princ "\nData: 14/01/2025")
(princ)
