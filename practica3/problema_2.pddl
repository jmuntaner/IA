(define (problem test-01) (:domain planif)
    (:objects p1 p2 p3 - Programador t1 t2 t3 - Tarea)
    (:init
        (= (habilidad p1) 3)
        (= (habilidad p2) 3)
        (= (habilidad p3) 3)
        
        (= (calidad p1) 1)
        (= (calidad p2) 1)
        (= (calidad p3) 2)
        
        (= (dificultad t1) 1)
        (= (dificultad t2) 1)
        (= (dificultad t3) 1)
        
        (= (horas t1) 1)
        (= (horas t2) 2)
        (= (horas t3) 3)

        (= (total) 0)
    )
    (:goal (and
                (forall (?t - Tarea) (realizada ?t))
                (forall (?t - Tarea) (revisada ?t))
            )
    )
    (:metric minimize (total))
)
