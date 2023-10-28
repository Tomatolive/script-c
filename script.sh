#!/bin/bash
clear

##########################################################################
## Programme : script.sh                                                ##
## But       : Création des fichiers de programmation                   ##
##             Création de la documentation Doxygen                     ##
##             Création d'un makefile et compilation                    ##
##             Exécution de programme (avec ou sans arguments)          ##
##             Création d'un readme pour le script                      ##
##             Affichage d'aide                                         ##
##                                                                      ##
## Arguments                                                            ##
## - IN      : -c                                                       ##
##             -cn                                                      ##
##             -d                                                       ##
##             -e                                                       ##
##             -h                                                       ##
##             -he                                                      ##
##             -m                                                       ##
## - IN#OUT  : neant                                                    ##
## - OUT     : neant                                                    ##
## Retour    : Répertoires, fichiers et affichage                       ##
##                                                                      ##
## Historique                    Date        Version  par            	##
## Création et édition du script 09/10/2023  1.0      Thomas Brasdefer  ##
## Modification, ajout d'arg°    10/10/2023  2.0      Thomas Brasdefer  ##
## Modification et ajout         11/10/2023  3.0      Thomas Brasdefer  ##
## Ajout et correction           12/10/2023  4.0      Thomas Brasdefer  ##
## Correction                    13/10/2023  4.1      Thomas Brasdefer  ##
## Modification                  24/10/2023  4.2      Thomas Brasdefer  ##
## Refonte majeure               27/10/2023  5.0      Thomas Brasdefer  ##
## Modification du makefile      28/10/2023  5.1      Thomas Brasdefer  ##      
##########################################################################

# --- Déclaration et initialisation (valeur par défaut) des variables associées aux arguments --- #
c=false
d=false
e=false
h=false
he=false
m=false
# --- Déclaration et initialisation (valeur par défaut) des variables contenant les noms des fichiers --- #
main="main"
fctc="fonctions"
fcth="fonctions"
exe="exe"
# --- Déclaration et initialisation de la variable représantant le nom de l'archive qui pourra être créée grâce au makefile --- #
archive="Programme\ C"
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
    if [ "$i" = "-cn" ]
    then
        c=true
        echo "Veuillez indiquer le nom du fichier main (sans indiquer l'extension) : "
        read main
        echo "Veuillez iniquer le nom du fichier contenant les fonctions (sans indiquer l'extension) : "
        read fctc
        echo "Veuillez indiquer le nom du fichier contenant le prototypage des fonctions (sans indiquer l'extension) : "
        read fcth
        echo "Veuillez indiquer le nom de l'executable : "
        read exe
    fi
    if [ "$i" = "-d" ]
    then
        d=true
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
    if [ "$i" = "-m" ]
    then
        m=true
    fi
done

# --- Affichage de l'aide (readme) --- #
if [ "$h" = true ]
then
    echo "Le script permet la génération des fichiers sources, la génération de la documentation doxygen, la création d'un makefile, la compilation et l'execution (avec ou sans arguments) du programme."
    echo "Il est impératif que les fichiers sources (fichiers de programmation), s'ils existent avant le lancement du script, soit placés dans le même répertoire que le script."
    echo "Après la première utilisation du script, il faut placer les fichiers sources dans le répertoire src."
    echo ""
    echo "Argument (l'ordre des arguments n'a aucune importance, cependant les tirets sont obligatoires) : "
    echo "-c : cet argument permet la création des fichiers de programmation, en utilisant les noms de fichiers par défaut"
    echo "-cn : argument similaire au précédent, à la différence que le script demandera le nom des fichiers"
    echo "-d : cet argument permet la création d'un fichier de config doxygen ainsi que la génération de la documentation"
    echo "-e : cet argument permet la compilation puis l'execution du programme (avec ou sans arguments). Attention, il faut déjà avoir généré un makefile pour pouvoir utiliser cet argument"
    echo "-h : cet argument affiche la présente documentation"
    echo "-he : cet argument exporte dans un fichier README la présente documentation"
    echo "-m : cet argument permet la création d'un makefile"
    echo "Appeler le script sans argument résultera dans 1) la création des différents répertoires (s'ils n'existent pas) 2) l'importation des fichiers sources du répertoire courant dans le réperoire src. NB : le script executera ces actions même s'il est appelé avec des arguments."
    echo ""
    echo "Exemples d'utilisation :"
    echo "./script.sh -c         : Création des trois fichiers main.c fonctions.c et fonctions.h"
    echo "./script.sh -m -d -e   : Création du makefile, génération de la documentation doxygen, compilation puis exécution du programme"
    echo "./script.sh -he        : Création de README.txt"
    exit 0
fi

# --- Génération du fichier readme --- #
if [ "$he" = true ]
then
    echo "***** Création du README *****"
    echo -e "Le script permet la génération des fichiers sources, la génération de la documentation doxygen, la création d'un makefile, la compilation et l'execution (avec ou sans arguments) du programme.\nIl est impératif que les fichiers sources (fichiers de programmation), s'ils existent avant le lancement du script, soit placés dans le même répertoire que le script.\nAprès la première utilisation du script, il faut placer les fichiers sources dans le répertoire src.\n\nArgument (l'ordre des arguments n'a aucune importance, cependant les tirets sont obligatoires) :\n-c : cet argument permet la création des fichiers de programmation, en utilisant les noms de fichiers par défaut\n-cn : argument similaire au précédent, à la différence que le script demandera le nom des fichiers\n-d : cet argument permet la création d'un fichier de config doxygen ainsi que la génération de la documentation\n-e : cet argument permet la compilation puis l'execution du programme (avec ou sans arguments). Attention, il faut déjà avoir généré un makefile pour pouvoir utiliser cet argument\n-h : cet argument affiche la présente documentation\n-he : cet argument exporte dans un fichier README la présente documentation\n-m : cet argument permet la création d'un makefile\nAppeler le script sans argument résultera dans 1) la création des différents répertoires (s'ils n'existent pas) 2) l'importation des fichiers sources du répertoire courant dans le réperoire src. NB : le script executera ces actions même s'il est appelé avec des arguments.\n\nExemples d'utilisation :\n./script.sh -c         : Création des trois fichiers main.c fonctions.c et fonctions.h\n./script.sh -m -d -e   : Création du makefile, génération de la documentation doxygen, compilation puis exécution du programme\n./script.sh -he        : Création de README.txt	" > README.txt
    echo "  OK"
    exit 0
fi

# --- Création des dossiers s'ils n'existent pas --- #
if [ ! -d "./src" ]
then
    echo "***** Création du dossier des sources *****"
    mkdir src/
    echo "  OK"
fi
if [ ! -d "./bin" ]
then
    echo "***** Création du dossier de l'executable *****"
    mkdir bin/
    echo "  OK"
fi
if [ ! -d "./doc" ]
then
    echo "***** Création du dossier de la documentation *****"
    mkdir doc/
    echo "  OK"
fi
if [ ! -d "./save" ]
then
    echo "***** Création du dossier de sauvegarde *****"
    mkdir save/
    echo "  OK"
fi

# --- Déplacement des fichiers (s'ils existent) dans le dossier src --- #
if [ `ls *.c 2> /dev/null | wc -l` -gt 0 ] || [ `ls *.h 2> /dev/null | wc -l` -gt 0 ]
then
    echo "***** Importation des sources *****"
    mv ./*.c ./*.h ./src/ 2> /dev/null
    echo "  OK"
fi

# --- Création des fichiers de programmation --- #
if [ "$c" = true ]
then
    cd src/
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
    cd ..
fi

# --- Création du doxyfile et de la documentation --- #
if [ "$d" = true ]
then
    cd src/
    echo "***** Création du fichier de configuration doxygen *****"
    # --- Redirection de la sortie standard lors de la création du doxyfile --- #
    doxygen -g proto1 > /dev/null
    # --- Changement d'option dans le doxyfile afin de supprimer les affichages réalisés par Doxygen --- #
    sed -e s/"QUIET                  = NO"/"QUIET                  = YES"/g proto1 > proto2
    sed -e s/"WARNINGS               = YES"/"WARNINGS               = NO"/g proto2 > Doxyfile
    # --- Changement d'option dans le doxyfile afin de générer la documentation dans le bon fichier --- #
    sed -i s@"OUTPUT_DIRECTORY       ="@"OUTPUT_DIRECTORY       = ../doc/"@g Doxyfile 
    rm proto1 proto2
    echo "  OK"
    echo "***** Génération de la documentation *****"
    # --- Redirection de la sortie erreur standard lors de la génération de la documentation --- #
    doxygen Doxyfile 2> /dev/null
    echo "  OK"
    cd ..
fi

# --- Création du makefile et compilation --- #
if [ "$m" = true ]
then
    # --- Vérification de l'existence du makefile --- #
    if [ ! -f "Makefile" ]
    then
        echo "***** Création du makefile *****"
        touch Makefile
        echo -e "# Fichier Makefile, crée par Thomas Brasdefer <brasdefert@gmail.com>\n# Pré-requis : Il est nécessaire que quatre répertoires (décrits ci-dessous) existent et que les fichiers sources (.c et .h) soient placés dans le répertoire des sources\n# Documentation des cibles : - all : permet la compilation du programme\n#							 - save : permet la copie des fichiers du répertoire des sources dans le répertoire de sauvegarde\n#							 - restore : permet la copie des fichiers du répertoire de sauvegarde dans le répertoire des sources\n#							 - comp : permet la création d'une archive contenant tous les fichiers sources\n#							 - clean : permet de supprimer les fichiers objets\n\n# Adresse du répertoire des fichiers sources\nsrcdir = ./src/\n# Adresse du répertoire des fichiers objets et de l'executable\nbindir = ./bin/\n# Adresse du répertoire de la documentation\ndocdir = ./doc/\n# Adresse du répertoire de sauvegarde des fichiers sources\nsavedir = ./save/\n# Nom de l'archive générée par comp\narchive = $archive\n# Noms des fichiers .c\nSRC = "'$'"(wildcard "'$'"(srcdir)*.c)\n# Noms des fichiers .o\nOBJ = "'$'"(subst "'$'"(srcdir),"'$'"(bindir),"'$'"(SRC:.c=.o))\n# Nom des fichiers .H\nHD = "'$'"(wildcard "'$'"(srcdir)*.h)\n# Adresse et nom de l'executable\nPROG = "'$'"(bindir)exe\nCC = gcc -Wall -g\n\nall : "'$'"(PROG)\n"'$'"(PROG) : "'$'"(OBJ)\n\t@echo 'Compilation de l executable' \n\t"'$'"(CC) "'$'"^ -o "'$'"@ -lm\n./bin/%.o : ./src/%.c\n\t@echo 'Compilation des fichiers objets'\n\t"'$'"(CC) -c "'$'"^ -o "'$'"@ -lm\n.PHONY : save restore clean\nsave :\n\t@echo 'Sauvegarde des fichiers sources'\n\tcp "'$'"(SRC) "'$'"(HD) "'$'"(savedir)\nrestore :\n\t@echo 'Restoration des fichiers sources'\n\tcp "'$'"(savedir)*.c "'$'"(savedir)*.h "'$'"(srcdir)\ncomp :\n\t@echo 'Création de l archive'\n\tmkdir "'$'"(archive)\n\tcp "'$'"(srcdir)* "'$'"(archive)/\n\ttar -cv "'$'"(archive)/ -f "'$'"(archive).tgz\n\trm -r "'$'"(archive)/\nclean :\n\t@echo 'Les précédents fichiers objets ont bien été effacé' \n\trm -f "'$'"(OBJ)" > Makefile   
        echo "  OK"
    else
        echo "/!\ Un fichier makefile existe déjà"
    fi
fi

# --- Execution, avec ou sans argument --- #
if [ "$e" = true ]
then
    if [ ! -f "Makefile" ]
    then
        echo "/!\ Erreur. Veuillez d'abord créer un makefile avant execution du programme"
        exit 1
    fi
    # --- Compilation --- #
    echo "***** Execution du makefile *****"
    make
    # --- Nettoyage du dossier bin des fichiers objets --- #
    make clean
    echo "  OK"
    cd bin/
    # --- Récupération du nom de l'executable --- #
    exe=`ls`
    echo "***** Execution du programme *****"
    ./$exe $strArg
fi
exit 0

