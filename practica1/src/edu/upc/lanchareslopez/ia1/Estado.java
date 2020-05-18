package edu.upc.lanchareslopez.ia1;

import IA.Comparticion.Usuario;
import IA.Comparticion.Usuarios;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.Random;

public class Estado {

    public static final String INTERCAMBIO = "Intercambio vectores";
    public static final String REMOVE = "Borrado ";

    public Usuarios usuarios;

    public ArrayList<ArrayList<Instance>> trayectos;

    public Estado(int n, int m) {
        this(n, m, new Random().nextInt());
    }

    public Estado(int n, int m, int seed) {
        usuarios = new Usuarios(n, m, seed);

        // Implement initial solution
        //generateRandomSolution(new Random().nextInt());
        //generateGreedySolution();
        generateGreedySolutionTwo();
        //generateGreedySolutionThree();
    }

    public Estado(Estado other) {
        this.usuarios = other.usuarios;
        this.trayectos = new ArrayList<ArrayList<Instance>>();
        for (ArrayList<Instance> inst : other.trayectos) {
            ArrayList<Instance> trayecto = new ArrayList<Instance>();
            for (Instance i : inst) {
                trayecto.add(new Instance(i));
            }
            this.trayectos.add(trayecto);
        }
    }

    private void generateRandomSolution(int seed) {
        Random random = new Random();
        random.setSeed(seed);
        this.trayectos = new ArrayList<ArrayList<Instance>>();

        for (Usuario usuario : usuarios) {
            if (usuario.isConductor()) {
                ArrayList<Instance> trayecto = new ArrayList<Instance>();
                trayecto.add(new Instance(ACTION.RECOGER, usuario));
                trayecto.add(new Instance(ACTION.DEJAR, usuario));
                trayectos.add(trayecto);
            }
        }

        for (Usuario usuario : usuarios) {
            if (!usuario.isConductor()) {
                ArrayList<Instance> trayecto = trayectos.get(random.nextInt(trayectos.size()));
//                int a1 = random.nextInt(trayecto.size() - 1) + 1;
//                int a2 = random.nextInt(trayecto.size() - 1) + 1;
//                if (a1 < a2) {
//                    int tmp = a1;
//                    a2 = a1;
//                    a1 = tmp;
//                }
                trayecto.add(1, new Instance(ACTION.DEJAR, usuario));
                trayecto.add(1, new Instance(ACTION.RECOGER, usuario));
            }
        }
    }

    public void generateGreedySolution() {
        trayectos = new ArrayList<>();
        for (Usuario usuario : usuarios) {
            if (usuario.isConductor()) {
                ArrayList<Instance> trayecto = new ArrayList<Instance>();
                trayecto.add(new Instance(ACTION.RECOGER, usuario));
                trayecto.add(new Instance(ACTION.DEJAR, usuario));
                trayectos.add(trayecto);
            }
        }

        for (Usuario usuario : usuarios) {
            if (!usuario.isConductor()) {
                int best = 0;
                int bestd = 200;
                for (int i=0; i<trayectos.size(); ++i) {
                    int d = 0;
                    d += distanciaInstancias(trayectos.get(i).get(trayectos.get(i).size()-2), new Instance(ACTION.RECOGER, usuario));
                    d += distanciaInstancias(trayectos.get(i).get(trayectos.get(i).size()-1), new Instance(ACTION.DEJAR, usuario));
                    if (d < bestd) {
                        bestd = d;
                        best = i;
                    }
                }
                trayectos.get(best).add(trayectos.get(best).size()-2, new Instance(ACTION.RECOGER, usuario));
                trayectos.get(best).add(trayectos.get(best).size()-2, new Instance(ACTION.DEJAR, usuario));
            }
        }
    }

    public void generateGreedySolutionTwo() {
        trayectos = new ArrayList<>();
        for (Usuario usuario : usuarios) {
            if (usuario.isConductor()) {
                ArrayList<Instance> trayecto = new ArrayList<Instance>();
                trayecto.add(new Instance(ACTION.RECOGER, usuario));
                trayecto.add(new Instance(ACTION.DEJAR, usuario));
                trayectos.add(trayecto);
            }
        }

        for (Usuario usuario : usuarios) {
            if (!usuario.isConductor()) {
                int best = 0;
                int bestj = 1;
                int bestd = Integer.MAX_VALUE;
                for (int i=0; i<trayectos.size(); ++i) {
                    for (int j=1; j<trayectos.get(i).size(); ++j) {
                        int d = 0;
                        d += distanciaInstancias(trayectos.get(i).get(j-1), new Instance(ACTION.RECOGER, usuario));
                        d += distanciaInstancias(trayectos.get(i).get(j), new Instance(ACTION.DEJAR, usuario));
                        if (d < bestd) {
                            Estado nuevoEstado = new Estado(this);
                            nuevoEstado.trayectos.get(i).add(j,new Instance(ACTION.RECOGER, usuario));
                            nuevoEstado.trayectos.get(i).add(j+1,new Instance(ACTION.DEJAR, usuario));
                            if (nuevoEstado.checkFullCar(i)) continue;
                            bestd = d;
                            best = i;
                            bestj = j;
                        }
                    }
                }
                trayectos.get(best).add(bestj,new Instance(ACTION.RECOGER, usuario));
                trayectos.get(best).add(bestj+1,new Instance(ACTION.DEJAR, usuario));
            }
        }
    }

    public void generateGreedySolutionThree() {
        trayectos = new ArrayList<>();
        for (Usuario usuario : usuarios) {
            if (usuario.isConductor()) {
                ArrayList<Instance> trayecto = new ArrayList<Instance>();
                trayecto.add(new Instance(ACTION.RECOGER, usuario));
                trayecto.add(new Instance(ACTION.DEJAR, usuario));
                trayectos.add(trayecto);
            }
        }

        for (Usuario usuario : usuarios) {
            if (!usuario.isConductor()) {
                int best = 0;
                int bestj = 1;
                int bestk = 2;
                int bestd = Integer.MAX_VALUE;
                for (int i=0; i<trayectos.size(); ++i) {
                    for (int j=1; j<trayectos.get(i).size(); ++j) {
                        for (int k=j+1; k<trayectos.get(i).size()+1; ++k) {
                            int d = 0;
                            d += distanciaInstancias(trayectos.get(i).get(j-1), new Instance(ACTION.RECOGER, usuario));
                            if (k == j+1) {
                                d += distanciaInstancias(new Instance(ACTION.DEJAR, usuario), new Instance(ACTION.RECOGER, usuario));
                            } else {
                                d += distanciaInstancias(trayectos.get(i).get(j), new Instance(ACTION.RECOGER, usuario));
                                d += distanciaInstancias(trayectos.get(i).get(k-2), new Instance(ACTION.DEJAR, usuario));
                            }
                            d += distanciaInstancias(trayectos.get(i).get(k-1), new Instance(ACTION.DEJAR, usuario));
                            if (d < bestd) {
                                Estado nuevoEstado = new Estado(this);
                                nuevoEstado.trayectos.get(i).add(j,new Instance(ACTION.RECOGER, usuario));
                                nuevoEstado.trayectos.get(i).add(k,new Instance(ACTION.DEJAR, usuario));
                                if (nuevoEstado.checkFullCar(i)) continue;
                                bestd = d;
                                best = i;
                                bestj = j;
                                bestk = k;
                            }
                        }
                    }
                    trayectos.get(best).add(bestj,new Instance(ACTION.RECOGER, usuario));
                    trayectos.get(best).add(bestk,new Instance(ACTION.DEJAR, usuario));
                }
            }
        }
    }

    /**
     * Swaps the element on the j position and the element on the j+1 position of the i-th route.
     * @param i the route to be changed
     * @param j the position to be interchanged
     */
    public boolean swapContiguousFromTrayecto(int i, int j) {
        return swapFromTrayecto(i, j, j+1);
    }

    /**
     * Swaps the element on the j position and the element on the k position of the i-th route.
     * @param i the route to be changed
     * @param j1 the position to be interchanged
     * @param j2 the position to be interchanged
     */
    public boolean swapFromTrayecto(int i, int j1, int j2) {
        if (j1 == 0 || j1 == trayectos.get(i).size() - 1 || j2 == 0 || j2 == trayectos.get(i).size() - 1 || j1 == j2)
            return false;
        int j = j1;
        int k = j2;
        if (j2 < j1) {
            j = j2;
            k = j1;
        }
        Instance i1 = trayectos.get(i).get(j);
        Instance i2 = trayectos.get(i).get(k);
        Estado nuevoEstado = new Estado(this);
        nuevoEstado.trayectos.get(i).remove(k);
        nuevoEstado.trayectos.get(i).remove(j);
        nuevoEstado.trayectos.get(i).add(j, i2);
        nuevoEstado.trayectos.get(i).add(k, i1);
        if (nuevoEstado.checkFullCar(i)) return false;
        if (isValid() && !nuevoEstado.isValid()) return false;
        trayectos.get(i).remove(k);
        trayectos.get(i).remove(j);
        trayectos.get(i).add(j, i2);
        trayectos.get(i).add(k, i1);
        return true;
    }

    /**
     * Removes the element on the jth position of the i-th route and its conjugate, and inserts
     * them in the same position in the k-th route.
     * @param i The route to be removed from
     * @param j The element to be removed
     * @param k The destination route
     */
    public boolean removeFromTrayecto(int i, int j, int k) {
        if (trayectos.get(i).size() == 2) {
            Instance ins1 = trayectos.get(i).get(0);
            Instance ins2 = trayectos.get(i).get(1);
            Estado nuevoEstado = new Estado(this);
            nuevoEstado.trayectos.get(k).add(1, ins2);
            nuevoEstado.trayectos.get(k).add(1, ins1);
            if (nuevoEstado.checkFullCar(k)) return false;
            trayectos.get(k).add(1, ins1);
            trayectos.get(k).add(trayectos.get(k).size() - 2, ins2);
            trayectos.remove(i);
            return true;
        }
        if (j == 0 || j == trayectos.get(i).size() - 1)
            return false;

        Instance ins1 = trayectos.get(i).remove(j);
        Instance ins2 = null;
        for (int j3 = 0; j3 < trayectos.get(i).size(); j3++) {
            Instance ins3 = trayectos.get(i).get(j3);
            if (ins3.usuario == ins1.usuario) {
                ins2 = trayectos.get(i).remove(j3);
                break;
            }
        }

        Estado nuevoEstado = new Estado(this);
        nuevoEstado.trayectos.get(k).add(1, ins2);
        nuevoEstado.trayectos.get(k).add(1, ins1);

        if (nuevoEstado.checkFullCar(k)) return false;
        if (isValid() && !nuevoEstado.isValid()) return false;

        trayectos.get(k).add(1, ins2);
        trayectos.get(k).add(1, ins1);

        return true;
    }

    public int getNumTrayectos() {
        return trayectos.size();
    }

    public int getTamanoTrayecto(int i) {
        return trayectos.get(i).size();
    }

    public int getMinTrayecto(int k) {
        int min = usuarios.size();
        int minI = Integer.MAX_VALUE;
        for (int i = 0; i < trayectos.size(); i++) {
            if (i != k && getTamanoTrayecto(i) < min) {
                min = getTamanoTrayecto(i);
                minI = i;
            }
        }
        return minI;
    }

    public enum ACTION {RECOGER, DEJAR}

    private class Instance implements Cloneable {
        public ACTION action;
        public Usuario usuario;

        public Instance(ACTION action, Usuario usuario) {
            this.action = action;
            this.usuario = usuario;
        }

        public Instance(Instance other) {
            this.usuario = other.usuario;
            this.action = other.action;
        }

        public int getXCoord() {
            return action == ACTION.RECOGER ? usuario.getCoordOrigenX() : usuario.getCoordDestinoX();
        }
        public int getYCoord() {
            return action == ACTION.RECOGER ? usuario.getCoordOrigenY() : usuario.getCoordDestinoY();
        }

        public String toString() {
            return (action == ACTION.RECOGER ? "r" : "d") + usuario.getCoordOrigenX() + usuario.getCoordDestinoY();
        }
    }

    private int distanciaInstancias(Instance i1, Instance i2) {
        return Math.abs(i1.getXCoord() - i2.getXCoord()) + Math.abs(i1.getYCoord() - i2.getYCoord());
    }

    public int getDistanciaTrayecto(int num) {
        ArrayList<Instance> coche = trayectos.get(num);
        int dist = 0;
        for (int i=1; i<coche.size(); ++i) {
            dist += distanciaInstancias(coche.get(i-1), coche.get(i));
        }
        return dist;
    }

    public boolean isValid() {
        for (int i = 0; i < trayectos.size(); i++) {
            if (getDistanciaTrayecto(i) > 300) {
                return false;
            }
        }
        return true;
    }

    private boolean checkFullCar(int i) {
        int r = 0;
        for (int j=0; j<trayectos.get(i).size(); ++j) {
            r += trayectos.get(i).get(j).action == ACTION.RECOGER ? 1 : -1;
            if (r > 3) return true;
        }
        return (r>3);
    }

    public String toString() {
        String s = "[";
        for (ArrayList<Instance> inss : trayectos) {
            s += "[";
            for (Instance ins : inss) {
                s += "'" + ins.toString() + "', ";
            }
            s += "],";
        }
        return s + "]";
    }

    private int constrain(int a, int b, int c) {
        return Math.min(Math.max(a, b), c);
    }
}
