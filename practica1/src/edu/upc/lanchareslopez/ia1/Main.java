package edu.upc.lanchareslopez.ia1;

import aima.search.framework.Problem;
import aima.search.framework.Search;
import aima.search.framework.SearchAgent;
import aima.search.informed.HillClimbingSearch;
import aima.search.informed.SimulatedAnnealingSearch;

import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;
import java.util.Random;

public class Main {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);
        System.out.println("PRACTICA 1 IA\n");
        System.out.print("Numero de usuarios: ");
        int n = sc.nextInt();
        System.out.print("Numero de conductores: ");
        int m = sc.nextInt();
        System.out.print("Seed (0=random): ");
        int seed = sc.nextInt();
        if (seed == 0) {
            seed = new Random().nextInt();
            System.out.printf("seed: %d", seed);
        }

        Estado state = new Estado(n,m,seed);
        HeuristicaDistancia d = new HeuristicaDistancia();
        System.out.println(d.getHeuristicValue(state));

        hillClimbingDistancia(state);
        simulatedAnnealingDistancia(state);
        hillClimbingDistanciaCoches(state);
        simulatedAnnealingDistanciaCoches(state);

    }

    private static void hillClimbingDistancia(Estado e) {
        System.out.println("HillClimbing  con heuristica distancia -->");
        try {
            Problem problem =  new Problem(e, new FuncionSucesoriaHillClimbing(new HeuristicaDistancia()), new EsTerminal(), new HeuristicaDistancia());
            Search search =  new HillClimbingSearch();
            SearchAgent agent = new SearchAgent(problem,search);

            System.out.println();
            //printActions(agent.getActions());
            printResult(agent.getActions());
            printInstrumentation(agent.getInstrumentation());

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static void simulatedAnnealingDistancia(Estado e) {
        System.out.println("Simulated Annealing  con heuristica distancia -->");
        try {
            Problem problem =  new Problem(e, new FuncionSucesoriaSimulatedAnnealing(new HeuristicaDistancia()), new EsTerminal(), new HeuristicaDistancia());
            SimulatedAnnealingSearch search =  new SimulatedAnnealingSearch(100000,10,5,0.01D);
            //search.traceOn();
            SearchAgent agent = new SearchAgent(problem,search);

            System.out.println();
            printEstados(agent.getActions());
            printInstrumentation(agent.getInstrumentation());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static void hillClimbingDistanciaCoches(Estado e) {
        System.out.println("HillClimbing  con heuristica distancia+conductores -->");
        try {
            Problem problem =  new Problem(e, new FuncionSucesoriaHillClimbing(new HeuristicaDistanciaCoches()), new EsTerminal(), new HeuristicaDistanciaCoches());
            Search search =  new HillClimbingSearch();
            SearchAgent agent = new SearchAgent(problem,search);

            System.out.println();
            //printActions(agent.getActions());
            printResult(agent.getActions());
            printInstrumentation(agent.getInstrumentation());

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static void simulatedAnnealingDistanciaCoches(Estado e) {
        System.out.println("Simulated Annealing  con heuristica distancia+conductores -->");
        try {
            Problem problem =  new Problem(e, new FuncionSucesoriaSimulatedAnnealing(new HeuristicaDistanciaCoches()), new EsTerminal(), new HeuristicaDistanciaCoches());
            SimulatedAnnealingSearch search =  new SimulatedAnnealingSearch(100000,10,5,0.01D);
            //search.traceOn();
            SearchAgent agent = new SearchAgent(problem,search);

            System.out.println();
            printEstados(agent.getActions());
            printInstrumentation(agent.getInstrumentation());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static void printInstrumentation(Properties properties) {
        Iterator keys = properties.keySet().iterator();
        while (keys.hasNext()) {
            String key = (String) keys.next();
            String property = properties.getProperty(key);
            System.out.println(key + " : " + property);
        }

    }

    private static void printActions(List actions) {
        for (int i = 0; i < actions.size(); i++) {
            String action = (String) actions.get(i);
            System.out.println(action);
        }
    }

    private static void  printResult(List actions) {
        String s = (String) actions.get(actions.size()-1);
        System.out.println(s);
    }

    private static void printEstados(List actions) {
        HeuristicaDistancia hd = new HeuristicaDistancia();
        for (int i = 0; i < actions.size(); i++) {
            Estado action = (Estado) actions.get(i);
            System.out.println("Distancia total: " + hd.getHeuristicValue(action) + ", conductores: " + action.getNumTrayectos() +", valid: " + action.isValid());
            //System.out.println(action);
        }
    }


}
