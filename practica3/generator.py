#!/usr/bin/env python3

import sys
from random import randint
from math import ceil

class Tarea:
    '''Representa una tarea con una dificultad d y un tiempo de realización t'''
    
    def __init__(self):
        '''Inicializa con una dificultad y un tiempo de realización aleatorios'''
        self.d = randint(1, 3)
        self.t = randint(1, 15)

class Programador:
    '''Representa un programador con una habilidad s y una calidad c'''
    def __init__(self):
        self.s = randint(1, 3)
        self.c = randint(1, 2)
 

def errorExit():
    '''Función para mostrar un error si los argumentos de ejecución son incorrectos'''    
    print('Usage: python {} [MODE] [n]'.format(sys.argv[0]))
    print('\tn es el número de tareas')
    print('\tMODE:')
    print('\t  basico -- Para el caso básico.')
    print('\t  1      -- Para la extensión 1')
    print('\t  2      -- Para la extensión 2')
    print('\t  3      -- Para la extensión 3')
    print('\t  4      -- Para la extensión 4')
    exit(1)

def genera(n, mode):
    '''Genera un caso de prueba de tamaño n para la extensión mode'''
    
    # Inicializa la lista de tareas
    tareas = []
    for i in range(n):
        tareas.append(Tarea())

    hard = len([x for x in tareas if x.d == 3])
    
    # Genera la lista de programadores. No debe haber demasiados ni demasiados pocos,
    # ni los programadores de habilidad alta deben ser insuficientes
    prog = []
    while len(prog) == 0 or len([x for x in prog if x.s >= 2])*2 < hard:
        prog = []
        m = randint(ceil(n/2), 2*n)
        for i in range(m):
            prog.append(Programador())

    # Imprime la parte inicial del programa y define los programadores y tareas
    s = '(define (problem test) (:domain planif)\n\t(:objects '
    for i in range(len(prog)):
        s += 'p{} '.format(str(i))
    s += '- Programador '
    for i in range(len(tareas)):
        s += 't{} '.format(str(i))
    s += '- Tarea)\n\t(:init'
    
    # Define las funciones que especifican las características de los programadores
    s += '\n'
    for i, p in enumerate(prog):
        s += '\t\t(= (habilidad p{}) {})\n'.format(str(i), p.s)
        if mode == '2' or mode == '3' or mode == '4':
            s += '\t\t(= (calidad p{}) {})\n'.format(str(i), p.c)
        if mode == '3' or mode == '4':
            s += '\t\t(= (tareas-realizadas p{}) 0)\n'.format(str(i))
    
    # Define las funciones que especifican las características de las tareas
    for i, t in enumerate(tareas):
        s += '\t\t(= (dificultad t{}) {})\n'.format(str(i), t.d)
        if mode == '2' or mode == '3' or mode == '4':
            s += '\t\t(= (horas t{}) {})\n'.format(str(i), t.t)
    if mode == '2' or mode == '3' or mode == '4':
        s += '\t\t(= (total) 0)\n'
    if mode == '4':
        s += '\t\t(= (num-personas) 0)\n'
    s += '\t)\n'
    
    # Define el goal del programa
    if mode == 'basico':
        s += '\t(:goal (forall (?t - Tarea) (realizada ?t)))\n'
    else:
        s += '\t(:goal (and\n\t\t(forall (?t - Tarea) (realizada ?t))\n'
        s += '\t\t(forall (?t - Tarea) (revisada ?t))\n\t\t)\n\t)\n'
    if mode == '2' or mode == '3':
        s += '\t(:metric minimize (total))\n'
    if mode == '4':
        s += '\t(:metric minimize (+ (* (num-personas) 90) (* (total) 10)))\n'
    s += ')'
    
    return s

if __name__ == '__main__':
    
    try:
        n = int(sys.argv[2])
    except:
        errorExit()
    if n < 1:
        errorExit()

    mode = sys.argv[1]
    if mode not in ['basico', '1', '2', '3', '4']:
        errorExit()
    
    s = genera(n,mode)
    print(s)
