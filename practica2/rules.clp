(defmodule MAIN (export ?ALL))

(defrule MAIN::main "Funcion main"
    (initial-fact)
    =>
    (focus recopilacion-persona)
)

;;;----------------------------------------------------------------------------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------------PREGUNTAS---------------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------------------------------------------------------------------------------------

(defmodule recopilacion-persona "Recopilacion de datos de entrada sobre la persona"
    (import MAIN ?ALL)
    (export ?ALL)
)

(defrule recopilacion-persona::bienvenida
    (declare (salience 0))
	(not (debug))
    =>
    (loop-for-count (?i 1 30) do (printout t crlf))
)

(defrule recopilacion-persona::debug
    (declare (salience 0))
	(debug)
    =>
    (focus calculo-necesidades)
)

(defrule recopilacion-persona::pregunta-nombre "Establece nombre del sujeto"
    (declare (salience -1))
    (not (persona nombre ?))
    =>
    (bind ?nombre (ask-question-string "Como se llama?"))
    (assert (persona nombre ?nombre))
)


(defrule recopilacion-persona::pregunta-edad "Establece edad del sujeto"
    (declare (salience -2))
    (not (persona edad ?))
    =>
	(bind ?d (ask-question-num "Que edad tiene?" 18 100))
	(if (< ?d 65) then
		(printout t "Tenga en cuenta que el sistema de generacion de menus esta pensado para personas de mas de 65 anyos." crlf)
		(printout t "Los resultados para su edad pueden ser inexactos." crlf)
	)
    (assert (persona edad ?d))
)


(defrule recopilacion-persona::pregunta-fisica "Establece sexo, estatura y peso del sujeto"
    (declare (salience -3))
    (not (persona estatura ?))
    =>
    (bind ?sex (ask-question-multi-opt "Indiquenos su sexo:" ?*SEXOS*))
    (bind ?est (ask-question-num "Introduzca su estatura en cm:" 50 250))
    (bind ?pes (ask-question-num "Introduzca su peso en kg:" 20 500))
    (assert (persona sexo ?sex))
    (assert (persona estatura ?est))
    (assert (persona peso ?pes))
)

(defrule recopilacion-persona::pregunta-ejercicio "Establece ejercicio fisico del sujeto"
    (declare (salience -4))
    (not (persona grado-ejercicio ?))
    =>
    (bind ?ge (ask-question-multi-opt "Cuanta actividad fisica hace?" ?*NIVELES_EJERCICIO*))
    (assert (persona grado-ejercicio ?ge))
)

(defrule recopilacion-persona::pregunta-condiciones "Establece enfermedades y otras condiciones"
    (declare (salience -5))
    (not (persona condiciones $?))
    =>
    (bind ?cond (ask-question-multi-answer "Se encuentra en alguna de estas situaciones (mencionelas todas o escriba no)? " ?*CONDICIONES*))
    (assert (persona condiciones ?cond))
)

(defrule recopilacion-persona::pregunta-preferencias "Establece preferencias dieteticas"
    (declare (salience -6))
    (not (persona preferencias ?))
    =>
    (bind ?pr (ask-question-multi-answer "Cuales son sus preferencias nutricionales? " ?*PREFERENCIAS*))
    (assert (persona preferencias ?pr))
)

(defrule recopilacion-persona::pregunta-estacion "Establece para que estacion del anyo es el menu"
    (declare (salience -7))
    (not (persona estacion ?))
    =>
    (bind ?e (ask-question-multi-answer "Durante que estacion del anyo va a seguir el menu? " ?*ESTACIONES*))
    (assert (persona estacion ?e))
    (focus calculo-necesidades)
)

;;;----------------------------------------------------------------------------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------Calculo DATOS-----------------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------------------------------------------------------------------------------------


(defmodule calculo-necesidades "Calculo de las necesidades nutricionales de la persona"
    (import MAIN ?ALL)
    (import recopilacion-persona ?ALL)
    (export ?ALL)
)

(defrule calculo-necesidades::calcula-energia "Calcula la energia diaria en kcal"
	(declare (salience -1))
    (not (necesidades energia ?))
    (persona edad ?edad)
    (persona peso ?peso)
    (persona estatura ?est)
    (persona sexo ?sexo)
    (persona grado-ejercicio ?nact)
    =>
    (if (eq ?sexo varon) then
        (bind ?mb (+ 66.4 (* 13.75 ?peso) (* 5 ?est) (* -6.55 ?edad)))
    else
        (bind ?mb (+ 655 (* 9.46 ?peso) (* 1.8 ?est) (* -4.68 ?edad)))
    )
    (if (eq ?nact bajo) then
        (bind ?er (* ?mb 1.2))
    else
        (if (eq ?nact medio) then
            (bind ?er (* ?mb 1.4))
        else
            (bind ?er (* ?mb 1.6))
        )
    )
	(make-instance nmin of Nutrientes (energia (* 0.95 ?er))) ;margen del 5%
	(make-instance nmax of Nutrientes (energia (* 1.05 ?er)))
	(assert (necesidades energia ?er))
)

(defrule calculo-necesidades::calcula-macronutrientes "Calcula los macronutrientes, en g"
    (declare (salience -2))
	(necesidades energia ?energia)
	(persona peso ?peso)
    =>
	(send [nmin] put-proteinas (* 0.66 ?peso))
	(send [nmax] put-proteinas (* 0.83 ?peso))
	(send [nmin] put-hidratos_de_carbono (* 0.125 ?energia)) ; 50-60% de la energia, 4 kcal/g
	(send [nmax] put-hidratos_de_carbono (* 0.15 ?energia)) 
	(send [nmin] put-azucar (* 0.0125 ?energia)) ; 5-10% de la energia, 4 kcal/g
	(send [nmax] put-azucar (* 0.025 ?energia)) 
	(send [nmin] put-grasas (* 0.0333 ?energia)) ; 30-35% de la energia, 9 kcal/g
	(send [nmax] put-grasas (* 0.0389 ?energia)) 
	(send [nmin] put-grasas_saturadas (* 0.00778 ?energia)) ; 7-10% de la energia, 9 kcal/g
	(send [nmax] put-grasas_saturadas (* 0.01111 ?energia)) 
	(send [nmin] put-colesterol 0) ;no se limita excepto en caso de hipercolesterolemia
	(send [nmax] put-colesterol ?*INF*) 
	(assert (necesidades macro))
)

(defrule calculo-necesidades::calcula-micronutrientes "Calcula los micronutrientes, en porcentaje de la cantidad recomendada para una dieta de 2000 calorías. En mg para el sodio y el potasio."
    (declare (salience -2))
	(necesidades energia ?energia)
    =>
    (bind ?p (* 100 (/ ?energia 2000)))
	(send [nmin] put-vitamina_c ?p)
	(send [nmax] put-vitamina_c ?*INF*)
	(send [nmin] put-vitamina_a ?p)
	(send [nmax] put-vitamina_a ?*INF*)
	(send [nmin] put-hierro ?p)
	(send [nmax] put-hierro ?*INF*)
	(send [nmin] put-calcio ?p)
	(send [nmax] put-calcio ?*INF*)
	(send [nmin] put-sodio 500)
	(send [nmax] put-sodio 5000)
	(send [nmin] put-potasio 3500)
	(send [nmax] put-potasio ?*INF*)
	(assert (necesidades micro))
)

(defrule calculo-necesidades::diabetes "Adapta las necesidades a usuarios con diabetes"
	(declare (salience -3))
	(persona condiciones $?cond)
	(necesidades energia ?energia)
	(test (member$ diabetes ?cond))
	=>
	(send [nmin] put-grasas (* 0.0278 ?energia)) ; Reducir grasa a 25-30% de la energia, 9 kcal/g
	(send [nmax] put-grasas (* 0.0333 ?energia))
	(send [nmin] put-hidratos_de_carbono (* 0.125 ?energia)) ; 50-65% de la energia, 4 kcal/g, para compensar la reduccion de grasa
	(send [nmax] put-hidratos_de_carbono (* 0.163 ?energia))
	(send [nmin] put-sodio 250)
	(send [nmax] put-sodio 2300) ; Menos de 2.3 g de sodio al dia
)

(defrule calculo-necesidades::hipertension "Adapta las necesidades a usuarios con hipertension"
	(declare (salience -3))
	(persona condiciones $?cond)
	(necesidades energia ?energia)
	(test (member$ hipertension ?cond))
	=>
	(send [nmin] put-sodio 250)
	(send [nmax] put-sodio 2300) ; Menos de 2.3 g de sodio al dia
	(send [nmin] put-potasio 4700)  ; Mas de 4700 mg de potasio
	(send [nmax] put-potasio ?*INF*)
	(send [nmin] put-grasas (* 0.0278 ?energia)) ; Reducir grasa a 25-30% de la energia, 9 kcal/g
	(send [nmax] put-grasas (* 0.0333 ?energia))
	(send [nmin] put-hidratos_de_carbono (* 0.125 ?energia)) ; 50-65% de la energia, 4 kcal/g, para compensar la reduccion de grasa
	(send [nmax] put-hidratos_de_carbono (* 0.163 ?energia))
)

(defrule calculo-necesidades::insuficiencia-renal "Adapta las necesidades a usuarios con insuficiencia renal"
	(declare (salience -3))
	(persona condiciones $?cond)
	(necesidades energia ?energia)
	(test (member$ insuficiencia-renal ?cond))
	=>
	(send [nmin] put-sodio 250)
	(send [nmax] put-sodio 2300) ; Menos de 2.3 g de sodio al dia
	(send [nmin] put-vitamina_c (* (send [nmin] get-vitamina_c) 1.5)) ; Mas vitamina C
	(send [nmax] put-vitamina_c ?*INF*)
)

(defrule calculo-necesidades::colesterol "Adapta las necesidades a usuarios con hipercolesterolemia"
	(declare (salience -3))
	(persona condiciones $?cond)
	(necesidades energia ?energia)
	(test (member$ colesterol ?cond))
	=>
	(send [nmin] put-grasas_saturadas (* 0.00333 ?energia)) ; 3-7% de la energia, 9 kcal/g
	(send [nmax] put-grasas_saturadas (* 0.00777 ?energia)) 
	(send [nmin] put-colesterol 0) ; 3-7% de la energia, 9 kcal/g ; Limita el colesterol a 200 mg
	(send [nmax] put-colesterol 200)
)

(defrule calculo-necesidades::cambia-foco "Cambia el foco si todas las necesidades estan definidas"
    (declare (salience -4))
    =>
	(printout t "El desayuno," crlf)
    (focus generacion-comidas)
)

;;;----------------------------------------------------------------------------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------Generacion COMIDAS------------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------------------------------------------------------------------------------------


(defmodule generacion-comidas "Generacion de las comidas"
    (import MAIN ?ALL)
    (import recopilacion-persona ?ALL)
    (import calculo-necesidades ?ALL)
    (export ?ALL)
)

(defrule generacion-comidas::puntuar-platos "Baja la puntuacion de los platos fuera de temporada o no aptos para las preferencias"
	(declare (salience -2))
	?p <- (object (is-a Plato) (estacion $?e))
	(persona preferencias ?pref)
	(persona estacion ?es)
	=>
	(bind ?punt 0)
	(if (not (apto-preferencias ?pref ?p)) then
		(bind ?punt (- ?punt 2))
	)
	(if (not (member$ ?es ?e)) then
		(bind ?punt (- ?punt 1))
	)
	(send ?p put-puntuacion ?punt)
)


(defrule generacion-comidas::generar-desayunos "Genera todos los desayunos posibles"
	(declare (salience -1))
	?fr <- (object (is-a Plato) (tipo_plato $?tp1))
	(test (eq (grupo-plato ?fr) Fruta))
	(test (member$ Desayuno ?tp1))
	?la <- (object (is-a Plato) (tipo_plato $?tp2))
	(test (member$ (grupo-plato ?la) (create$ Lacteo Otro)))
	(test (member$ Desayuno ?tp2))
	?ce <- (object (is-a Plato) (tipo_plato $?tp3))
	(test (eq (grupo-plato ?ce) Cereal))
	(test (member$ Desayuno ?tp3))
	=>
	(bind ?des (make-instance (gensym*) of Desayuno (platos ?la ?ce ?fr)))
)


(defrule generacion-comidas::generar-almuerzos "Genera todos los almuerzos/cenas posibles"
	(declare (salience -1))
	?pr <- (object (is-a Plato) (tipo_plato $?tp1))
	(test (member$ (grupo-plato ?pr) (create$ Legumbre Cereal Verdura Otro)))
	(test (member$ Principal ?tp1))
	?se <- (object (is-a Plato) (tipo_plato $?tp2))
	(test (member$ (grupo-plato ?se) (create$ Legumbre Carne Pescado Huevos Otro)))
	(test (neq (grupo-plato ?se) (grupo-plato ?pr)))
	(test (member$ Principal ?tp2))
	?po <- (object (is-a Plato) (tipo_plato $?tp3))
	(test (member$ Postre ?tp3))
	?ac <- (object (is-a Plato) (tipo_plato $?tp4))
	(test (neq (grupo-plato ?ac) (grupo-plato ?pr)))
	(test (neq (grupo-plato ?ac) (grupo-plato ?se)))
	(test (member$ Acompanamiento ?tp4))
	=>
	(make-instance (gensym*) of ComidaPrincipal (platos ?pr ?se ?ac ?po))
)

(defrule generacion-comidas::filtrar-desayunos-deficientes "Filtra los desayunos que no aportan una cantidad adecuada de energia"
	(declare (salience -2))
	?des <- (object (is-a Desayuno))
	=>
	(bind ?nut (nutrientes-comida ?des))
	(if (< (send ?nut get-energia) (* (send [nmin] get-energia) 0.25)) then
		(send ?des delete)
	else
		(if (> (send ?nut get-energia) (* (send [nmax] get-energia) 0.4)) then
			(send ?des delete)
		else
			(loop-for-count (?i 1 (length$ ?*NUTRIENTES*)) do
				(bind ?gnut (sym-cat (str-cat "get-" (nth$ ?i ?*NUTRIENTES*))))
				(bind ?n (send ?nut ?gnut))
				(bind ?nmax (send [nmax] ?gnut))
				(if (and (neq ?nmax 0.9) (> ?n ?nmax)) then
					(send ?des delete)
					(break)
				)
			)
		)
	)
)

(defrule generacion-comidas::filtrar-principales-deficientes "Filtra las comidas principales que no aportan una cantidad adecuada de energia"
	(declare (salience -2))
	(gen-comidas principales)
	?des <- (object (is-a ComidaPrincipal))
	=>
	(bind ?nut (nutrientes-comida ?des))
	(if (< (send ?nut get-energia) (* (send [nmin] get-energia) 0.3)) then
		(send ?des delete)
	else
		(if (> (send ?nut get-energia) (* (send [nmax] get-energia) 0.5)) then
			(send ?des delete)
		else
			(loop-for-count (?i 1 (length$ ?*NUTRIENTES*)) do
				(bind ?gnut (sym-cat (str-cat "get-" (nth$ ?i ?*NUTRIENTES*))))
				(bind ?n (send ?nut ?gnut))
				(bind ?nmax (send [nmax] ?gnut))
				(if (and (neq ?nmax 0.9) (> ?n ?nmax)) then
					(send ?des delete)
					(break)
				)
			)
		)
	)
)

(defrule generacion-comidas::filtrar-comidas-repetitivas "Filtra las comidas principales repetitivas"
	(declare (salience -3))
	(gen-comidas principales)
	?cp <- (object (is-a ComidaPrincipal) (platos $?p))
	=>
	(bind ?del FALSE)
	(loop-for-count (?i 1 (length$ ?p)) do
        (loop-for-count (?j (+ ?i 1) (length$ ?p)) do
            (if (eq (grupo-plato (nth$ ?i ?p)) (grupo-plato (nth$ ?j ?p))) then
                (send ?cp delete)
				(bind ?del TRUE)
				(break)
            )
        )
		(if (eq ?del TRUE) then (break))
	)
)

(defrule generacion-comidas::acabar
	(declare (salience -10))
	=>
	(focus generacion-menus)
)

;;;----------------------------------------------------------------------------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------Generacion MENUS--------------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------------------------------------------------------------------------------------

(defmodule generacion-menus "Generacion de los menus"
    (import MAIN ?ALL)
    (import generacion-comidas ?ALL)
    (import calculo-necesidades ?ALL)
    (export ?ALL)
)

(defrule generacion-menus::inicializar
	(declare (salience -3))
	?r <- (fase comidas)
	=>
	(retract ?r)
	(assert (fase desayunos))
)


(defrule generacion-menus::crea-menu-vacio "Crea un menu vacio"
	(declare (salience -4))
	=>
	(make-instance menu of Menu)
	(loop-for-count (?i 1 (length$ ?*DIAS_SEMANA*)) do
		(bind ?d (make-instance (nth$ ?i ?*DIAS_SEMANA*) of MenuDiario))
		(slot-insert$ [menu] dias ?i ?d)
	)
	(assert (gen-menus vacios))
	(assert (gen-menus desayunos reptresh 0))
	(assert (gen-menus desayunos platotresh 0))
)


(defrule generacion-menus::anade-desayuno-dia "Anade desayunos a los menus vacios"
	(declare (salience -5))
	(gen-menus vacios)
	(gen-menus desayunos reptresh ?reptresh)
	(gen-menus desayunos platotresh ?platotresh)
	?m <- (object (is-a MenuDiario))
	(not (gen-menus desayunado ?m TRUE))
	=>
	(bind ?repes 1000)
	(bind ?platosmalos 1000)
	(bind ?dess (find-all-instances ((?d Desayuno)) TRUE))
	(loop-for-count (?ides 1 (length$ ?dess)) do
		(bind ?des (nth$ ?ides ?dess))
		(bind ?repes 0)
		(bind ?platosmalos 0)
		(loop-for-count (?i 1 (length$ (send ?des get-platos))) do
			(bind ?p (nth$ ?i (send ?des get-platos)))
			(bind ?fnd (find-all-instances ((?md MenuDiario)) (and (neq (send ?md get-desayuno) [nil]) (member$ ?p (send (send ?md get-desayuno) get-platos)))))
			(bind ?repes (+ (length$ ?fnd) ?repes))
			(bind ?platosmalos (- ?platosmalos (send ?p get-puntuacion)))
		)
		(if (and (<= ?repes ?reptresh) (<= ?platosmalos ?platotresh)) then
			(send ?m put-desayuno ?des)
			(assert (gen-menus desayunado ?m TRUE))
			(break)
		)
	)
	(if (or (> ?repes ?reptresh) (> ?platosmalos ?platotresh)) then (assert (gen-menus desayunado ?m FALSE)))
)

(defrule generacion-menus::aumenta-tresh-desayunos "Aumenta el numero de posibles repeticiones o de platos no deseados (por estacion o preferencia) en los desayunos"
	(declare (salience -5))
	?r1 <- (gen-menus desayunado ?m FALSE)
	?r2 <- (gen-menus desayunos reptresh ?reptresh)
	?r3 <- (gen-menus desayunos platotresh ?platotresh)
	=>
	(retract ?r1)
	(if (<= ?reptresh (+ ?platotresh 1)) then
		(retract ?r2)
		(assert (gen-menus desayunos reptresh (+ ?reptresh 1)))
	else
		(retract ?r3)
		(assert (gen-menus desayunos platotresh (+ ?platotresh 1)))
	)
)

(defrule generacion-menus::comprueba-desayunos
	(declare (salience -6))
	=>
	(assert (fase almuerzos))
	(assert (gen-menus almuerzos reptresh 0))
	(assert (gen-menus almuerzos platotresh 0))
	(printout t "La comida..." crlf)
)

(defrule generacion-menus::anade-almuerzo-dia "Anade almuerzos a los menus"
	(declare (salience -6))
	(fase almuerzos)
	(gen-menus almuerzos reptresh ?reptresh)
	(gen-menus almuerzos platotresh ?platotresh)
	?m <- (object (is-a MenuDiario))
	(not (gen-menus almorzado ?m TRUE))
	=>
	(bind ?repes 1000)
	(bind ?platosmalos 1000)
	(bind ?dess (find-all-instances ((?d ComidaPrincipal)) TRUE))
	(loop-for-count (?ides 1 (length$ ?dess)) do
		(bind ?des (nth$ ?ides ?dess))
		(bind ?repes 0)
		(bind ?platosmalos 0)
		(loop-for-count (?i 1 (length$ (send ?des get-platos))) do
			; repeticiones con otros almuerzos
			(bind ?p (nth$ ?i (send ?des get-platos)))
			(bind ?fnd (find-all-instances ((?md MenuDiario)) (and (neq (send ?md get-almuerzo) [nil]) (member$ ?p (send (send ?md get-almuerzo) get-platos)))))
			(bind ?repes (+ (length$ ?fnd) ?repes))
			; repeticiones con el desayuno anterior
			(if (member$ ?p (send (send ?m get-desayuno) get-platos)) then (bind ?repes (+ 20 ?repes)))
			; platos fuera de estacion o de preferencias
			(bind ?platosmalos (- ?platosmalos (send ?p get-puntuacion)))
		)
		(bind ?nut (suma-nutrientes (duplicate-instance (nutrientes-comida (send ?m get-desayuno))) (nutrientes-comida ?des)))
		(if (> (puntua-nutrientes-max ?nut [nmax]) 0) then
			(bind ?platosmalos (+ ?platosmalos 50))
		)
		(if (and (<= ?repes ?reptresh) (<= ?platosmalos ?platotresh)) then
			(send ?m put-almuerzo ?des)
			(assert (gen-menus almorzado ?m TRUE))
			(break)
		)
	)
	(if (or (> ?repes ?reptresh) (> ?platosmalos ?platotresh)) then (assert (gen-menus almorzado ?m FALSE)))
)

(defrule generacion-menus::aumenta-tresh-almuerzos "Aumenta el numero de posibles repeticiones o de platos no deseados (por estacion o preferencia) en los almuerzos"
	(declare (salience -6))
	(fase almuerzos)
	?r1 <- (gen-menus almorzado ?m FALSE)
	?r2 <- (gen-menus almuerzos reptresh ?reptresh)
	?r3 <- (gen-menus almuerzos platotresh ?platotresh)
	=>
	(printout t ?reptresh " " ?platotresh crlf)
	(retract ?r1)
	(if (<= ?reptresh (+ ?platotresh 1)) then
		(retract ?r2)
		(assert (gen-menus almuerzos reptresh (+ ?reptresh 1)))
	else
		(retract ?r3)
		(assert (gen-menus almuerzos platotresh (+ ?platotresh 1)))
	)
)

(defrule generacion-menus::comprueba-almuerzos
	(declare (salience -7))
	?r <- (fase almuerzos)
	=>
	(retract ?r)
	(assert (fase cenas))
	(assert (gen-menus cenas reptresh 0))
	(assert (gen-menus cenas platotresh 0))
	(printout t "Y la cena!" crlf)
)

(defrule generacion-menus::anade-cena-dia "Anade cenas a los menus"
	(declare (salience -8))
	(fase cenas)
	?f1 <- (gen-menus cenas reptresh ?reptresh)
	?f2 <- (gen-menus cenas platotresh ?platotresh)
	?m <- (object (is-a MenuDiario))
	(not (gen-menus cenado ?m TRUE))
	=>
	(bind ?repes 1000)
	(bind ?platosmalos 1000)
	(bind ?minreps 1000)
	(bind ?minpm 1000)
	(bind ?dess (find-all-instances ((?d ComidaPrincipal)) TRUE))
	(loop-for-count (?ides 1 (length$ ?dess)) do
		(bind ?des (nth$ ?ides ?dess))
		(bind ?repes 0)
		(bind ?platosmalos 0)
		(loop-for-count (?i 1 (length$ (send ?des get-platos))) do
			; repeticiones con otras cenas
			(bind ?p (nth$ ?i (send ?des get-platos)))
			(bind ?fnd (find-all-instances ((?md MenuDiario)) (and (neq (send ?md get-cena) [nil]) (member$ ?p (send (send ?md get-cena) get-platos)))))
			(bind ?repes (+ (length$ ?fnd) ?repes))
			; repeticiones con el desayuno o el almuerzo anterior
			(if (member$ ?p (send (send ?m get-desayuno) get-platos)) then (bind ?repes (+ 20 ?repes)))
			(if (member$ ?p (send (send ?m get-almuerzo) get-platos)) then (bind ?repes (+ 20 ?repes)))
			; repeticiones con cualquier otra comida
			(bind ?fnd (find-all-instances ((?md MenuDiario)) (member$ ?p (send (send ?md get-almuerzo) get-platos))))
			(bind ?repes (+ (length$ ?fnd) ?repes))
			; platos fuera de estacion o de preferencias
			(bind ?platosmalos (- ?platosmalos (send ?p get-puntuacion)))
			; mismo tipo de plato que el almuerzo
			(if (member$ (grupo-plato ?p) (create$ Carne Pescado Huevos Legumbres)) then
				(bind ?ps (send (send ?m get-almuerzo) get-platos))
				(if (eq (grupo-plato ?p) (grupo-plato (nth$ 1 ?ps))) then (bind ?repes (+ 1 ?repes)))
				(if (eq (grupo-plato ?p) (grupo-plato (nth$ 2 ?ps))) then (bind ?repes (+ 1 ?repes)))
			)
		)
		(bind ?nut (suma-nutrientes (duplicate-instance (nutrientes-comida (send ?m get-desayuno))) (nutrientes-comida ?des)))
		(if (< (puntua-nutrientes-max ?nut [nmax]) 0) then
			(bind ?platosmalos (+ ?platosmalos (* (puntua-nutrientes-max ?nut [nmax]) -10)))
		)
		(if (< (puntua-nutrientes-min ?nut [nmin]) 0) then
			(bind ?platosmalos (+ ?platosmalos (* (puntua-nutrientes-min ?nut [nmin]) -10)))
		)
		(if (< ?repes ?minreps) then (bind ?minreps ?repes))
		(if (< ?platosmalos ?minpm) then (bind ?minpm ?platosmalos))
		(if (and (<= ?repes ?reptresh) (<= ?platosmalos ?platotresh)) then
			(send ?m put-cena ?des)
			(assert (gen-menus cenado ?m TRUE))
			(break)
		)
	)
	(if (neq (send ?m get-cena) nil) then (assert (gen-menus cenado ?m FALSE)))
	(if (> ?minreps ?reptresh) then
		(retract ?f1)
		(assert (gen-menus cenas reptresh ?minreps))
	)
	(if (> ?minpm ?platotresh) then
		(retract ?f2)
		(assert (gen-menus cenas platotresh ?minpm))
	)
)

(defrule generacion-menus::aumenta-tresh-cenas "Aumenta el numero de posibles repeticiones o de platos no deseados (por estacion o preferencia) en las cenas"
	(declare (salience -8))
	(fase cenas)
	?r1 <- (gen-menus cenado ?m FALSE)
	?r2 <- (gen-menus cenas reptresh ?reptresh)
	?r3 <- (gen-menus cenas platotresh ?platotresh)
	=>
	(retract ?r1)
	(if (> ?platotresh 10) then
		(retract ?r2)
		(assert (gen-menus cenas reptresh 1000))
	else
	(if (<= ?reptresh (+ ?platotresh 1)) then
		(retract ?r2)
		(assert (gen-menus cenas reptresh (+ ?reptresh 1)))
	else
		(retract ?r3)
		(assert (gen-menus cenas platotresh (+ ?platotresh 1)))
	))
)

(defrule generacion-menus::acaba
	(declare (salience -20))
	?r <- (fase cenas)
	=>
	(retract ?r)
	(focus resultados)
)

;;;----------------------------------------------------------------------------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------Impresion RESULTADOS----------------------------------------------------------
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;;----------------------------------------------------------------------------------------------------------------------------

(defmodule resultados "Impresion de los menus"
    (import MAIN ?ALL)
	(import generacion-menus ?ALL)
    (export ?ALL)
)

(defrule resultados::imprimir-resultados "Imprime el menu resultante"
	(persona nombre ?nombre)
	=>
	(if (ask-question-yes-no "Quiere ver los resultados detallados?") then
		(printout t crlf "MENU DETALLADO DE " (upcase ?nombre) crlf)
		(printout t "========================================="  crlf)
		(send [menu] print-detallado)
	else
		(printout t crlf "MENU DE " (upcase ?nombre) crlf)
		(printout t "========================================="  crlf)
		(send [menu] print)
	)
	(printout t crlf "Este programa no ha sido revisado por profesionales de la salud y ofrece estas recomendaciones solo a titulo informativo, si tiene necesidades nutricionales especiales consulte con su medico o nutricionista." crlf)
)

