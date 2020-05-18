---
title: Neural Ordinary Differential Equations
author:
  - Ernesto Lanchares
  - Ferran López
date: 27-05-2019
header-includes: |
    \usepackage{tikz,physics,mathtools,pgf,pgfplots}
    \newcommand*\diff{\mathop{}\!\mathrm{d}}
    \usetikzlibrary{arrows.meta, calc, chains, positioning}
    \pgfplotsset{compat=1.11}
---

# Neural Networks

---

## Neurona

. . .

functión de $\mathbb{R}^n \to \mathbb{R}$ de la forma
$f(a_1 x_1 + a_2 x_2 + \cdots + a_n x_n + b)$ ($f = ReLu, sigmoid, \dots$)

. . .

\begin{center}
    \begin{tikzpicture}[
            node distance = 4mm and 16mm,
            start chain = going below,
            arro/.style = {-Latex},
            bloque/.style = {text width=4ex, inner sep=1pt, align=right, on chain},
        ]
        % inputs
        \node[bloque] (in-1) {$x_1$};
        \node[bloque] (in-2) {$x_2$};
        \node[bloque] (in-3) {$\vdots$};
        \node[bloque] (in-4) {$x_n$};
        
        % output
        \node (out) [circle, draw=orange, minimum size=6mm,
          label=$f$,
          right=of $(in-2)!0.5!(in-3)$]  {};
    
        % conections
        \draw[arro] (in-1) -- (out);
        \draw[arro] (in-2) -- (out);
        %\draw[arro] (in-3) -- (out);
        \draw[arro] (in-4) -- (out);
        
        % output
        \coordinate[right=of out] (output);
        \draw[arro] (out) -- (output) node[right]   {Output};
    \end{tikzpicture}
\end{center}


---

## Neural Netwoks

. . .

Son combinaciones de muchas capas de neuronas

. . .

\def\layersep{2.5cm}

\begin{center}
    \begin{tikzpicture}[shorten >=1pt,->,draw=black!50, node distance=\layersep]
        \tikzstyle{every pin edge}=[<-,shorten <=1pt]
        \tikzstyle{neuron}=[circle,fill=black!25,minimum size=17pt,inner sep=0pt]
        \tikzstyle{input neuron}=[neuron, fill=green!50];
        \tikzstyle{output neuron}=[neuron, fill=red!50];
        \tikzstyle{hidden neuron}=[neuron, fill=blue!50];
        \tikzstyle{annot} = [text width=4em, text centered]
    
        % Draw the input layer nodes
        \foreach \name / \y in {1,...,4}
        % This is the same as writing \foreach \name / \y in {1/1,2/2,3/3,4/4}
            \node[input neuron, pin=left:Input \#\y] (I-\name) at (0,-\y) {};
    
        % Draw the hidden layer nodes
        \foreach \name / \y in {1,...,5}
            \path[yshift=0.5cm]
                node[hidden neuron] (H-\name) at (\layersep,-\y cm) {};
    
        % Draw the output layer node
        \node[output neuron,pin={[pin edge={->}]right:Output}, right of=H-3] (O) {};
    
        % Connect every node in the input layer with every node in the
        % hidden layer.
        \foreach \source in {1,...,4}
            \foreach \dest in {1,...,5}
                \path (I-\source) edge (H-\dest);
    
        % Connect every node in the hidden layer with the output layer
        \foreach \source in {1,...,5}
            \path (H-\source) edge (O);
    
        % Annotate the layers
        \node[annot,above of=H-1, node distance=1cm] (hl) {Hidden layer};
        \node[annot,left of=hl] {Input layer};
        \node[annot,right of=hl] {Output layer};
    \end{tikzpicture}
\end{center}

## Neural Networks de más capas
 
\begin{center}
    \begin{tikzpicture}[shorten >=1pt,->,draw=black!50, node
        distance=2.5cm]
        tikzstyle{every pin edge}=[<-,shorten <=1pt]
        \tikzstyle{neuron}=[circle,fill=black!25,minimum size=17pt,inner sep=0pt]
        \tikzstyle{input neuron}=[neuron, fill=green!50];
        \tikzstyle{output neuron}=[neuron, fill=red!50];
        \tikzstyle{hidden neuron}=[neuron, fill=blue!50];
        \tikzstyle{annot} = [text width=4em, text centered]
        
        % Draw the input layer nodes
        \foreach \name / \y in {1,...,4}
            % This is the same as writing \foreach \name / \y in {1/1,2/2,3/3,4/4}
            \path[yshift=-1cm] node[input neuron] (I-\name) at (0,-\y cm) {};
        
        % Draw the hidden layer nodes
        \foreach \name / \y in {1,...,5}
            \path[yshift=-0.5cm] node[hidden neuron] (H-\name) at (2.5cm,-\y cm) {};
        
        \foreach \name / \y in {1,...,7}
            \path[yshift=0.5cm] node[hidden neuron] (M-\name) at (5cm,-\y cm) {};
        
        % Draw the output layer node
        \node[output neuron, right of=M-4] (O) {};
        
        % Connect every node in the input layer with every node in the
        % hidden layer.
        \foreach \source in {1,...,4}
            \foreach \dest in {1,...,5}
                \path (I-\source) edge (H-\dest);
        
        % Connect every node in the hidden layer to the middle layer
        \foreach \source in {1,...,5}
            \foreach \dest in {1,...,7}
                \path (H-\source) edge (M-\dest);
        
        % Connect every node in the hidden layer with the output layer
        \foreach \source in {1,...,7}
            \path (M-\source) edge (O);
        
        % Annotate the layers
        \node[annot,above of=M-1, node distance=1cm] (ml) {Hidden layer \#2};
        \node[annot,left of=ml] (hl) {Hidden layer \#1};
        \node[annot,left of=hl] {Input layer};
        \node[annot,right of=ml] {Output layer};
    \end{tikzpicture}
\end{center}

# ResNets

## Formula matemática

Mientras que en una NN en cada capa podiamos modelar el resultado como

$$ h_{n+1} = f_n(h_n) $$

El output de capa capa es el resultado de aplicar cada neurona a la entrada.
En las ResNets modelamos el resultado como

$$ h_{n+1} = h_n + f_n(h_n)$$

---

## Representación de una ResNet

Mientras que en las NN tenemos el esquema

\begin{center}
    \begin{tikzpicture}
        \node (A) at (0,0) {$h_n$};
        \node[draw=black] (B) at (2,0) {$f_n$} edge[<-] (A);
        \node (D) at (4,0) {$h_{n+1}$} edge[<-] (B);
    \end{tikzpicture}
\end{center}

En las ResNets tenemos el esquema

\begin{center}
    \begin{tikzpicture}
        \node (A) at (0,0) {$h_n$};
        \node[draw=black] (B) at (2,0) {$f_n$} edge[<-] (A);
        \node[circle,draw=black] (C) at (4,0) {$+$} edge[<-] (B) edge[<-,bend right=40] (1,0);
        \node (D) at (6,0) {$h_{n+1}$} edge[<-] (C);
    \end{tikzpicture}
\end{center}

---

## Representación de una ResNet

\begin{center}
    \begin{tikzpicture}[shorten >=1pt,->,draw=black!50, node distance=\layersep]
        \tikzstyle{every pin edge}=[<-,shorten <=1pt]
        \tikzstyle{neuron}=[circle,fill=black!25,minimum size=17pt,inner sep=0pt]
        \tikzstyle{input neuron}=[neuron, fill=green!50];
        \tikzstyle{output neuron}=[neuron, fill=red!50];
        \tikzstyle{hidden neuron}=[neuron, fill=blue!50];
        \tikzstyle{annot} = [text width=4em, text centered]
    
        % Draw the input layer nodes
        \node[] (I-1) at (0,-1 cm) {Input \#1};
        \node[] (I-2) at (0,-3 cm) {Input \#2};
        \node[] (I-3) at (0,-5 cm) {Input \#3};
    
        % Draw the hidden layer nodes
        \node[hidden neuron] (H-1) at (2.5 cm, -1 cm) {};
        \node[hidden neuron] (H-2) at (2.5 cm, -3 cm) {};
        \node[hidden neuron] (H-3) at (2.5 cm, -5 cm) {};
    
        % Draw the output layer node
        \node[output neuron,pin={[pin edge={->}]right:Output \#1}] (O-1) at (5 cm, -1 cm) {$+$};
        \node[output neuron,pin={[pin edge={->}]right:Output \#2}] (O-2) at (5 cm, -3 cm) {$+$};
        \node[output neuron,pin={[pin edge={->}]right:Output \#3}] (O-3) at (5 cm, -5 cm) {$+$};
    
        % Connect every node in the input layer with every node in the
        % hidden layer.
        \foreach \source in {1,...,3}
            \foreach \dest in {1,...,3}
                \path (I-\source) edge (H-\dest);
    
        % Connect every node in the hidden layer with the output layer
        \foreach \source in {1,...,3}
            \path (H-\source) edge (O-\source);

        \foreach \source in {1,...,3}
            \path (I-\source) edge[bend left = 20] (O-\source);
    
    \end{tikzpicture}
\end{center}

---

## Ventajas de las ResNets

La ventaja principal es la posiblidad de "saltarse" capas, poniendo $f_n$ a 0. Gracias a
esto, podemos entrenar redes con muchas capas y la propia será la que "decida" cuantas
necesita para la tarea en cuestión. Evitando incurrir en *overfitting*.

# Ecuaciones en Derivadas Ordinarias (EDOs)

---

## EDOs

. . .

Una EDO es simplemente una ecuación donde la icognita es una función y
la función depende de sus derivadas.

. . .

$$
    f(x) = a f'(x) + b f^{\prime\prime}(x) + \sin(x) 
$$

---

## EDOs de primer orden

. . .

Las EDOs de primer orden son aquellas que solo dependen de la primera derivada.
Nos centramos en ellas porque

. . .

* EDOs de ordenes más altos se pueden transformar en un sistema de EDOs de primer orden.

. . .

* Las ODENets solo utilizan EDOs de primer orden

---

## EDOs de primer orden

Las EDOS de primer orden se pueden expresar como 
$$F(f,f',t) = 0$$

. . .

Nos restringimos a EDOs de la forma
$$f' = F(f,t)$$

. . .

Dado un $h_0 = f(t_0)$ podemos encontrar una solución aunque no siempre analítica,
por ello, empleamos métodos numéricos.

# Método de Euler

## Aproximación por Taylor

Dada una función $f$, podemos escribir (por Taylor) 
$$
f(t) = f(t_0) + f^\prime(t_0)(t - t_0) + \mathcal{O}\left( \left|t - t_0\right|^2 \right)
$$

. . .

Ahora, tomando $\Delta t = t_1 - t_0$, tenemos
$$
f(t_1) = f(t_0) + f^\prime(t_0) \Delta t + \mathcal{O}\left( \Delta t^2 \right)
$$

. . .

Negligiendo los errores:
$$
f(t_1) \approx f(t_0) + f^\prime(t_0) \Delta t
$$

---
## Aproximación por Taylor

Podemos aprovechar la expresión anterior para obtener aproximaciones de $f$

$$
\begin{aligned}
f(t_1) &\approx f(t_0) + f'(t_0) \Delta t \\
f(t_2) &\approx f(t_1) + f'(t_1) \Delta t \\
&\vdots \\
f(t_N) &\approx f(T_{N-1}) + f'(T_{N-1}) \Delta t
\end{aligned}
$$

. . .

Y notamos que
$$f'(t_i) = F\left( f(t_i), t_i \right)$$

## Método de Euler

De donde obtenemos el método de Euler, a $h_0, t_0$ dados, tenemos
$$h_i = h_{i-1} + F(h_{i-1}, t_i) \Delta t \quad \forall i = 1:N$$
con $h_i \approx f(t_i)$ y $t_i = t_{i-1} + \Delta t$.

. . .

\begin{center}
    \begin{tikzpicture}
        \begin{axis}[domain=0:2,legend pos=outer north east]
            \addplot[blue,mark=none] {sin(deg(x))};
            \addplot[red,mark=*] coordinates { (0,0) (2/5,2/5) (4/5,0.768424)
                (6/5,1.0471) (8/5,1.192) (2,1.18)};
            \legend{Exacta, Euler, RK4}
        \end{axis}
    \end{tikzpicture}
\end{center}


## Método de Euler

De donde obtenemos el método de Euler, a $h_0, t_0$ dados, tenemos
$$h_i = h_{i-1} + F(h_{i-1}, t_i) \Delta t \quad \forall i = 1:N$$
con $h_i \approx f(t_i)$ y $t_i = t_{i-1} + \Delta t$.

\begin{center}
    \begin{tikzpicture}
        \begin{axis}[domain=0:2,legend pos=outer north east]
            \addplot[blue,mark=none] {sin(deg(x))};
            \addplot[red,mark=*] coordinates { (0,0) (2/5,2/5) (4/5,0.768424)
                (6/5,1.0471) (8/5,1.192) (2,1.18)};
            \addplot[green,mark=*] coordinates { (0,0) (2/5,0.3894) (4/5,0.7174)
                (6/5,0.9320) (8/5,0.9996) (2,0.9093)};
            \legend{Exacta, Euler, RK4}
        \end{axis}
    \end{tikzpicture}
\end{center}

## Método de Euler

De donde obtenemos el método de Euler, a $h_0, t_0$ dados, tenemos
$$h_i = h_{i-1} + F(h_{i-1}, t_i) \Delta t \quad \forall i = 1:N$$
con $h_i \approx f(t_i)$ y $t_i = t_{i-1} + \Delta t$.

\begin{center}
    \begin{tikzpicture}
        \begin{axis}[domain=0:2,legend pos=outer north east]
            \addplot[blue,mark=none] {sin(deg(x))};
            \addplot[red,mark=*] coordinates { (0,0) (2/5,2/5) (4/5,0.768424)
                (6/5,1.0471) (8/5,1.192) (2,1.18)};
            \addplot[green,mark=*] coordinates { (0,0) (2/5,0.3894) (4/5,0.7174)
                (6/5,0.9320) (8/5,0.9996) (2,0.9093)};
            \addplot[red,] coordinates{ (0,0) (1.000000e-02,1.000000e-02)
                (2.000000e-02,1.999950e-02) (3.000000e-02,2.999750e-02) (4.000000e-02,3.999300e-02)
                (5.000000e-02,4.998500e-02) (6.000000e-02,5.997250e-02) (7.000000e-02,6.995451e-02)
                (8.000000e-02,7.993002e-02) (9.000000e-02,8.989804e-02) (1.000000e-01,9.985756e-02)
                (1.100000e-01,1.098076e-01) (1.200000e-01,1.197472e-01) (1.300000e-01,1.296753e-01)
                (1.400000e-01,1.395909e-01) (1.500000e-01,1.494930e-01) (1.600000e-01,1.593807e-01)
                (1.700000e-01,1.692530e-01) (1.800000e-01,1.791089e-01) (1.900000e-01,1.889473e-01)
                (2.000000e-01,1.987673e-01) (2.100000e-01,2.085680e-01) (2.200000e-01,2.183483e-01)
                (2.300000e-01,2.281073e-01) (2.400000e-01,2.378440e-01) (2.500000e-01,2.475573e-01)
                (2.600000e-01,2.572465e-01) (2.700000e-01,2.669104e-01) (2.800000e-01,2.765481e-01)
                (2.900000e-01,2.861586e-01) (3.000000e-01,2.957411e-01) (3.100000e-01,3.052944e-01)
                (3.200000e-01,3.148178e-01) (3.300000e-01,3.243101e-01) (3.400000e-01,3.337705e-01)
                (3.500000e-01,3.431981e-01) (3.600000e-01,3.525918e-01) (3.700000e-01,3.619508e-01)
                (3.800000e-01,3.712741e-01) (3.900000e-01,3.805607e-01) (4.000000e-01,3.898098e-01)
                (4.100000e-01,3.990204e-01) (4.200000e-01,4.081916e-01) (4.300000e-01,4.173225e-01)
                (4.400000e-01,4.264122e-01) (4.500000e-01,4.354597e-01) (4.600000e-01,4.444641e-01)
                (4.700000e-01,4.534247e-01) (4.800000e-01,4.623404e-01) (4.900000e-01,4.712103e-01)
                (5.000000e-01,4.800336e-01) (5.100000e-01,4.888095e-01) (5.200000e-01,4.975369e-01)
                (5.300000e-01,5.062151e-01) (5.400000e-01,5.148432e-01) (5.500000e-01,5.234203e-01)
                (5.600000e-01,5.319455e-01) (5.700000e-01,5.404180e-01) (5.800000e-01,5.488371e-01)
                (5.900000e-01,5.572017e-01) (6.000000e-01,5.655111e-01) (6.100000e-01,5.737644e-01)
                (6.200000e-01,5.819609e-01) (6.300000e-01,5.900997e-01) (6.400000e-01,5.981800e-01)
                (6.500000e-01,6.062009e-01) (6.600000e-01,6.141618e-01) (6.700000e-01,6.220617e-01)
                (6.800000e-01,6.298999e-01) (6.900000e-01,6.376756e-01) (7.000000e-01,6.453881e-01)
                (7.100000e-01,6.530365e-01) (7.200000e-01,6.606201e-01) (7.300000e-01,6.681382e-01)
                (7.400000e-01,6.755899e-01) (7.500000e-01,6.829746e-01) (7.600000e-01,6.902915e-01)
                (7.700000e-01,6.975399e-01) (7.800000e-01,7.047190e-01) (7.900000e-01,7.118281e-01)
                (8.000000e-01,7.188666e-01) (8.100000e-01,7.258336e-01) (8.200000e-01,7.327286e-01)
                (8.300000e-01,7.395508e-01) (8.400000e-01,7.462996e-01) (8.500000e-01,7.529742e-01)
                (8.600000e-01,7.595741e-01) (8.700000e-01,7.660984e-01) (8.800000e-01,7.725467e-01)
                (8.900000e-01,7.789182e-01) (9.000000e-01,7.852123e-01) (9.100000e-01,7.914284e-01)
                (9.200000e-01,7.975659e-01) (9.300000e-01,8.036241e-01) (9.400000e-01,8.096024e-01)
                (9.500000e-01,8.155003e-01) (9.600000e-01,8.213171e-01) (9.700000e-01,8.270523e-01)
                (9.800000e-01,8.327053e-01) (9.900000e-01,8.382756e-01) (1,8.437625e-01)
                (1.010000e+00,8.491655e-01) (1.020000e+00,8.544841e-01) (1.030000e+00,8.597178e-01)
                (1.040000e+00,8.648659e-01) (1.050000e+00,8.699281e-01) (1.060000e+00,8.749039e-01)
                (1.070000e+00,8.797926e-01) (1.080000e+00,8.845938e-01) (1.090000e+00,8.893071e-01)
                (1.100000e+00,8.939320e-01) (1.110000e+00,8.984679e-01) (1.120000e+00,9.029145e-01)
                (1.130000e+00,9.072714e-01) (1.140000e+00,9.115380e-01) (1.150000e+00,9.157139e-01)
                (1.160000e+00,9.197988e-01) (1.170000e+00,9.237922e-01) (1.180000e+00,9.276937e-01)
                (1.190000e+00,9.315029e-01) (1.200000e+00,9.352195e-01) (1.210000e+00,9.388431e-01)
                (1.220000e+00,9.423733e-01) (1.230000e+00,9.458098e-01) (1.240000e+00,9.491521e-01)
                (1.250000e+00,9.524001e-01) (1.260000e+00,9.555533e-01) (1.270000e+00,9.586115e-01)
                (1.280000e+00,9.615743e-01) (1.290000e+00,9.644415e-01) (1.300000e+00,9.672127e-01)
                (1.310000e+00,9.698876e-01) (1.320000e+00,9.724662e-01) (1.330000e+00,9.749479e-01)
                (1.340000e+00,9.773327e-01) (1.350000e+00,9.796202e-01) (1.360000e+00,9.818103e-01)
                (1.370000e+00,9.839026e-01) (1.380000e+00,9.858971e-01) (1.390000e+00,9.877936e-01)
                (1.400000e+00,9.895917e-01) (1.410000e+00,9.912914e-01) (1.420000e+00,9.928924e-01)
                (1.430000e+00,9.943947e-01) (1.440000e+00,9.957980e-01) (1.450000e+00,9.971022e-01)
                (1.460000e+00,9.983072e-01) (1.470000e+00,9.994129e-01) (1.480000e+00,1.000419e+00)
                (1.490000e+00,1.001326e+00) (1.500000e+00,1.002133e+00) (1.510000e+00,1.002840e+00)
                (1.520000e+00,1.003448e+00) (1.530000e+00,1.003956e+00) (1.540000e+00,1.004364e+00)
                (1.550000e+00,1.004671e+00) (1.560000e+00,1.004879e+00) (1.570000e+00,1.004987e+00)
                (1.580000e+00,1.004995e+00) (1.590000e+00,1.004903e+00) (1.600000e+00,1.004711e+00)
                (1.610000e+00,1.004419e+00) (1.620000e+00,1.004027e+00) (1.630000e+00,1.003536e+00)
                (1.640000e+00,1.002944e+00) (1.650000e+00,1.002252e+00) (1.660000e+00,1.001461e+00)
                (1.670000e+00,1.000570e+00) (1.680000e+00,9.995799e-01) (1.690000e+00,9.984900e-01)
                (1.700000e+00,9.973008e-01) (1.710000e+00,9.960123e-01) (1.720000e+00,9.946248e-01)
                (1.730000e+00,9.931383e-01) (1.740000e+00,9.915530e-01) (1.750000e+00,9.898690e-01)
                (1.760000e+00,9.880865e-01) (1.770000e+00,9.862057e-01) (1.780000e+00,9.842269e-01)
                (1.790000e+00,9.821501e-01) (1.800000e+00,9.799755e-01) (1.810000e+00,9.777035e-01)
                (1.820000e+00,9.753342e-01) (1.830000e+00,9.728679e-01) (1.840000e+00,9.703048e-01)
                (1.850000e+00,9.676451e-01) (1.860000e+00,9.648892e-01) (1.870000e+00,9.620374e-01)
                (1.880000e+00,9.590898e-01) (1.890000e+00,9.560468e-01) (1.900000e+00,9.529086e-01)
                (1.910000e+00,9.496758e-01) (1.920000e+00,9.463484e-01) (1.930000e+00,9.429269e-01)
                (1.940000e+00,9.394116e-01) (1.950000e+00,9.358029e-01) (1.960000e+00,9.321011e-01)
                (1.970000e+00,9.283066e-01) (1.980000e+00,9.244197e-01) (1.990000e+00,9.204409e-01)
                };
            \legend{Exacta, Euler, RK4, Euler menor $\Delta t$}
        \end{axis}
    \end{tikzpicture}
\end{center}

# Similitud Euler-ResNet

## Similitud Euler-ResNet

Recordemos el modelo matemático de las resnet: teniamos una entrada inicial
$h_0$ y calculabamos $h_N$ (nuestro output) reiterando el proceso
$$h_i = h_{i-1} + f_i(h_{i-1})$$

. . .

Definimos $F(h, t) = f_t(h)$, de tal forma que
$$h_i = h_{i-1} + F(h_{i-1}, t_i)$$
donde $t_i = i$.

. . .

Entonces $\Delta t = t_i - t_{i-1} = i - (i-1) = 1$ y podemos escribir
$$h_i = h_{i-1} + F(h_{i-1}, t_i) \Delta t$$

# Modificando el código de una ResNet

## Codigo inicial

```python
def ResNet(h):
    for t in range(N):
        h = h + nnet(h, params[t])
    return h
```
. . .

Modificandolo un poco

```python
def F(h, t, params):
    return nnet(h, params[t])

def ResNet(h):
    for t in range(N):
        h = h + F(h, t, params[t])
    return h
```

## Código de las ODENets

```python
def F(h, t, params):
    return nnet(h, params[t])

def ResNet(h):
    return EulerMethod(h, F, [0, N], params,
                        delta_t = 1)
```

. . .

Cambiando Euler por otro método
```python
def F(h, t, params):
    return nnet([h t], params)

def ODENet(h):
    return ODESolve(h, F, [0, 1], params)
```

## Ventajas de las ODENets

Realmente las ODENets no suponen una gran ventaja respecto a 
las ResNets en cuanto a mejoría de la solución. 

Tienen coste de memoria constante mientras que las ResNets tienen coste lineal

       TestError #params Memory                   Time
------ --------- ------- ------------------------ ------------------------
ResNet 0.41%     0.60M   $\mathcal{O}(L)$         $\mathcal{O}(L)$
RK-Net 0.47%     0.22M   $\mathcal{O}(\tilde{L})$ $\mathcal{O}(\tilde{L})$
ODENet 0.42%     0.22M   $\mathcal{O}(1)$         $\mathcal{O}(\tilde{L})$

# Impacto de las ODENets

## Impacto en la comunidad investigadora

\begin{center}
    \Huge NeurIPS

    \includegraphics[width=0.5\textwidth]{NeurIPS-logo.eps}
\end{center}

## Impacto económico

\begin{center}
    \includegraphics[width=\textwidth]{fsf.eps}

    \raisebox{-0.5\height}{\includegraphics{esp.png}}
    \raisebox{-0.5\height}{\includegraphics[width=0.4\textwidth]{meditate.eps}}
\end{center}
