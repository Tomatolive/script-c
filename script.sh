#!/bin/bash
clear

##########################################################################
## Programme : script.sh                                                ##
## But       : Création des fichiers de programmation                   ##
##             Création de la documentation Doxygen                     ##
##             Création d'un makefile et compilation (CMake ou non)     ##
##			   Débogage													##
##             Exécution de programme (avec ou sans arguments)          ##
##             Création d'un readme pour le script                      ##
##             Affichage d'aide                                         ##
## Création  : 09/10/2023                                               ##
## Version   : 7.0 du 04/11/2023                                        ##
## Auteur    : Thomas Brasdefer <brasdefert@gmail.com>                  ##
##########################################################################

# --- Déclaration et initialisation (valeur par défaut) des variables associées aux arguments --- #
c=false
d=false
db=false
e=false
h=false
he=false
m=false
# --- Déclaration et initialisation (valeur par défaut) des options --- #
main=`grep ^@main $0 |  sed 's/@main=*//'` # Variable représentant le nom du fichier principal
fctc=`grep ^@fctc $0 |  sed 's/@fctc=*//'` # Variable représentant le nom du fichier de corps des fonctions
fcth=`grep ^@fcth $0 |  sed 's/@fcth=*//'` # Variable représentant le nom du fichier d'entetes des fonctions
exe=`grep ^@executable $0 |  sed 's/@executable=*//'` # Variable représentant le nom de l'exécutable
archive=`grep ^@archive $0 |  sed 's/@archive=*//'` # Variable représantant le nom de l'archive qui pourra être créée grâce au makefile sans CMake
makefile=`grep ^@makefile $0 |  sed 's/@makefile=*//'` # Variable déterminant la création du makefile avec ou sans cmake
d_gdb=`grep ^@d_gdb $0 |  sed 's/@d_gdb=*//'` # Variable déterminant l'utilisation de gdb
d_valgrind=`grep ^@d_valgrind $0 |  sed 's/@d_valgrind=*//'` # Variable déterminant l'utilisation de valgrind
# --- Déclaration et initialisation (valeur par défaut) des variables permettant la récupération et l'utilisation d'argument pour l'exécution du programme C --- #
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
    fi
    if [ "$i" = "-e" ] || [ "$i" = "-db" ]
    then
        if [ "$i" = "-e" ]
        then
        	e=true
		elif [ "$i" = "-db" ]
		then
			db=true
		fi
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
    echo "Le script permet la génération des fichiers sources, la génération de la documentation doxygen, la création d'un makefile (avec ou sans CMake), la compilation, le débogage et l'exécution (avec ou sans arguments) du programme."
    echo "Le script créera, s'ils n'existent pas, un répertoire pour les fichiers sources (src), un répertoire pour l'exécutable (bin), un répertoire pour la documentation doxygen (doc) et un dossier de sauvegarde des fichiers sources (save)."
    echo "Il est impératif que les fichiers sources (fichiers de programmation), s'ils existent avant le lancement du script, soit placés dans le même répertoire que le script."
    echo "Après la première utilisation du script, placez les fichiers sources soit dans le répertoire du script, soit dans le répertoire src."
	echo "Ces programmes sont nécessaires pour le bon fonctionnement du script : cmake, doxygen, gcc, gdb, make et valgrind."
    echo ""
    echo "Le script est capable de générer deux Makefile différents : un Makefile manuel et un Makefile généré par CMake."
    echo "Ici, c'est le Makefile manuel qui nous intéresse. Voici un petit résumé des cibles du Makefile :"
    echo "-> all : permet la compilation du programme. Commande : make|make all"
    echo "-> save : permet la copie des fichiers du répertoire des sources src dans le répertoire de sauvegarde save. Commande : make save"
    echo "-> restore : permet la copie des fichiers du répertoire de sauvegarde save dans le répertoire des sources src. Commande : make restore"
    echo "-> comp : permet la création d'une archive contenant tous les fichiers sources. Commande : make comp"
    echo "-> clean : permet de supprimer les fichiers objets. Commande : make clean"
    echo ""
    echo "Options :"
    echo "Les options sont des paramètres directement modifiables par l'utilisateur dans le code du script. Ils se trouvent à la fin du fichier et peuvent prendre différentes valeurs :"
    echo "-> @main : représente le nom du fichier principal. Valeur : quelconque"
    echo "-> @fctc : représente le nom du fichier de corps des fonctions. Valeur : quelconque"
    echo "-> @fcth : représente le nom du fichier d'entetes des fonctions. Valeur : quelconque"
    echo "-> @executable : représente le nom de l'exécutable. Valeur : quelconque"
    echo "-> @archive : représente le nom de l'archive créée par le makefile SANS CMake. Valeur : quelconque"
    echo "-> @makefile : représente la création du makefile SANS CMake. Valeur : true|false"
    echo "-> @d_gdb : représente le débogage avec gdb. Valeur : true|false"
    echo "-> @d_valgrind : représente le débogage avec valgrind. Valeur : true|false"
    echo ""
    echo "Arguments (l'ordre des arguments n'a aucune importance, cependant les tirets sont obligatoires) : "
    echo "-c : cet argument permet la création des fichiers de programmation, en utilisant les noms de fichiers des options @main, @fctc et @fcth"
    echo "-d : cet argument permet la création d'un fichier de config doxygen ainsi que la génération de la documentation"
	echo "-db : cet argument permet le débogage du programme. Le script lancera valgrind et gdb pour déboguer le programme en fonction de la valeur des options @d_gdb et @d_valgrind"
    echo "-e : cet argument permet la compilation puis l'exécution du programme (avec ou sans arguments). Attention, il faut déjà avoir généré un makefile pour pouvoir utiliser cet argument"
    echo "-h : cet argument affiche la présente documentation"
    echo "-he : cet argument exporte dans un fichier README la présente documentation"
    echo "-m : cet argument permet la création d'un makefile. En fonction de la valeur de @makefile, le makefile sera soit crée manuellement, soit avec Cmake"
    echo "Appeler le script sans argument résultera dans 1) la création des différents répertoires (s'ils n'existent pas) 2) l'importation des fichiers sources du répertoire courant dans le répertoire src. NB : le script exécutera ces actions même s'il est appelé avec des arguments."
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
    echo -e "Le script permet la génération des fichiers sources, la génération de la documentation doxygen, la création d'un makefile (avec ou sans CMake), la compilation, le débogage et l'exécution (avec ou sans arguments) du programme.\nLe script créera, s'ils n'existent pas, un répertoire pour les fichiers sources (src), un répertoire pour l'exécutable (bin), un répertoire pour la documentation doxygen (doc) et un dossier de sauvegarde des fichiers sources (save).\nIl est impératif que les fichiers sources (fichiers de programmation), s'ils existent avant le lancement du script, soit placés dans le même répertoire que le script.\nAprès la première utilisation du script, placez les fichiers sources soit dans le répertoire du script, soit dans le répertoire src.\nCes programmes sont nécessaires pour le bon fonctionnement du script : cmake, doxygen, gcc, gdb, make et valgrind.\n\nLe script est capable de générer deux Makefile différents : un Makefile manuel et un Makefile généré par CMake.\nIci, c'est le Makefile manuel qui nous intéresse. Voici un petit résumé des cibles du Makefile :\n-> all : permet la compilation du programme. Commande : make|make all\n-> save : permet la copie des fichiers du répertoire des sources src dans le répertoire de sauvegarde save. Commande : make save\n-> restore : permet la copie des fichiers du répertoire de sauvegarde save dans le répertoire des sources src. Commande : make restore\n-> comp : permet la création d'une archive contenant tous les fichiers sources. Commande : make comp\n-> clean : permet de supprimer les fichiers objets. Commande : make clean\n\nOptions :\nLes options sont des paramètres directement modifiables par l'utilisateur dans le code du script. Ils se trouvent à la fin du fichier et peuvent prendre différentes valeurs :\n-> @main : représente le nom du fichier principal. Valeur : quelconque\n-> @fctc : représente le nom du fichier de corps des fonctions. Valeur : quelconque\n-> @fcth : représente le nom du fichier d'entetes des fonctions. Valeur : quelconque\n-> @executable : représente le nom de l'exécutable. Valeur : quelconque\n-> @archive : représente le nom de l'archive créée par le makefile SANS CMake. Valeur : quelconque\n-> @makefile : représente la création du makefile SANS CMake. Valeur : true|false\n-> @d_gdb : représente le débogage avec gdb. Valeur : true|false\n-> @d_valgrind : représente le débogage avec valgrind. Valeur : true|false\n\nArguments (l'ordre des arguments n'a aucune importance, cependant les tirets sont obligatoires) :\n-c : cet argument permet la création des fichiers de programmation, en utilisant les noms de fichiers des options @main, @fctc et @fcth\n-d : cet argument permet la création d'un fichier de config doxygen ainsi que la génération de la documentation\n-db : cet argument permet le débogage du programme. Le script lancera valgrind et gdb pour déboguer le programme en fonction de la valeur des options @d_gdb et @d_valgrind\n-e : cet argument permet la compilation puis l'exécution du programme (avec ou sans arguments). Attention, il faut déjà avoir généré un makefile pour pouvoir utiliser cet argument\n-h : cet argument affiche la présente documentation\n-he : cet argument exporte dans un fichier README la présente documentation\n-m : cet argument permet la création d'un makefile. En fonction de la valeur de @makefile, le makefile sera soit crée manuellement, soit avec Cmake\nAppeler le script sans argument résultera dans 1) la création des différents répertoires (s'ils n'existent pas) 2) l'importation des fichiers sources du répertoire courant dans le répertoire src. NB : le script exécutera ces actions même s'il est appelé avec des arguments.\n\nExemples d'utilisation :\n./script.sh -c         : Création des trois fichiers main.c fonctions.c et fonctions.h\n./script.sh -m -d -e   : Création du makefile, génération de la documentation doxygen, compilation puis exécution du programme\n./script.sh -he        : Création de README.txt	" > README.txt
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
    echo "***** Création du dossier de l'exécutable *****"
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
    if [ ! -f Doxyfile ]
    then
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
    fi
    echo "***** Génération de la documentation *****"
    # --- Redirection de la sortie erreur standard lors de la génération de la documentation --- #
    doxygen Doxyfile 2> /dev/null
    echo "  OK"
    cd ..
fi

# --- Création du makefile et compilation --- #
if [ "$m" = true ]
then
    if [ "$makefile" = true ]
    then
        # --- Vérification de l'existence du makefile --- #
        if [ ! -f "Makefile" ]
        then
            echo "***** Création du makefile *****"
            touch Makefile
            echo -e "# Fichier Makefile, crée par Thomas Brasdefer <brasdefert@gmail.com>\n# Pré-requis : Il est nécessaire que quatre répertoires (décrits ci-dessous) existent et que les fichiers sources (.c et .h) soient placés dans le répertoire des sources\n# Documentation des cibles : - all : permet la compilation du programme\n#							 - save : permet la copie des fichiers du répertoire des sources dans le répertoire de sauvegarde\n#							 - restore : permet la copie des fichiers du répertoire de sauvegarde dans le répertoire des sources\n#							 - comp : permet la création d'une archive contenant tous les fichiers sources\n#							 - clean : permet de supprimer les fichiers objets\n\n# Adresse du répertoire des fichiers sources\nsrcdir ?= ./src/\n# Adresse du répertoire des fichiers objets et de l'exécutable\nbindir ?= ./bin/\n# Adresse du répertoire de la documentation\ndocdir ?= ./doc/\n# Adresse du répertoire de sauvegarde des fichiers sources\nsavedir ?= ./save/\n# Nom de l'archive générée par comp\narchive ?= $archive\n# Noms des fichiers .c\nSRC ?= "'$'"(wildcard "'$'"(srcdir)*.c)\n# Noms des fichiers .o\nOBJ ?= "'$'"(subst "'$'"(srcdir),"'$'"(bindir),"'$'"(SRC:.c=.o))\n# Nom des fichiers .H\nHD ?= "'$'"(wildcard "'$'"(srcdir)*.h)\n# Adresse et nom de l'exécutable\nPROG ?= "'$'"(bindir)$exe\n# Choix du compilateur\nCC ?= gcc\n# Arguments pour le débogage\nDEB ?= -g -O0\n\nall : "'$'"(PROG)\n"'$'"(PROG) : "'$'"(OBJ)\n\t@echo 'Compilation de l exécutable' \n\t"'$'"(CC) "'$'"^ -o "'$'"@\n./bin/%.o : ./src/%.c\n\t@echo 'Compilation des fichiers objets'\n\t"'$'"(CC) "'$'"(DEB) -Wall -c "'$'"^ -o "'$'"@\n.PHONY : save restore clean\nsave :\n\t@echo 'Sauvegarde des fichiers sources'\n\tcp "'$'"(SRC) "'$'"(HD) "'$'"(savedir)\nrestore :\n\t@echo 'Restoration des fichiers sources'\n\tcp "'$'"(savedir)*.c "'$'"(savedir)*.h "'$'"(srcdir)\ncomp :\n\t@echo 'Création de l archive'\n\tmkdir "'$'"(archive)\n\tcp "'$'"(srcdir)* "'$'"(archive)/\n\ttar -cv "'$'"(archive)/ -f "'$'"(archive).tgz\n\trm -r "'$'"(archive)/\nclean :\n\t@echo 'Les précédents fichiers objets ont bien été effacé' \n\trm -f "'$'"(OBJ)" > Makefile   
            echo "  OK"
        else
            echo "/!\ Un fichier makefile existe déjà"
        fi
    else
        echo "***** Lancement de CMake *****"
        touch CMakeLists.txt
        echo -e "# Version minimum requise de CMake\ncmake_minimum_required(VERSION 3.0)\n\n# Étiquetage du projet\nproject(projet)\n\n# Variables des fichiers à compiler\nset(SRC\n\t./src/main.c\n\t./src/fonctions.c\n\t)\nset(HD\n\t./src/fonctions.h\n\t)\n\n# Exécutable "exe" compilé à partir des variables ci-dessus\n\nadd_executable(exe "'$'"{SRC} "'$'"{HD})\n\n# On installe l'exécutable dans le dossier bin\ninstall (TARGETS exe DESTINATION bin)" > CMakeLists.txt
        cmake .
        echo "  OK"
    fi
fi

# --- Exécution ou débogage, avec ou sans argument --- #
if [ "$e" = true ] || [ "$db" = true ]
then
    if [ ! -f "Makefile" ]
    then
        echo "/!\ Erreur. Veuillez d'abord créer un makefile avant exécution ou débogage du programme"
        exit 1
    fi
    # --- Compilation --- #
    echo "***** Exécution du makefile *****"
    make
    # --- Nettoyage du dossier bin des fichiers objets --- #
    make clean
    echo "  OK"
	# --- Débogage --- #
	if [ "$db" = true ]
	then
        if [ "$d_valgrind" = true ]
        then
            echo "***** Lancement de Valgrind *****"
		    valgrind --leak-check=full --show-leak-kinds=all -s ./bin/$exe $strArg
		    echo "	OK"
        fi
        if [ "$d_gdb" = true ]
        then 
            echo "***** Lancement de GDB *****"
            gdb ./bin/$exe
            echo "	OK"
        fi
	# -- Exécution --- #
	elif [ "$e" = true ]
	then
    	echo "***** Exécution du programme *****"
    	./bin/$exe $strArg
	fi
fi
exit 0

@OPTIONS
@main=main
@fctc=fonctions
@fcth=fonctions
@executable=exe
@archive=Programme
@makefile=true
@d_gdb=true
@d_valgrind=true
