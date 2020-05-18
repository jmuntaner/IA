

(defmessage-handler  Nutrientes print primary ()
	(loop-for-count (?i 1 (length$ ?*NUTRIENTES*)) do
		(bind ?gnut (sym-cat (str-cat "get-" (nth$ ?i ?*NUTRIENTES*))))
		(printout t (nth$ ?i ?*NUTRIENTES*) " " (send ?self ?gnut) crlf)
	)
)

(defmessage-handler Plato print primary ()
	(printout t ?self:nombre crlf)
)

(defmessage-handler Comida print primary ()
	(bind ?p (send ?self get-platos))
	(loop-for-count (?i 1 (length$ ?p)) do
		(send (nth$ ?i ?p) print)
	)
)

(defmessage-handler MenuDiario print primary ()
	(printout t "Desayuno:" crlf)
	(send ?self:desayuno print)
	(printout t crlf "Comida:" crlf)
	(send ?self:almuerzo print)
	(printout t crlf "Cena:" crlf)
	(send ?self:cena print)
	(printout t crlf)
)

(defmessage-handler Menu print primary ()
	(bind ?d (send ?self get-dias))
	(loop-for-count (?i 1 (length$ ?*DIAS_SEMANA*)) do
		(printout t "=========" crlf)
		(printout t (upcase (nth$ ?i ?*DIAS_SEMANA*)) crlf)
		(printout t "=========" crlf)
		(send (nth$ ?i ?d) print)
	)
	(printout t "Se recomienda beber 2 litros de agua al dia." crlf)
)

(defmessage-handler IngredientePlato print primary ()
	(printout t "    " ?self:cantidad " ")
	(if (neq (send ?self:ingrediente get-nombre_racion) "") then
		(printout t (send ?self:ingrediente get-nombre_racion) " ")
	)
	(printout t (send ?self:ingrediente get-nombre) crlf)
)

(defmessage-handler Comida print-detallado primary ()
	(bind ?p ?self:platos)
	(loop-for-count (?i 1 (length$ ?p)) do
		(printout t (send (nth$ ?i ?p) get-nombre) crlf)
		(bind ?ing (send (nth$ ?i ?p) get-ingrediente_principal))
		(send ?ing print)
		(bind ?ing (send (nth$ ?i ?p) get-ingredientes_secundarios))
		(loop-for-count (?j 1 (length$ ?ing)) do
			(send (nth$ ?j ?ing) print)
		)
	)
)

(defmessage-handler MenuDiario print-detallado primary ()
	(printout t "Desayuno:" crlf)
	(send ?self:desayuno print-detallado)
	(printout t crlf "Comida:" crlf)
	(send ?self:almuerzo print-detallado)
	(printout t crlf "Cena:" crlf)
	(send ?self:cena print-detallado)
	(printout t crlf)
)

(defmessage-handler Menu print-detallado primary ()
	(bind ?d (send ?self get-dias))
	(loop-for-count (?i 1 (length$ ?*DIAS_SEMANA*)) do
		(printout t "=========" crlf)
		(printout t (upcase (nth$ ?i ?*DIAS_SEMANA*)) crlf)
		(printout t "=========" crlf)
		(send (nth$ ?i ?d) print-detallado)
	)
	(printout t "Se recomienda beber 2 litros de agua al dia." crlf)
)
