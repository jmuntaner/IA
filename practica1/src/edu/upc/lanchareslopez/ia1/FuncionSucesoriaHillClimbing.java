package edu.upc.lanchareslopez.ia1;

import IA.probTSP.ProbTSPBoard;
import aima.search.framework.HeuristicFunction;
import aima.search.framework.Successor;
import aima.search.framework.SuccessorFunction;

import java.util.ArrayList;
import java.util.List;

public class FuncionSucesoriaHillClimbing implements SuccessorFunction {

    private HeuristicFunction function;

    public FuncionSucesoriaHillClimbing(HeuristicFunction function) {
        this.function = function;
    }

    @Override
    public List getSuccessors(Object aState) {
        ArrayList<Successor> retVal = new ArrayList<Successor>();
        Estado state  = (Estado) aState;

        for (int i = 0; i < state.getNumTrayectos(); i++) {
            for (int j = 0; j < state.getTamanoTrayecto(i) - 1; j++) {
                Estado nuevoEstado = new Estado(state);

                if (!nuevoEstado.swapFromTrayecto(i, j, j+1))
                    continue;

                double h = function.getHeuristicValue(nuevoEstado);
                String S = String.format(Estado.INTERCAMBIO + " %d[%d] <--> %d[%d] coste(%f)", i, j, i, j + 1, h);
                //S += nuevoEstado.toString();
                S += " valid: " + nuevoEstado.isValid();
                retVal.add(new Successor(S, nuevoEstado));
            }
        }

        for (int i = 0; i < state.getNumTrayectos(); i++) {
            for (int j = 0; j < state.getTamanoTrayecto(i) - 1; j++) {
                //for (int k = 0; k < state.getNumTrayectos(); k++) {
                    Estado nuevoEstado = new Estado(state);

                    //int k = Math.max(Math.min(i + 1, nuevoEstado.getNumTrayectos() - 1), 0);
                    int k = nuevoEstado.getMinTrayecto(i);
                    if (k == i || !nuevoEstado.removeFromTrayecto(i, j, k))
                        continue;

                    double h = function.getHeuristicValue(nuevoEstado);
                    String S = String.format(Estado.REMOVE + "%d[%d] --> %d coste(%f)", i, j, k, h);
                    //S += nuevoEstado.toString();
                    S += " valid: " + nuevoEstado.isValid();
                    retVal.add(new Successor(S, nuevoEstado));
                //}
            }
        }



        return retVal;
    }
}
