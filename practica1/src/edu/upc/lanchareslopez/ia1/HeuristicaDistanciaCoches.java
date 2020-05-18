package edu.upc.lanchareslopez.ia1;

import aima.search.framework.HeuristicFunction;

public class HeuristicaDistanciaCoches implements HeuristicFunction {

    @Override
    public double getHeuristicValue(Object o) {
        Estado e = (Estado) o;

        double dist = 0;
        for (int i=0; i<e.getNumTrayectos(); ++i) {
            int d = e.getDistanciaTrayecto(i);
            dist += d;
            if (d > 300) {
                dist += 10*(d-300);
            }
        }

        return dist*e.getNumTrayectos();
    }
}
