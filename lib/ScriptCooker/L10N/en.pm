#    This file is part of ScriptCooker.
#
#    ScriptCooker is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    ScriptCooker is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with ScriptCooker.  If not, see <http://www.gnu.org/licenses/>.
#
package ScriptCooker::L10N::en;
use base qw(ScriptCooker::L10N);

%Lexicon = (

    #Permet le message d'erreur en cas de traduction manquante
    'Pas de traduction trouv�e pour : ' => 'No translation found for : ',


    #Common strings
    "Procedure : %s, Type : %s, Severite : %d\nMessage : %s" => "Procedure : %s, Type : %s, Severity : %d\nMessage : %s",
    'Usage: [_1]'                           => 'Usage: [_1]',
    'Demarrage du programme (ARG=[_1])'     => 'Program startup (ARG=[_1])',
    'Sortie du programme avec le code [_1]' => 'Program exit with code [_1]',
    'Le nombre d\'arguments est incorrect'   => 'Incorrect number of arguments',
    'Terminaison du programme'              => 'Command termination',


    # 'Au moins un trigger de [_1] ([_2]) a renvoy� une erreur'              => '',
    # 'Aucune ligne trouvee a remplacer'                                     => '',
    # 'Aucune ligne trouvee a supprimer'                                     => '',
    # 'Aucune valeur a inserer n\'est specifiee'                             => '',
    # 'Bonjour [_1] !'                                                       => '',
    # 'Cr�ation d\'un objet Define'                                          => '',
    # 'Debut du traitement de [_1]'                                          => '',
    # 'Declenchement du trigger : [_1]'                                      => '',
    # 'Erreur interne : [_1] doit etre un type de colonne strict'            => '',
    # 'Erreur lors du calcul des conditions'                                 => '',
    # 'Erreur � l\'execution du trigger [_1]'                                => '',
    # 'Exception pendant la generation de la fonction de tri : [_1]'         => '',
    # 'Fin anormale du processus numero [_1] de nom [_2]'                    => '',
    # 'Fin en warning du processus numero [_1] de nom [_2]'                  => '',
    # 'Fin normale du processus numero [_1] de nom [_2]'                     => '',
    # 'Il n\'y a pas assez de valeurs par rapport au nombre de colonnes'     => '',
    # 'Il y a trop de valeurs par rapport au nombre de colonnes'             => '',
    # 'Impossible d\'ecrire dans la table [_1] : [_2]'                       => '',
    # 'Impossible d\'obtenir la source de donn�e de [_1]'                    => '',
    # 'Impossible d\'ouvrir le fichier [_1] : [_2]'                          => '',
    # 'Impossible d\'ouvrir le fichier [_1] en lecture !'                    => '',
    # 'Impossible d\'ouvrir le fichier [_1] en lecture : [_2]'               => '',
    # 'Impossible d\'ouvrir le fichier [_1].'                                => '',
    # 'Impossible de charger la librairie d\'acces au TYPE : [_1]'           => '',
    # 'Impossible de creer l\'objet [_1]'                                    => '',
    # 'Impossible de fermer le fichier [_1] : [_2]'                          => '',
    # 'Impossible de lire le fichier [_1] : [_2]'                            => '',
    # 'Impossible de poser un verrou sur [_1] : [_2]'                        => '',
    # 'Impossible de reconnaitre le format de PreProcessor : [_1]'           => '',
    # 'Impossible de remplacer une ligne sur une table sans clef'            => '',
    # 'Impossible de retrouver le type de [_1]'                              => '',
    # 'Impossible de se deplacer dans le fichier [_1] : [_2]'                => '',
    # 'Impossible de se positioner au debut du fichier [_1] : [_2]'          => '',
    # 'Impossible de se positionner au debut de la table [_1] : [_2]'        => '',
    # 'Impossible de trouver la table [_1]'                                  => '',
    # 'Impossible de trouver la taille du champs [_1]'                       => '',
    # 'Impossible de trouver la variable des librairies dynamique pour l\'OS [_1]' => '',
    # 'Impossible de trouver le fichier [_1]'                                => '',
    # 'Impossible de trouver ou d\'ouvrir le fichier de definition [_1]'     => '',
    # 'Impossible de vider le fichier [_1] : [_2]'                           => '',
    # 'L\'argument [_1] n\'est pas valide'                                   => '',
    # 'L\'evaluation de <[_1]> est incorrecte !'                             => '',
    # 'L\'operateur de selection est incorrect !'                            => '',
    # 'La chaine de definition [_1] n\'est pas valide ou est absente'        => '',
    # 'La chaine de definition n\'est pas valide ou est absente'             => '',
    # 'La cle de reference de la contrainte sur [_1] est incorrecte.'        => '',
    # 'La colonne [_1] (Table [_2]) n\'existe pas'                           => '',
    # 'La colonne [_1] doit absolument contenir une valeur.'                 => '',
    # 'La colonne [_1] n\'existe pas'                                        => '',
    # 'La colonne [_1] toto n\'existe pas'                                   => '',
    # 'La commande [_1] a retourner le code retour : [_2]'                   => '',
    # 'La commande [_1] est obsolete'                                        => '',
    # 'La contrainte [_1] est invalide !'                                    => '',
    # 'La definition [_1] a trop de valeur'                                  => '',
    # 'La definition [_1] est mal form�e : [_2]'                             => '',
    # 'La definition [_1] est present plusieurs fois dans [_2]'              => '',
    # 'La definition [_1] n\'a pas assez de valeur'                          => '',
    # 'La definition suivante est incorrecte: [_1]'                          => '',
    # 'La fonction [_1] est obsolete'                                        => '',
    # 'La table [_1] est une table virtuelle'                                => '',
    # 'La table [_1] existe sous plusieurs cles etrangeres.'                 => '',
    # 'La valeur d\'une cle primaire ne peut-etre nulle.'                    => '',
    # 'La valeur donnee pour la colonne [_1] n\'est pas correcte.'           => '',
    # 'Le delai maximum d\'attente de deverouillage a ete atteint'           => '',
    # 'Le fichier de la table [_1] est d�j� ouvert'                          => '',
    # 'Le fichier de la table [_1] n\'est pas ouvert'                        => '',
    # 'Le nom de fichier [_1] n\'est pas valide'                             => '',
    # 'Le separateur implicite implicite \',\' ne sera plus pris en charge dans la prochaine version des I-TOOLS : [_1] ([_2])' => '',
    # 'Les champs COMMAND et FILE sont mutuellement exclusifs'               => '',
    # 'Les variables suivantes ne sont pas des d�finitions valides : [_1]'   => '',
    # 'Non unicite de la clef de la ligne a inserer'                         => '',
    # 'Numero d\'erreur [_1] non reference.'                                 => '',
    # 'Operateur [_1] non reconnu'                                           => '',
    # 'Option ou suffixe de recherche invalide !'                            => '',
    # 'Ouverture de la table [_1] de type [_2]'                              => '',
    # 'Ouverture du fichier [_1] (table [_2])'                               => '',
    # 'Probleme a l\'execution de la commande [_1] : [_2]'                   => '',
    # 'Probleme de lecture de STDIN'                                         => '',
    # 'Probl�me lors de l\'execution de [_1]'                                => '',
    # 'Probl�me lors du lancement de la commande [_1]'                       => '',
    # 'Recherche directe du fichier [_1]'                                    => '',
    # 'Recherche du fichier [_1] dans [_2]'                                  => '',
    # 'Recherche du fichier dans un PATH'                                    => '',
    # 'Sortie forcee en erreur'                                              => '',
    # 'Un s�parateur ne peut pas �tre vide'                                  => '',
    # 'Valeur [_1] prise en compte sans le caractere \'%\' !'                => '',
    # 'Variable d\'environnement [_1] manquante ou non exportee !'           => '',
    # '[_1] de traduction'                                                   => '',
    # '[_1] lignes supprim�es'                                               => '',
    # 'c\'est du texte'                                                      => '',
    # 'fichier tab introuvable : [_1]'                                       => '',
    # 'fichier tab ou command manquant pour [_1]'                            => '',
    # 'sortie en warning'                                                    => '',
    # 'test d\'erreur'                                                       => '',
    # 'usage : [_1]'                                                         => '',
);

1;
