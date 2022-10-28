# Graph2Strat compiler

## Build

Pour compiler, installer ocaml et son package manager (opam), puis installer dune et menhir

Ensuite, dans le présent dossier, lancer dune build

## Utilisation

Lancer le compilateur avec ./_build/default/main.exe suivi du nom de fichier .dot à traiter ou sans arguments pour lire sur l'entrée standard ne pas oublier de piper la sortie standard dans un fichier possible de ne pas mettre de fichier pour entrer le graphe sur l'entrée standard, ou de mettre le flag --lib pour récupérer une copie de la librairie statemachine à utiliser avec le code généré

### Syntaxe reconnue

Les graphes reconnus par le compilateur respectent le subset de la syntaxe DOT suivante:

```dot
//init NomEtatInitial
digraph NomStateMachine {
NomDeNoeud [comment=""] //(crée un noeud sans callbacks)
NomDeNoeud [comment="nom_on_enter"] //(crée un noeud avec une callback d'entrée)
NomDeNoeud [comment="nom_on_enter/nom_on_leave"] //(crée un noeud avec une callback d'entrée et une callback de sortie)

NomDeNoeudDépart -> NomDeNoeudArrivée [label=""] //(crée une transition sans callback ni garde)
NomDeNoeudDépart -> NomDeNoeudArrivée [label="nom_on_transition"] //(crée une transition avec callback sans garde (acceptée par défaut))
NomDeNoeudDépart -> NomDeNoeudArrivée [label="nom_on_transition/nom_guard"] //(crée une transition avec garde (prédicat à vérifier pour activer la transition))

{NomDépartA NomDépartB ...} -> NomDeNoeudArrivée [label="..."] //(comme au-dessus, mais permet de partir de plusieurs noeuds différents pour arriver au même noeud)

}
```

### Bugs/limitations:

Pour l'instant, le compilateur ne permet pas d'insérer du code dans un fichier existant. Il ne faut pas déclarer plusieurs noeuds avec le même nom et des charactéristiques différentes. Le compilateur devrait inférer les noeuds manquants si ils sont déclarés et les créer vides, mais il peut subsister des bugs.

En somme, pensez à quand-même vérifier l'output du programme avant de vous en servir.

## TODO du projet

- [ ] Prendre en charge le templating
  - [ ] Zone des déclarations d'états et de transitions
  - [ ] Zone des définitions de fonctions
- [ ] Prendre en charge les fichiers en argv
- [ ] Option d'ajouter un self. à l'attribut statemachine
