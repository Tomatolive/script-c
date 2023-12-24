# Script-c

<table>
<tr>
<td>

## Index
1. [Introduction](#introdution)
    1. [Description](#description)
    2. [Recommandations](#recommandations)
2. [Makefile](#makefile)
3. [Options](#options)
4. [Arguments](#arguments)
5. [Exemples d'utilisation](#exemples-d'utilisation)
</td>
</table>

## Introduction
#### Description
Le script permet la génération des fichiers sources, la génération de la documentation doxygen, la création d'un makefile (avec ou sans CMake), la compilation, le débogage et l'exécution (avec ou sans arguments) du programme.  
Le script créera, s'ils n'existent pas, un répertoire pour les fichiers sources (`src`), un répertoire pour l'exécutable (`bin`), un répertoire pour la documentation doxygen (`doc`) et un dossier de sauvegarde des fichiers sources (`save`).
#### Recommandations
Il est **impératif** que les fichiers sources (fichiers de programmation), s'ils existent avant le lancement du script, soit placés dans le même répertoire que le script.  
Après la première utilisation du script, placez les fichiers sources soit dans le répertoire du script, soit dans le répertoire `src`.   
Ces programmes sont nécessaires pour le bon fonctionnement du script : [`cmake`](https://cmake.org/download/), [`doxygen`](https://www.doxygen.nl/download.html), [`gcc`](https://gcc.gnu.org/install/index.html), [`gdb`](https://www.sourceware.org/gdb/download/), [`make`](https://www.gnu.org/software/make/#download) et [`valgrind`](https://valgrind.org/downloads/).  

## Makefile
Le script est capable de générer deux Makefile différents : un Makefile manuel et un Makefile généré par CMake.  
Ici, c'est le Makefile manuel qui nous intéresse. Voici un petit résumé des cibles du Makefile :  
|   Cible   |                                             Description                                             |     Commande      |
|:---------:|:---------------------------------------------------------------------------------------------------:|:-----------------:|
| `all`     | Permet la compilation du programme                                                                  | `make`/`make all` |
| `save`    | Permet la copie des fichiers du répertoire des sources `src` dans le répertoire de sauvegarde `save`| `make save`       |
| `restore` | Permet la copie des fichiers du répertoire de sauvegarde `save` dans le répertoire des sources `src`| `make restore`    |
| `comp`    | Permet la création d'une archive contenant tous les fichiers sources                                | `make comp`       |
| `clean`   | Permet de supprimer les fichiers objets                                                             | `make clean`      |

## Options
Les options sont des paramètres directement modifiables par l'utilisateur dans le code du script. Ils se trouvent à la fin du fichier et peuvent prendre différentes valeurs :  
|    Option     |                     Description                     |     Valeur     |
|:-------------:|:---------------------------------------------------:|:--------------:|
| `@main`       | Représente le nom du fichier principal              | Quelconque     |
| `@fctc`       | Représente le nom du fichier de corps des fonctions | Quelconque     |
| `@fcth`       | Représente le nom du fichier d'entetes des fonctions| Quelconque     |
| `@executable` | Représente le nom de l'exécutable                   | Quelconque     |
| `@archive`    | Représente le nom de l'archive créée par le makefile| Quelconque     |
| `@editeur`    | Réprésente la commmande ouvrant un editeur de code  | Quelconque     |
| `@argument`   | Représente l'utilisation d'argument                 | `true`/`false` |
| `@makefile`   | Représente la création du makefile SANS CMake       | `true`/`false` |
| `@d_gdb`      | Représente le débogage avec gdb                     | `true`/`false` |
| `@d_valgrind` | Représente le débogage avec valgrind                | `true`/`false` |

## Arguments
L'ordre des arguments n'a aucune importance, cependant les tirets sont obligatoires :  
* `-c` : cet argument permet la création des fichiers de programmation, en utilisant les noms de fichiers des options `@main`, `@fctc` et `@fcth`  
* `-d` : cet argument permet la création d'un fichier de config doxygen ainsi que la génération de la documentation  
* `-db` : cet argument permet le débogage du programme. Le script lancera valgrind et gdb pour déboguer le programme en fonction de la valeur des options `@d_gdb` et `@d_valgrind`  
* `-e` : cet argument permet la compilation puis l'exécution du programme (avec ou sans arguments), ainsi qu'une vérification préalable des fuites mémoires. Attention, il faut déjà avoir généré un makefile pour pouvoir utiliser cet argument  
* `-h` : cet argument affiche la présente documentation  
* `-he` : cet argument exporte dans un fichier README la présente documentation  
* `-m` : cet argument permet la création d'un makefile. En fonction de la valeur de `@makefile`, le makefile sera soit crée manuellement, soit avec Cmake  

Appeler le script sans argument résultera dans 1) la création des différents répertoires (s'ils n'existent pas) 2) l'importation des fichiers sources du répertoire courant dans le répertoire `src`. NB : le script exécutera ces actions même s'il est appelé avec des arguments.  

## Exemples d'utilisation
`./script.sh -c`         : Création des trois fichiers `main.c` `fonctions.c` et `fonctions.h`  
`./script.sh -m -d -e`   : Création du makefile, génération de la documentation doxygen, compilation puis exécution du programme  
`./script.sh -he`        : Création de `README.txt`	