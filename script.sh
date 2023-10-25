#!/bin/bash
clear

##########################################################################
## Programme : script.sh                                                ##
## But       : Création des fichiers de programmation                   ##
##             Création de la documentation Doxygen                     ##
##             Compilation de programme C (avec ou sans makefile)       ##
##             Exécution de programme (avec ou sans arguments)          ##
##             Création d'un readme pour le script                      ##
##             Affichage d'aide                                         ##
##                                                                      ##
## Arguments                                                            ##
## - IN      : -c                                                       ##
##             -cs                                                      ##
##             -csn                                                     ##
##             -cun                                                     ##
##             -d                                                       ##
##             -e                                                       ##
##             -h                                                       ##
##             -he                                                      ##
## - IN#OUT  : neant                                                    ##
## - OUT     : neant                                                    ##
## Retour    : Affichage                                                ##
##                                                                      ##
## Historique                    Date        Version  par            	##
## Création et édition du script 09/10/2023  1.0      Thomas Brasdefer  ##
## Modification, ajout de d'arg° 10/10/2023  2.0      Thomas Brasdefer  ##
## Modification et ajout         11/10/2023  3.0      Thomas Brasdefer  ##
## Ajout et correction           12/10/2023  4.0      Thomas Brasdefer  ##
## Correction                    13/10/2023  4.1      Thomas Brasdefer  ##
## Modification                  24/10/2023  4.2      Thomas Brasdefer  ##
##########################################################################

# --- Déclaration et initialisation (valeur par défaut) des variables associées aux arguments --- #
c=false
cs=false
cu=true
d=false
e=false
h=false
he=false
# --- Déclaration et initialisation (valeur par défaut) des variables contenant les noms des fichiers --- #
main="main"
fctc="fonctions"
fcth="fonctions"
exe="exe"
# --- Déclaration et initialisation (valeur par défaut) des variables permettant la récupération et l'utilisation d'argument pour l'execution du programme C --- #
strIn=""  # Variable contenant les différentes entrées d'arguments
strArg="" # Variable contenant, à terme, l'entièreté des arguments
nbArg=-1  # Variable contenant, à terme, le nombre d'arguments

# --- Boucle parcourant l'entièreté des arguments --- #
for i in $*
do
    if [ "$i" = "-h" ]
    then
        h=true
    fi
    if [ "$i" = "-he" ]
    then
        he=true
    fi
    if [ "$i" = "-c" ]
    then
        c=true
    fi
    if [ "$i" = "-d" ]
    then
        d=true
    elif [ "$i" = "-cs" ]
    then
        cs=true
        cu=false
    elif [ "$i" = "-csn" ]
    then
        cs=true
        cu=false
        echo "Veuillez indiquer le nom du fichier main (sans indiquer l'extension) : "
        read main
        echo "Veuillez iniquer le nom du fichier contenant les fonctions (sans indiquer l'extension) : "
        read fctc
        echo "Veuillez indiquer le nom du fichier contenant le prototypage des fonctions (sans indiquer l'extension) : "
        read fcth
        echo "Veuillez indiquer le nom de l'executable : "
        read exe
    elif [ "$i" = "-cun" ]
    then
        echo "Veuillez indiquer le nom du fichier main (sans indiquer l'extension) : "
        read main
        echo "Veuillez indiquer le nom de l'executable : "
        read exe
    fi
    if [ "$i" = "-e" ]
    then
        e=true
        echo "Veuillez indiquer le nombre d'argument (0 s'il n'y en a pas)"
        read nbArg
        if [ "$nbArg" -gt 0 ]
        then
            for (( j=1; j <= $nbArg; j++ ));
            do
                echo "Entrez l'argument numéro $j :"
                read strIn
                # --- Concaténation des arguments en une seule chaine --- #
                strArg="$strArg $strIn"
            done
        fi
    fi
done

# --- Affichage de l'aide (readme) --- #
if [ "$h" = true ]
then
    echo "Le script permet la génération des fichiers sources, la génération de la documentation doxygen, la compilation (simple ou séparée) et l'execution (avec ou sans arguments) du programme."
    echo "Il est impératif que les fichiers sources (fichiers de programmation), s'ils existent avant le lancement du script, soit placés dans le même répertoire que le script."
    echo ""
    echo "Argument (l'ordre des arguments n'a aucune importance, cependant les tirets sont obligatoires) : "
    echo "-c : cet argument permet la création des fichiers de programmation. Si aucun autre argument n'est utilisé, le script créera et compilera un simple fichier main.c. En utilisant l'argument -cs, il créera et compilera les trois fichiers en utilisant les noms par défaut. Pour utiliser des noms personnalisés, utilisez les arguments -csn ou -cun"
    echo "-cs : cet argument permet la compilation séparée, avec la création d'un makefile. Les noms par défaut des fichiers seront main.c, fonctions.c et fonctions.h"
    echo "-csn : argument similaire au précédent, à la différence que le script demandera le nom des fichiers"
    echo "-cun : cet argument permet la compilation simple. Le script demandera le nom du fichier"
    echo "-d : cet argument permet la création d'un fichier de config doxygen ainsi que la génération de la documentation"
    echo "-e : cet argument permet de lancer l'execution du programme (avec ou sans arguments) après compilation"
    echo "-h : cet argument affiche la présente documentation"
    echo "-he : cet argument exporte dans un fichier README la présente documentation"
    echo "Appeler le script sans argument résultera dans de la compilation simple, avec main.c comme nom du fichier par défaut, sans génération de documentation."
    echo ""
    echo "Exemples d'utilisation :"
    echo "./script.sh -c -cs     : Création des trois fichiers main.c fonctions.c et fonctions.h, avec compilation grâce au makefile"
    echo "./script.sh -csn -d -e : Compilation séparée, demandant le nom des trois fichiers, génération de la documentation doxygen, puis exécution du programme"
    echo "./script.sh -he        : Création de README.txt"
    exit 0
fi

# --- Génération du fichier readme --- #
if [ "$he" = true ]
then
    echo "***** Création du README *****"
    echo -e "Le script permet la génération des fichiers sources, la génération de la documentation doxygen, la compilation (simple ou séparée) et l'execution (avec ou sans arguments) du programme. \nIl est impératif que les fichiers sources (fichiers de programmation), s'ils existent avant le lancement du script, soit placés dans le même répertoire que le script. \n\nArgument (l'ordre des arguments n'a aucune importance, cependant les tirets sont obligatoires) : \n-c : cet argument permet la création des fichiers de programmation. Si aucun autre argument n'est utilisé, le script créera et compilera un simple fichier main.c. En utilisant l'argument -cs, il créera et compilera les trois fichiers en utilisant les noms par défaut. Pour utiliser des noms personnalisés, utilisez les arguments -csn ou -cun \n-cs : cet argument permet la compilation séparée, avec la création d'un makefile. Les noms par défaut des fichiers seront main.c, fonctions.c et fonctions.h \ncsn : argument similaire au précédent, à la différence que le script demandera le nom des fichiers \n-cun : cet argument permet la compilation simple. Le script demandera le nom du fichier \n-d : cet argument permet la création d'un fichier de config doxygen ainsi que la génération de la documentation \n-e : cet argument permet de lancer l'execution du programme (avec ou sans arguments) après compilation \n-h : cet argument affiche la présente documentation \n-he : cet argument exporte dans un fichier README la présente documentation \nAppeler le script sans argument résultera dans de la compilation simple, avec main.c comme nom du fichier par défaut, sans génération de documentation. \n\nExemples d'utilisation : \n./script.sh -c -cs     : Création des trois fichiers main.c fonctions.c et fonctions.h, avec compilation grâce au makefile \n./script.sh -csn -d -e : Compilation séparée, demandant le nom des trois fichiers, génération de la documentation doxygen, puis exécution du programme \n./script.sh -he	       : Création de README.txt" > README.txt
    echo "  OK"
    exit 0
fi

# --- Création du dossier Sources s'il n'existe pas --- #
if [ ! -d "./Sources" ]
then
    echo "***** Création du dossier Sources *****"
    mkdir Sources/
    echo "  OK"
fi

# --- Déplacement des fichiers (s'ils existent) pour la compilation séparée --- #
if [ "$cs" = true ]
then
    echo "***** Importation des sources *****"
    if [ -f "$fctc.c" ]
    then
        mv ./"$fctc".c ./Sources/
    fi
    if [ -f "$fcth.h" ]
    then
        mv ./"$fcth".h ./Sources/
    fi
    echo "  OK"
fi
# --- Déplacement du fichier main (s'il existe) pour la compilation simple --- #
if [ -f "$main.c" ]
then
    echo "***** Importation des sources *****"
    if [ -f "$main.c" ]
    then
        mv ./"$main".c ./Sources/
    fi
    echo "  OK"
fi

cd Sources/

# --- Création des fichiers de programmation en compilation séparéoe --- #
if [ "$c" = true ] && [ "$cs" = true ]
then
    echo "***** Création des fichiers .c et .h *****"
    if [ ! -f "./$main.c" ]
    then
        touch $main.c
        echo -e '#include "'$fcth'.h" \n#include <stdio.h> \n\nint main(int argc, char** argv) { \n\treturn 0; \n}' > $main.c
    else
        echo "/!\ $main.c existe déjà"
    fi
    if [ ! -f "./$fctc.c" ]
    then
        touch $fctc.c
        echo -e '#include "'$fcth'.h" \n#include <stdio.h>' > $fctc.c
    else
        echo "/!\ $fctc.c existe déjà"
    fi
    if [ ! -f "./$fcth.h" ]
    then
        touch $fcth.h
        echo -e "#include <stdio.h> \n#ifndef `echo $fcth | tr '[:lower:]' '[:upper:]'`_H \n#define `echo $fcth | tr '[:lower:]' '[:upper:]'`_H \n#endif" > $fcth.h  # tr '[:lower:]' '[:upper:]' permet de passer de minuscule à majuscule la chaine de caractère passée en entrée
    else
        echo "/!\ $fcth.h existe déjà"
    fi
    echo "  OK"
    echo "***** Ouverture des fichiers *****"
    code $main.c
    code $fctc.c
    code $fcth.h
    echo "  OK"
# --- Création des fichiers de programmation en compilation simple --- #
elif [ "$c" = true ] && [ "$cu" = true ]
then 
    echo "***** Création du main *****"
    if [ ! -f "./$main.c" ]
    then
        touch $main.c
        echo -e "#include <stdio.h> \n\nint main(int argc, char** argv) { \n\treturn 0; \n}" > $main.c
    else
        echo "/!\ $main.c existe déjà"
    fi
    echo "  OK"
    echo "***** Ouverture du fichier *****"
    code $main.c
    echo "  OK"
fi

# --- Création du doxyfile et de la documentation --- #
if [ "$d" = true ]
then
    echo "***** Création du fichier de configuration doxygen *****"
    # --- Redirection de la sortie standard lors de la création du doxyfile --- #
    doxygen -g proto1 > /dev/null
    # --- Changement d'option dans le doxyfile afin de supprimer les affichages réalisés par Doxygen --- #
    sed -e s/"QUIET                  = NO"/"QUIET                  = YES"/g proto1 > proto2
    sed -e s/"WARNINGS               = YES"/"WARNINGS               = NO"/g proto2 > Doxyfile
    rm proto1 proto2
    echo "  OK"
    echo "***** Génération de la documentation *****"
    # --- Redirection de la sortie erreur standard lors de la génération de la documentation --- #
    doxygen Doxyfile 2> /dev/null
    echo "  OK"
fi

# --- Création du makefile et compilation séparée --- #
if [ "$cs" = true ]
then
    # --- Vérification de l'existence des fichiers --- #
    if [ ! -f "$main.c" ]
    then
        echo "/!\ $main.c n'existe pas. Merci de vérifier l'existence du fichier et de le placer dans le répertoire."
        exit 1
    elif [ ! -f "$fctc.c" ]
    then
        echo "/!\ $fctc.c n'existe pas. Merci de vérifier l'existence du fichier et de le placer dans le répertoire."
        exit 1
    elif [ ! -f "$fcth.h" ]
    then
        echo "/!\ $fcth.h n'existe pas. Merci de vérifier l'existence du fichier et de le placer dans le répertoire."
        exit 1
    fi
    echo "***** Création du makefile *****"
    touch Makefile.mk
    echo -e "$exe: $fctc.o $main.o \n\t@echo '"Compilation de l executable"' \n\tgcc -o $exe $fctc.o $main.o -lm \n$fctc.o: $fctc.c $fcth.h \n\t@echo '"Compilation de $fctc"' \n\tgcc -g -c $fctc.c -o $fctc.o -lm \n$main.o: $main.c $fcth.h \n\t@echo '"Compilation du main"' \n\tgcc -g -c $main.c -o $main.o -lm \nclean: \n\t@echo '"Les précédents fichiers ont bien été effacé"' \n\trm -f *.o" > Makefile.mk    echo "  OK"
    echo "***** Execution du makefile *****"
    make -f Makefile.mk
    echo "  OK"
# --- Compilation simple --- #
elif [ "$cu" = true ]
then
    # --- Vérification de l'existence du fichier --- #
    if [ ! -f "$main.c" ]
    then
        echo "$main.c n'existe pas. Merci de vérifier l'existence du fichier et de le placer dans le répertoire."
        exit 1
    fi
    echo "***** Compilation du programme *****"
    gcc -Wall -g $main.c -o $exe
    echo "  OK"
fi

# --- Execution, avec ou sans argument --- #
if [ "$e" = true ]
then
    echo "***** Execution du programme *****"
    ./$exe $strArg
fi
exit 0

