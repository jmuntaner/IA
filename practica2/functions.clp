

;%%%%%
;%
;% DEFINITIONS
;%
;%%%%%

(defglobal
    ?*SEXOS* = (create$ varon mujer)
    ?*NIVELES_EJERCICIO* = (create$ bajo medio alto)
    ?*CONDICIONES* = (create$ hipertension diabetes insuficiencia-renal colesterol)
    ?*PREFERENCIAS* = (create$ normal vegetariano vegano pescetariano)
    ?*ESTACIONES* = (create$ Primavera Verano Otono Invierno)
	?*DIAS_SEMANA* = (create$ lunes martes miercoles jueves viernes sabado domingo)
    ?*NUTRIENTES* = (create$ energia proteinas hidratos_de_carbono azucar grasas grasas_saturadas colesterol sodio potasio vitamina_a vitamina_c hierro calcio)
)

(defglobal
    ?*INF* = 100000
)

;%%%%%
;%
;% FUNCTIONS
;%
;%%%%%

;%%% Entrada %%%

(deffunction ask-question-yes-no (?question)
    (printout t ?question "(s/n)" crlf "> ")
    (bind ?answer (read))
    (bind ?allowed-values (create$ Yes No yes no Y N y n Si si S s))
    (while (not (member$ ?answer ?allowed-values)) do
        (printout t ?question "(s/n)" crlf "> ")
        (bind ?answer (read))
    )
    (if (or (eq ?answer No) (eq ?answer no) (eq ?answer N) (eq ?answer n))
        then FALSE
        else TRUE
    )
)

(deffunction ask-question-opt (?question ?allowed-values)
    (printout t ?question ?allowed-values crlf "> ")
    (bind ?answer (read))
    (while (not (member$ ?answer ?allowed-values)) do
        (printout t ?question crlf "> ")
        (bind ?answer (read))
    )
    ?answer
)

(deffunction ask-question-multi-opt (?question ?allowed-values)
    (printout t ?question crlf ?allowed-values crlf "> ")
    (bind ?line (readline))
    (bind $?answer (explode$ ?line))
    (bind ?valid FALSE)
    (while (not ?valid) do
        (loop-for-count (?i 1 (length$ $?answer)) do
            (bind ?valid FALSE)
            (bind ?value-belongs FALSE)
            (loop-for-count (?j 1 (length$ $?allowed-values)) do
                (if (eq (nth$ ?i $?answer) (nth$ ?j $?allowed-values)) then
                    (bind ?value-belongs TRUE)
                    (break)
                )
            )
            (if (not ?value-belongs) then
                (printout t (nth$ ?i $?answer) " is not a valid option" crlf)
                (break)
            )
            (bind ?valid TRUE)
        )
        (if ?valid then (break))

        (printout t ?question crlf "> ")
        (bind ?line (readline))
        (bind $?answer (explode$ ?line))
    )
    $?answer
)

(deffunction ask-question-multi-answer (?question ?allowed-values)
    (printout t ?question crlf ?allowed-values crlf "> ")
    (bind ?line (readline))
    (if (member$ ?line (create$ no No n)) then
        (bind $?answer (create$))
    else
        (bind $?answer (str-explode ?line))
    )
    $?answer
)

(deffunction ask-question-date-format (?question)
    (printout t ?question crlf "> ")
    (while TRUE do
        (bind ?date (readline))
        (bind $?answer (explode$ ?date))
        (if (not (eq (length$ ?answer) 2)) then
            (printout t "| > Incorrect format, date should have the format DD MM" crlf "| ")
        else (if (and
            (and (>= (nth$ 1 ?answer) 1) (<= (nth$ 1 ?answer) 31))
            (and (>= (nth$ 2 ?answer) 1) (<= (nth$ 2 ?answer) 12))) 
            then
                (break)
        else
        (printout t "| > Check that date is valid" crlf "| ")
        ))
    )
    ?answer
)

(deffunction is-num (?num)
    (eq (type ?num) INTEGER)
)

(deffunction ask-question-num (?question ?min ?max)
    (printout t ?question crlf "> ")
    (bind ?answer (read))
    (while (not (and (is-num ?answer) (>= ?answer ?min) (<= ?answer ?max))) do
        (printout t ?question  crlf "> ")
            (bind ?answer (read)))
    ?answer
)

(deffunction ask-question-string (?question)
    (printout t ?question crlf "> ")
    (bind ?answer (read))
    (while (not (lexemep ?answer)) do
        (printout t ?question crlf "> ")
            (bind ?answer (read))
    )
    ?answer
)

;%%% Platos %%%

(deffunction grupo-plato (?plato) "Devuelve que tipo de alimento es el ingrediente principal del plato"
    (bind ?ipp (send ?plato get-ingrediente_principal))
    (bind ?ip (send ?ipp get-ingrediente))
    (send ?ip get-tipo_ingrediente)
)

(deffunction grupo-preferencias (?pref ?grupo) "Comprueba si las personas con las preferencias especificadas pueden comer alimentos de este grupo"
    (switch ?pref
    (case vegetariano then (return (not (member$ ?grupo (create$ Carne Pescado)))))
    (case pescetariano then (return (not (member$ ?grupo (create$ Carne)))))
    (case vegano then (return (not (member$ ?grupo (create$ Carne Pescado Huevos Lacteo)))))
    (default TRUE))
)

(deffunction apto-preferencias (?pref ?plato) "Comprueba si el plato es apto para personas con ciertas preferencias"
    (bind ?ipp (send ?plato get-ingrediente_principal))
    (bind ?g (send (send ?ipp get-ingrediente) get-tipo_ingrediente))
    (if (not (grupo-preferencias ?pref ?g)) then (return FALSE))
    (bind ?isp (send ?plato get-ingredientes_secundarios))
    (loop-for-count (?i 1 (length$ ?isp)) do
        (bind ?g (send (send (nth$ ?i ?isp) get-ingrediente) get-tipo_ingrediente))
        (if (not (grupo-preferencias ?pref ?g)) then (return FALSE))
    )
    TRUE
)

;%%% Nutrientes %%%

(deffunction suma-nutrientes (?n1 ?n2) "Suma a n1 los nutrientes de n2"
	(loop-for-count (?i 1 (length$ ?*NUTRIENTES*)) do
		(bind ?gnut (sym-cat (str-cat "get-" (nth$ ?i ?*NUTRIENTES*))))
		(bind ?pnut (sym-cat (str-cat "put-" (nth$ ?i ?*NUTRIENTES*))))
		(send ?n1 ?pnut (+ (send ?n1 ?gnut) (send ?n2 ?gnut)))
	)
	?n1
)

(deffunction multiplica-nutrientes (?n ?k) "Multiplica las cantidades de n por k"
	(loop-for-count (?i 1 (length$ ?*NUTRIENTES*)) do
		(bind ?gnut (sym-cat (str-cat "get-" (nth$ ?i ?*NUTRIENTES*))))
		(bind ?pnut (sym-cat (str-cat "put-" (nth$ ?i ?*NUTRIENTES*))))
		(send ?n ?pnut (* (send ?n ?gnut) ?k))
	)
	?n
)

(deffunction nutrientes-plato (?p) "Calcula los nutrientes de un plato"
	(if (< (send (send ?p get-nutrientes) get-energia) 0) then
		(bind ?n (duplicate-instance (send (send (send ?p get-ingrediente_principal) get-ingrediente) get-nutrientes)))
		(multiplica-nutrientes ?n (send (send ?p get-ingrediente_principal) get-cantidad))
		(loop-for-count (?i 1 (length$ (send ?p get-ingredientes_secundarios))) do
			(bind ?in (nth$ ?i (send ?p get-ingredientes_secundarios)))
			(bind ?inn (duplicate-instance (send (send ?in get-ingrediente) get-nutrientes)))
			(multiplica-nutrientes ?inn (send ?in get-cantidad))
			(suma-nutrientes ?n ?inn)
		)
		(send ?p put-nutrientes ?n)
	)
	(send ?p get-nutrientes)
)

(deffunction nutrientes-comida (?c) "Calcula los nutrientes de una comida"
	(if (< (send (send ?c get-nutrientes) get-energia) 0) then
		(bind ?p (send ?c get-platos))
		(bind ?n (duplicate-instance (nutrientes-plato (nth$ 1 ?p))))
		(loop-for-count (?i 2 (length$ ?p)) do
			(suma-nutrientes ?n (nutrientes-plato (nth$ ?i ?p)))
		)
		(send ?c put-nutrientes ?n)
	)
	(send ?c get-nutrientes)
)

(deffunction nutrientes-dia (?md) "Calcula los nutrientes de un menu diario"
	(bind ?n (duplicate-instance (nutrientes-comida (send ?md get-desayuno))))
	(if (neq (send ?md get-almuerzo) nil) then (suma-nutrientes ?n (nutrientes-comida (send ?md get-almuerzo))))
	(if (neq (send ?md get-cena) nil) then (suma-nutrientes ?n (nutrientes-comida (send ?md get-cena))))
)


(deffunction puntua-nutrientes-max (?nut ?max) "Comprueba si los nutrientes se encuentran por debajo del maximo. Devuelve una puntuacion."
	(bind ?punt 0.0)
	(loop-for-count (?i 1 (length$ ?*NUTRIENTES*)) do
		(bind ?gnut (sym-cat (str-cat "get-" (nth$ ?i ?*NUTRIENTES*))))
		(bind ?n (send ?nut ?gnut))
		(bind ?nmax (send ?max ?gnut))
		(if (and (neq ?nmax 0.0) (> ?n ?nmax)) then
			(bind ?dif (/ (- ?n ?nmax) ?nmax))
			(bind ?punt (- ?punt ?dif))
		)
	)
	?punt
)

(deffunction puntua-nutrientes-min (?nut ?min) "Comprueba si los nutrientes se encuentran por encima del minimo. Devuelve una puntuacion."
	(bind ?punt 0.0)
	(loop-for-count (?i 1 (length$ ?*NUTRIENTES*)) do
		(bind ?gnut (sym-cat (str-cat "get-" (nth$ ?i ?*NUTRIENTES*))))
		(bind ?n (send ?nut ?gnut))
		(bind ?nmin (send ?min ?gnut))
		(if (< ?n ?nmin) then
			(bind ?dif (/ (- ?nmin ?n) ?nmin))
			(bind ?punt (- ?punt ?dif))
		)
	)
	?punt
)

(deffunction puntua-nutrientes (?nut ?min ?max) "Comprueba si los nutrientes se encuentran entre el minimo y el maximo. Devuelve una puntuacion."
	(+ (puntua-nutrientes-max ?nut ?max) (puntua-nutrientes-min ?nut ?min))
)

(deffunction puntua-nutrientes-debug (?nut ?min ?max) "Comprueba si los nutrientes se encuentran entre el minimo y el maximo. Devuelve una puntuacion."
	(bind ?punt 0.0)
	(loop-for-count (?i 1 (length$ ?*NUTRIENTES*)) do
		(bind ?gnut (sym-cat (str-cat "get-" (nth$ ?i ?*NUTRIENTES*))))
		(bind ?n (send ?nut ?gnut))
		(bind ?nmin (send ?min ?gnut))
		(if (< ?n ?nmin) then
			(printout t "<" (nth$ ?i ?*NUTRIENTES*) " " (/ (- ?nmin ?n) ?nmin) crlf)
			(bind ?dif (/ (- ?nmin ?n) ?nmin))
			(bind ?punt (- ?punt ?dif))
		)
		(bind ?nmax (send ?max ?gnut))
		(if (and (neq ?nmax 0.0) (> ?n ?nmax)) then
			(printout t ">" (nth$ ?i ?*NUTRIENTES*) " " (/ (- ?n ?nmax) ?nmax) crlf)
			(bind ?dif (/ (- ?n ?nmax) ?nmax))
			(bind ?punt (- ?punt ?dif))
		)
	)
	?punt
)
