(define (problem test-01) (:domain planif)
    (:objects p1 p2 p3 - Programador t1 t2 t3 - Tarea)
    (:init
        (= (habilidad p1) 1)
        (= (habilidad p2) 2)
        (= (habilidad p3) 3)
        
        (= (dificultad t1) 1)
        (= (dificultad t2) 2)
        (= (dificultad t3) 3)
    )

    (:goal (and
                (forall (?t - Tarea) (realizada ?t))
                (forall (?t - Tarea) (revisada ?t))
            )
    )
)
