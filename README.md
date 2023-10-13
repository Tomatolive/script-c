# script-c
Le script permet la génération des fichiers sources, la génération de la documentation doxygen, la compilation (simple ou séparée) et l'execution (avec ou sans arguments) du programme.
Il est impératif que les fichiers sources (fichiers de programmation), s'ils existent avant le lancement du script, soit placés dans le même répertoire que le script.

Argument (l'ordre des arguments n'a aucune importance, cependant les tirets sont obligatoires) :
-c : cet argument permet la création des fichiers de programmation. Si aucun autre argument n'est utilisé, le script créera et compilera un simple fichier main.c. En utilisant l'argument -cs, il créera et compilera les trois fichiers en utilisant les noms par défault. Pour utiliser des noms personnalisés, utilisez les arguments -csn ou -cun
-cs : cet argument permet la compilation séparée, avec la création d'un makefile. Les noms par défault des fichiers seront main.c, fonctions.c et fonctions.h
-csn : argument similaire au précédent, à la différence que le script demandera le nom des fichiers
-cun : cet argument permet la compilation simple. Le script demandera le nom du fichier
-d : cet argument permet la création d'un fichier de config doxygen ainsi que la génération de la documentation
-e : cet argument permet de lancer l'execution du programme (avec ou sans arguments) après compilation
-h : cet argument affiche la présente documentation
-he : cet argument exporte dans un fichier README la présente documentation
Appeler le script sans argument résultera dans de la compilation simple, avec main.c comme nom du fichier par défault, sans génération de documentation.

Exemples d'utilisation :
./script.sh -c -cs     : Création des trois fichiers main.c fonctions.c et fonctions.h, avec compilation grâce au makefile
./script.sh -csn -d -e : Compilation séparée, demandant le nom des trois fichiers, génération de la documentation doxygen, puis exécution du programme
./script.sh -he	       : Création de README.txt	
