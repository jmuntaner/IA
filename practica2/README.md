# Práctica 2: Sistema generación de menús para gente mayor de 65 años

## Cantidades mínimas y máximas recomendadas
### Energía
Este depende del sexo, de la estatura, el peso, la edad y un factor de actividad física
En hombres es: MB = 66,473 + (13,751 × masa (kg)) + (5,0033 × estatura (cm)) - (6,55 × edad (años)).
En mujeres es: MB = 655 + (9,463 × masa (kg)) + (1,8 × estatura (cm)) - (4,6756 × edad (años)).
La cantidad de energía recomendad es E_R = MB*NAF (en nuestro caso consideraremos 1.2, 1.4 y 1.6, bajo, medio y alto respectivamente).
#### Otros factores de corrección
Si sobra tiempo existen otros factores como haber sido operado, estrés, etc...
### MacroNutrientes
La cantidad de proteínas recomendadas esta entre 0.66 y 0.83 g por kg
La cantidad de grasa recomendada esta entre 0.3·E_R y 0.35·E_R
De esta, la cantidad de grasa saturada esta entre 0.07·E_R y 0.1·E_R. En mayores de 65 años no debe superar los 300 mg.
La cantidad de carbohidratos recomendada esta entre 0.50·E_R y 0.6·E_R
De estos, el azucar no debe superar el 0.1·E_R. Hemos establecido un mínimo de 0.05·E_R para que la dieta sea más apetecible y por tanto más fácil de seguir

Hay que tener en cuenta que los carbohidratos y proteinas aportan 4 kcal/g y las grasas, 9 kcal/g
### MicroNutrientes
Se ha escogido los micronuntrientes más o menos *importantes*

En el caso de los micronutrientes, en la base de datos las vitaminas A y C, el hierro y el calcio aparecen ya en relación a la cantidad diaria recomendada para una dieta de 2000 kcal.

| Nutriente         | Varones | Mujeres |
|-------------------|---------|---------|
| Vitamina A (μg)   | 900     | 800     |
| Vitamina B6 (mg)  | 1.9     | 1.7     |
| Vitamina B12 (μg) | 2.4     | 2.4     |
| Vitamina C (mg)   | 60      | 60      |
| Vitamina D (μg)   | 20      | 20      |
| Vitamina E (mg)   | 10      | 10      |
| Hierro (mg)       | 8       | 10      |
| Calcio (mg)       | 1300    | 1300    |
| Magnesio (mg)     | 420     | 320     |
| Yodo (μg)         | 150     | 150     |
| Potasio (mg)      | 3500    | 3500    |

No deben superarse los 5 g de sodio.
Las mujeres premenopáusicas (menores de 45 años) deben tomar un 30% más de hierro.
La vitamina A es tóxica en cantidades muy altas (más de 15000 μg).

## ¿Cómo afectan las enfermedades a las dietas?
### Diabetes

No sobrepasar el 30% de grasas, reducir la cantidad de sal a 2g/día, se reocmienda una cantidad de fibra de 14g/1000kcal.

### Hipertensión

Limitar ingesta de sal 2g de sodio diario, 4700 mg/dia de Potasio, disminuir la ingesta de grasa total

### Insuficiencia renal

E = 35kcal* (peso ideal god knows) /dia. Vitamina C 75-100mg/dia

### Osteoporosis

### Enfermedades articulares inflamatorias

## Respecto a la cocción

tabla % de pérdidas


| Tipo Alimento     | Tipo cocción | Minerales | Vitamina A | Vitamina B6 | Vitamina B12 | Vitamina C | Vitamina E |
|-------------------|--------------|-----------|------------|-------------|--------------|------------|------------|
| Lácteos           | Hervido      | 5         | 10         | 10          | 5            | 50         | 20         |
|                   | Fritura      | 0         | 10         | 10          | 5            | 50         | 20         |
|                   | Horneado     | 0         | 10         | 10          | 5            | 50         | 20         |
|                   | Plancha      | 0         | 10         | 10          | 5            | 50         | 20         |
|                   | Estofado     | 5         | 10         | 10          | 5            | 50         | 20         |
| Cereales          | Hervido      | 5         | 10         | 40          | 0            | 0          | 0          |
|                   | Fritura      | 0         | 10         | 40          | 0            | 0          | 0          |
|                   | Horneado     | 0         | 10         | 25          | 0            | 0          | 0          |
|                   | Plancha      | 0         | 10         | 30          | 0            | 0          | 0          |
|                   | Estofado     | 5         | 10         | 40          | 0            | 0          | 0          |
| Verduras y Frutas | Hervido      | 5         | 10         | 40          | 0            | 50         | 0          |
|                   | Fritura      | 0         | 10         | 40          | 0            | 50         | 15         |
|                   | Horneado     | 0         | 10         | 40          | 0            | 50         | 0          |
|                   | Plancha      | 0         | 15         | 35          | 0            | 40         | 0          |
|                   | Estofado     | 5         | 20         | 40          | 0            | 50         | 10         |
| Carnes            | Hervido      | 5         | 10         | 50          | 20           | 20         | 20         |
|                   | Fritura      | 0         | 20         | 20          | 20           | 20         | 20         |
|                   | Horneado     | 0         | 5          | 20          | 20           | 20         | 20         |
|                   | Plancha      | 5         | 15         | 30          | 20           | 20         | 20         |
|                   | Estofado     | 5         | 15         | 40          | 20           | 20         | 20         |
| Pescado           | Hervido      | 5         | 10         | 5           | 5            | 20         | 0          |
|                   | Fritura      | 0         | 20         | 20          | 0            | 20         | 0          |
|                   | Hervido      | 0         | 20         | 10          | 10           | 20         | 0          |
|                   | Plancha      | 0         | 10         | 10          | 10           | 20         | 0          |
|                   | Estofado     | 5         | 15         | 10          | 5            | 20         | 0          |
