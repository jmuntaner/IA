package edu.upc.lanchareslopez.ia1;

import aima.search.framework.HeuristicFunction;

public class HeuristicaDistancia implements HeuristicFunction {

    @Override
    public double getHeuristicValue(Object o) {
        Estado e = (Estado) o;

        double dist = 0;
        for (int i=0; i<e.getNumTrayectos(); ++i) {
            int d = e.getDistanciaTrayecto(i);
            dist += d > 300 ? 300 + (d-300)*20 : d;
        }
        return dist;
    }
}
