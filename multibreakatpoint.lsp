;;;=========================================================================
;;; MULTIBREAKATPOINT Command
;;; Autore: Antonio Demarcus
;;; Version: 1.0
;;; Data: 25/11/2024
;;; 
;;; Comando per dividere una linea (orizzontale o verticale) 
;;; in più punti usando le intersezioni
;;;=========================================================================

(defun C:multibreakatpoint ( / ss pt error oldos mainline lastent choice)
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
  
  ; Chiedi all'utente il tipo di linea
  (initget "Orizzontale Verticale")
  (setq choice (getkword "\nSeleziona il tipo di linea [Orizzontale/Verticale]: "))
  
  ; Seleziona la linea da dividere
  (if choice
    (progn
      (if (= choice "Orizzontale")
        (prompt "\nSeleziona linea orizzontale da dividere con linee verticali: ")
        (prompt "\nSeleziona linea verticale da dividere con linee orizzontali: ")
      )
      
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
            (command "_POINT" pt)
          )
        )
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
(princ "\nVersione: 1.0")
(princ "\nData: 25/11/2024")
(princ)