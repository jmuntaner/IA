(define (domain planif)
    (:requirements :adl :typing :fluents)
    (:types Programador - item 
            Tarea - item)
    (:functions
        (habilidad ?p - Programador)
        (dificultad ?t - Tarea)
    )
    (:predicates
        (realizada ?t - Tarea)
    )
    (:action realizar
        :parameters (?p - Programador ?t - Tarea)
        :precondition (and
                        (>= (+ (habilidad ?p) 1) (dificultad ?t))
                        (not (realizada ?t))
                        )
        :effect (realizada ?t)
    )
)  
