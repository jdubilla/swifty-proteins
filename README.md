# Swifty-Proteins

Swifty Proteins est un projet développé dans le cadre du cursus de l'école 42. Il s'agit de créer une application mobile permettant aux utilisateurs de visualiser des molécules en 3D, à partir de données téléchargées depuis la Protein Data Bank (PDB) via leur format de fichier .sdf.

## Table des matières
- [Introduction](#introduction)
- [Fonctionnalités](#fonctionnalités)
- [Technologies Utilisées](#technologies)
- [À propos des Fichiers .sdf](#fichierssdf)
- [Présentation du projet](#presentation)


<div id='introduction'/> 

## Introduction

L'objectif de Swifty Proteins est de fournir une interface intuitive permettant aux utilisateurs d'explorer les structures de protéines en utilisant des techniques de visualisation moléculaire. L'application utilise SceneKit pour le rendu des modèles 3D et offre un environnement interactif pour manipuler et inspecter ces molécules.


<div id='fonctionnalités'/> 

## Fonctionnalités

- **Gestion des utilisateurs** : Utilisation d'un backend pour la gestion des utilisateurs.
- **Connexion** : Utilisation de FaceID (ou TouchID) pour permettre de s'authentifier a chaque ouverture de l'application.
- **Visualisation 3D** : Visualiser des molécules de protéines dans un espace tridimensionnel grace au framework SceneKit.
- **Sélection de molécules** : Choisir parmi une variété de structures de protéines disponibles.
- **Contrôles interactifs** : Zoomer, faire pivoter et explorer les molécules à l'aide de gestes intuitifs.
- **Affichage d'informations** : Obtenir des informations sur la molécule sélectionnée.


<div id='technologies'/> 

## Technologies Utilisées

- **Application**: Swift, SwiftUI
- **3D**: SceneKit
- **Backend**: Node.js, Express.js
- **Base de données**: MySQL
- **Sécurité**: FaceID, TouchID, Keychain, JSON Web Tokens (JWT), argon2
- **Déploiement**: Docker (pour le backend et la base de données)


<div id='fichierssdf'/> 

## À propos des Fichiers .sdf et la Protein Data Bank (PDB)

Les fichiers .sdf sont des fichiers au format Structure Data File, un standard utilisé pour représenter des structures moléculaires telles que des protéines. Ces fichiers contiennent des informations essentielles sur la structure, la géométrie et d'autres propriétés importantes des molécules.

La Protein Data Bank (PDB) est une ressource inestimable pour les chercheurs et les scientifiques du domaine de la biologie structurale. Elle rassemble une vaste collection de données sur des structures macromoléculaires, y compris des protéines, rendant ces informations accessibles pour l'étude, la recherche et la visualisation.


### Téléchargement des Données depuis la PDB

Pour alimenter cette application, les données sont téléchargées directement depuis la PDB via leur interface conviviale, offrant ainsi un accès rapide et fiable à une diversité de structures protéiques.


#### Exemple de fichier .sdf pour une toute petite molecule (ALF) de 5 atoms :

```sdf
ALF
  -OEChem-12082319453D

  5  4  0     0  0  0  0  0  0999 V2000
    7.3920   68.8290   74.6090 Al  0  5  0  0  0  0  0  0  0  0  0  0
    8.5740   70.0280   75.1840 F   0  0  0  0  0  0  0  0  0  0  0  0
    6.1610   67.6360   74.0360 F   0  0  0  0  0  0  0  0  0  0  0  0
    8.3250   68.6190   73.0940 F   0  0  0  0  0  0  0  0  0  0  0  0
    6.4680   69.0490   76.1250 F   0  0  0  0  0  0  0  0  0  0  0  0
  1  2  1  0  0  0  0
  1  3  1  0  0  0  0
  1  4  1  0  0  0  0
  1  5  1  0  0  0  0
M  CHG  1   1  -1
M  END
> <OPENEYE_ISO_SMILES>
F[Al-](F)(F)F

> <OPENEYE_INCHI>
InChI=1S/Al.4FH/h;4*1H/q+3;;;;/p-4

> <OPENEYE_INCHIKEY>
UYOMQIYKOOHAMK-UHFFFAOYSA-J

> <FORMULA>
AlF4-

$$$$
```

### Parsing du Fichier .sdf pour récuperer les informations

Pour exploiter les données du fichier .sdf dans cette application, un processus de parsing est nécessaire pour extraire les informations clés. Deux blocs essentiels sont identifiés dans ce format :

#### Bloc des Coordonnées (X, Y, Z)

Ce bloc contient les coordonnées spatiales des atomes constituant la protéine. Ces informations tri-dimensionnelles (X, Y, Z) sont fondamentales pour la représentation spatiale de la structure moléculaire.

Exemple :

```sdf
    7.3920   68.8290   74.6090 Al  0  5  0  0  0  0  0  0  0  0  0  0
    8.5740   70.0280   75.1840 F   0  0  0  0  0  0  0  0  0  0  0  0
    6.1610   67.6360   74.0360 F   0  0  0  0  0  0  0  0  0  0  0  0
    8.3250   68.6190   73.0940 F   0  0  0  0  0  0  0  0  0  0  0  0
    6.4680   69.0490   76.1250 F   0  0  0  0  0  0  0  0  0  0  0  0
```

#### Bloc des Connexions Atomiques

Ce bloc décrit les connexions entre les atomes, définissant ainsi la structure et la liaison moléculaire. Ces connexions sont cruciales pour comprendre la topologie et la configuration tridimensionnelle de la protéine.

Exemple :

```sdf
  1  2  1  0  0  0  0
  1  3  1  0  0  0  0
  1  4  1  0  0  0  0
  1  5  1  0  0  0  0
```

La première ligne du bloc des connexions atomiques indique une liaison entre la molécule numéro un (la première ligne du premier bloc avec les coordonnées x, y et z) et la molécule numéro deux. Cette liaison est spécifiée comme étant une connexion simple, bien qu'il soit possible d'avoir des liaisons simples ou doubles.


<div id='presentation'/> 

## Présentation du projet

- Vidéo du projet :

https://github.com/jdubilla/swifty-proteins/assets/86416832/5a7debaa-d835-4739-8d82-0cc593294460


