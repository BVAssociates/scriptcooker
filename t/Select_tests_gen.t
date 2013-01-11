#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 450;

my $expected_code;
my $expected_string;
my $expected_error;
my $return_code;
my $return_string;
my $return_error;

my $home;

use ScriptCooker::Utils;
source_profile('t/sample/profile.RT.minimal');

##################
# Select
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Select [-h] [-s] [-m Sep] [-r Nlines] [Columns] 
 		  FROM <Table|-> [WHERE <Condition>] [ORDER_BY <Columns>]
Procedure : Select, Type : Erreur, Severite : 202
Message : Ligne de commande incorrecte

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select'."> errstd") or diag($return_error);


##################
# Select from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages'."> errstd") or diag($return_error);


##################
# Select '*' from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select \'*\' from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select \'*\' from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select \'*\' from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select \'*\' from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select \'*\' from error_messages'."> errstd") or diag($return_error);


##################
# Select FROM error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select FROM error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select FROM error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select FROM error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select FROM error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select FROM error_messages'."> errstd") or diag($return_error);


##################
# Select From error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select From error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select From error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select From error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select From error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select From error_messages'."> errstd") or diag($return_error);


##################
# Select -s from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages'."> errstd") or diag($return_error);


##################
# Select -r0 from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r0 from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r0 from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r0 from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r0 from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r0 from error_messages'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1;test sans quote

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages'."> errstd") or diag($return_error);


##################
# Select from error_messages_sort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
Check;65;Non unicite de la clef
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PATH;120;PATH=$PATH
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_sort'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_sort'."> errstd") or diag($return_error);


##################
# Select Error from error_messages_sort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Error'@@ROW='$Error'@@SIZE='4n'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Error'
65
346
346
8
97
0001
0001
0001
0001
0001
0002
0003
0004
0365
176
8
68
97
120
137
138
139
0004
506
004
0001
0002
128
132
182
182
001
002
003
127
128
68
8
68
97
1
2
3
4
0001
0002
0003
0004
0001
0002
0003
0004
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95
96
97
98
99
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
125
126
127
128
129
130
131
132
133
134
148
149
150
151
152
301
302
303
304
305
306
308
309
310
311
312
313
314
315
316
317
318
319
320
321
401
402
403
404
405
406
408
409
410
411
412
413
414
415
416
417
420
501
502
503
504
505
506
507
508
509
510
511
512
513
514
515
517
518
519
520

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Error from error_messages_sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Error from error_messages_sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Error from error_messages_sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Error from error_messages_sort'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Error from error_messages_sort'."> errstd") or diag($return_error);


##################
# Select Error,Function from error_messages_sort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Error;Function'@@ROW='$Error;$Function'@@SIZE='4n;20s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
65;Check
346;FT_LISTLST_SQLNET
346;FT_LIST_TNSNAME
8;Insert
97;Insert
0001;ME_CREATE_SYNORA
0001;ME_DROP_SYNORA
0001;ME_LOAD_TABORA
0001;ME_RESTORE_TABORA
0001;ME_SECURE_TABORA
0002;ME_SECURE_TABORA
0003;ME_SECURE_TABORA
0004;ME_SECURE_TABORA
0365;ME_SECURE_TABORA
176;ME_TRUNC_TABORA
8;Modify
68;Modify
97;Modify
120;PATH
137;PC_BACK_TBSORA
138;PC_BACK_TBSORA
139;PC_BACK_TBSORA
0004;PC_CHGSTAT_SERV
506;PC_ENV_SQLNET
004;PC_INITF_SQLNET
0001;PC_LISTBACK_ARCHORA
0002;PC_LISTBACK_ARCHORA
128;PC_LISTBACK_CTRLORA
132;PC_LISTBACK_CTRLORA
182;PC_LISTID_INSORA
182;PC_LISTID_SQLNET
001;PC_STAT_TNSNAME
002;PC_STAT_TNSNAME
003;PC_STAT_TNSNAME
127;PC_SWITCH_LOGORA
128;PC_SWITCH_LOGORA
68;Remove
8;Replace
68;Replace
97;Replace
1;TEST
2;TEST
3;TEST
4;TEST
0001;V1_alim_30_motcle
0002;V1_alim_30_motcle
0003;V1_alim_30_motcle
0004;V1_alim_30_motcle
0001;V1_alim_40_meth
0002;V1_alim_40_meth
0003;V1_alim_40_meth
0004;V1_alim_40_meth
1;generic
2;generic
3;generic
4;generic
5;generic
6;generic
7;generic
8;generic
9;generic
10;generic
11;generic
12;generic
13;generic
14;generic
15;generic
16;generic
17;generic
18;generic
19;generic
20;generic
21;generic
22;generic
23;generic
24;generic
25;generic
26;generic
27;generic
28;generic
29;generic
30;generic
31;generic
32;generic
33;generic
34;generic
35;generic
36;generic
37;generic
38;generic
39;generic
40;generic
41;generic
42;generic
43;generic
44;generic
45;generic
46;generic
47;generic
48;generic
49;generic
50;generic
51;generic
52;generic
53;generic
54;generic
55;generic
56;generic
57;generic
58;generic
59;generic
60;generic
61;generic
62;generic
63;generic
64;generic
65;generic
66;generic
67;generic
68;generic
69;generic
70;generic
71;generic
72;generic
73;generic
74;generic
75;generic
76;generic
77;generic
78;generic
79;generic
80;generic
81;generic
82;generic
83;generic
84;generic
85;generic
86;generic
87;generic
88;generic
89;generic
90;generic
91;generic
92;generic
93;generic
94;generic
95;generic
96;generic
97;generic
98;generic
99;generic
100;generic
101;generic
102;generic
103;generic
104;generic
105;generic
106;generic
107;generic
108;generic
109;generic
110;generic
111;generic
112;generic
113;generic
114;generic
115;generic
116;generic
117;generic
118;generic
119;generic
120;generic
121;generic
122;generic
123;generic
124;generic
125;generic
126;generic
127;generic
128;generic
129;generic
130;generic
131;generic
132;generic
133;generic
134;generic
148;generic
149;generic
150;generic
151;generic
152;generic
301;generic
302;generic
303;generic
304;generic
305;generic
306;generic
308;generic
309;generic
310;generic
311;generic
312;generic
313;generic
314;generic
315;generic
316;generic
317;generic
318;generic
319;generic
320;generic
321;generic
401;generic
402;generic
403;generic
404;generic
405;generic
406;generic
408;generic
409;generic
410;generic
411;generic
412;generic
413;generic
414;generic
415;generic
416;generic
417;generic
420;generic
501;generic
502;generic
503;generic
504;generic
505;generic
506;generic
507;generic
508;generic
509;generic
510;generic
511;generic
512;generic
513;generic
514;generic
515;generic
517;generic
518;generic
519;generic
520;generic

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Error,Function from error_messages_sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Error,Function from error_messages_sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Error,Function from error_messages_sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Error,Function from error_messages_sort'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Error,Function from error_messages_sort'."> errstd") or diag($return_error);


##################
# Select Message,Function from error_messages_sort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Message;Function'@@ROW='$Message;$Function'@@SIZE='80s;20s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function'
Non unicite de la clef;Check
Aucun Listener convenablement declare dans %s;FT_LISTLST_SQLNET
Aucun Service TNS convenablement declare dans %s;FT_LIST_TNSNAME
La condition de selection de cle n'est pas valide;Insert
Aucune valeur a inserer n'est specifiee;Insert
Probleme a la creation du Synonyme %s;ME_CREATE_SYNORA
Probleme a la suppression du Synonyme %s;ME_DROP_SYNORA
Echec du Load sqlldr de %s;ME_LOAD_TABORA
Erreur lors de la restauration de la table %s;ME_RESTORE_TABORA
Impossible de recuperer la taille du tablespace %s;ME_SECURE_TABORA
Impossible de recuperer la taille de la table %s;ME_SECURE_TABORA
Erreur lors de la securisation de la table %s;ME_SECURE_TABORA
Impossible de recuperer la taille de la sauvegarde;ME_SECURE_TABORA
Probleme lors de la mise a jour de la table %s;ME_SECURE_TABORA
Probleme de truncate sur %s (Contrainte type P referencee) ;ME_TRUNC_TABORA
La condition de selection de la cle n est pas valide;Modify
Aucune ligne trouvee a modifier;Modify
Aucune valeur a modifier n'est specifiee;Modify
PATH=$PATH;PATH
Probleme pour mettre le TBSPACE %s en BEGIN BACKUP;PC_BACK_TBSORA
Probleme pour mettre le TBSPACE %s en END BACKUP;PC_BACK_TBSORA
Probleme pour manipuler le TBSPACE %s;PC_BACK_TBSORA
Aucune instance n'est associee a l'application %s;PC_CHGSTAT_SERV
Impossible de trouver l'environnement de l'instance Sqlnet %s;PC_ENV_SQLNET
La configuration SqlNet %s de %s est introuvable;PC_INITF_SQLNET
Il manque la sequence d'archives %s pour la base %s;PC_LISTBACK_ARCHORA
Il n'existe pas d'archives commençant a la sequence %s.;PC_LISTBACK_ARCHORA
Impossible d'interroger les logfiles de %s;PC_LISTBACK_CTRLORA
Impossible d'interroger les controlfiles de %s;PC_LISTBACK_CTRLORA
Impossible de trouver la Base du user %s;PC_LISTID_INSORA
Impossible de trouver le Noyau SqlNet du user %s;PC_LISTID_SQLNET
Le service TNS %s n'est pas decrit;PC_STAT_TNSNAME
Il n'y a pas de listener demarre servant le service TNS %s;PC_STAT_TNSNAME
Erreur de configuration de l'adresse du service TNS %s;PC_STAT_TNSNAME
Probleme lors du switch des logfiles de %s;PC_SWITCH_LOGORA
Impossible d'interroger les logfiles pour %s;PC_SWITCH_LOGORA
Aucune ligne trouvee a supprimer;Remove
La condition de selection de la cle n'est pas valide;Replace
Aucune ligne trouvee a remplacer;Replace
Aucune valeur a remplacer n'est specifiee;Replace
test sans quote;TEST
test avec ' des ' quote;TEST
test avec " des " double quote;TEST
test avec \" des \' quote echappees;TEST
ECHEC ce l'Insert Arg de %s dans t_me_alma;V1_alim_30_motcle
Argument de la methode %s non declare dans me_alma;V1_alim_30_motcle
Rang de l'argument de la methode %s incoherent;V1_alim_30_motcle
ECHEC de l'insertion du mot cle %s dans t_me_ma;V1_alim_30_motcle
Le mot cle d'action %s n'existe pas;V1_alim_40_meth
L'Insertion de la methode physique %s a echoue;V1_alim_40_meth
L'Insertion de la variable interne %s a echoue;V1_alim_40_meth
L'Insertion du type physique %s a echoue;V1_alim_40_meth
Impossible de trouver l'executable %s;generic
Impossible de trouver la table %s;generic
Impossible de trouver ou d'ouvrir le fichier de definition %s;generic
Impossible de trouver le fichier %s;generic
Le fichier de definition %s n'est pas valide;generic
La table %s est une table virtuelle;generic
La colonne %s n'existe pas;generic
La condition de selection n'est pas valide;generic
La chaine de definition %s n'est pas valide ou est absente;generic
Impossible d'ouvrir le fichier %s;generic
Impossible d'ecrire dans le fichier %s;generic
Impossible de supprimer le fichier %s;generic
Impossible de changer les droits sur le fichier %s;generic
Impossible de renommer/deplacer le fichier %s en %s;generic
Impossible de copier le fichier %s;generic
Erreur lors d'une ecriture dans le fichier %s;generic
La commande <%s> a echoue;generic
La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !;generic
L'evaluation de <%s> est incorrecte !;generic
L'option %s n'est pas valide;generic
Le nombre d'arguments est incorrect;generic
L'argument %s n'est pas valide;generic
Utilisation incorrecte de l'option -h;generic
Ligne de commande incorrecte;generic
Erreur lors d'une allocation de memoire %s;generic
Erreur lors d'une re-allocation de memoire %s;generic
Erreur lors du chargement de la librairie %s !;generic
Impossible de retrouver le symbole %s en librairie !;generic
Erreur lors de la fermeture de la librairie %s !;generic
Votre licence d'utilisation %s a expire !;generic
Le Hostid de la machine n'est pas valide !;generic
La licence n'est pas valide !;generic
Il n'y a pas de licence valide pour ce produit !;generic
Le nombre de clients pour ce produit est depasse !;generic
Le nom de fichier %s n'est pas valide;generic
Le fichier %s est verouille;generic
Impossible de poser un verrou sur le fichier %s;generic
Le delai maximum d'attente de deverouillage a ete atteint;generic
Le fichier %s n'est pas verouille;generic
Impossible de retirer le verrou du fichier %s;generic
Le nombre maximal de selections simultanees est depasse;generic
Le Handle d'une requete n'est pas valide;generic
Le nombre maximal de conditions est depasse;generic
Impossible de retrouver la librairie %s !;generic
Un Handle n'est pas valide;generic
Le nombre maximal de fichiers ouverts est depasse;generic
Le nombre maximal %s d'allocations de memoire est depasse;generic
Impossible de retrouver le fichier de menu %s;generic
Impossible de retrouver le dictionnaire graphique %s;generic
Erreur lors de l'execution de la fonction de log;generic
Erreur de type '%s' lors de la deconnexion Oracle !;generic
Impossible d'ecrire dans le fichier log %s;generic
Impossible de determiner le nom du traitement;generic
Le numero d'erreur est manquant;generic
Le message d'information est manquant;generic
Le numero d'erreur %s n'a pas de message associe;generic
Le numero d'erreur %s n'est pas correct;generic
Le type de message de log n'est pas correct;generic
Le nom de table %s n'est pas valide;generic
La colonne %s doit absolument contenir une valeur;generic
Il n'y a pas assez de valeurs par rapport au nombre de colonnes;generic
Il y a trop de valeurs par rapport au nombre de colonnes;generic
La valeur donnee pour la colonne %s n'est pas correcte.;generic
Le nom de la table n'est pas specifie;generic
Non unicite de la clef de la ligne a inserer;generic
Le groupe d'utilisateurs %s n'existe pas;generic
Impossible de remplacer une ligne sur une table sans clef;generic
Aucune ligne trouvee;generic
Entete de definition invalide !;generic
Variables d'environnement SEP ou FORMAT absente !;generic
Il n'y a pas de lignes en entree stdin !;generic
Impossible d'ouvrir le fichier %s en ecriture !;generic
Impossible d'ouvrir le fichier %s en lecture !;generic
Impossible d'ouvrir le fichier %s en lecture et ecriture !;generic
Erreur generique Oracle : %s;generic
Erreur de syntaxe dans la requete SQL generee : %s;generic
Une valeur a inserer est trop large pour sa colonne !;generic
Impossible de se connecter a Oracle avec l'utilisateur %s;generic
Impossible de locker la table %s. Ressource deja occupee !;generic
La requete interne SQL s'est terminee en erreur !;generic
Le nouveau separateur n'est pas specifie !;generic
Le nombre maximal de colonnes %s du dictionnaire est depasse !;generic
La colonne %s apparait plusieurs fois dans le dictionnaire !;generic
La source de donnees %s du dictionnaire est invalide !;generic
La table %s ne peut-etre verouillee ou deverouillee !;generic
Vous ne pouvez pas remplacer une cle !;generic
Impossible de creer un nouveau processus %s !;generic
Le nombre maximal de tables %s est depasse;generic
Option ou suffixe de recherche invalide !;generic
Pas de librairie chargee pour acceder a la base de donnees !;generic
Variable d'environnement %s manquante ou non exportee !;generic
Parametre <+ recent que> inferieur au parametre <+ vieux que>.;generic
Le type de la colonne %s est invalide !;generic
Impossible de retrouver le formulaire %s;generic
Impossible de retrouver le panneau de commandes %s.;generic
L'operateur de selection est incorrect !;generic
Aucune valeur donnee;generic
La taille maximale %s d'une ligne est depassee !;generic
Le champ %s est mal decrit dans la table %s;generic
%s;generic
Le parametre %s n'est pas un chiffre;generic
L'utilisateur %s n'existe pas;generic
La cle de reference de la contrainte sur %s est incorrecte.;generic
Erreur lors du delete sur %s;generic
La variable %s n'est pas du bon type;generic
Probleme lors du chargement de l'environnement %s;generic
Environnement %s non accessible;generic
Probleme pour acceder a la table %s;generic
La table %s n'existe pas ou n'est pas accessible;generic
Impossible de retrouver l'objet %s;generic
La table %s existe sous plusieurs schemas;generic
Probleme pour recuperer les contraintes de %s;generic
Erreur lors du disable de contraintes de %s;generic
Erreur lors de l'enable de contraintes de %s;generic
Erreur lors du chargement de la table %s;generic
Des enregistrements ont ete rejetes pour la table %s;generic
La contrainte %s est invalide !;generic
Le nombre maximal %s de cles etrangeres est depasse.;generic
Le nombre maximal %s de contraintes est depasse.;generic
Impossible de creer le fichier %s;generic
La table %s n'est pas une table de reference.;generic
La table %s existe sous plusieurs cles etrangères.;generic
Les droits sur le fichier %s sont incorrects.;generic
Probleme pour recuperer les informations '%s' de la Machine %s.;generic
Le type de la licence est invalide.;generic
L'utilisateur %s n'est pas administrateur du systeme.;generic
Les colonnes %s doivent absolument contenir une valeur.;generic
La table %s ne possede pas de cle primaire.;generic
La valeur d'une cle primaire ne peut-etre nulle.;generic
Options de commande %s incompatibles;generic
Le tri de séléction '%s' est invalide.;generic
Le format de la date '%s' est invalide.;generic
Les eléments % de la date doivent être séparés par un caractère.;generic
La date '%s' ne correspond pas au format %s.;generic
Vous n'avez pas les droits %s.;generic
Probleme d'environnement %s;generic
Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID;generic
Variables inconnues BV_ORAUSER et/ou BV_ORAPASS;generic
L'intance %s est invalide ou non demarrée.;generic
Le module applicatif %s n'est pas ou mal declaré.;generic
L'instance de service %s ne semble pas exister.;generic
Le script fils <%s> a retourne un warning;generic
Le script fils <%s> a retourne une erreur bloquante;generic
Le script fils <%s> a retourne une erreur fatale;generic
Le script fils <%s> a retourne un code d'erreur errone %s;generic
Erreur a l'execution de %s;generic
Le service %s '%s' n'existe pas.;generic
Le service %s '%s' est deja demarre.;generic
Le service %s '%s' est deja arrete.;generic
Le service %s '%s' n'a pas demarre correctement.;generic
Le service %s '%s' ne s'est pas arrete correctement.;generic
Le service %s '%s' n'est pas ou mal declaré.;generic
Le module applicatif %s ne possède aucune instance de service.;generic
La ressource %s '%s' n'est pas ou mal declaré.;generic
Impossible de choisir un type pour le Service %s '%s'.;generic
Impossible de choisir un type de service pour le I-CLES %s.;generic
La table %s n'est pas collectable.;generic
Le type de ressource %s n'est pas ou mal déclaré.;generic
Le Type de Service %s du I-CLES %s n'existe pas.;generic
Le repertoire %s n'existe pas;generic
Impossible de creer le repertoire %s;generic
Impossible d'ecrire dans le repertoire %s;generic
Impossible de lire le contenu du repertoire %s;generic
Le fichier %s n'existe pas ou est vide;generic
Le fichier %s existe deja;generic
Le fichier %s n'est pas au format %s;generic
Erreur lors de l'initialisation du fichier %s;generic
Probleme lors de la restauration/decompression de %s;generic
Probleme lors de la decompression de %s;generic
Probleme lors de la compression de %s;generic
Probleme lors de la securisation/compression de %s;generic
Le Lecteur %s doit etre NO REWIND pour avancer/reculer;generic
Le device %s n'existe pas ou est indisponible;generic
Probleme lors de la creation du lien vers %s;generic
Le lecteur %s est inaccessible;generic
Impossible d'aller sous le répertoire '%s'.;generic
L'instance Oracle %s n'est pas demarree;generic
L'instance Oracle %s n'est pas arretee;generic
%s n'est pas un mode d'arret Oracle valide;generic
%s n'est pas un mode de demarrage Oracle valide;generic
La base Oracle %s existe deja dans /etc/oratab;generic
Impossible de retrouver l'environnement de l'instance Oracle %s;generic
Impossible de retrouver l'init file de la base %s;generic
Le fichier de config de %s n'est pas renseigne dans l'initfile;generic
Les controlfiles de %s ne sont pas renseignes dans les initfiles;generic
Les parametres d'archive %s n'existent pas dans les initfiles;generic
Parametre log_archive_dest de %s non defini dans les initfiles;generic
Parametre log_archive_format de %s non defini dans les initfiles;generic
L'archivage de %s n'est pas demarre correctement;generic
L'archivage de %s n'est pas arrete correctement;generic
Script SQL %s non accessible;generic
Le script SQL %s ne s'est pas execute correctement;generic
Probleme lors de la suppression de la table %s ;generic
Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID;generic
Aucun Archive Oracle pour la Base %s;generic

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Message,Function from error_messages_sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Message,Function from error_messages_sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Message,Function from error_messages_sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Message,Function from error_messages_sort'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Message,Function from error_messages_sort'."> errstd") or diag($return_error);


##################
# Select -s from error_messages_sort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Check;65;Non unicite de la clef
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PATH;120;PATH=$PATH
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages_sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages_sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages_sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages_sort'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages_sort'."> errstd") or diag($return_error);


##################
# Select -r0 from error_messages_sort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r0 from error_messages_sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r0 from error_messages_sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r0 from error_messages_sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r0 from error_messages_sort'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r0 from error_messages_sort'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages_sort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
generic;6;La table %s est une table virtuelle

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Casse compatibilité (Voir http://srcsrv/issues/17)}, 3;


run3('Select -r1 from error_messages_sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages_sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages_sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages_sort'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages_sort'."> errstd") or diag($return_error);

}


##################
# Select from error_messages | Select from -
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages | Select from -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Select from -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Select from -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Select from -'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Select from -'."> errstd") or diag($return_error);


##################
# Select from error_messages | Select -s from -
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages | Select -s from -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Select -s from -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Select -s from -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Select -s from -'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Select -s from -'."> errstd") or diag($return_error);


##################
# Select -s from error_messages | Select from -
##################

$expected_code = 203;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 203
Message : La chaine de definition %s n'est pas valide ou est absente

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages | Select from -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages | Select from -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages | Select from -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages | Select from -'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages | Select from -'."> errstd") or diag($return_error);


##################
# Select -s -r0 from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s -r0 from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s -r0 from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s -r0 from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s -r0 from error_messages'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s -r0 from error_messages'."> errstd") or diag($return_error);


##################
# Select -s -r1 from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s -r1 from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s -r1 from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s -r1 from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s -r1 from error_messages'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s -r1 from error_messages'."> errstd") or diag($return_error);


##################
# Select from table_space
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='OWNER;OBJECT_NAME;SUBOBJECT_NAME;OBJECT_ID;DATA_OBJECT_ID;OBJECT_TYPE;CREATED;LAST_DDL_TIME;TIMESTAMP;STATUS;TEMPORARY;GENERATED;SECONDARY'@@ROW='$OWNER;$OBJECT_NAME;$SUBOBJECT_NAME;$OBJECT_ID;$DATA_OBJECT_ID;$OBJECT_TYPE;$CREATED;$LAST_DDL_TIME;$TIMESTAMP;$STATUS;$TEMPORARY;$GENERATED;$SECONDARY'@@SIZE='30s;128s;30s;22n;22n;18s;7d;7d;19s;7s;1s;1s;1s'@@HEADER='table champs vides'@@KEY='OWNER;OBJECT_NAME'
a;b;c;d;e;f;g;h;i;j;k;l;m
;b;c;d;e;f;g;h;i;j;k;l;m
a;;c;d;e;f;g;h;i;j;k;l;m
a;b;;d;e;f;g;h;i;j;k;l;m
a;b;c;;e;f;g;h;i;j;k;l;m
a;b;c;d;;f;g;h;i;j;k;l;m
a;b;c;d;e;;g;h;i;j;k;l;m
a;b;c;d;e;f;;h;i;j;k;l;m
a;b;c;d;e;f;g;;i;j;k;l;m
a;b;c;d;e;f;g;h;;j;k;l;m
a;b;c;d;e;f;g;h;i;;k;l;m
a;b;c;d;e;f;g;h;i;j;;l;m
a;b;c;d;e;f;g;h;u;j;k;;m
a;b;c;d;e;f;g;h;i;j;k;l;

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from table_space', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from table_space'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from table_space'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from table_space'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from table_space'."> errstd") or diag($return_error);


##################
# Select OWNER,SUBOBJECT_NAME,DATA_OBJECT_ID,CREATED,TIMESTAMP,TEMPORARY,SECONDARY from table_space
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='OWNER;SUBOBJECT_NAME;DATA_OBJECT_ID;CREATED;TIMESTAMP;TEMPORARY;SECONDARY'@@ROW='$OWNER;$SUBOBJECT_NAME;$DATA_OBJECT_ID;$CREATED;$TIMESTAMP;$TEMPORARY;$SECONDARY'@@SIZE='30s;30s;22n;7d;19s;1s;1s'@@HEADER='table champs vides'@@KEY='OWNER'
a;c;e;g;i;k;m
;c;e;g;i;k;m
a;c;e;g;i;k;m
a;;e;g;i;k;m
a;c;e;g;i;k;m
a;c;;g;i;k;m
a;c;e;g;i;k;m
a;c;e;;i;k;m
a;c;e;g;i;k;m
a;c;e;g;;k;m
a;c;e;g;i;k;m
a;c;e;g;i;;m
a;c;e;g;u;k;m
a;c;e;g;i;k;

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select OWNER,SUBOBJECT_NAME,DATA_OBJECT_ID,CREATED,TIMESTAMP,TEMPORARY,SECONDARY from table_space', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select OWNER,SUBOBJECT_NAME,DATA_OBJECT_ID,CREATED,TIMESTAMP,TEMPORARY,SECONDARY from table_space'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select OWNER,SUBOBJECT_NAME,DATA_OBJECT_ID,CREATED,TIMESTAMP,TEMPORARY,SECONDARY from table_space'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select OWNER,SUBOBJECT_NAME,DATA_OBJECT_ID,CREATED,TIMESTAMP,TEMPORARY,SECONDARY from table_space'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select OWNER,SUBOBJECT_NAME,DATA_OBJECT_ID,CREATED,TIMESTAMP,TEMPORARY,SECONDARY from table_space'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Function=Check
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Check;65;Non unicite de la clef

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Function=Check', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Function=Check'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Function=Check'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Function=Check'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Function=Check'."> errstd") or diag($return_error);


##################
# Select -s -r10 from error_messages where Function=Check
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Check;65;Non unicite de la clef

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s -r10 from error_messages where Function=Check', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s -r10 from error_messages where Function=Check'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s -r10 from error_messages where Function=Check'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s -r10 from error_messages where Function=Check'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s -r10 from error_messages where Function=Check'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Function =Check
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Check;65;Non unicite de la clef

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Function =Check', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Function =Check'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Function =Check'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Function =Check'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Function =Check'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Function= Check
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Check;65;Non unicite de la clef

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Function= Check', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Function= Check'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Function= Check'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Function= Check'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Function= Check'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Function = Check
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Check;65;Non unicite de la clef

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Function = Check', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Function = Check'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Function = Check'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Function = Check'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Function = Check'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where "Function = Check"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Check;65;Non unicite de la clef

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where "Function = Check"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where "Function = Check"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where "Function = Check"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where "Function = Check"'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where "Function = Check"'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Function=.Error
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : La valeur donnee pour la colonne Function n'est pas correcte.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Function=.Error', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Function=.Error'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Function=.Error'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Function=.Error'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Function=.Error'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Unknown=.Error
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : La colonne Unknown n'existe pas

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Unknown=.Error', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Unknown=.Error'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Unknown=.Error'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Unknown=.Error'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Unknown=.Error'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Function=.Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Function=.Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Function=.Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Function=.Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Function=.Message'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Function=.Message'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Function=.Unknown
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Function=.Unknown', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Function=.Unknown'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Function=.Unknown'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Function=.Unknown'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Function=.Unknown'."> errstd") or diag($return_error);


##################
# Select -s from error_messages "where Function = Check"
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Select [-h] [-s] [-m Sep] [-r Nlines] [Columns] 
 		  FROM <Table|-> [WHERE <Condition>] [ORDER_BY <Columns>]
Procedure : Select, Type : Erreur, Severite : 202
Message : Mot cle 'FROM' en double.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages "where Function = Check"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages "where Function = Check"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages "where Function = Check"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages "where Function = Check"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages "where Function = Check"'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '=' 2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;2;test avec ' des ' quote
generic;2;Impossible de trouver la table %s
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'=\' 2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'=\' 2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'=\' 2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'=\' 2'."> output <".q{TEST;2;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'=\' 2'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '=' 2.00
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;2;test avec ' des ' quote
generic;2;Impossible de trouver la table %s
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'=\' 2.00', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'=\' 2.00'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'=\' 2.00'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'=\' 2.00'."> output <".q{TEST;2;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'=\' 2.00'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '=' 2,00
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;2;test avec ' des ' quote
generic;2;Impossible de trouver la table %s
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'=\' 2,00', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'=\' 2,00'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'=\' 2,00'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'=\' 2,00'."> output <".q{TEST;2;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'=\' 2,00'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '=' texte
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : La valeur donnee pour la colonne Error  n'est pas correcte.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'=\' texte', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'=\' texte'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'=\' texte'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'=\' texte'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'=\' texte'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '=' -2
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Select: invalid option -- '2'
Usage : Select [-h] [-s] [-m Sep] [-r Nlines] [Columns] 
 		  FROM <Table|-> [WHERE <Condition>] [ORDER_BY <Columns>]
Procedure : Select, Type : Erreur, Severite : 202
Message : L'option -2 n'est pas valide

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'=\' -2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'=\' -2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'=\' -2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'=\' -2'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'=\' -2'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '~' 2
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : L'operateur de selection est incorrect !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'~\' 2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'~\' 2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'~\' 2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'~\' 2'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'~\' 2'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '!~' 2
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : L'operateur de selection est incorrect !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'!~\' 2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'!~\' 2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'!~\' 2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'!~\' 2'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'!~\' 2'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '==' 2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Bug I-TOOLS 2.0 (Voir http://srcsrv/issues/26)}, 3;


run3('Select -s from error_messages where Error \'==\' 2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'==\' 2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'==\' 2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'==\' 2'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'==\' 2'."> errstd") or diag($return_error);

}


##################
# Select -s from error_messages where Error '!=' 2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'!=\' 2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'!=\' 2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'!=\' 2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'!=\' 2'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'!=\' 2'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 2'."> output <".q{TEST;3;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 2'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>=' 2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>=\' 2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>=\' 2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>=\' 2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>=\' 2'."> output <".q{TEST;2;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>=\' 2'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '<' 2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST_${TESTVAR};0;test avec des une clef contenant une variable
generic;1;Impossible de trouver l'executable %s
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'<\' 2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'<\' 2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'<\' 2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'<\' 2'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'<\' 2'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '<=' 2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST_${TESTVAR};0;test avec des une clef contenant une variable
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'<=\' 2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'<=\' 2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'<=\' 2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'<=\' 2'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'<=\' 2'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where ID '>' 1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
2%deuxieme%20120101120000%0%40
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where ID \'>\' 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where ID \'>\' 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where ID \'>\' 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where ID \'>\' 1'."> output <".q{2%deuxieme...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where ID \'>\' 1'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '=' 60
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
3%troisieme%20100101120000%o%60

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'=\' 60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'=\' 60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'=\' 60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'=\' 60'."> output <".q{3%troisiem...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'=\' 60'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '=' 60%
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
3%troisieme%20100101120000%o%60

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Log_Interne, Type : Erreur, Severite : 201
Message : Valeur 60% prise en compte sans le caractere '%' !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'=\' 60%', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'=\' 60%'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'=\' 60%'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'=\' 60%'."> output <".q{3%troisiem...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'=\' 60%'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '=' 60.00
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
3%troisieme%20100101120000%o%60

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'=\' 60.00', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'=\' 60.00'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'=\' 60.00'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'=\' 60.00'."> output <".q{3%troisiem...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'=\' 60.00'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '=' texte
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : La valeur donnee pour la colonne Pourcentage  n'est pas correcte.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'=\' texte', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'=\' texte'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'=\' texte'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'=\' texte'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'=\' texte'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '=' -60
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Select: invalid option -- '6'
Usage : Select [-h] [-s] [-m Sep] [-r Nlines] [Columns] 
 		  FROM <Table|-> [WHERE <Condition>] [ORDER_BY <Columns>]
Procedure : Select, Type : Erreur, Severite : 202
Message : L'option = n'est pas valide

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'=\' -60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'=\' -60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'=\' -60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'=\' -60'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'=\' -60'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '~' 60
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : L'operateur de selection est incorrect !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'~\' 60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'~\' 60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'~\' 60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'~\' 60'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'~\' 60'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '!~' 60
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : L'operateur de selection est incorrect !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'!~\' 60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'!~\' 60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'!~\' 60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'!~\' 60'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'!~\' 60'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '==' 60
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'==\' 60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'==\' 60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'==\' 60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'==\' 60'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'==\' 60'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '!=' 60
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'!=\' 60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'!=\' 60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'!=\' 60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'!=\' 60'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'!=\' 60'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '>' 60
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'>\' 60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'>\' 60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'>\' 60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'>\' 60'."> output <".q{4%quatriem...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'>\' 60'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '>=' 60
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'>=\' 60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'>=\' 60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'>=\' 60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'>=\' 60'."> output <".q{3%troisiem...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'>=\' 60'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '<' 60
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'<\' 60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'<\' 60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'<\' 60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'<\' 60'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'<\' 60'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Pourcentage '<=' 60
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
3%troisieme%20100101120000%o%60
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Pourcentage \'<=\' 60', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Pourcentage \'<=\' 60'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Pourcentage \'<=\' 60'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Pourcentage \'<=\' 60'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Pourcentage \'<=\' 60'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message = NOPE
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message = NOPE', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message = NOPE'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message = NOPE'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message = NOPE'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message = NOPE'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message == NOPE
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message == NOPE', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message == NOPE'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message == NOPE'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message == NOPE'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message == NOPE'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message != NOPE
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message != NOPE', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message != NOPE'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message != NOPE'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message != NOPE'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message != NOPE'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '~' NOPE
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'~\' NOPE', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' NOPE'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' NOPE'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' NOPE'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' NOPE'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '!~' NOPE
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'!~\' NOPE', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'!~\' NOPE'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'!~\' NOPE'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'!~\' NOPE'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'!~\' NOPE'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '~' Aucune
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;68;Aucune ligne trouvee
generic;97;Aucune valeur donnee
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'~\' Aucune', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' Aucune'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' Aucune'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' Aucune'."> output <".q{Insert;97;...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' Aucune'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '~' Aucune ligne
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Modify;68;Aucune ligne trouvee a modifier
Remove;68;Aucune ligne trouvee a supprimer
Replace;68;Aucune ligne trouvee a remplacer
generic;68;Aucune ligne trouvee

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'~\' Aucune ligne', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' Aucune ligne'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' Aucune ligne'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' Aucune ligne'."> output <".q{Modify;68;...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' Aucune ligne'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '~' '"Aucune ligne"'
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Modify;68;Aucune ligne trouvee a modifier
Remove;68;Aucune ligne trouvee a supprimer
Replace;68;Aucune ligne trouvee a remplacer
generic;68;Aucune ligne trouvee

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'~\' \'"Aucune ligne"\'', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' \'"Aucune ligne"\''."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' \'"Aucune ligne"\''."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' \'"Aucune ligne"\''."> output <".q{Modify;68;...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' \'"Aucune ligne"\''."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '~' "'Aucune ligne'"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Modify;68;Aucune ligne trouvee a modifier
Remove;68;Aucune ligne trouvee a supprimer
Replace;68;Aucune ligne trouvee a remplacer
generic;68;Aucune ligne trouvee

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'~\' "\'Aucune ligne\'"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' "\'Aucune ligne\'"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' "\'Aucune ligne\'"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' "\'Aucune ligne\'"'."> output <".q{Modify;68;...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' "\'Aucune ligne\'"'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '~' '\'
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'~\' \'\\\'', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' \'\\\''."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' \'\\\''."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' \'\\\''."> output <".q{TEST;4;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' \'\\\''."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '~' '\\'
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;5;test avec \\ echappements \n

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'~\' \'\\\\\'', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' \'\\\\\''."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' \'\\\\\''."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' \'\\\\\''."> output <".q{TEST;5;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' \'\\\\\''."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '<' Aucune
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
generic;100;%s
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;520;Aucun Archive Oracle pour la Base %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'<\' Aucune', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'<\' Aucune'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'<\' Aucune'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'<\' Aucune'."> output <".q{generic;10...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'<\' Aucune'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '<=' Aucune
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
generic;100;%s
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;520;Aucun Archive Oracle pour la Base %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'<=\' Aucune', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'<=\' Aucune'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'<=\' Aucune'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'<=\' Aucune'."> output <".q{generic;10...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'<=\' Aucune'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '>' Aucune
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'>\' Aucune', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'>\' Aucune'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'>\' Aucune'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'>\' Aucune'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'>\' Aucune'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '>=' Aucune
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'>=\' Aucune', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'>=\' Aucune'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'>=\' Aucune'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'>=\' Aucune'."> output <".q{TEST;1;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'>=\' Aucune'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '~' and
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Bug I-TOOLS 2.0}, 3;


run3('Select -s from error_messages where Message \'~\' and', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' and'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' and'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' and'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' and'."> errstd") or diag($return_error);

}


##################
# Select -s from error_messages where Message '~' '"and"'
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
generic;17;La commande <%s> a echoue
generic;24;Ligne de commande incorrecte
generic;42;Le Handle d'une requete n'est pas valide
generic;45;Un Handle n'est pas valide
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;130;Options de commande %s incompatibles

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'~\' \'"and"\'', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' \'"and"\''."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' \'"and"\''."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' \'"and"\''."> output <".q{TEST;8;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' \'"and"\''."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Message '~' "'and'"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
generic;17;La commande <%s> a echoue
generic;24;Ligne de commande incorrecte
generic;42;Le Handle d'une requete n'est pas valide
generic;45;Un Handle n'est pas valide
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;130;Options de commande %s incompatibles

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Message \'~\' "\'and\'"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Message \'~\' "\'and\'"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Message \'~\' "\'and\'"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Message \'~\' "\'and\'"'."> output <".q{TEST;8;tes...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Message \'~\' "\'and\'"'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Date = 20110101120000
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Date = 20110101120000', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Date = 20110101120000'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Date = 20110101120000'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Date = 20110101120000'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Date = 20110101120000'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Date = 2011
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Date = 2011', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Date = 2011'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Date = 2011'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Date = 2011'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Date = 2011'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Date != 20110101120000
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
2%deuxieme%20120101120000%0%40
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Date != 20110101120000', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Date != 20110101120000'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Date != 20110101120000'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Date != 20110101120000'."> output <".q{2%deuxieme...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Date != 20110101120000'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Date '~' 2011
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Date \'~\' 2011', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Date \'~\' 2011'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Date \'~\' 2011'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Date \'~\' 2011'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Date \'~\' 2011'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Date '!~' 2011
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
2%deuxieme%20120101120000%0%40
3%troisieme%20100101120000%o%60

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Date \'!~\' 2011', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Date \'!~\' 2011'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Date \'!~\' 2011'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Date \'!~\' 2011'."> output <".q{2%deuxieme...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Date \'!~\' 2011'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Date '<' 2011
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
3%troisieme%20100101120000%o%60

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Date \'<\' 2011', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Date \'<\' 2011'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Date \'<\' 2011'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Date \'<\' 2011'."> output <".q{3%troisiem...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Date \'<\' 2011'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Date '<=' 2011
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
3%troisieme%20100101120000%o%60

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Date \'<=\' 2011', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Date \'<=\' 2011'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Date \'<=\' 2011'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Date \'<=\' 2011'."> output <".q{3%troisiem...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Date \'<=\' 2011'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Date '>' 2011
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Date \'>\' 2011', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Date \'>\' 2011'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Date \'>\' 2011'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Date \'>\' 2011'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Date \'>\' 2011'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Date '>=' 2011
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Date \'>=\' 2011', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Date \'>=\' 2011'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Date \'>=\' 2011'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Date \'>=\' 2011'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Date \'>=\' 2011'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool = 1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool = 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool = 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool = 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool = 1'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool = 1'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool = 0
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
2%deuxieme%20120101120000%0%40
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool = 0', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool = 0'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool = 0'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool = 0'."> output <".q{2%deuxieme...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool = 0'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool = O
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool = O', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool = O'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool = O'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool = O'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool = O'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool = N
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
2%deuxieme%20120101120000%0%40
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool = N', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool = N'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool = N'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool = N'."> output <".q{2%deuxieme...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool = N'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool = Y
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool = Y', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool = Y'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool = Y'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool = Y'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool = Y'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool = texte
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : La valeur donnee pour la colonne Bool  n'est pas correcte.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool = texte', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool = texte'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool = texte'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool = texte'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool = texte'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool = 3
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : La valeur donnee pour la colonne Bool  n'est pas correcte.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool = 3', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool = 3'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool = 3'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool = 3'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool = 3'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool != 1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
2%deuxieme%20120101120000%0%40
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool != 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool != 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool != 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool != 1'."> output <".q{2%deuxieme...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool != 1'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool '~' 0
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : L'operateur de selection est incorrect !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool \'~\' 0', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool \'~\' 0'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool \'~\' 0'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool \'~\' 0'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool \'~\' 0'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool '~' 1
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : L'operateur de selection est incorrect !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool \'~\' 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool \'~\' 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool \'~\' 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool \'~\' 1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool \'~\' 1'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool '!~' 1
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : L'operateur de selection est incorrect !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool \'!~\' 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool \'!~\' 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool \'!~\' 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool \'!~\' 1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool \'!~\' 1'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool '<' 1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
2%deuxieme%20120101120000%0%40
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool \'<\' 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool \'<\' 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool \'<\' 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool \'<\' 1'."> output <".q{2%deuxieme...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool \'<\' 1'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool '<=' 1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool \'<=\' 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool \'<=\' 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool \'<=\' 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool \'<=\' 1'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool \'<=\' 1'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool '>' 1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool \'>\' 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool \'>\' 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool \'>\' 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool \'>\' 1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool \'>\' 1'."> errstd") or diag($return_error);


##################
# Select -s from table_simple where Bool '>=' 1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple where Bool \'>=\' 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple where Bool \'>=\' 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple where Bool \'>=\' 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple where Bool \'>=\' 1'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple where Bool \'>=\' 1'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 80 AND Message '~' Aucune
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;97;Aucune valeur donnee

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune'."> output <".q{Insert;97;...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 80 AND Message '~' Aucune ligne AND Function = Replace
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND Function = Replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND Function = Replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND Function = Replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND Function = Replace'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND Function = Replace'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 80 AND Message '~' Aucune ligne AND AND Function = Replace
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : La colonne AND Function  n'existe pas

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND AND Function = Replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND AND Function = Replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND AND Function = Replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND AND Function = Replace'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune ligne AND AND Function = Replace'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 80 AND Message '~' "'Aucune ligne AND'" AND Function = Replace
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 80 AND Message \'~\' "\'Aucune ligne AND\'" AND Function = Replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' "\'Aucune ligne AND\'" AND Function = Replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' "\'Aucune ligne AND\'" AND Function = Replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' "\'Aucune ligne AND\'" AND Function = Replace'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' "\'Aucune ligne AND\'" AND Function = Replace'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 80 AND Message '~' '"Aucune ligne AND"' AND Function = Replace
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 80 AND Message \'~\' \'"Aucune ligne AND"\' AND Function = Replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' \'"Aucune ligne AND"\' AND Function = Replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' \'"Aucune ligne AND"\' AND Function = Replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' \'"Aucune ligne AND"\' AND Function = Replace'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' \'"Aucune ligne AND"\' AND Function = Replace'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 80 OR Message '~' Aucune
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;68;Aucune ligne trouvee
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune'."> output <".q{Insert;97;...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 80 OR Message '~' Aucune OR Function = Replace
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;68;Aucune ligne trouvee
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune OR Function = Replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune OR Function = Replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune OR Function = Replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune OR Function = Replace'."> output <".q{Insert;97;...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune OR Function = Replace'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 80 AND Message '~' Aucune OR Function = Replace
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;97;Aucune valeur donnee

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune OR Function = Replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune OR Function = Replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune OR Function = Replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune OR Function = Replace'."> output <".q{Insert;97;...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 80 AND Message \'~\' Aucune OR Function = Replace'."> errstd") or diag($return_error);


##################
# Select -s from error_messages where Error '>' 80 OR Message '~' Aucune AND Function = Replace
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune AND Function = Replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune AND Function = Replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune AND Function = Replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune AND Function = Replace'."> output <".q{Insert;97;...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages where Error \'>\' 80 OR Message \'~\' Aucune AND Function = Replace'."> errstd") or diag($return_error);


##################
# Select -m';' from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
Check;65;Non unicite de la clef
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -m\';\' from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -m\';\' from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -m\';\' from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -m\';\' from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -m\';\' from error_messages'."> errstd") or diag($return_error);


##################
# Select -m%% from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'@@FORMAT='Function%%Error%%Message'@@ROW='$Function%%$Error%%$Message'@@SIZE='20s%%4n%%80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function%%Error'
TEST%%1%%test sans quote
TEST%%2%%test avec ' des ' quote
TEST%%3%%test avec " des " double quote
TEST%%4%%test avec \" des \' quote echappees
TEST%%5%%test avec \\ echappements \n
TEST%%6%%test avec trop de %% separ%%ateurs%%
TEST%%7%%test avec des $variables $TESTVAR
TEST%%8%%test avec des $variables $(echo "commande evaluee")
TEST%%9%%test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR}%%0%%test avec des une clef contenant une variable
Check%%65%%Non unicite de la clef
Insert%%8%%La condition de selection de cle n'est pas valide
Insert%%97%%Aucune valeur a inserer n'est specifiee
Modify%%8%%La condition de selection de la cle n est pas valide
Modify%%68%%Aucune ligne trouvee a modifier
Modify%%97%%Aucune valeur a modifier n'est specifiee
Remove%%68%%Aucune ligne trouvee a supprimer
Replace%%8%%La condition de selection de la cle n'est pas valide
Replace%%68%%Aucune ligne trouvee a remplacer
Replace%%97%%Aucune valeur a remplacer n'est specifiee
generic%%1%%Impossible de trouver l'executable %s
generic%%2%%Impossible de trouver la table %s
generic%%3%%Impossible de trouver ou d'ouvrir le fichier de definition %s
generic%%4%%Impossible de trouver le fichier %s
generic%%5%%Le fichier de definition %s n'est pas valide
generic%%6%%La table %s est une table virtuelle
generic%%7%%La colonne %s n'existe pas
generic%%8%%La condition de selection n'est pas valide
generic%%9%%La chaine de definition %s n'est pas valide ou est absente
generic%%10%%Impossible d'ouvrir le fichier %s
generic%%11%%Impossible d'ecrire dans le fichier %s
generic%%12%%Impossible de supprimer le fichier %s
generic%%13%%Impossible de changer les droits sur le fichier %s
generic%%14%%Impossible de renommer/deplacer le fichier %s en %s
generic%%15%%Impossible de copier le fichier %s
generic%%16%%Erreur lors d'une ecriture dans le fichier %s
generic%%17%%La commande <%s> a echoue
generic%%18%%La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic%%19%%L'evaluation de <%s> est incorrecte !
generic%%20%%L'option %s n'est pas valide
generic%%21%%Le nombre d'arguments est incorrect
generic%%22%%L'argument %s n'est pas valide
generic%%23%%Utilisation incorrecte de l'option -h
generic%%24%%Ligne de commande incorrecte
generic%%25%%Erreur lors d'une allocation de memoire %s
generic%%26%%Erreur lors d'une re-allocation de memoire %s
generic%%27%%Erreur lors du chargement de la librairie %s !
generic%%28%%Impossible de retrouver le symbole %s en librairie !
generic%%29%%Erreur lors de la fermeture de la librairie %s !
generic%%30%%Votre licence d'utilisation %s a expire !
generic%%31%%Le Hostid de la machine n'est pas valide !
generic%%32%%La licence n'est pas valide !
generic%%33%%Il n'y a pas de licence valide pour ce produit !
generic%%34%%Le nombre de clients pour ce produit est depasse !
generic%%35%%Le nom de fichier %s n'est pas valide
generic%%36%%Le fichier %s est verouille
generic%%37%%Impossible de poser un verrou sur le fichier %s
generic%%38%%Le delai maximum d'attente de deverouillage a ete atteint
generic%%39%%Le fichier %s n'est pas verouille
generic%%40%%Impossible de retirer le verrou du fichier %s
generic%%41%%Le nombre maximal de selections simultanees est depasse
generic%%42%%Le Handle d'une requete n'est pas valide
generic%%43%%Le nombre maximal de conditions est depasse
generic%%44%%Impossible de retrouver la librairie %s !
generic%%45%%Un Handle n'est pas valide
generic%%46%%Le nombre maximal de fichiers ouverts est depasse
generic%%47%%Le nombre maximal %s d'allocations de memoire est depasse
generic%%48%%Impossible de retrouver le fichier de menu %s
generic%%49%%Impossible de retrouver le dictionnaire graphique %s
generic%%50%%Erreur lors de l'execution de la fonction de log
generic%%51%%Erreur de type '%s' lors de la deconnexion Oracle !
generic%%52%%Impossible d'ecrire dans le fichier log %s
generic%%53%%Impossible de determiner le nom du traitement
generic%%54%%Le numero d'erreur est manquant
generic%%55%%Le message d'information est manquant
generic%%56%%Le numero d'erreur %s n'a pas de message associe
generic%%57%%Le numero d'erreur %s n'est pas correct
generic%%58%%Le type de message de log n'est pas correct
generic%%59%%Le nom de table %s n'est pas valide
generic%%60%%La colonne %s doit absolument contenir une valeur
generic%%61%%Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic%%62%%Il y a trop de valeurs par rapport au nombre de colonnes
generic%%63%%La valeur donnee pour la colonne %s n'est pas correcte.
generic%%64%%Le nom de la table n'est pas specifie
generic%%65%%Non unicite de la clef de la ligne a inserer
generic%%66%%Le groupe d'utilisateurs %s n'existe pas
generic%%67%%Impossible de remplacer une ligne sur une table sans clef
generic%%68%%Aucune ligne trouvee
generic%%69%%Entete de definition invalide !
generic%%70%%Variables d'environnement SEP ou FORMAT absente !
generic%%71%%Il n'y a pas de lignes en entree stdin !
generic%%72%%Impossible d'ouvrir le fichier %s en ecriture !
generic%%73%%Impossible d'ouvrir le fichier %s en lecture !
generic%%74%%Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic%%75%%Erreur generique Oracle : %s
generic%%76%%Erreur de syntaxe dans la requete SQL generee : %s
generic%%77%%Une valeur a inserer est trop large pour sa colonne !
generic%%78%%Impossible de se connecter a Oracle avec l'utilisateur %s
generic%%79%%Impossible de locker la table %s. Ressource deja occupee !
generic%%80%%La requete interne SQL s'est terminee en erreur !
generic%%81%%Le nouveau separateur n'est pas specifie !
generic%%82%%Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic%%83%%La colonne %s apparait plusieurs fois dans le dictionnaire !
generic%%84%%La source de donnees %s du dictionnaire est invalide !
generic%%85%%La table %s ne peut-etre verouillee ou deverouillee !
generic%%86%%Vous ne pouvez pas remplacer une cle !
generic%%87%%Impossible de creer un nouveau processus %s !
generic%%88%%Le nombre maximal de tables %s est depasse
generic%%89%%Option ou suffixe de recherche invalide !
generic%%90%%Pas de librairie chargee pour acceder a la base de donnees !
generic%%91%%Variable d'environnement %s manquante ou non exportee !
generic%%92%%Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic%%93%%Le type de la colonne %s est invalide !
generic%%94%%Impossible de retrouver le formulaire %s
generic%%95%%Impossible de retrouver le panneau de commandes %s.
generic%%96%%L'operateur de selection est incorrect !
generic%%97%%Aucune valeur donnee
generic%%98%%La taille maximale %s d'une ligne est depassee !
generic%%99%%Le champ %s est mal decrit dans la table %s
generic%%100%%%s
generic%%101%%Le parametre %s n'est pas un chiffre
generic%%102%%L'utilisateur %s n'existe pas
generic%%103%%La cle de reference de la contrainte sur %s est incorrecte.
generic%%104%%Erreur lors du delete sur %s
generic%%105%%La variable %s n'est pas du bon type
generic%%106%%Probleme lors du chargement de l'environnement %s
generic%%107%%Environnement %s non accessible
generic%%108%%Probleme pour acceder a la table %s
generic%%109%%La table %s n'existe pas ou n'est pas accessible
generic%%110%%Impossible de retrouver l'objet %s
generic%%111%%La table %s existe sous plusieurs schemas
generic%%112%%Probleme pour recuperer les contraintes de %s
generic%%113%%Erreur lors du disable de contraintes de %s
generic%%114%%Erreur lors de l'enable de contraintes de %s
generic%%115%%Erreur lors du chargement de la table %s
generic%%116%%Des enregistrements ont ete rejetes pour la table %s
generic%%117%%La contrainte %s est invalide !
generic%%118%%Le nombre maximal %s de cles etrangeres est depasse.
generic%%119%%Le nombre maximal %s de contraintes est depasse.
generic%%120%%Impossible de creer le fichier %s
generic%%121%%La table %s n'est pas une table de reference.
generic%%122%%La table %s existe sous plusieurs cles etrangères.
generic%%123%%Les droits sur le fichier %s sont incorrects.
generic%%124%%Probleme pour recuperer les informations '%s' de la Machine %s.
generic%%125%%Le type de la licence est invalide.
generic%%126%%L'utilisateur %s n'est pas administrateur du systeme.
generic%%127%%Les colonnes %s doivent absolument contenir une valeur.
generic%%128%%La table %s ne possede pas de cle primaire.
generic%%129%%La valeur d'une cle primaire ne peut-etre nulle.
generic%%130%%Options de commande %s incompatibles
generic%%131%%Le tri de séléction '%s' est invalide.
generic%%132%%Le format de la date '%s' est invalide.
generic%%133%%Les eléments % de la date doivent être séparés par un caractère.
generic%%134%%La date '%s' ne correspond pas au format %s.
generic%%148%%Vous n'avez pas les droits %s.
generic%%149%%Probleme d'environnement %s
generic%%150%%Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic%%151%%Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic%%152%%L'intance %s est invalide ou non demarrée.
V1_alim_30_motcle%%0001%%ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle%%0002%%Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle%%0003%%Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle%%0004%%ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth%%0001%%Le mot cle d'action %s n'existe pas
V1_alim_40_meth%%0002%%L'Insertion de la methode physique %s a echoue
V1_alim_40_meth%%0003%%L'Insertion de la variable interne %s a echoue
V1_alim_40_meth%%0004%%L'Insertion du type physique %s a echoue
PC_CHGSTAT_SERV%%0004%%Aucune instance n'est associee a l'application %s
generic%%301%%Le module applicatif %s n'est pas ou mal declaré.
generic%%302%%L'instance de service %s ne semble pas exister.
generic%%303%%Le script fils <%s> a retourne un warning
generic%%304%%Le script fils <%s> a retourne une erreur bloquante
generic%%305%%Le script fils <%s> a retourne une erreur fatale
generic%%306%%Le script fils <%s> a retourne un code d'erreur errone %s
generic%%308%%Erreur a l'execution de %s
generic%%309%%Le service %s '%s' n'existe pas.
generic%%310%%Le service %s '%s' est deja demarre.
generic%%311%%Le service %s '%s' est deja arrete.
generic%%312%%Le service %s '%s' n'a pas demarre correctement.
generic%%313%%Le service %s '%s' ne s'est pas arrete correctement.
generic%%314%%Le service %s '%s' n'est pas ou mal declaré.
generic%%315%%Le module applicatif %s ne possède aucune instance de service.
generic%%316%%La ressource %s '%s' n'est pas ou mal declaré.
generic%%317%%Impossible de choisir un type pour le Service %s '%s'.
generic%%318%%Impossible de choisir un type de service pour le I-CLES %s.
generic%%319%%La table %s n'est pas collectable.
generic%%320%%Le type de ressource %s n'est pas ou mal déclaré.
generic%%321%%Le Type de Service %s du I-CLES %s n'existe pas.
generic%%401%%Le repertoire %s n'existe pas
generic%%402%%Impossible de creer le repertoire %s
generic%%403%%Impossible d'ecrire dans le repertoire %s
generic%%404%%Impossible de lire le contenu du repertoire %s
generic%%405%%Le fichier %s n'existe pas ou est vide
generic%%406%%Le fichier %s existe deja
generic%%408%%Le fichier %s n'est pas au format %s
generic%%409%%Erreur lors de l'initialisation du fichier %s
generic%%410%%Probleme lors de la restauration/decompression de %s
generic%%411%%Probleme lors de la decompression de %s
generic%%412%%Probleme lors de la compression de %s
generic%%413%%Probleme lors de la securisation/compression de %s
generic%%414%%Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic%%415%%Le device %s n'existe pas ou est indisponible
generic%%416%%Probleme lors de la creation du lien vers %s
generic%%417%%Le lecteur %s est inaccessible
generic%%420%%Impossible d'aller sous le répertoire '%s'.
ME_CREATE_SYNORA%%0001%%Probleme a la creation du Synonyme %s
ME_DROP_SYNORA%%0001%%Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA%%0001%%Echec du Load sqlldr de %s
ME_RESTORE_TABORA%%0001%%Erreur lors de la restauration de la table %s
ME_SECURE_TABORA%%0001%%Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA%%0002%%Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA%%0003%%Erreur lors de la securisation de la table %s
ME_SECURE_TABORA%%0004%%Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA%%0365%%Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA%%176%%Probleme de truncate sur %s (Contrainte type P referencee) 
PC_BACK_TBSORA%%137%%Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA%%138%%Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA%%139%%Probleme pour manipuler le TBSPACE %s
PC_LISTBACK_ARCHORA%%0001%%Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA%%0002%%Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA%%128%%Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA%%132%%Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA%%182%%Impossible de trouver la Base du user %s
PC_SWITCH_LOGORA%%127%%Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA%%128%%Impossible d'interroger les logfiles pour %s
generic%%501%%L'instance Oracle %s n'est pas demarree
generic%%502%%L'instance Oracle %s n'est pas arretee
generic%%503%%%s n'est pas un mode d'arret Oracle valide
generic%%504%%%s n'est pas un mode de demarrage Oracle valide
generic%%505%%La base Oracle %s existe deja dans /etc/oratab
generic%%506%%Impossible de retrouver l'environnement de l'instance Oracle %s
generic%%507%%Impossible de retrouver l'init file de la base %s
generic%%508%%Le fichier de config de %s n'est pas renseigne dans l'initfile
generic%%509%%Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic%%510%%Les parametres d'archive %s n'existent pas dans les initfiles
generic%%511%%Parametre log_archive_dest de %s non defini dans les initfiles
generic%%512%%Parametre log_archive_format de %s non defini dans les initfiles
generic%%513%%L'archivage de %s n'est pas demarre correctement
generic%%514%%L'archivage de %s n'est pas arrete correctement
generic%%515%%Script SQL %s non accessible
generic%%517%%Le script SQL %s ne s'est pas execute correctement
generic%%518%%Probleme lors de la suppression de la table %s 
generic%%519%%Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic%%520%%Aucun Archive Oracle pour la Base %s
PC_INITF_SQLNET%%004%%La configuration SqlNet %s de %s est introuvable
FT_LISTLST_SQLNET%%346%%Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME%%346%%Aucun Service TNS convenablement declare dans %s
PC_ENV_SQLNET%%506%%Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_LISTID_SQLNET%%182%%Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME%%001%%Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME%%002%%Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME%%003%%Erreur de configuration de l'adresse du service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Bug I-TOOLS 2.0 (Voir http://srcsrv/issues/35)}, 3;


run3('Select -m%% from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -m%% from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -m%% from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -m%% from error_messages'."> output <".q{SEP='%%'@@...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -m%% from error_messages'."> errstd") or diag($return_error);

}


##################
# Select -m% from table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%'@@FORMAT='ID%Description%Date%Bool%Pourcentage'@@ROW='$ID%$Description%$Date%$Bool%$Pourcentage'@@SIZE='4n%80s%20d%2b%10p'@@HEADER='table simple'@@KEY='ID'
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -m% from table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -m% from table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -m% from table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -m% from table_simple'."> output <".q{SEP='%'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -m% from table_simple'."> errstd") or diag($return_error);


##################
# Select -m%% from table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'@@FORMAT='ID%%Description%%Date%%Bool%%Pourcentage'@@ROW='$ID%%$Description%%$Date%%$Bool%%$Pourcentage'@@SIZE='4n%%80s%%20d%%2b%%10p'@@HEADER='table simple'@@KEY='ID'
1%%premier%%20110101120000%%1%%20
2%%deuxieme%%20120101120000%%0%%40
3%%troisieme%%20100101120000%%o%%60
4%%quatrieme%%20110101140001%%Y%%80
5%%cinquieme%%20110101140002%%Y%%90
6%%sixieme%%20110101140003%%Y%%100n
7%%septieme%%20110101140004X%%Y%%10
8%%huitieme%%20110101140004%%errror_bool%%10
toto%%mauvais ID%%20110101140005%%0%%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -m%% from table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -m%% from table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -m%% from table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -m%% from table_simple'."> output <".q{SEP='%%'@@...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -m%% from table_simple'."> errstd") or diag($return_error);


##################
# Select -mX from table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='X'@@FORMAT='IDXDescriptionXDateXBoolXPourcentage'@@ROW='$IDX$DescriptionX$DateX$BoolX$Pourcentage'@@SIZE='4nX80sX20dX2bX10p'@@HEADER='table simple'@@KEY='ID'
1XpremierX20110101120000X1X20
2XdeuxiemeX20120101120000X0X40
3XtroisiemeX20100101120000XoX60
4XquatriemeX20110101140001XYX80
5XcinquiemeX20110101140002XYX90
6XsixiemeX20110101140003XYX100n
7XseptiemeX20110101140004XXYX10
8XhuitiemeX20110101140004Xerrror_boolX10
totoXmauvais IDX20110101140005X0X20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -mX from table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -mX from table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -mX from table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -mX from table_simple'."> output <".q{SEP='X'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -mX from table_simple'."> errstd") or diag($return_error);


##################
# Select Function from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function'@@ROW='$Function'@@SIZE='20s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function'
TEST
TEST
TEST
TEST
TEST
TEST
TEST
TEST
TEST
TEST_${TESTVAR}
Check
Insert
Insert
Modify
Modify
Modify
Remove
Replace
Replace
Replace
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
V1_alim_30_motcle
V1_alim_30_motcle
V1_alim_30_motcle
V1_alim_30_motcle
V1_alim_40_meth
V1_alim_40_meth
V1_alim_40_meth
V1_alim_40_meth
PC_CHGSTAT_SERV
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
ME_CREATE_SYNORA
ME_DROP_SYNORA
ME_LOAD_TABORA
ME_RESTORE_TABORA
ME_SECURE_TABORA
ME_SECURE_TABORA
ME_SECURE_TABORA
ME_SECURE_TABORA
ME_SECURE_TABORA
ME_TRUNC_TABORA
PC_BACK_TBSORA
PC_BACK_TBSORA
PC_BACK_TBSORA
PC_LISTBACK_ARCHORA
PC_LISTBACK_ARCHORA
PC_LISTBACK_CTRLORA
PC_LISTBACK_CTRLORA
PC_LISTID_INSORA
PC_SWITCH_LOGORA
PC_SWITCH_LOGORA
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
generic
PC_INITF_SQLNET
FT_LISTLST_SQLNET
FT_LIST_TNSNAME
PC_ENV_SQLNET
PC_LISTID_SQLNET
PC_STAT_TNSNAME
PC_STAT_TNSNAME
PC_STAT_TNSNAME

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Function from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Function from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Function from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Function from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Function from error_messages'."> errstd") or diag($return_error);


##################
# Select Function,Error from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error'@@ROW='$Function;$Error'@@SIZE='20s;4n'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1
TEST;2
TEST;3
TEST;4
TEST;5
TEST;6
TEST;7
TEST;8
TEST;9
TEST_${TESTVAR};0
Check;65
Insert;8
Insert;97
Modify;8
Modify;68
Modify;97
Remove;68
Replace;8
Replace;68
Replace;97
generic;1
generic;2
generic;3
generic;4
generic;5
generic;6
generic;7
generic;8
generic;9
generic;10
generic;11
generic;12
generic;13
generic;14
generic;15
generic;16
generic;17
generic;18
generic;19
generic;20
generic;21
generic;22
generic;23
generic;24
generic;25
generic;26
generic;27
generic;28
generic;29
generic;30
generic;31
generic;32
generic;33
generic;34
generic;35
generic;36
generic;37
generic;38
generic;39
generic;40
generic;41
generic;42
generic;43
generic;44
generic;45
generic;46
generic;47
generic;48
generic;49
generic;50
generic;51
generic;52
generic;53
generic;54
generic;55
generic;56
generic;57
generic;58
generic;59
generic;60
generic;61
generic;62
generic;63
generic;64
generic;65
generic;66
generic;67
generic;68
generic;69
generic;70
generic;71
generic;72
generic;73
generic;74
generic;75
generic;76
generic;77
generic;78
generic;79
generic;80
generic;81
generic;82
generic;83
generic;84
generic;85
generic;86
generic;87
generic;88
generic;89
generic;90
generic;91
generic;92
generic;93
generic;94
generic;95
generic;96
generic;97
generic;98
generic;99
generic;100
generic;101
generic;102
generic;103
generic;104
generic;105
generic;106
generic;107
generic;108
generic;109
generic;110
generic;111
generic;112
generic;113
generic;114
generic;115
generic;116
generic;117
generic;118
generic;119
generic;120
generic;121
generic;122
generic;123
generic;124
generic;125
generic;126
generic;127
generic;128
generic;129
generic;130
generic;131
generic;132
generic;133
generic;134
generic;148
generic;149
generic;150
generic;151
generic;152
V1_alim_30_motcle;0001
V1_alim_30_motcle;0002
V1_alim_30_motcle;0003
V1_alim_30_motcle;0004
V1_alim_40_meth;0001
V1_alim_40_meth;0002
V1_alim_40_meth;0003
V1_alim_40_meth;0004
PC_CHGSTAT_SERV;0004
generic;301
generic;302
generic;303
generic;304
generic;305
generic;306
generic;308
generic;309
generic;310
generic;311
generic;312
generic;313
generic;314
generic;315
generic;316
generic;317
generic;318
generic;319
generic;320
generic;321
generic;401
generic;402
generic;403
generic;404
generic;405
generic;406
generic;408
generic;409
generic;410
generic;411
generic;412
generic;413
generic;414
generic;415
generic;416
generic;417
generic;420
ME_CREATE_SYNORA;0001
ME_DROP_SYNORA;0001
ME_LOAD_TABORA;0001
ME_RESTORE_TABORA;0001
ME_SECURE_TABORA;0001
ME_SECURE_TABORA;0002
ME_SECURE_TABORA;0003
ME_SECURE_TABORA;0004
ME_SECURE_TABORA;0365
ME_TRUNC_TABORA;176
PC_BACK_TBSORA;137
PC_BACK_TBSORA;138
PC_BACK_TBSORA;139
PC_LISTBACK_ARCHORA;0001
PC_LISTBACK_ARCHORA;0002
PC_LISTBACK_CTRLORA;128
PC_LISTBACK_CTRLORA;132
PC_LISTID_INSORA;182
PC_SWITCH_LOGORA;127
PC_SWITCH_LOGORA;128
generic;501
generic;502
generic;503
generic;504
generic;505
generic;506
generic;507
generic;508
generic;509
generic;510
generic;511
generic;512
generic;513
generic;514
generic;515
generic;517
generic;518
generic;519
generic;520
PC_INITF_SQLNET;004
FT_LISTLST_SQLNET;346
FT_LIST_TNSNAME;346
PC_ENV_SQLNET;506
PC_LISTID_SQLNET;182
PC_STAT_TNSNAME;001
PC_STAT_TNSNAME;002
PC_STAT_TNSNAME;003

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Function,Error from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Function,Error from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Function,Error from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Function,Error from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Function,Error from error_messages'."> errstd") or diag($return_error);


##################
# Select Function, Error from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error'@@ROW='$Function;$Error'@@SIZE='20s;4n'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1
TEST;2
TEST;3
TEST;4
TEST;5
TEST;6
TEST;7
TEST;8
TEST;9
TEST_${TESTVAR};0
Check;65
Insert;8
Insert;97
Modify;8
Modify;68
Modify;97
Remove;68
Replace;8
Replace;68
Replace;97
generic;1
generic;2
generic;3
generic;4
generic;5
generic;6
generic;7
generic;8
generic;9
generic;10
generic;11
generic;12
generic;13
generic;14
generic;15
generic;16
generic;17
generic;18
generic;19
generic;20
generic;21
generic;22
generic;23
generic;24
generic;25
generic;26
generic;27
generic;28
generic;29
generic;30
generic;31
generic;32
generic;33
generic;34
generic;35
generic;36
generic;37
generic;38
generic;39
generic;40
generic;41
generic;42
generic;43
generic;44
generic;45
generic;46
generic;47
generic;48
generic;49
generic;50
generic;51
generic;52
generic;53
generic;54
generic;55
generic;56
generic;57
generic;58
generic;59
generic;60
generic;61
generic;62
generic;63
generic;64
generic;65
generic;66
generic;67
generic;68
generic;69
generic;70
generic;71
generic;72
generic;73
generic;74
generic;75
generic;76
generic;77
generic;78
generic;79
generic;80
generic;81
generic;82
generic;83
generic;84
generic;85
generic;86
generic;87
generic;88
generic;89
generic;90
generic;91
generic;92
generic;93
generic;94
generic;95
generic;96
generic;97
generic;98
generic;99
generic;100
generic;101
generic;102
generic;103
generic;104
generic;105
generic;106
generic;107
generic;108
generic;109
generic;110
generic;111
generic;112
generic;113
generic;114
generic;115
generic;116
generic;117
generic;118
generic;119
generic;120
generic;121
generic;122
generic;123
generic;124
generic;125
generic;126
generic;127
generic;128
generic;129
generic;130
generic;131
generic;132
generic;133
generic;134
generic;148
generic;149
generic;150
generic;151
generic;152
V1_alim_30_motcle;0001
V1_alim_30_motcle;0002
V1_alim_30_motcle;0003
V1_alim_30_motcle;0004
V1_alim_40_meth;0001
V1_alim_40_meth;0002
V1_alim_40_meth;0003
V1_alim_40_meth;0004
PC_CHGSTAT_SERV;0004
generic;301
generic;302
generic;303
generic;304
generic;305
generic;306
generic;308
generic;309
generic;310
generic;311
generic;312
generic;313
generic;314
generic;315
generic;316
generic;317
generic;318
generic;319
generic;320
generic;321
generic;401
generic;402
generic;403
generic;404
generic;405
generic;406
generic;408
generic;409
generic;410
generic;411
generic;412
generic;413
generic;414
generic;415
generic;416
generic;417
generic;420
ME_CREATE_SYNORA;0001
ME_DROP_SYNORA;0001
ME_LOAD_TABORA;0001
ME_RESTORE_TABORA;0001
ME_SECURE_TABORA;0001
ME_SECURE_TABORA;0002
ME_SECURE_TABORA;0003
ME_SECURE_TABORA;0004
ME_SECURE_TABORA;0365
ME_TRUNC_TABORA;176
PC_BACK_TBSORA;137
PC_BACK_TBSORA;138
PC_BACK_TBSORA;139
PC_LISTBACK_ARCHORA;0001
PC_LISTBACK_ARCHORA;0002
PC_LISTBACK_CTRLORA;128
PC_LISTBACK_CTRLORA;132
PC_LISTID_INSORA;182
PC_SWITCH_LOGORA;127
PC_SWITCH_LOGORA;128
generic;501
generic;502
generic;503
generic;504
generic;505
generic;506
generic;507
generic;508
generic;509
generic;510
generic;511
generic;512
generic;513
generic;514
generic;515
generic;517
generic;518
generic;519
generic;520
PC_INITF_SQLNET;004
FT_LISTLST_SQLNET;346
FT_LIST_TNSNAME;346
PC_ENV_SQLNET;506
PC_LISTID_SQLNET;182
PC_STAT_TNSNAME;001
PC_STAT_TNSNAME;002
PC_STAT_TNSNAME;003

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Function, Error from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Function, Error from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Function, Error from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Function, Error from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Function, Error from error_messages'."> errstd") or diag($return_error);


##################
# Select Function ,Error from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error'@@ROW='$Function;$Error'@@SIZE='20s;4n'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1
TEST;2
TEST;3
TEST;4
TEST;5
TEST;6
TEST;7
TEST;8
TEST;9
TEST_${TESTVAR};0
Check;65
Insert;8
Insert;97
Modify;8
Modify;68
Modify;97
Remove;68
Replace;8
Replace;68
Replace;97
generic;1
generic;2
generic;3
generic;4
generic;5
generic;6
generic;7
generic;8
generic;9
generic;10
generic;11
generic;12
generic;13
generic;14
generic;15
generic;16
generic;17
generic;18
generic;19
generic;20
generic;21
generic;22
generic;23
generic;24
generic;25
generic;26
generic;27
generic;28
generic;29
generic;30
generic;31
generic;32
generic;33
generic;34
generic;35
generic;36
generic;37
generic;38
generic;39
generic;40
generic;41
generic;42
generic;43
generic;44
generic;45
generic;46
generic;47
generic;48
generic;49
generic;50
generic;51
generic;52
generic;53
generic;54
generic;55
generic;56
generic;57
generic;58
generic;59
generic;60
generic;61
generic;62
generic;63
generic;64
generic;65
generic;66
generic;67
generic;68
generic;69
generic;70
generic;71
generic;72
generic;73
generic;74
generic;75
generic;76
generic;77
generic;78
generic;79
generic;80
generic;81
generic;82
generic;83
generic;84
generic;85
generic;86
generic;87
generic;88
generic;89
generic;90
generic;91
generic;92
generic;93
generic;94
generic;95
generic;96
generic;97
generic;98
generic;99
generic;100
generic;101
generic;102
generic;103
generic;104
generic;105
generic;106
generic;107
generic;108
generic;109
generic;110
generic;111
generic;112
generic;113
generic;114
generic;115
generic;116
generic;117
generic;118
generic;119
generic;120
generic;121
generic;122
generic;123
generic;124
generic;125
generic;126
generic;127
generic;128
generic;129
generic;130
generic;131
generic;132
generic;133
generic;134
generic;148
generic;149
generic;150
generic;151
generic;152
V1_alim_30_motcle;0001
V1_alim_30_motcle;0002
V1_alim_30_motcle;0003
V1_alim_30_motcle;0004
V1_alim_40_meth;0001
V1_alim_40_meth;0002
V1_alim_40_meth;0003
V1_alim_40_meth;0004
PC_CHGSTAT_SERV;0004
generic;301
generic;302
generic;303
generic;304
generic;305
generic;306
generic;308
generic;309
generic;310
generic;311
generic;312
generic;313
generic;314
generic;315
generic;316
generic;317
generic;318
generic;319
generic;320
generic;321
generic;401
generic;402
generic;403
generic;404
generic;405
generic;406
generic;408
generic;409
generic;410
generic;411
generic;412
generic;413
generic;414
generic;415
generic;416
generic;417
generic;420
ME_CREATE_SYNORA;0001
ME_DROP_SYNORA;0001
ME_LOAD_TABORA;0001
ME_RESTORE_TABORA;0001
ME_SECURE_TABORA;0001
ME_SECURE_TABORA;0002
ME_SECURE_TABORA;0003
ME_SECURE_TABORA;0004
ME_SECURE_TABORA;0365
ME_TRUNC_TABORA;176
PC_BACK_TBSORA;137
PC_BACK_TBSORA;138
PC_BACK_TBSORA;139
PC_LISTBACK_ARCHORA;0001
PC_LISTBACK_ARCHORA;0002
PC_LISTBACK_CTRLORA;128
PC_LISTBACK_CTRLORA;132
PC_LISTID_INSORA;182
PC_SWITCH_LOGORA;127
PC_SWITCH_LOGORA;128
generic;501
generic;502
generic;503
generic;504
generic;505
generic;506
generic;507
generic;508
generic;509
generic;510
generic;511
generic;512
generic;513
generic;514
generic;515
generic;517
generic;518
generic;519
generic;520
PC_INITF_SQLNET;004
FT_LISTLST_SQLNET;346
FT_LIST_TNSNAME;346
PC_ENV_SQLNET;506
PC_LISTID_SQLNET;182
PC_STAT_TNSNAME;001
PC_STAT_TNSNAME;002
PC_STAT_TNSNAME;003

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Function ,Error from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Function ,Error from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Function ,Error from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Function ,Error from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Function ,Error from error_messages'."> errstd") or diag($return_error);


##################
# Select Function , Error from error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error'@@ROW='$Function;$Error'@@SIZE='20s;4n'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1
TEST;2
TEST;3
TEST;4
TEST;5
TEST;6
TEST;7
TEST;8
TEST;9
TEST_${TESTVAR};0
Check;65
Insert;8
Insert;97
Modify;8
Modify;68
Modify;97
Remove;68
Replace;8
Replace;68
Replace;97
generic;1
generic;2
generic;3
generic;4
generic;5
generic;6
generic;7
generic;8
generic;9
generic;10
generic;11
generic;12
generic;13
generic;14
generic;15
generic;16
generic;17
generic;18
generic;19
generic;20
generic;21
generic;22
generic;23
generic;24
generic;25
generic;26
generic;27
generic;28
generic;29
generic;30
generic;31
generic;32
generic;33
generic;34
generic;35
generic;36
generic;37
generic;38
generic;39
generic;40
generic;41
generic;42
generic;43
generic;44
generic;45
generic;46
generic;47
generic;48
generic;49
generic;50
generic;51
generic;52
generic;53
generic;54
generic;55
generic;56
generic;57
generic;58
generic;59
generic;60
generic;61
generic;62
generic;63
generic;64
generic;65
generic;66
generic;67
generic;68
generic;69
generic;70
generic;71
generic;72
generic;73
generic;74
generic;75
generic;76
generic;77
generic;78
generic;79
generic;80
generic;81
generic;82
generic;83
generic;84
generic;85
generic;86
generic;87
generic;88
generic;89
generic;90
generic;91
generic;92
generic;93
generic;94
generic;95
generic;96
generic;97
generic;98
generic;99
generic;100
generic;101
generic;102
generic;103
generic;104
generic;105
generic;106
generic;107
generic;108
generic;109
generic;110
generic;111
generic;112
generic;113
generic;114
generic;115
generic;116
generic;117
generic;118
generic;119
generic;120
generic;121
generic;122
generic;123
generic;124
generic;125
generic;126
generic;127
generic;128
generic;129
generic;130
generic;131
generic;132
generic;133
generic;134
generic;148
generic;149
generic;150
generic;151
generic;152
V1_alim_30_motcle;0001
V1_alim_30_motcle;0002
V1_alim_30_motcle;0003
V1_alim_30_motcle;0004
V1_alim_40_meth;0001
V1_alim_40_meth;0002
V1_alim_40_meth;0003
V1_alim_40_meth;0004
PC_CHGSTAT_SERV;0004
generic;301
generic;302
generic;303
generic;304
generic;305
generic;306
generic;308
generic;309
generic;310
generic;311
generic;312
generic;313
generic;314
generic;315
generic;316
generic;317
generic;318
generic;319
generic;320
generic;321
generic;401
generic;402
generic;403
generic;404
generic;405
generic;406
generic;408
generic;409
generic;410
generic;411
generic;412
generic;413
generic;414
generic;415
generic;416
generic;417
generic;420
ME_CREATE_SYNORA;0001
ME_DROP_SYNORA;0001
ME_LOAD_TABORA;0001
ME_RESTORE_TABORA;0001
ME_SECURE_TABORA;0001
ME_SECURE_TABORA;0002
ME_SECURE_TABORA;0003
ME_SECURE_TABORA;0004
ME_SECURE_TABORA;0365
ME_TRUNC_TABORA;176
PC_BACK_TBSORA;137
PC_BACK_TBSORA;138
PC_BACK_TBSORA;139
PC_LISTBACK_ARCHORA;0001
PC_LISTBACK_ARCHORA;0002
PC_LISTBACK_CTRLORA;128
PC_LISTBACK_CTRLORA;132
PC_LISTID_INSORA;182
PC_SWITCH_LOGORA;127
PC_SWITCH_LOGORA;128
generic;501
generic;502
generic;503
generic;504
generic;505
generic;506
generic;507
generic;508
generic;509
generic;510
generic;511
generic;512
generic;513
generic;514
generic;515
generic;517
generic;518
generic;519
generic;520
PC_INITF_SQLNET;004
FT_LISTLST_SQLNET;346
FT_LIST_TNSNAME;346
PC_ENV_SQLNET;506
PC_LISTID_SQLNET;182
PC_STAT_TNSNAME;001
PC_STAT_TNSNAME;002
PC_STAT_TNSNAME;003

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Function , Error from error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Function , Error from error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Function , Error from error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Function , Error from error_messages'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Function , Error from error_messages'."> errstd") or diag($return_error);


##################
# Select Function , Error from error_messages_doublesep
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'@@FORMAT='Function%%Error'@@ROW='$Function%%$Error'@@SIZE='20s%%4n'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function%%Error'
TEST%%1
TEST%%2
TEST%%3
TEST%%4
Check%%65
PATH%%120
Insert%%8
Insert%%97
Modify%%8
Modify%%68
Modify%%97
Remove%%68
Replace%%8
Replace%%68
Replace%%97
generic%%1
generic%%2
generic%%3
generic%%4
generic%%5
generic%%6
generic%%7
generic%%8
generic%%9
generic%%10
generic%%11
generic%%12
generic%%13
generic%%14
generic%%15
generic%%16
generic%%17
generic%%18
generic%%19
generic%%20
generic%%21
generic%%22
generic%%23
generic%%24
generic%%25
generic%%26
generic%%27
generic%%28
generic%%29
generic%%30
generic%%31
generic%%32
generic%%33
generic%%34
generic%%35
generic%%36
generic%%37
generic%%38
generic%%39
generic%%40
generic%%41
generic%%42
generic%%43
generic%%44
generic%%45
generic%%46
generic%%47
generic%%48
generic%%49
generic%%50
generic%%51
generic%%52
generic%%53
generic%%54
generic%%55
generic%%56
generic%%57
generic%%58
generic%%59
generic%%60
generic%%61
generic%%62
generic%%63
generic%%64
generic%%65
generic%%66
generic%%67
generic%%68
generic%%69
generic%%70
generic%%71
generic%%72
generic%%73
generic%%74
generic%%75
generic%%76
generic%%77
generic%%78
generic%%79
generic%%80
generic%%81
generic%%82
generic%%83
generic%%84
generic%%85
generic%%86
generic%%87
generic%%88
generic%%89
generic%%90
generic%%91
generic%%92
generic%%93
generic%%94
generic%%95
generic%%96
generic%%97
generic%%98
generic%%99
generic%%100
generic%%101
generic%%102
generic%%103
generic%%104
generic%%105
generic%%106
generic%%107
generic%%108
generic%%109
generic%%110
generic%%111
generic%%112
generic%%113
generic%%114
generic%%115
generic%%116
generic%%117
generic%%118
generic%%119
generic%%120
generic%%121
generic%%122
generic%%123
generic%%124
generic%%125
generic%%126
generic%%127
generic%%128
generic%%129
generic%%130
generic%%131
generic%%132
generic%%133
generic%%134
generic%%148
generic%%149
generic%%150
generic%%151
generic%%152
V1_alim_30_motcle%%0001
V1_alim_30_motcle%%0002
V1_alim_30_motcle%%0003
V1_alim_30_motcle%%0004
V1_alim_40_meth%%0001
V1_alim_40_meth%%0002
V1_alim_40_meth%%0003
V1_alim_40_meth%%0004
PC_CHGSTAT_SERV%%0004
generic%%301
generic%%302
generic%%303
generic%%304
generic%%305
generic%%306
generic%%308
generic%%309
generic%%310
generic%%311
generic%%312
generic%%313
generic%%314
generic%%315
generic%%316
generic%%317
generic%%318
generic%%319
generic%%320
generic%%321
generic%%401
generic%%402
generic%%403
generic%%404
generic%%405
generic%%406
generic%%408
generic%%409
generic%%410
generic%%411
generic%%412
generic%%413
generic%%414
generic%%415
generic%%416
generic%%417
generic%%420
ME_CREATE_SYNORA%%0001
ME_DROP_SYNORA%%0001
ME_LOAD_TABORA%%0001
ME_RESTORE_TABORA%%0001
ME_SECURE_TABORA%%0001
ME_SECURE_TABORA%%0002
ME_SECURE_TABORA%%0003
ME_SECURE_TABORA%%0004
ME_SECURE_TABORA%%0365
ME_TRUNC_TABORA%%176
PC_BACK_TBSORA%%137
PC_BACK_TBSORA%%138
PC_BACK_TBSORA%%139
PC_LISTBACK_ARCHORA%%0001
PC_LISTBACK_ARCHORA%%0002
PC_LISTBACK_CTRLORA%%128
PC_LISTBACK_CTRLORA%%132
PC_LISTID_INSORA%%182
PC_SWITCH_LOGORA%%127
PC_SWITCH_LOGORA%%128
generic%%501
generic%%502
generic%%503
generic%%504
generic%%505
generic%%506
generic%%507
generic%%508
generic%%509
generic%%510
generic%%511
generic%%512
generic%%513
generic%%514
generic%%515
generic%%517
generic%%518
generic%%519
generic%%520
PC_INITF_SQLNET%%004
FT_LISTLST_SQLNET%%346
FT_LIST_TNSNAME%%346
PC_ENV_SQLNET%%506
PC_LISTID_SQLNET%%182
PC_STAT_TNSNAME%%001
PC_STAT_TNSNAME%%002
PC_STAT_TNSNAME%%003

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Function , Error from error_messages_doublesep', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Function , Error from error_messages_doublesep'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Function , Error from error_messages_doublesep'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Function , Error from error_messages_doublesep'."> output <".q{SEP='%%'@@...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Function , Error from error_messages_doublesep'."> errstd") or diag($return_error);


##################
# Select from error_messages ORDER_BY
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
Check;65;Non unicite de la clef
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages ORDER_BY', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages ORDER_BY'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages ORDER_BY'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages ORDER_BY'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages ORDER_BY'."> errstd") or diag($return_error);


##################
# Select from error_messages ORDER_BY Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
generic;100;%s
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
generic;520;Aucun Archive Oracle pour la Base %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;68;Aucune ligne trouvee
Modify;68;Aucune ligne trouvee a modifier
Replace;68;Aucune ligne trouvee a remplacer
Remove;68;Aucune ligne trouvee a supprimer
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;97;Aucune valeur donnee
generic;116;Des enregistrements ont ete rejetes pour la table %s
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
generic;69;Entete de definition invalide !
generic;107;Environnement %s non accessible
generic;308;Erreur a l'execution de %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;75;Erreur generique Oracle : %s
generic;25;Erreur lors d'une allocation de memoire %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;409;Erreur lors de l'initialisation du fichier %s
generic;29;Erreur lors de la fermeture de la librairie %s !
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;115;Erreur lors du chargement de la table %s
generic;104;Erreur lors du delete sur %s
generic;113;Erreur lors du disable de contraintes de %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;71;Il n'y a pas de lignes en entree stdin !
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;11;Impossible d'ecrire dans le fichier %s
generic;52;Impossible d'ecrire dans le fichier log %s
generic;403;Impossible d'ecrire dans le repertoire %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;10;Impossible d'ouvrir le fichier %s
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;13;Impossible de changer les droits sur le fichier %s
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;15;Impossible de copier le fichier %s
generic;120;Impossible de creer le fichier %s
generic;402;Impossible de creer le repertoire %s
generic;87;Impossible de creer un nouveau processus %s !
generic;53;Impossible de determiner le nom du traitement
generic;404;Impossible de lire le contenu du repertoire %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;37;Impossible de poser un verrou sur le fichier %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;40;Impossible de retirer le verrou du fichier %s
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;110;Impossible de retrouver l'objet %s
generic;44;Impossible de retrouver la librairie %s !
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;48;Impossible de retrouver le fichier de menu %s
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;12;Impossible de supprimer le fichier %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
generic;1;Impossible de trouver l'executable %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
generic;2;Impossible de trouver la table %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;4;Impossible de trouver le fichier %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;514;L'archivage de %s n'est pas arrete correctement
generic;513;L'archivage de %s n'est pas demarre correctement
generic;22;L'argument %s n'est pas valide
generic;19;L'evaluation de <%s> est incorrecte !
generic;502;L'instance Oracle %s n'est pas arretee
generic;501;L'instance Oracle %s n'est pas demarree
generic;302;L'instance de service %s ne semble pas exister.
generic;152;L'intance %s est invalide ou non demarrée.
generic;96;L'operateur de selection est incorrect !
generic;20;L'option %s n'est pas valide
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;102;L'utilisateur %s n'existe pas
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;60;La colonne %s doit absolument contenir une valeur
generic;7;La colonne %s n'existe pas
generic;17;La commande <%s> a echoue
Insert;8;La condition de selection de cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
generic;8;La condition de selection n'est pas valide
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
generic;117;La contrainte %s est invalide !
generic;134;La date '%s' ne correspond pas au format %s.
generic;32;La licence n'est pas valide !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;6;La table %s est une table virtuelle
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;111;La table %s existe sous plusieurs schemas
generic;319;La table %s n'est pas collectable.
generic;121;La table %s n'est pas une table de reference.
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;128;La table %s ne possede pas de cle primaire.
generic;98;La taille maximale %s d'une ligne est depassee !
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;105;La variable %s n'est pas du bon type
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;42;Le Handle d'une requete n'est pas valide
generic;31;Le Hostid de la machine n'est pas valide !
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;99;Le champ %s est mal decrit dans la table %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;415;Le device %s n'existe pas ou est indisponible
generic;36;Le fichier %s est verouille
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;39;Le fichier %s n'est pas verouille
generic;405;Le fichier %s n'existe pas ou est vide
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;5;Le fichier de definition %s n'est pas valide
generic;132;Le format de la date '%s' est invalide.
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;417;Le lecteur %s est inaccessible
generic;55;Le message d'information est manquant
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
generic;35;Le nom de fichier %s n'est pas valide
generic;64;Le nom de la table n'est pas specifie
generic;59;Le nom de table %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;34;Le nombre de clients pour ce produit est depasse !
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;43;Le nombre maximal de conditions est depasse
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;41;Le nombre maximal de selections simultanees est depasse
generic;88;Le nombre maximal de tables %s est depasse
generic;81;Le nouveau separateur n'est pas specifie !
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;54;Le numero d'erreur est manquant
generic;101;Le parametre %s n'est pas un chiffre
generic;401;Le repertoire %s n'existe pas
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;311;Le service %s '%s' est deja arrete.
generic;310;Le service %s '%s' est deja demarre.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;309;Le service %s '%s' n'existe pas.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
generic;131;Le tri de séléction '%s' est invalide.
generic;93;Le type de la colonne %s est invalide !
generic;125;Le type de la licence est invalide.
generic;58;Le type de message de log n'est pas correct
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;123;Les droits sur le fichier %s sont incorrects.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;24;Ligne de commande incorrecte
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
Check;65;Non unicite de la clef
generic;65;Non unicite de la clef de la ligne a inserer
generic;89;Option ou suffixe de recherche invalide !
generic;130;Options de commande %s incompatibles
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
generic;149;Probleme d'environnement %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
generic;412;Probleme lors de la compression de %s
generic;416;Probleme lors de la creation du lien vers %s
generic;411;Probleme lors de la decompression de %s
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;518;Probleme lors de la suppression de la table %s 
generic;106;Probleme lors du chargement de l'environnement %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
generic;108;Probleme pour acceder a la table %s
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
generic;112;Probleme pour recuperer les contraintes de %s
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
generic;515;Script SQL %s non accessible
generic;45;Un Handle n'est pas valide
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;23;Utilisation incorrecte de l'option -h
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;30;Votre licence d'utilisation %s a expire !
generic;148;Vous n'avez pas les droits %s.
generic;86;Vous ne pouvez pas remplacer une cle !
TEST;3;test avec " des " double quote
TEST;2;test avec ' des ' quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;7;test avec des $variables $TESTVAR
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
TEST;6;test avec trop de ; separ;ateurs;
TEST;1;test sans quote

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages ORDER_BY Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages ORDER_BY Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages ORDER_BY Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages ORDER_BY Message'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages ORDER_BY Message'."> errstd") or diag($return_error);


##################
# Select from error_messages ORDER_BY Message ASC
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
generic;100;%s
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
generic;520;Aucun Archive Oracle pour la Base %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;68;Aucune ligne trouvee
Modify;68;Aucune ligne trouvee a modifier
Replace;68;Aucune ligne trouvee a remplacer
Remove;68;Aucune ligne trouvee a supprimer
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;97;Aucune valeur donnee
generic;116;Des enregistrements ont ete rejetes pour la table %s
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
generic;69;Entete de definition invalide !
generic;107;Environnement %s non accessible
generic;308;Erreur a l'execution de %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;75;Erreur generique Oracle : %s
generic;25;Erreur lors d'une allocation de memoire %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;409;Erreur lors de l'initialisation du fichier %s
generic;29;Erreur lors de la fermeture de la librairie %s !
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;115;Erreur lors du chargement de la table %s
generic;104;Erreur lors du delete sur %s
generic;113;Erreur lors du disable de contraintes de %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;71;Il n'y a pas de lignes en entree stdin !
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;11;Impossible d'ecrire dans le fichier %s
generic;52;Impossible d'ecrire dans le fichier log %s
generic;403;Impossible d'ecrire dans le repertoire %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;10;Impossible d'ouvrir le fichier %s
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;13;Impossible de changer les droits sur le fichier %s
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;15;Impossible de copier le fichier %s
generic;120;Impossible de creer le fichier %s
generic;402;Impossible de creer le repertoire %s
generic;87;Impossible de creer un nouveau processus %s !
generic;53;Impossible de determiner le nom du traitement
generic;404;Impossible de lire le contenu du repertoire %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;37;Impossible de poser un verrou sur le fichier %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;40;Impossible de retirer le verrou du fichier %s
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;110;Impossible de retrouver l'objet %s
generic;44;Impossible de retrouver la librairie %s !
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;48;Impossible de retrouver le fichier de menu %s
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;12;Impossible de supprimer le fichier %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
generic;1;Impossible de trouver l'executable %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
generic;2;Impossible de trouver la table %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;4;Impossible de trouver le fichier %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;514;L'archivage de %s n'est pas arrete correctement
generic;513;L'archivage de %s n'est pas demarre correctement
generic;22;L'argument %s n'est pas valide
generic;19;L'evaluation de <%s> est incorrecte !
generic;502;L'instance Oracle %s n'est pas arretee
generic;501;L'instance Oracle %s n'est pas demarree
generic;302;L'instance de service %s ne semble pas exister.
generic;152;L'intance %s est invalide ou non demarrée.
generic;96;L'operateur de selection est incorrect !
generic;20;L'option %s n'est pas valide
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;102;L'utilisateur %s n'existe pas
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;60;La colonne %s doit absolument contenir une valeur
generic;7;La colonne %s n'existe pas
generic;17;La commande <%s> a echoue
Insert;8;La condition de selection de cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
generic;8;La condition de selection n'est pas valide
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
generic;117;La contrainte %s est invalide !
generic;134;La date '%s' ne correspond pas au format %s.
generic;32;La licence n'est pas valide !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;6;La table %s est une table virtuelle
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;111;La table %s existe sous plusieurs schemas
generic;319;La table %s n'est pas collectable.
generic;121;La table %s n'est pas une table de reference.
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;128;La table %s ne possede pas de cle primaire.
generic;98;La taille maximale %s d'une ligne est depassee !
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;105;La variable %s n'est pas du bon type
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;42;Le Handle d'une requete n'est pas valide
generic;31;Le Hostid de la machine n'est pas valide !
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;99;Le champ %s est mal decrit dans la table %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;415;Le device %s n'existe pas ou est indisponible
generic;36;Le fichier %s est verouille
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;39;Le fichier %s n'est pas verouille
generic;405;Le fichier %s n'existe pas ou est vide
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;5;Le fichier de definition %s n'est pas valide
generic;132;Le format de la date '%s' est invalide.
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;417;Le lecteur %s est inaccessible
generic;55;Le message d'information est manquant
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
generic;35;Le nom de fichier %s n'est pas valide
generic;64;Le nom de la table n'est pas specifie
generic;59;Le nom de table %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;34;Le nombre de clients pour ce produit est depasse !
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;43;Le nombre maximal de conditions est depasse
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;41;Le nombre maximal de selections simultanees est depasse
generic;88;Le nombre maximal de tables %s est depasse
generic;81;Le nouveau separateur n'est pas specifie !
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;54;Le numero d'erreur est manquant
generic;101;Le parametre %s n'est pas un chiffre
generic;401;Le repertoire %s n'existe pas
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;311;Le service %s '%s' est deja arrete.
generic;310;Le service %s '%s' est deja demarre.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;309;Le service %s '%s' n'existe pas.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
generic;131;Le tri de séléction '%s' est invalide.
generic;93;Le type de la colonne %s est invalide !
generic;125;Le type de la licence est invalide.
generic;58;Le type de message de log n'est pas correct
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;123;Les droits sur le fichier %s sont incorrects.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;24;Ligne de commande incorrecte
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
Check;65;Non unicite de la clef
generic;65;Non unicite de la clef de la ligne a inserer
generic;89;Option ou suffixe de recherche invalide !
generic;130;Options de commande %s incompatibles
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
generic;149;Probleme d'environnement %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
generic;412;Probleme lors de la compression de %s
generic;416;Probleme lors de la creation du lien vers %s
generic;411;Probleme lors de la decompression de %s
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;518;Probleme lors de la suppression de la table %s 
generic;106;Probleme lors du chargement de l'environnement %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
generic;108;Probleme pour acceder a la table %s
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
generic;112;Probleme pour recuperer les contraintes de %s
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
generic;515;Script SQL %s non accessible
generic;45;Un Handle n'est pas valide
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;23;Utilisation incorrecte de l'option -h
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;30;Votre licence d'utilisation %s a expire !
generic;148;Vous n'avez pas les droits %s.
generic;86;Vous ne pouvez pas remplacer une cle !
TEST;3;test avec " des " double quote
TEST;2;test avec ' des ' quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;7;test avec des $variables $TESTVAR
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
TEST;6;test avec trop de ; separ;ateurs;
TEST;1;test sans quote

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages ORDER_BY Message ASC', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages ORDER_BY Message ASC'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages ORDER_BY Message ASC'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages ORDER_BY Message ASC'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages ORDER_BY Message ASC'."> errstd") or diag($return_error);


##################
# Select from error_messages ORDER_BY Message DESC
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST;1;test sans quote
TEST;6;test avec trop de ; separ;ateurs;
TEST_${TESTVAR};0;test avec des une clef contenant une variable
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;5;test avec \\ echappements \n
TEST;4;test avec \" des \' quote echappees
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
generic;86;Vous ne pouvez pas remplacer une cle !
generic;148;Vous n'avez pas les droits %s.
generic;30;Votre licence d'utilisation %s a expire !
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;23;Utilisation incorrecte de l'option -h
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;45;Un Handle n'est pas valide
generic;515;Script SQL %s non accessible
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;112;Probleme pour recuperer les contraintes de %s
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
generic;108;Probleme pour acceder a la table %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
generic;106;Probleme lors du chargement de l'environnement %s
generic;518;Probleme lors de la suppression de la table %s 
generic;413;Probleme lors de la securisation/compression de %s
generic;410;Probleme lors de la restauration/decompression de %s
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
generic;411;Probleme lors de la decompression de %s
generic;416;Probleme lors de la creation du lien vers %s
generic;412;Probleme lors de la compression de %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
generic;149;Probleme d'environnement %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;130;Options de commande %s incompatibles
generic;89;Option ou suffixe de recherche invalide !
generic;65;Non unicite de la clef de la ligne a inserer
Check;65;Non unicite de la clef
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;24;Ligne de commande incorrecte
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;58;Le type de message de log n'est pas correct
generic;125;Le type de la licence est invalide.
generic;93;Le type de la colonne %s est invalide !
generic;131;Le tri de séléction '%s' est invalide.
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;309;Le service %s '%s' n'existe pas.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;303;Le script fils <%s> a retourne un warning
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;401;Le repertoire %s n'existe pas
generic;101;Le parametre %s n'est pas un chiffre
generic;54;Le numero d'erreur est manquant
generic;57;Le numero d'erreur %s n'est pas correct
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;81;Le nouveau separateur n'est pas specifie !
generic;88;Le nombre maximal de tables %s est depasse
generic;41;Le nombre maximal de selections simultanees est depasse
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;43;Le nombre maximal de conditions est depasse
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;34;Le nombre de clients pour ce produit est depasse !
generic;21;Le nombre d'arguments est incorrect
generic;59;Le nom de table %s n'est pas valide
generic;64;Le nom de la table n'est pas specifie
generic;35;Le nom de fichier %s n'est pas valide
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;55;Le message d'information est manquant
generic;417;Le lecteur %s est inaccessible
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;132;Le format de la date '%s' est invalide.
generic;5;Le fichier de definition %s n'est pas valide
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;405;Le fichier %s n'existe pas ou est vide
generic;39;Le fichier %s n'est pas verouille
generic;408;Le fichier %s n'est pas au format %s
generic;406;Le fichier %s existe deja
generic;36;Le fichier %s est verouille
generic;415;Le device %s n'existe pas ou est indisponible
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;99;Le champ %s est mal decrit dans la table %s
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;31;Le Hostid de la machine n'est pas valide !
generic;42;Le Handle d'une requete n'est pas valide
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;105;La variable %s n'est pas du bon type
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;98;La taille maximale %s d'une ligne est depassee !
generic;128;La table %s ne possede pas de cle primaire.
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;121;La table %s n'est pas une table de reference.
generic;319;La table %s n'est pas collectable.
generic;111;La table %s existe sous plusieurs schemas
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;6;La table %s est une table virtuelle
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;80;La requete interne SQL s'est terminee en erreur !
generic;32;La licence n'est pas valide !
generic;134;La date '%s' ne correspond pas au format %s.
generic;117;La contrainte %s est invalide !
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
generic;8;La condition de selection n'est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Insert;8;La condition de selection de cle n'est pas valide
generic;17;La commande <%s> a echoue
generic;7;La colonne %s n'existe pas
generic;60;La colonne %s doit absolument contenir une valeur
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;102;L'utilisateur %s n'existe pas
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;20;L'option %s n'est pas valide
generic;96;L'operateur de selection est incorrect !
generic;152;L'intance %s est invalide ou non demarrée.
generic;302;L'instance de service %s ne semble pas exister.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;19;L'evaluation de <%s> est incorrecte !
generic;22;L'argument %s n'est pas valide
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;2;Impossible de trouver la table %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
generic;1;Impossible de trouver l'executable %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
generic;12;Impossible de supprimer le fichier %s
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;94;Impossible de retrouver le formulaire %s
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;44;Impossible de retrouver la librairie %s !
generic;110;Impossible de retrouver l'objet %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;40;Impossible de retirer le verrou du fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;67;Impossible de remplacer une ligne sur une table sans clef
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
generic;37;Impossible de poser un verrou sur le fichier %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;404;Impossible de lire le contenu du repertoire %s
generic;53;Impossible de determiner le nom du traitement
generic;87;Impossible de creer un nouveau processus %s !
generic;402;Impossible de creer le repertoire %s
generic;120;Impossible de creer le fichier %s
generic;15;Impossible de copier le fichier %s
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;13;Impossible de changer les droits sur le fichier %s
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;10;Impossible d'ouvrir le fichier %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;52;Impossible d'ecrire dans le fichier log %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
generic;71;Il n'y a pas de lignes en entree stdin !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
generic;113;Erreur lors du disable de contraintes de %s
generic;104;Erreur lors du delete sur %s
generic;115;Erreur lors du chargement de la table %s
generic;27;Erreur lors du chargement de la librairie %s !
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;409;Erreur lors de l'initialisation du fichier %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;114;Erreur lors de l'enable de contraintes de %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;25;Erreur lors d'une allocation de memoire %s
generic;75;Erreur generique Oracle : %s
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
generic;308;Erreur a l'execution de %s
generic;107;Environnement %s non accessible
generic;69;Entete de definition invalide !
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;97;Aucune valeur donnee
Replace;97;Aucune valeur a remplacer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Insert;97;Aucune valeur a inserer n'est specifiee
Remove;68;Aucune ligne trouvee a supprimer
Replace;68;Aucune ligne trouvee a remplacer
Modify;68;Aucune ligne trouvee a modifier
generic;68;Aucune ligne trouvee
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
generic;520;Aucun Archive Oracle pour la Base %s
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;100;%s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages ORDER_BY Message DESC', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages ORDER_BY Message DESC'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages ORDER_BY Message DESC'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages ORDER_BY Message DESC'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages ORDER_BY Message DESC'."> errstd") or diag($return_error);


##################
# Select from error_messages ORDER_BY Error,Function
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST_${TESTVAR};0;test avec des une clef contenant une variable
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
TEST;1;test sans quote
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
generic;1;Impossible de trouver l'executable %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
TEST;2;test avec ' des ' quote
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
generic;2;Impossible de trouver la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
TEST;3;test avec " des " double quote
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
TEST;4;test avec \" des \' quote echappees
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;4;Impossible de trouver le fichier %s
TEST;5;test avec \\ echappements \n
generic;5;Le fichier de definition %s n'est pas valide
TEST;6;test avec trop de ; separ;ateurs;
generic;6;La table %s est une table virtuelle
TEST;7;test avec des $variables $TESTVAR
generic;7;La colonne %s n'existe pas
Insert;8;La condition de selection de cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
TEST;8;test avec des $variables $(echo "commande evaluee")
generic;8;La condition de selection n'est pas valide
TEST;9;test avec des $variables `echo "commande evaluee"`
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
Check;65;Non unicite de la clef
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
Modify;68;Aucune ligne trouvee a modifier
Remove;68;Aucune ligne trouvee a supprimer
Replace;68;Aucune ligne trouvee a remplacer
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
generic;127;Les colonnes %s doivent absolument contenir une valeur.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages ORDER_BY Error,Function', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages ORDER_BY Error,Function'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages ORDER_BY Error,Function'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages ORDER_BY Error,Function'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages ORDER_BY Error,Function'."> errstd") or diag($return_error);


##################
# Select from error_messages ORDER_BY Error DESC , Function ASC
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
generic;520;Aucun Archive Oracle pour la Base %s
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;518;Probleme lors de la suppression de la table %s 
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;515;Script SQL %s non accessible
generic;514;L'archivage de %s n'est pas arrete correctement
generic;513;L'archivage de %s n'est pas demarre correctement
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;507;Impossible de retrouver l'init file de la base %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;502;L'instance Oracle %s n'est pas arretee
generic;501;L'instance Oracle %s n'est pas demarree
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;417;Le lecteur %s est inaccessible
generic;416;Probleme lors de la creation du lien vers %s
generic;415;Le device %s n'existe pas ou est indisponible
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;413;Probleme lors de la securisation/compression de %s
generic;412;Probleme lors de la compression de %s
generic;411;Probleme lors de la decompression de %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;408;Le fichier %s n'est pas au format %s
generic;406;Le fichier %s existe deja
generic;405;Le fichier %s n'existe pas ou est vide
generic;404;Impossible de lire le contenu du repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;402;Impossible de creer le repertoire %s
generic;401;Le repertoire %s n'existe pas
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;319;La table %s n'est pas collectable.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;311;Le service %s '%s' est deja arrete.
generic;310;Le service %s '%s' est deja demarre.
generic;309;Le service %s '%s' n'existe pas.
generic;308;Erreur a l'execution de %s
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;303;Le script fils <%s> a retourne un warning
generic;302;L'instance de service %s ne semble pas exister.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
generic;152;L'intance %s est invalide ou non demarrée.
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;149;Probleme d'environnement %s
generic;148;Vous n'avez pas les droits %s.
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
generic;134;La date '%s' ne correspond pas au format %s.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
generic;132;Le format de la date '%s' est invalide.
generic;131;Le tri de séléction '%s' est invalide.
generic;130;Options de commande %s incompatibles
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;128;La table %s ne possede pas de cle primaire.
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;125;Le type de la licence est invalide.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;121;La table %s n'est pas une table de reference.
generic;120;Impossible de creer le fichier %s
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;117;La contrainte %s est invalide !
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;115;Erreur lors du chargement de la table %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;112;Probleme pour recuperer les contraintes de %s
generic;111;La table %s existe sous plusieurs schemas
generic;110;Impossible de retrouver l'objet %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;108;Probleme pour acceder a la table %s
generic;107;Environnement %s non accessible
generic;106;Probleme lors du chargement de l'environnement %s
generic;105;La variable %s n'est pas du bon type
generic;104;Erreur lors du delete sur %s
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;102;L'utilisateur %s n'existe pas
generic;101;Le parametre %s n'est pas un chiffre
generic;100;%s
generic;99;Le champ %s est mal decrit dans la table %s
generic;98;La taille maximale %s d'une ligne est depassee !
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;97;Aucune valeur donnee
generic;96;L'operateur de selection est incorrect !
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;94;Impossible de retrouver le formulaire %s
generic;93;Le type de la colonne %s est invalide !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;89;Option ou suffixe de recherche invalide !
generic;88;Le nombre maximal de tables %s est depasse
generic;87;Impossible de creer un nouveau processus %s !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;81;Le nouveau separateur n'est pas specifie !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;75;Erreur generique Oracle : %s
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;69;Entete de definition invalide !
Modify;68;Aucune ligne trouvee a modifier
Remove;68;Aucune ligne trouvee a supprimer
Replace;68;Aucune ligne trouvee a remplacer
generic;68;Aucune ligne trouvee
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;66;Le groupe d'utilisateurs %s n'existe pas
Check;65;Non unicite de la clef
generic;65;Non unicite de la clef de la ligne a inserer
generic;64;Le nom de la table n'est pas specifie
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;60;La colonne %s doit absolument contenir une valeur
generic;59;Le nom de table %s n'est pas valide
generic;58;Le type de message de log n'est pas correct
generic;57;Le numero d'erreur %s n'est pas correct
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;55;Le message d'information est manquant
generic;54;Le numero d'erreur est manquant
generic;53;Impossible de determiner le nom du traitement
generic;52;Impossible d'ecrire dans le fichier log %s
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;50;Erreur lors de l'execution de la fonction de log
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;48;Impossible de retrouver le fichier de menu %s
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;45;Un Handle n'est pas valide
generic;44;Impossible de retrouver la librairie %s !
generic;43;Le nombre maximal de conditions est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;41;Le nombre maximal de selections simultanees est depasse
generic;40;Impossible de retirer le verrou du fichier %s
generic;39;Le fichier %s n'est pas verouille
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;37;Impossible de poser un verrou sur le fichier %s
generic;36;Le fichier %s est verouille
generic;35;Le nom de fichier %s n'est pas valide
generic;34;Le nombre de clients pour ce produit est depasse !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;32;La licence n'est pas valide !
generic;31;Le Hostid de la machine n'est pas valide !
generic;30;Votre licence d'utilisation %s a expire !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;27;Erreur lors du chargement de la librairie %s !
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;25;Erreur lors d'une allocation de memoire %s
generic;24;Ligne de commande incorrecte
generic;23;Utilisation incorrecte de l'option -h
generic;22;L'argument %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;20;L'option %s n'est pas valide
generic;19;L'evaluation de <%s> est incorrecte !
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;17;La commande <%s> a echoue
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;15;Impossible de copier le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;10;Impossible d'ouvrir le fichier %s
TEST;9;test avec des $variables `echo "commande evaluee"`
generic;9;La chaine de definition %s n'est pas valide ou est absente
Insert;8;La condition de selection de cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
TEST;8;test avec des $variables $(echo "commande evaluee")
generic;8;La condition de selection n'est pas valide
TEST;7;test avec des $variables $TESTVAR
generic;7;La colonne %s n'existe pas
TEST;6;test avec trop de ; separ;ateurs;
generic;6;La table %s est une table virtuelle
TEST;5;test avec \\ echappements \n
generic;5;Le fichier de definition %s n'est pas valide
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
TEST;4;test avec \" des \' quote echappees
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;4;Impossible de trouver le fichier %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
TEST;3;test avec " des " double quote
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
TEST;2;test avec ' des ' quote
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
generic;2;Impossible de trouver la table %s
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
TEST;1;test sans quote
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
generic;1;Impossible de trouver l'executable %s
TEST_${TESTVAR};0;test avec des une clef contenant une variable

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages ORDER_BY Error DESC , Function ASC', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages ORDER_BY Error DESC , Function ASC'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages ORDER_BY Error DESC , Function ASC'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages ORDER_BY Error DESC , Function ASC'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages ORDER_BY Error DESC , Function ASC'."> errstd") or diag($return_error);


##################
# Select from error_messages ORDER_BY Function,Error
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
Check;65;Non unicite de la clef
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages ORDER_BY Function,Error', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages ORDER_BY Function,Error'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages ORDER_BY Function,Error'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages ORDER_BY Function,Error'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages ORDER_BY Function,Error'."> errstd") or diag($return_error);


##################
# Select from error_messages_sort ORDER_BY
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
Check;65;Non unicite de la clef
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PATH;120;PATH=$PATH
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_sort ORDER_BY', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_sort ORDER_BY'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_sort ORDER_BY'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_sort ORDER_BY'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_sort ORDER_BY'."> errstd") or diag($return_error);


##################
# Select from error_messages_sort ORDER_BY Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
generic;100;%s
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
generic;520;Aucun Archive Oracle pour la Base %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;68;Aucune ligne trouvee
Modify;68;Aucune ligne trouvee a modifier
Replace;68;Aucune ligne trouvee a remplacer
Remove;68;Aucune ligne trouvee a supprimer
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;97;Aucune valeur donnee
generic;116;Des enregistrements ont ete rejetes pour la table %s
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
generic;69;Entete de definition invalide !
generic;107;Environnement %s non accessible
generic;308;Erreur a l'execution de %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;75;Erreur generique Oracle : %s
generic;25;Erreur lors d'une allocation de memoire %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;409;Erreur lors de l'initialisation du fichier %s
generic;29;Erreur lors de la fermeture de la librairie %s !
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;115;Erreur lors du chargement de la table %s
generic;104;Erreur lors du delete sur %s
generic;113;Erreur lors du disable de contraintes de %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;71;Il n'y a pas de lignes en entree stdin !
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;11;Impossible d'ecrire dans le fichier %s
generic;52;Impossible d'ecrire dans le fichier log %s
generic;403;Impossible d'ecrire dans le repertoire %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;10;Impossible d'ouvrir le fichier %s
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;13;Impossible de changer les droits sur le fichier %s
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;15;Impossible de copier le fichier %s
generic;120;Impossible de creer le fichier %s
generic;402;Impossible de creer le repertoire %s
generic;87;Impossible de creer un nouveau processus %s !
generic;53;Impossible de determiner le nom du traitement
generic;404;Impossible de lire le contenu du repertoire %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;37;Impossible de poser un verrou sur le fichier %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;40;Impossible de retirer le verrou du fichier %s
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;110;Impossible de retrouver l'objet %s
generic;44;Impossible de retrouver la librairie %s !
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;48;Impossible de retrouver le fichier de menu %s
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;12;Impossible de supprimer le fichier %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
generic;1;Impossible de trouver l'executable %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
generic;2;Impossible de trouver la table %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;4;Impossible de trouver le fichier %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;514;L'archivage de %s n'est pas arrete correctement
generic;513;L'archivage de %s n'est pas demarre correctement
generic;22;L'argument %s n'est pas valide
generic;19;L'evaluation de <%s> est incorrecte !
generic;502;L'instance Oracle %s n'est pas arretee
generic;501;L'instance Oracle %s n'est pas demarree
generic;302;L'instance de service %s ne semble pas exister.
generic;152;L'intance %s est invalide ou non demarrée.
generic;96;L'operateur de selection est incorrect !
generic;20;L'option %s n'est pas valide
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;102;L'utilisateur %s n'existe pas
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;60;La colonne %s doit absolument contenir une valeur
generic;7;La colonne %s n'existe pas
generic;17;La commande <%s> a echoue
Insert;8;La condition de selection de cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
generic;8;La condition de selection n'est pas valide
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
generic;117;La contrainte %s est invalide !
generic;134;La date '%s' ne correspond pas au format %s.
generic;32;La licence n'est pas valide !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;6;La table %s est une table virtuelle
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;111;La table %s existe sous plusieurs schemas
generic;319;La table %s n'est pas collectable.
generic;121;La table %s n'est pas une table de reference.
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;128;La table %s ne possede pas de cle primaire.
generic;98;La taille maximale %s d'une ligne est depassee !
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;105;La variable %s n'est pas du bon type
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;42;Le Handle d'une requete n'est pas valide
generic;31;Le Hostid de la machine n'est pas valide !
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;99;Le champ %s est mal decrit dans la table %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;415;Le device %s n'existe pas ou est indisponible
generic;36;Le fichier %s est verouille
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;39;Le fichier %s n'est pas verouille
generic;405;Le fichier %s n'existe pas ou est vide
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;5;Le fichier de definition %s n'est pas valide
generic;132;Le format de la date '%s' est invalide.
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;417;Le lecteur %s est inaccessible
generic;55;Le message d'information est manquant
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
generic;35;Le nom de fichier %s n'est pas valide
generic;64;Le nom de la table n'est pas specifie
generic;59;Le nom de table %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;34;Le nombre de clients pour ce produit est depasse !
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;43;Le nombre maximal de conditions est depasse
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;41;Le nombre maximal de selections simultanees est depasse
generic;88;Le nombre maximal de tables %s est depasse
generic;81;Le nouveau separateur n'est pas specifie !
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;54;Le numero d'erreur est manquant
generic;101;Le parametre %s n'est pas un chiffre
generic;401;Le repertoire %s n'existe pas
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;311;Le service %s '%s' est deja arrete.
generic;310;Le service %s '%s' est deja demarre.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;309;Le service %s '%s' n'existe pas.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
generic;131;Le tri de séléction '%s' est invalide.
generic;93;Le type de la colonne %s est invalide !
generic;125;Le type de la licence est invalide.
generic;58;Le type de message de log n'est pas correct
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;123;Les droits sur le fichier %s sont incorrects.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;24;Ligne de commande incorrecte
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
Check;65;Non unicite de la clef
generic;65;Non unicite de la clef de la ligne a inserer
generic;89;Option ou suffixe de recherche invalide !
generic;130;Options de commande %s incompatibles
PATH;120;PATH=$PATH
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
generic;149;Probleme d'environnement %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
generic;412;Probleme lors de la compression de %s
generic;416;Probleme lors de la creation du lien vers %s
generic;411;Probleme lors de la decompression de %s
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;518;Probleme lors de la suppression de la table %s 
generic;106;Probleme lors du chargement de l'environnement %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
generic;108;Probleme pour acceder a la table %s
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
generic;112;Probleme pour recuperer les contraintes de %s
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
generic;515;Script SQL %s non accessible
generic;45;Un Handle n'est pas valide
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;23;Utilisation incorrecte de l'option -h
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;30;Votre licence d'utilisation %s a expire !
generic;148;Vous n'avez pas les droits %s.
generic;86;Vous ne pouvez pas remplacer une cle !
TEST;3;test avec " des " double quote
TEST;2;test avec ' des ' quote
TEST;4;test avec \" des \' quote echappees
TEST;1;test sans quote

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_sort ORDER_BY Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_sort ORDER_BY Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_sort ORDER_BY Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_sort ORDER_BY Message'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_sort ORDER_BY Message'."> errstd") or diag($return_error);


##################
# Select from error_messages_sort ORDER_BY Error DESC , Function ASC
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
generic;520;Aucun Archive Oracle pour la Base %s
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;518;Probleme lors de la suppression de la table %s 
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;515;Script SQL %s non accessible
generic;514;L'archivage de %s n'est pas arrete correctement
generic;513;L'archivage de %s n'est pas demarre correctement
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;507;Impossible de retrouver l'init file de la base %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;502;L'instance Oracle %s n'est pas arretee
generic;501;L'instance Oracle %s n'est pas demarree
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;417;Le lecteur %s est inaccessible
generic;416;Probleme lors de la creation du lien vers %s
generic;415;Le device %s n'existe pas ou est indisponible
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;413;Probleme lors de la securisation/compression de %s
generic;412;Probleme lors de la compression de %s
generic;411;Probleme lors de la decompression de %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;408;Le fichier %s n'est pas au format %s
generic;406;Le fichier %s existe deja
generic;405;Le fichier %s n'existe pas ou est vide
generic;404;Impossible de lire le contenu du repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;402;Impossible de creer le repertoire %s
generic;401;Le repertoire %s n'existe pas
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;319;La table %s n'est pas collectable.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;311;Le service %s '%s' est deja arrete.
generic;310;Le service %s '%s' est deja demarre.
generic;309;Le service %s '%s' n'existe pas.
generic;308;Erreur a l'execution de %s
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;303;Le script fils <%s> a retourne un warning
generic;302;L'instance de service %s ne semble pas exister.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
generic;152;L'intance %s est invalide ou non demarrée.
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;149;Probleme d'environnement %s
generic;148;Vous n'avez pas les droits %s.
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
generic;134;La date '%s' ne correspond pas au format %s.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
generic;132;Le format de la date '%s' est invalide.
generic;131;Le tri de séléction '%s' est invalide.
generic;130;Options de commande %s incompatibles
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
generic;128;La table %s ne possede pas de cle primaire.
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;125;Le type de la licence est invalide.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;121;La table %s n'est pas une table de reference.
PATH;120;PATH=$PATH
generic;120;Impossible de creer le fichier %s
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;117;La contrainte %s est invalide !
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;115;Erreur lors du chargement de la table %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;112;Probleme pour recuperer les contraintes de %s
generic;111;La table %s existe sous plusieurs schemas
generic;110;Impossible de retrouver l'objet %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;108;Probleme pour acceder a la table %s
generic;107;Environnement %s non accessible
generic;106;Probleme lors du chargement de l'environnement %s
generic;105;La variable %s n'est pas du bon type
generic;104;Erreur lors du delete sur %s
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;102;L'utilisateur %s n'existe pas
generic;101;Le parametre %s n'est pas un chiffre
generic;100;%s
generic;99;Le champ %s est mal decrit dans la table %s
generic;98;La taille maximale %s d'une ligne est depassee !
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;97;Aucune valeur a remplacer n'est specifiee
generic;97;Aucune valeur donnee
generic;96;L'operateur de selection est incorrect !
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;94;Impossible de retrouver le formulaire %s
generic;93;Le type de la colonne %s est invalide !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;89;Option ou suffixe de recherche invalide !
generic;88;Le nombre maximal de tables %s est depasse
generic;87;Impossible de creer un nouveau processus %s !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;81;Le nouveau separateur n'est pas specifie !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;75;Erreur generique Oracle : %s
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;69;Entete de definition invalide !
Modify;68;Aucune ligne trouvee a modifier
Remove;68;Aucune ligne trouvee a supprimer
Replace;68;Aucune ligne trouvee a remplacer
generic;68;Aucune ligne trouvee
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;66;Le groupe d'utilisateurs %s n'existe pas
Check;65;Non unicite de la clef
generic;65;Non unicite de la clef de la ligne a inserer
generic;64;Le nom de la table n'est pas specifie
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;60;La colonne %s doit absolument contenir une valeur
generic;59;Le nom de table %s n'est pas valide
generic;58;Le type de message de log n'est pas correct
generic;57;Le numero d'erreur %s n'est pas correct
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;55;Le message d'information est manquant
generic;54;Le numero d'erreur est manquant
generic;53;Impossible de determiner le nom du traitement
generic;52;Impossible d'ecrire dans le fichier log %s
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;50;Erreur lors de l'execution de la fonction de log
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;48;Impossible de retrouver le fichier de menu %s
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;45;Un Handle n'est pas valide
generic;44;Impossible de retrouver la librairie %s !
generic;43;Le nombre maximal de conditions est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;41;Le nombre maximal de selections simultanees est depasse
generic;40;Impossible de retirer le verrou du fichier %s
generic;39;Le fichier %s n'est pas verouille
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;37;Impossible de poser un verrou sur le fichier %s
generic;36;Le fichier %s est verouille
generic;35;Le nom de fichier %s n'est pas valide
generic;34;Le nombre de clients pour ce produit est depasse !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;32;La licence n'est pas valide !
generic;31;Le Hostid de la machine n'est pas valide !
generic;30;Votre licence d'utilisation %s a expire !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;27;Erreur lors du chargement de la librairie %s !
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;25;Erreur lors d'une allocation de memoire %s
generic;24;Ligne de commande incorrecte
generic;23;Utilisation incorrecte de l'option -h
generic;22;L'argument %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;20;L'option %s n'est pas valide
generic;19;L'evaluation de <%s> est incorrecte !
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;17;La commande <%s> a echoue
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;15;Impossible de copier le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;10;Impossible d'ouvrir le fichier %s
generic;9;La chaine de definition %s n'est pas valide ou est absente
Insert;8;La condition de selection de cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
generic;8;La condition de selection n'est pas valide
generic;7;La colonne %s n'existe pas
generic;6;La table %s est une table virtuelle
generic;5;Le fichier de definition %s n'est pas valide
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
TEST;4;test avec \" des \' quote echappees
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;4;Impossible de trouver le fichier %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
TEST;3;test avec " des " double quote
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
TEST;2;test avec ' des ' quote
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
generic;2;Impossible de trouver la table %s
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
TEST;1;test sans quote
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
generic;1;Impossible de trouver l'executable %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_sort ORDER_BY Error DESC , Function ASC', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_sort ORDER_BY Error DESC , Function ASC'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_sort ORDER_BY Error DESC , Function ASC'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_sort ORDER_BY Error DESC , Function ASC'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_sort ORDER_BY Error DESC , Function ASC'."> errstd") or diag($return_error);


##################
# Select from error_messages ORDER BY Function,Error
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Select [-h] [-s] [-m Sep] [-r Nlines] [Columns] 
 		  FROM <Table|-> [WHERE <Condition>] [ORDER_BY <Columns>]
Procedure : Select, Type : Erreur, Severite : 202
Message : Mot cle 'FROM' en double.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages ORDER BY Function,Error', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages ORDER BY Function,Error'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages ORDER BY Function,Error'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages ORDER BY Function,Error'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages ORDER BY Function,Error'."> errstd") or diag($return_error);


##################
# Select from table_command_nosort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test renvoyé par une commande'@@KEY='Function;Error'
generic;2;Impossible de trouver la table %s
generic;4;Impossible de trouver le fichier %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;12;Impossible de supprimer le fichier %s
generic;20;L'option %s n'est pas valide
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
Modify;68;Aucune ligne trouvee a modifier
generic;24;Ligne de commande incorrecte
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
generic;35;Le nom de fichier %s n'est pas valide
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
generic;7;La colonne %s n'existe pas
generic;28;Impossible de retrouver le symbole %s en librairie !
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;1;Impossible de trouver l'executable %s
generic;17;La commande <%s> a echoue
generic;14;Impossible de renommer/deplacer le fichier %s en %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;21;Le nombre d'arguments est incorrect
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
generic;15;Impossible de copier le fichier %s
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;5;Le fichier de definition %s n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;30;Votre licence d'utilisation %s a expire !
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;23;Utilisation incorrecte de l'option -h
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;34;Le nombre de clients pour ce produit est depasse !
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
Insert;8;La condition de selection de la cle n'est pas valide
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;33;Il n'y a pas de licence valide pour ce produit !
Replace;97;Aucune valeur a remplacer n'est specifiee
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles de %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
generic;10;Impossible d'ouvrir le fichier %s
generic;8;La condition de selection n'est pas valide
Modify;8;La condition de selection de la cle n'est pas valide
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
generic;26;Erreur lors d'une re-allocation de memoire %s
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
generic;25;Erreur lors d'une allocation de memoire %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
Remove;68;Aucune ligne trouvee a supprimer
Insert;97;Aucune valeur a inserer n'est specifiee
Replace;68;Aucune ligne trouvee a remplacer
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;22;L'argument %s n'est pas valide
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
generic;16;Erreur lors d'une ecriture dans le fichier %s
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
Modify;97;Aucune valeur a modifier n'est specifiee
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
generic;6;La table %s est une table virtuelle
generic;19;L'evaluation de <%s> est incorrecte !
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
Check;65;Non unicite de la clef  # test de commentaire
generic;11;Impossible d'ecrire dans le fichier %s
generic;27;Erreur lors du chargement de la librairie %s !
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
Replace;8;La condition de selection de la cle n'est pas valide
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from table_command_nosort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from table_command_nosort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from table_command_nosort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from table_command_nosort'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from table_command_nosort'."> errstd") or diag($return_error);


##################
# Select from table_command_nosort ORDER_BY
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test renvoyé par une commande'@@KEY='Function;Error'
Check;65;Non unicite de la clef  # test de commentaire
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de la cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n'est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles de %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from table_command_nosort ORDER_BY', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from table_command_nosort ORDER_BY'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from table_command_nosort ORDER_BY'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from table_command_nosort ORDER_BY'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from table_command_nosort ORDER_BY'."> errstd") or diag($return_error);


##################
# Select from table_command_nosort ORDER_BY Message,Function
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test renvoyé par une commande'@@KEY='Function;Error'
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
Modify;68;Aucune ligne trouvee a modifier
Replace;68;Aucune ligne trouvee a remplacer
Remove;68;Aucune ligne trouvee a supprimer
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;97;Aucune valeur a remplacer n'est specifiee
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
generic;25;Erreur lors d'une allocation de memoire %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;29;Erreur lors de la fermeture de la librairie %s !
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;27;Erreur lors du chargement de la librairie %s !
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
generic;33;Il n'y a pas de licence valide pour ce produit !
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
generic;11;Impossible d'ecrire dans le fichier %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles de %s
generic;10;Impossible d'ouvrir le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;15;Impossible de copier le fichier %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;12;Impossible de supprimer le fichier %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
generic;1;Impossible de trouver l'executable %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
generic;2;Impossible de trouver la table %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;4;Impossible de trouver le fichier %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;22;L'argument %s n'est pas valide
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;7;La colonne %s n'existe pas
generic;17;La commande <%s> a echoue
Insert;8;La condition de selection de la cle n'est pas valide
Modify;8;La condition de selection de la cle n'est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
generic;8;La condition de selection n'est pas valide
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
generic;32;La licence n'est pas valide !
generic;6;La table %s est une table virtuelle
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;31;Le Hostid de la machine n'est pas valide !
generic;5;Le fichier de definition %s n'est pas valide
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
generic;35;Le nom de fichier %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;34;Le nombre de clients pour ce produit est depasse !
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
generic;24;Ligne de commande incorrecte
Check;65;Non unicite de la clef  # test de commentaire
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
generic;23;Utilisation incorrecte de l'option -h
generic;30;Votre licence d'utilisation %s a expire !

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from table_command_nosort ORDER_BY Message,Function', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from table_command_nosort ORDER_BY Message,Function'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from table_command_nosort ORDER_BY Message,Function'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from table_command_nosort ORDER_BY Message,Function'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from table_command_nosort ORDER_BY Message,Function'."> errstd") or diag($return_error);


##################
# Select from table_command_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test renvoyé par une commande'@@KEY=''
generic;2;Impossible de trouver la table %s
generic;4;Impossible de trouver le fichier %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;12;Impossible de supprimer le fichier %s
generic;20;L'option %s n'est pas valide
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
Modify;68;Aucune ligne trouvee a modifier
generic;24;Ligne de commande incorrecte
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
generic;35;Le nom de fichier %s n'est pas valide
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
generic;7;La colonne %s n'existe pas
generic;28;Impossible de retrouver le symbole %s en librairie !
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;1;Impossible de trouver l'executable %s
generic;17;La commande <%s> a echoue
generic;14;Impossible de renommer/deplacer le fichier %s en %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;21;Le nombre d'arguments est incorrect
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
generic;15;Impossible de copier le fichier %s
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;5;Le fichier de definition %s n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;30;Votre licence d'utilisation %s a expire !
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;23;Utilisation incorrecte de l'option -h
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;34;Le nombre de clients pour ce produit est depasse !
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
Insert;8;La condition de selection de la cle n'est pas valide
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;33;Il n'y a pas de licence valide pour ce produit !
Replace;97;Aucune valeur a remplacer n'est specifiee
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles de %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
generic;10;Impossible d'ouvrir le fichier %s
generic;8;La condition de selection n'est pas valide
Modify;8;La condition de selection de la cle n'est pas valide
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
generic;26;Erreur lors d'une re-allocation de memoire %s
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
generic;25;Erreur lors d'une allocation de memoire %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
Remove;68;Aucune ligne trouvee a supprimer
Insert;97;Aucune valeur a inserer n'est specifiee
Replace;68;Aucune ligne trouvee a remplacer
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;22;L'argument %s n'est pas valide
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
generic;16;Erreur lors d'une ecriture dans le fichier %s
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
Modify;97;Aucune valeur a modifier n'est specifiee
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
generic;6;La table %s est une table virtuelle
generic;19;L'evaluation de <%s> est incorrecte !
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
Check;65;Non unicite de la clef  # test de commentaire
generic;11;Impossible d'ecrire dans le fichier %s
generic;27;Erreur lors du chargement de la librairie %s !
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
Replace;8;La condition de selection de la cle n'est pas valide
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from table_command_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from table_command_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from table_command_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from table_command_nokey'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from table_command_nokey'."> errstd") or diag($return_error);


##################
# Select from table_command_nokey ORDER_BY
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test renvoyé par une commande'@@KEY=''
generic;2;Impossible de trouver la table %s
generic;4;Impossible de trouver le fichier %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;12;Impossible de supprimer le fichier %s
generic;20;L'option %s n'est pas valide
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
Modify;68;Aucune ligne trouvee a modifier
generic;24;Ligne de commande incorrecte
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
generic;35;Le nom de fichier %s n'est pas valide
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
generic;7;La colonne %s n'existe pas
generic;28;Impossible de retrouver le symbole %s en librairie !
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;1;Impossible de trouver l'executable %s
generic;17;La commande <%s> a echoue
generic;14;Impossible de renommer/deplacer le fichier %s en %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
generic;21;Le nombre d'arguments est incorrect
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
generic;15;Impossible de copier le fichier %s
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;5;Le fichier de definition %s n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;30;Votre licence d'utilisation %s a expire !
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;23;Utilisation incorrecte de l'option -h
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;34;Le nombre de clients pour ce produit est depasse !
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
Insert;8;La condition de selection de la cle n'est pas valide
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;33;Il n'y a pas de licence valide pour ce produit !
Replace;97;Aucune valeur a remplacer n'est specifiee
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles de %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
generic;10;Impossible d'ouvrir le fichier %s
generic;8;La condition de selection n'est pas valide
Modify;8;La condition de selection de la cle n'est pas valide
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
generic;26;Erreur lors d'une re-allocation de memoire %s
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
generic;25;Erreur lors d'une allocation de memoire %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
Remove;68;Aucune ligne trouvee a supprimer
Insert;97;Aucune valeur a inserer n'est specifiee
Replace;68;Aucune ligne trouvee a remplacer
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;22;L'argument %s n'est pas valide
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
generic;16;Erreur lors d'une ecriture dans le fichier %s
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
Modify;97;Aucune valeur a modifier n'est specifiee
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
generic;6;La table %s est une table virtuelle
generic;19;L'evaluation de <%s> est incorrecte !
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
Check;65;Non unicite de la clef  # test de commentaire
generic;11;Impossible d'ecrire dans le fichier %s
generic;27;Erreur lors du chargement de la librairie %s !
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
Replace;8;La condition de selection de la cle n'est pas valide
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from table_command_nokey ORDER_BY', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from table_command_nokey ORDER_BY'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from table_command_nokey ORDER_BY'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from table_command_nokey ORDER_BY'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from table_command_nokey ORDER_BY'."> errstd") or diag($return_error);


##################
# Select from table_command_nokey ORDER_BY Message,Function
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test renvoyé par une commande'@@KEY=''
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
Modify;68;Aucune ligne trouvee a modifier
Replace;68;Aucune ligne trouvee a remplacer
Remove;68;Aucune ligne trouvee a supprimer
Insert;97;Aucune valeur a inserer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Replace;97;Aucune valeur a remplacer n'est specifiee
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
generic;25;Erreur lors d'une allocation de memoire %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;29;Erreur lors de la fermeture de la librairie %s !
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;27;Erreur lors du chargement de la librairie %s !
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
generic;33;Il n'y a pas de licence valide pour ce produit !
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
generic;11;Impossible d'ecrire dans le fichier %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles de %s
generic;10;Impossible d'ouvrir le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;15;Impossible de copier le fichier %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;12;Impossible de supprimer le fichier %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
generic;1;Impossible de trouver l'executable %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
generic;2;Impossible de trouver la table %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
generic;4;Impossible de trouver le fichier %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;22;L'argument %s n'est pas valide
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;7;La colonne %s n'existe pas
generic;17;La commande <%s> a echoue
Insert;8;La condition de selection de la cle n'est pas valide
Modify;8;La condition de selection de la cle n'est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
generic;8;La condition de selection n'est pas valide
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
generic;32;La licence n'est pas valide !
generic;6;La table %s est une table virtuelle
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;31;Le Hostid de la machine n'est pas valide !
generic;5;Le fichier de definition %s n'est pas valide
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
generic;35;Le nom de fichier %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;34;Le nombre de clients pour ce produit est depasse !
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
generic;24;Ligne de commande incorrecte
Check;65;Non unicite de la clef  # test de commentaire
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
generic;23;Utilisation incorrecte de l'option -h
generic;30;Votre licence d'utilisation %s a expire !

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from table_command_nokey ORDER_BY Message,Function', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from table_command_nokey ORDER_BY Message,Function'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from table_command_nokey ORDER_BY Message,Function'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from table_command_nokey ORDER_BY Message,Function'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from table_command_nokey ORDER_BY Message,Function'."> errstd") or diag($return_error);


##################
# Select from error_messages_doublesep ORDER_BY Message,Function
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'@@FORMAT='Function%%Error%%Message'@@ROW='$Function%%$Error%%$Message'@@SIZE='20s%%4n%%80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function%%Error'
generic%%100%%%s
generic%%503%%%s n'est pas un mode d'arret Oracle valide
generic%%504%%%s n'est pas un mode de demarrage Oracle valide
V1_alim_30_motcle%%0002%%Argument de la methode %s non declare dans me_alma
generic%%520%%Aucun Archive Oracle pour la Base %s
FT_LISTLST_SQLNET%%346%%Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME%%346%%Aucun Service TNS convenablement declare dans %s
PC_CHGSTAT_SERV%%0004%%Aucune instance n'est associee a l'application %s
generic%%68%%Aucune ligne trouvee
Modify%%68%%Aucune ligne trouvee a modifier
Replace%%68%%Aucune ligne trouvee a remplacer
Remove%%68%%Aucune ligne trouvee a supprimer
Insert%%97%%Aucune valeur a inserer n'est specifiee
Modify%%97%%Aucune valeur a modifier n'est specifiee
Replace%%97%%Aucune valeur a remplacer n'est specifiee
generic%%97%%Aucune valeur donnee
generic%%116%%Des enregistrements ont ete rejetes pour la table %s
V1_alim_30_motcle%%0001%%ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle%%0004%%ECHEC de l'insertion du mot cle %s dans t_me_ma
ME_LOAD_TABORA%%0001%%Echec du Load sqlldr de %s
generic%%69%%Entete de definition invalide !
generic%%107%%Environnement %s non accessible
generic%%308%%Erreur a l'execution de %s
PC_STAT_TNSNAME%%003%%Erreur de configuration de l'adresse du service TNS %s
generic%%76%%Erreur de syntaxe dans la requete SQL generee : %s
generic%%51%%Erreur de type '%s' lors de la deconnexion Oracle !
generic%%75%%Erreur generique Oracle : %s
generic%%25%%Erreur lors d'une allocation de memoire %s
generic%%16%%Erreur lors d'une ecriture dans le fichier %s
generic%%26%%Erreur lors d'une re-allocation de memoire %s
generic%%114%%Erreur lors de l'enable de contraintes de %s
generic%%50%%Erreur lors de l'execution de la fonction de log
generic%%409%%Erreur lors de l'initialisation du fichier %s
generic%%29%%Erreur lors de la fermeture de la librairie %s !
ME_RESTORE_TABORA%%0001%%Erreur lors de la restauration de la table %s
ME_SECURE_TABORA%%0003%%Erreur lors de la securisation de la table %s
generic%%27%%Erreur lors du chargement de la librairie %s !
generic%%115%%Erreur lors du chargement de la table %s
generic%%104%%Erreur lors du delete sur %s
generic%%113%%Erreur lors du disable de contraintes de %s
PC_LISTBACK_ARCHORA%%0001%%Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA%%0002%%Il n'existe pas d'archives commençant a la sequence %s.
generic%%61%%Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic%%33%%Il n'y a pas de licence valide pour ce produit !
generic%%71%%Il n'y a pas de lignes en entree stdin !
PC_STAT_TNSNAME%%002%%Il n'y a pas de listener demarre servant le service TNS %s
generic%%62%%Il y a trop de valeurs par rapport au nombre de colonnes
generic%%420%%Impossible d'aller sous le répertoire '%s'.
generic%%11%%Impossible d'ecrire dans le fichier %s
generic%%52%%Impossible d'ecrire dans le fichier log %s
generic%%403%%Impossible d'ecrire dans le repertoire %s
PC_LISTBACK_CTRLORA%%132%%Impossible d'interroger les controlfiles de %s
PC_LISTBACK_CTRLORA%%128%%Impossible d'interroger les logfiles de %s
PC_SWITCH_LOGORA%%128%%Impossible d'interroger les logfiles pour %s
generic%%10%%Impossible d'ouvrir le fichier %s
generic%%72%%Impossible d'ouvrir le fichier %s en ecriture !
generic%%73%%Impossible d'ouvrir le fichier %s en lecture !
generic%%74%%Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic%%13%%Impossible de changer les droits sur le fichier %s
generic%%318%%Impossible de choisir un type de service pour le I-CLES %s.
generic%%317%%Impossible de choisir un type pour le Service %s '%s'.
generic%%15%%Impossible de copier le fichier %s
generic%%120%%Impossible de creer le fichier %s
generic%%402%%Impossible de creer le repertoire %s
generic%%87%%Impossible de creer un nouveau processus %s !
generic%%53%%Impossible de determiner le nom du traitement
generic%%404%%Impossible de lire le contenu du repertoire %s
generic%%79%%Impossible de locker la table %s. Ressource deja occupee !
generic%%37%%Impossible de poser un verrou sur le fichier %s
ME_SECURE_TABORA%%0004%%Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA%%0002%%Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA%%0001%%Impossible de recuperer la taille du tablespace %s
generic%%67%%Impossible de remplacer une ligne sur une table sans clef
generic%%14%%Impossible de renommer/deplacer le fichier %s en %s
generic%%40%%Impossible de retirer le verrou du fichier %s
generic%%506%%Impossible de retrouver l'environnement de l'instance Oracle %s
generic%%507%%Impossible de retrouver l'init file de la base %s
generic%%110%%Impossible de retrouver l'objet %s
generic%%44%%Impossible de retrouver la librairie %s !
generic%%49%%Impossible de retrouver le dictionnaire graphique %s
generic%%48%%Impossible de retrouver le fichier de menu %s
generic%%94%%Impossible de retrouver le formulaire %s
generic%%95%%Impossible de retrouver le panneau de commandes %s.
generic%%28%%Impossible de retrouver le symbole %s en librairie !
generic%%78%%Impossible de se connecter a Oracle avec l'utilisateur %s
generic%%12%%Impossible de supprimer le fichier %s
PC_ENV_SQLNET%%506%%Impossible de trouver l'environnement de l'instance Sqlnet %s
generic%%1%%Impossible de trouver l'executable %s
PC_LISTID_INSORA%%182%%Impossible de trouver la Base du user %s
generic%%2%%Impossible de trouver la table %s
PC_LISTID_SQLNET%%182%%Impossible de trouver le Noyau SqlNet du user %s
generic%%4%%Impossible de trouver le fichier %s
generic%%3%%Impossible de trouver ou d'ouvrir le fichier de definition %s
V1_alim_40_meth%%0002%%L'Insertion de la methode physique %s a echoue
V1_alim_40_meth%%0003%%L'Insertion de la variable interne %s a echoue
V1_alim_40_meth%%0004%%L'Insertion du type physique %s a echoue
generic%%514%%L'archivage de %s n'est pas arrete correctement
generic%%513%%L'archivage de %s n'est pas demarre correctement
generic%%22%%L'argument %s n'est pas valide
generic%%19%%L'evaluation de <%s> est incorrecte !
generic%%502%%L'instance Oracle %s n'est pas arretee
generic%%501%%L'instance Oracle %s n'est pas demarree
generic%%302%%L'instance de service %s ne semble pas exister.
generic%%152%%L'intance %s est invalide ou non demarrée.
generic%%96%%L'operateur de selection est incorrect !
generic%%20%%L'option %s n'est pas valide
generic%%126%%L'utilisateur %s n'est pas administrateur du systeme.
generic%%102%%L'utilisateur %s n'existe pas
generic%%505%%La base Oracle %s existe deja dans /etc/oratab
generic%%9%%La chaine de definition %s n'est pas valide ou est absente
generic%%103%%La cle de reference de la contrainte sur %s est incorrecte.
generic%%83%%La colonne %s apparait plusieurs fois dans le dictionnaire !
generic%%60%%La colonne %s doit absolument contenir une valeur
generic%%7%%La colonne %s n'existe pas
generic%%17%%La commande <%s> a echoue
Insert%%8%%La condition de selection de cle n'est pas valide
Modify%%8%%La condition de selection de la cle n est pas valide
Replace%%8%%La condition de selection de la cle n'est pas valide
generic%%8%%La condition de selection n'est pas valide
PC_INITF_SQLNET%%004%%La configuration SqlNet %s de %s est introuvable
generic%%117%%La contrainte %s est invalide !
generic%%134%%La date '%s' ne correspond pas au format %s.
generic%%32%%La licence n'est pas valide !
generic%%80%%La requete interne SQL s'est terminee en erreur !
generic%%316%%La ressource %s '%s' n'est pas ou mal declaré.
generic%%84%%La source de donnees %s du dictionnaire est invalide !
generic%%6%%La table %s est une table virtuelle
generic%%122%%La table %s existe sous plusieurs cles etrangères.
generic%%111%%La table %s existe sous plusieurs schemas
generic%%319%%La table %s n'est pas collectable.
generic%%121%%La table %s n'est pas une table de reference.
generic%%109%%La table %s n'existe pas ou n'est pas accessible
generic%%85%%La table %s ne peut-etre verouillee ou deverouillee !
generic%%128%%La table %s ne possede pas de cle primaire.
generic%%98%%La taille maximale %s d'une ligne est depassee !
generic%%129%%La valeur d'une cle primaire ne peut-etre nulle.
generic%%63%%La valeur donnee pour la colonne %s n'est pas correcte.
generic%%105%%La variable %s n'est pas du bon type
generic%%18%%La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic%%42%%Le Handle d'une requete n'est pas valide
generic%%31%%Le Hostid de la machine n'est pas valide !
generic%%414%%Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic%%321%%Le Type de Service %s du I-CLES %s n'existe pas.
generic%%99%%Le champ %s est mal decrit dans la table %s
generic%%38%%Le delai maximum d'attente de deverouillage a ete atteint
generic%%415%%Le device %s n'existe pas ou est indisponible
generic%%36%%Le fichier %s est verouille
generic%%406%%Le fichier %s existe deja
generic%%408%%Le fichier %s n'est pas au format %s
generic%%39%%Le fichier %s n'est pas verouille
generic%%405%%Le fichier %s n'existe pas ou est vide
generic%%508%%Le fichier de config de %s n'est pas renseigne dans l'initfile
generic%%5%%Le fichier de definition %s n'est pas valide
generic%%132%%Le format de la date '%s' est invalide.
generic%%66%%Le groupe d'utilisateurs %s n'existe pas
generic%%417%%Le lecteur %s est inaccessible
generic%%55%%Le message d'information est manquant
generic%%301%%Le module applicatif %s n'est pas ou mal declaré.
generic%%315%%Le module applicatif %s ne possède aucune instance de service.
V1_alim_40_meth%%0001%%Le mot cle d'action %s n'existe pas
generic%%35%%Le nom de fichier %s n'est pas valide
generic%%64%%Le nom de la table n'est pas specifie
generic%%59%%Le nom de table %s n'est pas valide
generic%%21%%Le nombre d'arguments est incorrect
generic%%34%%Le nombre de clients pour ce produit est depasse !
generic%%47%%Le nombre maximal %s d'allocations de memoire est depasse
generic%%118%%Le nombre maximal %s de cles etrangeres est depasse.
generic%%119%%Le nombre maximal %s de contraintes est depasse.
generic%%82%%Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic%%43%%Le nombre maximal de conditions est depasse
generic%%46%%Le nombre maximal de fichiers ouverts est depasse
generic%%41%%Le nombre maximal de selections simultanees est depasse
generic%%88%%Le nombre maximal de tables %s est depasse
generic%%81%%Le nouveau separateur n'est pas specifie !
generic%%56%%Le numero d'erreur %s n'a pas de message associe
generic%%57%%Le numero d'erreur %s n'est pas correct
generic%%54%%Le numero d'erreur est manquant
generic%%101%%Le parametre %s n'est pas un chiffre
generic%%401%%Le repertoire %s n'existe pas
generic%%517%%Le script SQL %s ne s'est pas execute correctement
generic%%306%%Le script fils <%s> a retourne un code d'erreur errone %s
generic%%303%%Le script fils <%s> a retourne un warning
generic%%304%%Le script fils <%s> a retourne une erreur bloquante
generic%%305%%Le script fils <%s> a retourne une erreur fatale
generic%%311%%Le service %s '%s' est deja arrete.
generic%%310%%Le service %s '%s' est deja demarre.
generic%%312%%Le service %s '%s' n'a pas demarre correctement.
generic%%314%%Le service %s '%s' n'est pas ou mal declaré.
generic%%309%%Le service %s '%s' n'existe pas.
generic%%313%%Le service %s '%s' ne s'est pas arrete correctement.
PC_STAT_TNSNAME%%001%%Le service TNS %s n'est pas decrit
generic%%131%%Le tri de séléction '%s' est invalide.
generic%%93%%Le type de la colonne %s est invalide !
generic%%125%%Le type de la licence est invalide.
generic%%58%%Le type de message de log n'est pas correct
generic%%320%%Le type de ressource %s n'est pas ou mal déclaré.
generic%%127%%Les colonnes %s doivent absolument contenir une valeur.
generic%%509%%Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic%%123%%Les droits sur le fichier %s sont incorrects.
generic%%133%%Les eléments % de la date doivent être séparés par un caractère.
generic%%510%%Les parametres d'archive %s n'existent pas dans les initfiles
generic%%24%%Ligne de commande incorrecte
generic%%150%%Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
Check%%65%%Non unicite de la clef
generic%%65%%Non unicite de la clef de la ligne a inserer
generic%%89%%Option ou suffixe de recherche invalide !
generic%%130%%Options de commande %s incompatibles
PATH%%120%%PATH=$PATH
generic%%92%%Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic%%511%%Parametre log_archive_dest de %s non defini dans les initfiles
generic%%512%%Parametre log_archive_format de %s non defini dans les initfiles
generic%%90%%Pas de librairie chargee pour acceder a la base de donnees !
generic%%519%%Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
ME_CREATE_SYNORA%%0001%%Probleme a la creation du Synonyme %s
ME_DROP_SYNORA%%0001%%Probleme a la suppression du Synonyme %s
generic%%149%%Probleme d'environnement %s
ME_TRUNC_TABORA%%176%%Probleme de truncate sur %s (Contrainte type P referencee) 
generic%%412%%Probleme lors de la compression de %s
generic%%416%%Probleme lors de la creation du lien vers %s
generic%%411%%Probleme lors de la decompression de %s
ME_SECURE_TABORA%%0365%%Probleme lors de la mise a jour de la table %s
generic%%410%%Probleme lors de la restauration/decompression de %s
generic%%413%%Probleme lors de la securisation/compression de %s
generic%%518%%Probleme lors de la suppression de la table %s 
generic%%106%%Probleme lors du chargement de l'environnement %s
PC_SWITCH_LOGORA%%127%%Probleme lors du switch des logfiles de %s
generic%%108%%Probleme pour acceder a la table %s
PC_BACK_TBSORA%%139%%Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA%%137%%Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA%%138%%Probleme pour mettre le TBSPACE %s en END BACKUP
generic%%112%%Probleme pour recuperer les contraintes de %s
generic%%124%%Probleme pour recuperer les informations '%s' de la Machine %s.
V1_alim_30_motcle%%0003%%Rang de l'argument de la methode %s incoherent
generic%%515%%Script SQL %s non accessible
generic%%45%%Un Handle n'est pas valide
generic%%77%%Une valeur a inserer est trop large pour sa colonne !
generic%%23%%Utilisation incorrecte de l'option -h
generic%%91%%Variable d'environnement %s manquante ou non exportee !
generic%%70%%Variables d'environnement SEP ou FORMAT absente !
generic%%151%%Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic%%30%%Votre licence d'utilisation %s a expire !
generic%%148%%Vous n'avez pas les droits %s.
generic%%86%%Vous ne pouvez pas remplacer une cle !
TEST%%3%%test avec " des " double quote
TEST%%2%%test avec ' des ' quote
TEST%%4%%test avec \" des \' quote echappees
TEST%%1%%test sans quote

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_doublesep ORDER_BY Message,Function', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_doublesep ORDER_BY Message,Function'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_doublesep ORDER_BY Message,Function'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_doublesep ORDER_BY Message,Function'."> output <".q{SEP='%%'@@...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_doublesep ORDER_BY Message,Function'."> errstd") or diag($return_error);


##################
# Select from error_messages WHERE ORDER_BY
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
Check;65;Non unicite de la clef
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages WHERE ORDER_BY', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages WHERE ORDER_BY'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages WHERE ORDER_BY'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages WHERE ORDER_BY'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages WHERE ORDER_BY'."> errstd") or diag($return_error);


##################
# Select Message from error_messages WHERE ORDER_BY Function,Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Message'@@ROW='$Message'@@SIZE='80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY=''
Non unicite de la clef
Aucun Listener convenablement declare dans %s
Aucun Service TNS convenablement declare dans %s
Aucune valeur a inserer n'est specifiee
La condition de selection de cle n'est pas valide
Probleme a la creation du Synonyme %s
Probleme a la suppression du Synonyme %s
Echec du Load sqlldr de %s
Erreur lors de la restauration de la table %s
Erreur lors de la securisation de la table %s
Impossible de recuperer la taille de la sauvegarde
Impossible de recuperer la taille de la table %s
Impossible de recuperer la taille du tablespace %s
Probleme lors de la mise a jour de la table %s
Probleme de truncate sur %s (Contrainte type P referencee) 
Aucune ligne trouvee a modifier
Aucune valeur a modifier n'est specifiee
La condition de selection de la cle n est pas valide
Probleme pour manipuler le TBSPACE %s
Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
Probleme pour mettre le TBSPACE %s en END BACKUP
Aucune instance n'est associee a l'application %s
Impossible de trouver l'environnement de l'instance Sqlnet %s
La configuration SqlNet %s de %s est introuvable
Il manque la sequence d'archives %s pour la base %s
Il n'existe pas d'archives commençant a la sequence %s.
Impossible d'interroger les controlfiles de %s
Impossible d'interroger les logfiles de %s
Impossible de trouver la Base du user %s
Impossible de trouver le Noyau SqlNet du user %s
Erreur de configuration de l'adresse du service TNS %s
Il n'y a pas de listener demarre servant le service TNS %s
Le service TNS %s n'est pas decrit
Impossible d'interroger les logfiles pour %s
Probleme lors du switch des logfiles de %s
Aucune ligne trouvee a supprimer
Aucune ligne trouvee a remplacer
Aucune valeur a remplacer n'est specifiee
La condition de selection de la cle n'est pas valide
test avec " des " double quote
test avec ' des ' quote
test avec \" des \' quote echappees
test avec \\ echappements \n
test avec des $variables $(echo "commande evaluee")
test avec des $variables $TESTVAR
test avec des $variables `echo "commande evaluee"`
test avec trop de 
test sans quote
test avec des une clef contenant une variable
Argument de la methode %s non declare dans me_alma
ECHEC ce l'Insert Arg de %s dans t_me_alma
ECHEC de l'insertion du mot cle %s dans t_me_ma
Rang de l'argument de la methode %s incoherent
L'Insertion de la methode physique %s a echoue
L'Insertion de la variable interne %s a echoue
L'Insertion du type physique %s a echoue
Le mot cle d'action %s n'existe pas
%s
%s n'est pas un mode d'arret Oracle valide
%s n'est pas un mode de demarrage Oracle valide
Aucun Archive Oracle pour la Base %s
Aucune ligne trouvee
Aucune valeur donnee
Des enregistrements ont ete rejetes pour la table %s
Entete de definition invalide !
Environnement %s non accessible
Erreur a l'execution de %s
Erreur de syntaxe dans la requete SQL generee : %s
Erreur de type '%s' lors de la deconnexion Oracle !
Erreur generique Oracle : %s
Erreur lors d'une allocation de memoire %s
Erreur lors d'une ecriture dans le fichier %s
Erreur lors d'une re-allocation de memoire %s
Erreur lors de l'enable de contraintes de %s
Erreur lors de l'execution de la fonction de log
Erreur lors de l'initialisation du fichier %s
Erreur lors de la fermeture de la librairie %s !
Erreur lors du chargement de la librairie %s !
Erreur lors du chargement de la table %s
Erreur lors du delete sur %s
Erreur lors du disable de contraintes de %s
Il n'y a pas assez de valeurs par rapport au nombre de colonnes
Il n'y a pas de licence valide pour ce produit !
Il n'y a pas de lignes en entree stdin !
Il y a trop de valeurs par rapport au nombre de colonnes
Impossible d'aller sous le répertoire '%s'.
Impossible d'ecrire dans le fichier %s
Impossible d'ecrire dans le fichier log %s
Impossible d'ecrire dans le repertoire %s
Impossible d'ouvrir le fichier %s
Impossible d'ouvrir le fichier %s en ecriture !
Impossible d'ouvrir le fichier %s en lecture !
Impossible d'ouvrir le fichier %s en lecture et ecriture !
Impossible de changer les droits sur le fichier %s
Impossible de choisir un type de service pour le I-CLES %s.
Impossible de choisir un type pour le Service %s '%s'.
Impossible de copier le fichier %s
Impossible de creer le fichier %s
Impossible de creer le repertoire %s
Impossible de creer un nouveau processus %s !
Impossible de determiner le nom du traitement
Impossible de lire le contenu du repertoire %s
Impossible de locker la table %s. Ressource deja occupee !
Impossible de poser un verrou sur le fichier %s
Impossible de remplacer une ligne sur une table sans clef
Impossible de renommer/deplacer le fichier %s en %s
Impossible de retirer le verrou du fichier %s
Impossible de retrouver l'environnement de l'instance Oracle %s
Impossible de retrouver l'init file de la base %s
Impossible de retrouver l'objet %s
Impossible de retrouver la librairie %s !
Impossible de retrouver le dictionnaire graphique %s
Impossible de retrouver le fichier de menu %s
Impossible de retrouver le formulaire %s
Impossible de retrouver le panneau de commandes %s.
Impossible de retrouver le symbole %s en librairie !
Impossible de se connecter a Oracle avec l'utilisateur %s
Impossible de supprimer le fichier %s
Impossible de trouver l'executable %s
Impossible de trouver la table %s
Impossible de trouver le fichier %s
Impossible de trouver ou d'ouvrir le fichier de definition %s
L'archivage de %s n'est pas arrete correctement
L'archivage de %s n'est pas demarre correctement
L'argument %s n'est pas valide
L'evaluation de <%s> est incorrecte !
L'instance Oracle %s n'est pas arretee
L'instance Oracle %s n'est pas demarree
L'instance de service %s ne semble pas exister.
L'intance %s est invalide ou non demarrée.
L'operateur de selection est incorrect !
L'option %s n'est pas valide
L'utilisateur %s n'est pas administrateur du systeme.
L'utilisateur %s n'existe pas
La base Oracle %s existe deja dans /etc/oratab
La chaine de definition %s n'est pas valide ou est absente
La cle de reference de la contrainte sur %s est incorrecte.
La colonne %s apparait plusieurs fois dans le dictionnaire !
La colonne %s doit absolument contenir une valeur
La colonne %s n'existe pas
La commande <%s> a echoue
La condition de selection n'est pas valide
La contrainte %s est invalide !
La date '%s' ne correspond pas au format %s.
La licence n'est pas valide !
La requete interne SQL s'est terminee en erreur !
La ressource %s '%s' n'est pas ou mal declaré.
La source de donnees %s du dictionnaire est invalide !
La table %s est une table virtuelle
La table %s existe sous plusieurs cles etrangères.
La table %s existe sous plusieurs schemas
La table %s n'est pas collectable.
La table %s n'est pas une table de reference.
La table %s n'existe pas ou n'est pas accessible
La table %s ne peut-etre verouillee ou deverouillee !
La table %s ne possede pas de cle primaire.
La taille maximale %s d'une ligne est depassee !
La valeur d'une cle primaire ne peut-etre nulle.
La valeur donnee pour la colonne %s n'est pas correcte.
La variable %s n'est pas du bon type
La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
Le Handle d'une requete n'est pas valide
Le Hostid de la machine n'est pas valide !
Le Lecteur %s doit etre NO REWIND pour avancer/reculer
Le Type de Service %s du I-CLES %s n'existe pas.
Le champ %s est mal decrit dans la table %s
Le delai maximum d'attente de deverouillage a ete atteint
Le device %s n'existe pas ou est indisponible
Le fichier %s est verouille
Le fichier %s existe deja
Le fichier %s n'est pas au format %s
Le fichier %s n'est pas verouille
Le fichier %s n'existe pas ou est vide
Le fichier de config de %s n'est pas renseigne dans l'initfile
Le fichier de definition %s n'est pas valide
Le format de la date '%s' est invalide.
Le groupe d'utilisateurs %s n'existe pas
Le lecteur %s est inaccessible
Le message d'information est manquant
Le module applicatif %s n'est pas ou mal declaré.
Le module applicatif %s ne possède aucune instance de service.
Le nom de fichier %s n'est pas valide
Le nom de la table n'est pas specifie
Le nom de table %s n'est pas valide
Le nombre d'arguments est incorrect
Le nombre de clients pour ce produit est depasse !
Le nombre maximal %s d'allocations de memoire est depasse
Le nombre maximal %s de cles etrangeres est depasse.
Le nombre maximal %s de contraintes est depasse.
Le nombre maximal de colonnes %s du dictionnaire est depasse !
Le nombre maximal de conditions est depasse
Le nombre maximal de fichiers ouverts est depasse
Le nombre maximal de selections simultanees est depasse
Le nombre maximal de tables %s est depasse
Le nouveau separateur n'est pas specifie !
Le numero d'erreur %s n'a pas de message associe
Le numero d'erreur %s n'est pas correct
Le numero d'erreur est manquant
Le parametre %s n'est pas un chiffre
Le repertoire %s n'existe pas
Le script SQL %s ne s'est pas execute correctement
Le script fils <%s> a retourne un code d'erreur errone %s
Le script fils <%s> a retourne un warning
Le script fils <%s> a retourne une erreur bloquante
Le script fils <%s> a retourne une erreur fatale
Le service %s '%s' est deja arrete.
Le service %s '%s' est deja demarre.
Le service %s '%s' n'a pas demarre correctement.
Le service %s '%s' n'est pas ou mal declaré.
Le service %s '%s' n'existe pas.
Le service %s '%s' ne s'est pas arrete correctement.
Le tri de séléction '%s' est invalide.
Le type de la colonne %s est invalide !
Le type de la licence est invalide.
Le type de message de log n'est pas correct
Le type de ressource %s n'est pas ou mal déclaré.
Les colonnes %s doivent absolument contenir une valeur.
Les controlfiles de %s ne sont pas renseignes dans les initfiles
Les droits sur le fichier %s sont incorrects.
Les eléments % de la date doivent être séparés par un caractère.
Les parametres d'archive %s n'existent pas dans les initfiles
Ligne de commande incorrecte
Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
Non unicite de la clef de la ligne a inserer
Option ou suffixe de recherche invalide !
Options de commande %s incompatibles
Parametre <+ recent que> inferieur au parametre <+ vieux que>.
Parametre log_archive_dest de %s non defini dans les initfiles
Parametre log_archive_format de %s non defini dans les initfiles
Pas de librairie chargee pour acceder a la base de donnees !
Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
Probleme d'environnement %s
Probleme lors de la compression de %s
Probleme lors de la creation du lien vers %s
Probleme lors de la decompression de %s
Probleme lors de la restauration/decompression de %s
Probleme lors de la securisation/compression de %s
Probleme lors de la suppression de la table %s 
Probleme lors du chargement de l'environnement %s
Probleme pour acceder a la table %s
Probleme pour recuperer les contraintes de %s
Probleme pour recuperer les informations '%s' de la Machine %s.
Script SQL %s non accessible
Un Handle n'est pas valide
Une valeur a inserer est trop large pour sa colonne !
Utilisation incorrecte de l'option -h
Variable d'environnement %s manquante ou non exportee !
Variables d'environnement SEP ou FORMAT absente !
Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
Votre licence d'utilisation %s a expire !
Vous n'avez pas les droits %s.
Vous ne pouvez pas remplacer une cle !

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Message from error_messages WHERE ORDER_BY Function,Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Message from error_messages WHERE ORDER_BY Function,Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Message from error_messages WHERE ORDER_BY Function,Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Message from error_messages WHERE ORDER_BY Function,Message'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Message from error_messages WHERE ORDER_BY Function,Message'."> errstd") or diag($return_error);


##################
# Select Message from error_messages WHERE Error=2 ORDER_BY
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Message'@@ROW='$Message'@@SIZE='80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY=''
Impossible de recuperer la taille de la table %s
Il n'existe pas d'archives commençant a la sequence %s.
Il n'y a pas de listener demarre servant le service TNS %s
test avec ' des ' quote
Argument de la methode %s non declare dans me_alma
L'Insertion de la methode physique %s a echoue
Impossible de trouver la table %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Message from error_messages WHERE Error=2 ORDER_BY', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Message from error_messages WHERE Error=2 ORDER_BY'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Message from error_messages WHERE Error=2 ORDER_BY'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Message from error_messages WHERE Error=2 ORDER_BY'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Message from error_messages WHERE Error=2 ORDER_BY'."> errstd") or diag($return_error);


##################
# Select Message from error_messages WHERE Error=2 ORDER_BY Function
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Message'@@ROW='$Message'@@SIZE='80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY=''
Impossible de recuperer la taille de la table %s
Il n'existe pas d'archives commençant a la sequence %s.
Il n'y a pas de listener demarre servant le service TNS %s
test avec ' des ' quote
Argument de la methode %s non declare dans me_alma
L'Insertion de la methode physique %s a echoue
Impossible de trouver la table %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select Message from error_messages WHERE Error=2 ORDER_BY Function', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select Message from error_messages WHERE Error=2 ORDER_BY Function'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select Message from error_messages WHERE Error=2 ORDER_BY Function'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select Message from error_messages WHERE Error=2 ORDER_BY Function'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select Message from error_messages WHERE Error=2 ORDER_BY Function'."> errstd") or diag($return_error);


##################
# Select from table_command
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;N#Error;Message'@@ROW='$Function;$N#Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test renvoyé par une commande'@@KEY='Function;N#Error'
Check;65;Non unicite de la clef  # test de commentaire
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de la cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n'est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles de %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from table_command', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from table_command'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from table_command'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from table_command'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from table_command'."> errstd") or diag($return_error);


##################
# Select from error_messages_file
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test'@@KEY='Function;Error'
Check;65;Non unicite de la clef
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_file', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_file'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_file'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_file'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_file'."> errstd") or diag($return_error);


##################
# Select from error_messages_file_bad
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : Impossible de trouver le fichier t/sample/tab/error_messages_xxx

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_file_bad', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_file_bad'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_file_bad'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_file_bad'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_file_bad'."> errstd") or diag($return_error);


##################
# Select from error_messages_file_dyn
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test'@@KEY='Function;Error'
Check;65;Non unicite de la clef
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
Insert;8;La condition de selection de cle n'est pas valide
Insert;97;Aucune valeur a inserer n'est specifiee
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
Modify;8;La condition de selection de la cle n est pas valide
Modify;68;Aucune ligne trouvee a modifier
Modify;97;Aucune valeur a modifier n'est specifiee
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
Remove;68;Aucune ligne trouvee a supprimer
Replace;8;La condition de selection de la cle n'est pas valide
Replace;68;Aucune ligne trouvee a remplacer
Replace;97;Aucune valeur a remplacer n'est specifiee
TEST;1;test sans quote
TEST;2;test avec ' des ' quote
TEST;3;test avec " des " double quote
TEST;4;test avec \" des \' quote echappees
TEST;5;test avec \\ echappements \n
TEST;6;test avec trop de ; separ;ateurs;
TEST;7;test avec des $variables $TESTVAR
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST_${TESTVAR};0;test avec des une clef contenant une variable
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
generic;1;Impossible de trouver l'executable %s
generic;2;Impossible de trouver la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;4;Impossible de trouver le fichier %s
generic;5;Le fichier de definition %s n'est pas valide
generic;6;La table %s est une table virtuelle
generic;7;La colonne %s n'existe pas
generic;8;La condition de selection n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
generic;10;Impossible d'ouvrir le fichier %s
generic;11;Impossible d'ecrire dans le fichier %s
generic;12;Impossible de supprimer le fichier %s
generic;13;Impossible de changer les droits sur le fichier %s
generic;14;Impossible de renommer/deplacer le fichier %s en %s
generic;15;Impossible de copier le fichier %s
generic;16;Erreur lors d'une ecriture dans le fichier %s
generic;17;La commande <%s> a echoue
generic;18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
generic;19;L'evaluation de <%s> est incorrecte !
generic;20;L'option %s n'est pas valide
generic;21;Le nombre d'arguments est incorrect
generic;22;L'argument %s n'est pas valide
generic;23;Utilisation incorrecte de l'option -h
generic;24;Ligne de commande incorrecte
generic;25;Erreur lors d'une allocation de memoire %s
generic;26;Erreur lors d'une re-allocation de memoire %s
generic;27;Erreur lors du chargement de la librairie %s !
generic;28;Impossible de retrouver le symbole %s en librairie !
generic;29;Erreur lors de la fermeture de la librairie %s !
generic;30;Votre licence d'utilisation %s a expire !
generic;31;Le Hostid de la machine n'est pas valide !
generic;32;La licence n'est pas valide !
generic;33;Il n'y a pas de licence valide pour ce produit !
generic;34;Le nombre de clients pour ce produit est depasse !
generic;35;Le nom de fichier %s n'est pas valide
generic;36;Le fichier %s est verouille
generic;37;Impossible de poser un verrou sur le fichier %s
generic;38;Le delai maximum d'attente de deverouillage a ete atteint
generic;39;Le fichier %s n'est pas verouille
generic;40;Impossible de retirer le verrou du fichier %s
generic;41;Le nombre maximal de selections simultanees est depasse
generic;42;Le Handle d'une requete n'est pas valide
generic;43;Le nombre maximal de conditions est depasse
generic;44;Impossible de retrouver la librairie %s !
generic;45;Un Handle n'est pas valide
generic;46;Le nombre maximal de fichiers ouverts est depasse
generic;47;Le nombre maximal %s d'allocations de memoire est depasse
generic;48;Impossible de retrouver le fichier de menu %s
generic;49;Impossible de retrouver le dictionnaire graphique %s
generic;50;Erreur lors de l'execution de la fonction de log
generic;51;Erreur de type '%s' lors de la deconnexion Oracle !
generic;52;Impossible d'ecrire dans le fichier log %s
generic;53;Impossible de determiner le nom du traitement
generic;54;Le numero d'erreur est manquant
generic;55;Le message d'information est manquant
generic;56;Le numero d'erreur %s n'a pas de message associe
generic;57;Le numero d'erreur %s n'est pas correct
generic;58;Le type de message de log n'est pas correct
generic;59;Le nom de table %s n'est pas valide
generic;60;La colonne %s doit absolument contenir une valeur
generic;61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
generic;62;Il y a trop de valeurs par rapport au nombre de colonnes
generic;63;La valeur donnee pour la colonne %s n'est pas correcte.
generic;64;Le nom de la table n'est pas specifie
generic;65;Non unicite de la clef de la ligne a inserer
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
generic;69;Entete de definition invalide !
generic;70;Variables d'environnement SEP ou FORMAT absente !
generic;71;Il n'y a pas de lignes en entree stdin !
generic;72;Impossible d'ouvrir le fichier %s en ecriture !
generic;73;Impossible d'ouvrir le fichier %s en lecture !
generic;74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
generic;75;Erreur generique Oracle : %s
generic;76;Erreur de syntaxe dans la requete SQL generee : %s
generic;77;Une valeur a inserer est trop large pour sa colonne !
generic;78;Impossible de se connecter a Oracle avec l'utilisateur %s
generic;79;Impossible de locker la table %s. Ressource deja occupee !
generic;80;La requete interne SQL s'est terminee en erreur !
generic;81;Le nouveau separateur n'est pas specifie !
generic;82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
generic;83;La colonne %s apparait plusieurs fois dans le dictionnaire !
generic;84;La source de donnees %s du dictionnaire est invalide !
generic;85;La table %s ne peut-etre verouillee ou deverouillee !
generic;86;Vous ne pouvez pas remplacer une cle !
generic;87;Impossible de creer un nouveau processus %s !
generic;88;Le nombre maximal de tables %s est depasse
generic;89;Option ou suffixe de recherche invalide !
generic;90;Pas de librairie chargee pour acceder a la base de donnees !
generic;91;Variable d'environnement %s manquante ou non exportee !
generic;92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
generic;93;Le type de la colonne %s est invalide !
generic;94;Impossible de retrouver le formulaire %s
generic;95;Impossible de retrouver le panneau de commandes %s.
generic;96;L'operateur de selection est incorrect !
generic;97;Aucune valeur donnee
generic;98;La taille maximale %s d'une ligne est depassee !
generic;99;Le champ %s est mal decrit dans la table %s
generic;100;%s
generic;101;Le parametre %s n'est pas un chiffre
generic;102;L'utilisateur %s n'existe pas
generic;103;La cle de reference de la contrainte sur %s est incorrecte.
generic;104;Erreur lors du delete sur %s
generic;105;La variable %s n'est pas du bon type
generic;106;Probleme lors du chargement de l'environnement %s
generic;107;Environnement %s non accessible
generic;108;Probleme pour acceder a la table %s
generic;109;La table %s n'existe pas ou n'est pas accessible
generic;110;Impossible de retrouver l'objet %s
generic;111;La table %s existe sous plusieurs schemas
generic;112;Probleme pour recuperer les contraintes de %s
generic;113;Erreur lors du disable de contraintes de %s
generic;114;Erreur lors de l'enable de contraintes de %s
generic;115;Erreur lors du chargement de la table %s
generic;116;Des enregistrements ont ete rejetes pour la table %s
generic;117;La contrainte %s est invalide !
generic;118;Le nombre maximal %s de cles etrangeres est depasse.
generic;119;Le nombre maximal %s de contraintes est depasse.
generic;120;Impossible de creer le fichier %s
generic;121;La table %s n'est pas une table de reference.
generic;122;La table %s existe sous plusieurs cles etrangères.
generic;123;Les droits sur le fichier %s sont incorrects.
generic;124;Probleme pour recuperer les informations '%s' de la Machine %s.
generic;125;Le type de la licence est invalide.
generic;126;L'utilisateur %s n'est pas administrateur du systeme.
generic;127;Les colonnes %s doivent absolument contenir une valeur.
generic;128;La table %s ne possede pas de cle primaire.
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;134;La date '%s' ne correspond pas au format %s.
generic;148;Vous n'avez pas les droits %s.
generic;149;Probleme d'environnement %s
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;152;L'intance %s est invalide ou non demarrée.
generic;301;Le module applicatif %s n'est pas ou mal declaré.
generic;302;L'instance de service %s ne semble pas exister.
generic;303;Le script fils <%s> a retourne un warning
generic;304;Le script fils <%s> a retourne une erreur bloquante
generic;305;Le script fils <%s> a retourne une erreur fatale
generic;306;Le script fils <%s> a retourne un code d'erreur errone %s
generic;308;Erreur a l'execution de %s
generic;309;Le service %s '%s' n'existe pas.
generic;310;Le service %s '%s' est deja demarre.
generic;311;Le service %s '%s' est deja arrete.
generic;312;Le service %s '%s' n'a pas demarre correctement.
generic;313;Le service %s '%s' ne s'est pas arrete correctement.
generic;314;Le service %s '%s' n'est pas ou mal declaré.
generic;315;Le module applicatif %s ne possède aucune instance de service.
generic;316;La ressource %s '%s' n'est pas ou mal declaré.
generic;317;Impossible de choisir un type pour le Service %s '%s'.
generic;318;Impossible de choisir un type de service pour le I-CLES %s.
generic;319;La table %s n'est pas collectable.
generic;320;Le type de ressource %s n'est pas ou mal déclaré.
generic;321;Le Type de Service %s du I-CLES %s n'existe pas.
generic;401;Le repertoire %s n'existe pas
generic;402;Impossible de creer le repertoire %s
generic;403;Impossible d'ecrire dans le repertoire %s
generic;404;Impossible de lire le contenu du repertoire %s
generic;405;Le fichier %s n'existe pas ou est vide
generic;406;Le fichier %s existe deja
generic;408;Le fichier %s n'est pas au format %s
generic;409;Erreur lors de l'initialisation du fichier %s
generic;410;Probleme lors de la restauration/decompression de %s
generic;411;Probleme lors de la decompression de %s
generic;412;Probleme lors de la compression de %s
generic;413;Probleme lors de la securisation/compression de %s
generic;414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
generic;415;Le device %s n'existe pas ou est indisponible
generic;416;Probleme lors de la creation du lien vers %s
generic;417;Le lecteur %s est inaccessible
generic;420;Impossible d'aller sous le répertoire '%s'.
generic;501;L'instance Oracle %s n'est pas demarree
generic;502;L'instance Oracle %s n'est pas arretee
generic;503;%s n'est pas un mode d'arret Oracle valide
generic;504;%s n'est pas un mode de demarrage Oracle valide
generic;505;La base Oracle %s existe deja dans /etc/oratab
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
generic;507;Impossible de retrouver l'init file de la base %s
generic;508;Le fichier de config de %s n'est pas renseigne dans l'initfile
generic;509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
generic;510;Les parametres d'archive %s n'existent pas dans les initfiles
generic;511;Parametre log_archive_dest de %s non defini dans les initfiles
generic;512;Parametre log_archive_format de %s non defini dans les initfiles
generic;513;L'archivage de %s n'est pas demarre correctement
generic;514;L'archivage de %s n'est pas arrete correctement
generic;515;Script SQL %s non accessible
generic;517;Le script SQL %s ne s'est pas execute correctement
generic;518;Probleme lors de la suppression de la table %s 
generic;519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
generic;520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_file_dyn', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_file_dyn'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_file_dyn'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_file_dyn'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_file_dyn'."> errstd") or diag($return_error);


##################
# Select from error_messages_file_dyn_bad
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Select, Type : Erreur, Severite : 202
Message : Impossible de trouver le fichier error_messages_xxx

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_file_dyn_bad', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_file_dyn_bad'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_file_dyn_bad'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_file_dyn_bad'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_file_dyn_bad'."> errstd") or diag($return_error);

