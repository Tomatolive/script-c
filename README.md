# script-c
Le script permet la génération des fichiers sources, la génération de la documentation doxygen, la création d'un makefile, la compilation, le débogage et l'exécution (avec ou sans arguments) du programme.  
Il est impératif que les fichiers sources (fichiers de programmation), s'ils existent avant le lancement du script, soit placés dans le même répertoire que le script.  
Après la première utilisation du script, il faut placer les fichiers sources dans le répertoire src.  
Aucun fichier ne doit être placé par l'utilisateur dans le répertoire bin. Le faire risque d'engendrer des problèmes lors de l'exécution ou du débogage.  
Ces programmes sont nécessaires pour le bon fonctionnement du script : doxygen, gcc, gdb, make et valgrind.  

Argument (l'ordre des arguments n'a aucune importance, cependant les tirets sont obligatoires) :  
-c : cet argument permet la création des fichiers de programmation, en utilisant les noms de fichiers par défaut  
-cn : argument similaire au précédent, à la différence que le script demandera le nom des fichiers  
-d : cet argument permet la création d'un fichier de config doxygen ainsi que la génération de la documentation  
-db : cet argument permet le débogage du programme. Le script lancera valgrind et gdb pour déboguer le programme  
-e : cet argument permet la compilation puis l'exécution du programme (avec ou sans arguments). Attention, il faut déjà avoir généré un makefile pour pouvoir utiliser cet argument  
-h : cet argument affiche la présente documentation  
-he : cet argument exporte dans un fichier README la présente documentation  
-m : cet argument permet la création d'un makefile  
Appeler le script sans argument résultera dans 1) la création des différents répertoires (s'ils n'existent pas) 2) l'importation des fichiers sources du répertoire courant dans le réperoire src. NB : le script exécutera ces actions même s'il est appelé avec des arguments.  

Exemples d'utilisation :  
./script.sh -c         : Création des trois fichiers main.c fonctions.c et fonctions.h  
./script.sh -m -d -e   : Création du makefile, génération de la documentation doxygen, compilation puis exécution du programme  
./script.sh -he        : Création de README.txt	
