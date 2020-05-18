(define (domain planif)
    (:requirements :adl :typing)
    (:types Programador - item 
            Tarea - item)
    (:functions
        (habilidad ?p - Programador)
        (dificultad ?t - Tarea)
    )
    (:predicates
        (trabaja ?p - Programador ?t - Tarea)
        (realizada ?t - Tarea)
        (revisada ?t - Tarea)
    )
    (:action realizar
        :parameters (?p - Programador ?t - Tarea)
        :precondition (and
                        (>= (+ (habilidad ?p) 1) (dificultad ?t))
                        (not (realizada ?t))
                        )
        :effect (and
                    (trabaja ?p ?t)
                    (realizada ?t)
                    (not (revisada ?t))
                )
    )
    (:action revisar
        :parameters (?p - Programador ?t - Tarea)
        :precondition (and 
                        (>= (+ (habilidad ?p) 1) (dificultad ?t))
                        (not (trabaja ?p ?t))
                        (realizada ?t)
                        (not (revisada ?t))
                        )
        :effect (revisada ?t)
    )
) 
