# DoublePendule_Physique
Projet Physique HES-SO Valais-Wallis

# Objectifs du projet
1. Simuler la dynamique du pendule double et la comparer aux vidéos;
2. Prédire le comportement futur du pendule double;
3. Quantifier la précision des résultats.

# Théorie
Le double pendule est un processus chaotique. Cela veut dire qu'il est extrêmement
sensible aux conditions initiales.

Avec les phénomènes choatiques, la précision de calcul influe fortement sur les
résultats produits. En raison des arrondissements et imprefections des calculs
numériques, il est souvent impossible de prédire la nature du phénomène chaotique
sur le long terme.

Cependant, il est possible de prédire et donc simuler les états du futur proche.

Cela est le but de ce projet.

## Formules
$$\frac{\delta v}{\delta t} = -\frac{GMm}{\Vert \vec{r} \Vert^3} \cdot \vec{r}$$
