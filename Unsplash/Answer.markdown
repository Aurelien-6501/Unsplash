
Réponse questions


1. Qu’est-ce que LazyVGrid et pourquoi l’utiliser ?

LazyVGrid est un conteneur SwiftUI qui organise les vues sous forme de grille verticale et les éléments sont disposés.

On l'utilise parce que qu'il est pratique pour faire des interfaces avec un format organisé et optimisé. En plus on peut mettre le style que l'on souhaite sur la grid.


2. Les différents types de colonnes et pourquoi utiliser flexible ?

Types de colonnes dans LazyVGrid :
- .fixed :
Définie une largeur fixe pour chaque colonne.

- .flexible :
Adapte la largeur des colonnes en fonction de l’espace disponible.

- .adaptive :
Permet aux colonnes de changer de taille ou de se dupliquer en fonction de l’espace disponible.

Pourquoi utiliser flexible ici ?
 
 Avec .flexible, les colonnes s’ajustent dynamiquement pour partager équitablement l’espace disponible. Ce qui donne en plus un design responsive.

3. Pourquoi les images prennent toute la largeur de l’écran ?

Par défaut, SwiftUI occupe tout l’espace disponible : Avec .flexible, les colonnes remplissent entièrement la largeur de leur conteneur parent.
Si les colonnes ne sont pas configurées avec une taille minimale/maximale elles prennent l’espace offert par leur conteneur.




Expliquez les différences entre ces 3 méthodes.



1. async/await

Une manière simple d’écrire du code asynchrone.
On utilise await pour attendre qu’une tâche se termine avant de passer à la suivante. Le code ressemble à du code synchrone.

2. Combine

Un framework pour gérer des flux de données.
On utilise des Publishers (qui envoient des données) et des Subscribers (qui reçoivent les données).

3. Completion Handlers
Une méthode classique avec des callbacks.
On passe une fonction (closure) à exécuter une fois l’opération terminée.

