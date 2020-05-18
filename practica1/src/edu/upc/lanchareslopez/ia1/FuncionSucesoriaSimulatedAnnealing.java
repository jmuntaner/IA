package edu.upc.lanchareslopez.ia1;

import IA.probTSP.ProbTSPBoard;
import aima.search.framework.HeuristicFunction;
import aima.search.framework.Successor;
import aima.search.framework.SuccessorFunction;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class FuncionSucesoriaSimulatedAnnealing implements SuccessorFunction {

    private HeuristicFunction function;

    public FuncionSucesoriaSimulatedAnnealing(HeuristicFunction function) {
        this.function = function;
    }

    @Override
    public List getSuccessors(Object aState) {
        ArrayList<Successor> retVal = new ArrayList<Successor>();
        Estado state  = (Estado) aState;
        Random random = new Random();

        do {
            double operatorType = random.nextDouble();

            if (operatorType < 0.7) {  //Swap
                int i = random.nextInt(state.getNumTrayectos());
                int j1 = random.nextInt(state.getTamanoTrayecto(i));
                Estado nuevoEstado = new Estado(state);
                if (nuevoEstado.swapFromTrayecto(i, j1, j1+1)) {
                    double h = function.getHeuristicValue(nuevoEstado);
                    String S = String.format(Estado.INTERCAMBIO + " %d[%d] <--> %d[%d] coste(%f)", i, j1, i, j1+1, h);
                    retVal.add(new Successor(S, nuevoEstado));
                }
            } else { //Move
                Estado nuevoEstado = new Estado(state);
                int i = random.nextInt(state.getNumTrayectos());
                int j = random.nextInt(state.getTamanoTrayecto(i));
                int k = random.nextInt(state.getNumTrayectos());
                while (k == i) {
                    k = random.nextInt(state.getNumTrayectos());
                }

                //int k = Math.max(Math.min(i + 1, nuevoEstado.getNumTrayectos() - 1), 0);
                if (nuevoEstado.removeFromTrayecto(i, j, k)) {
                    double h = function.getHeuristicValue(nuevoEstado);
                    String S = String.format(Estado.REMOVE + "%d[%d] --> %d coste(%f)", i, j, k, h);
                    retVal.add(new Successor(S, nuevoEstado));
                }
            }
        } while (retVal.size() < 1);

        return retVal;
    }
}
