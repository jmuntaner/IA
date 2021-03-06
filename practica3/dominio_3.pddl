(define (domain planif)
    (:requirements :adl :typing :fluents)
    (:types Programador - item 
            Tarea - item)
    (:functions
        (habilidad ?p - Programador)
        (calidad ?p - Programador)
        (dificultad ?t - Tarea)
        (horas ?t - Tarea)
        (tareas-realizadas ?p - Programador)
        (total)
    )
    (:predicates
        (realizada ?t - Tarea)
        (trabaja ?p - Programador ?t - Tarea)
        (revisada ?t - Tarea)
    )
    (:action realizar
        :parameters (?p - Programador ?t - Tarea)
        :precondition (and
                        (not (realizada ?t))
                        (>= (+ (habilidad ?p) 1) (dificultad ?t))
                        (< (tareas-realizadas ?p) 2)
                    )
        :effect (and
                    (increase (total) (horas ?t))
                    (increase (total) (calidad ?p))
                    (increase (tareas-realizadas ?p) 1)
                    (when (> (dificultad ?t) (habilidad ?p)) (increase (total) 2))
                    (realizada ?t)
                    (not (revisada ?t))
                    (trabaja ?p ?t)
                )
    )
    (:action revisar
        :parameters (?p - Programador ?t - Tarea)
        :precondition (and
                        (not (trabaja ?p ?t))
                        (realizada ?t)
                        (>= (+ (habilidad ?p) 1) (dificultad ?t))
                        (not (revisada ?t))
                        (< (tareas-realizadas ?p) 2)                        
                        )
        :effect (and
                    (increase (tareas-realizadas ?p) 1)                   
                    (revisada ?t) 
                )
    )
) 
