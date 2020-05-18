package edu.upc.lanchareslopez.ia1;

import aima.search.framework.GoalTest;

public class EsTerminal implements GoalTest {

    @Override
    public boolean isGoalState(Object o) {
        return false;
    }
}
