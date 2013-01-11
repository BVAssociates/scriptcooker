#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 54;

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
# echo "" | Sort
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Sort, Type : Erreur, Severite : 202
Message : Variable d'environnement SEP manquante ou non exportee !

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "" | Sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "" | Sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "" | Sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "" | Sort'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "" | Sort'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort
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

run3('Select from error_messages | Sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort -s
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

run3('Select from error_messages | Sort -s', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort -s'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort -s'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort -s'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort -s'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort -r -s
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
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
generic;152;L'intance %s est invalide ou non demarrée.
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;149;Probleme d'environnement %s
generic;148;Vous n'avez pas les droits %s.
generic;134;La date '%s' ne correspond pas au format %s.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;132;Le format de la date '%s' est invalide.
generic;131;Le tri de séléction '%s' est invalide.
generic;130;Options de commande %s incompatibles
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;128;La table %s ne possede pas de cle primaire.
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
generic;68;Aucune ligne trouvee
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;66;Le groupe d'utilisateurs %s n'existe pas
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
generic;8;La condition de selection n'est pas valide
generic;7;La colonne %s n'existe pas
generic;6;La table %s est une table virtuelle
generic;5;Le fichier de definition %s n'est pas valide
generic;4;Impossible de trouver le fichier %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;2;Impossible de trouver la table %s
generic;1;Impossible de trouver l'executable %s
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
TEST_${TESTVAR};0;test avec des une clef contenant une variable
TEST;9;test avec des $variables `echo "commande evaluee"`
TEST;8;test avec des $variables $(echo "commande evaluee")
TEST;7;test avec des $variables $TESTVAR
TEST;6;test avec trop de ; separ;ateurs;
TEST;5;test avec \\ echappements \n
TEST;4;test avec \" des \' quote echappees
TEST;3;test avec " des " double quote
TEST;2;test avec ' des ' quote
TEST;1;test sans quote
Replace;97;Aucune valeur a remplacer n'est specifiee
Replace;68;Aucune ligne trouvee a remplacer
Replace;8;La condition de selection de la cle n'est pas valide
Remove;68;Aucune ligne trouvee a supprimer
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
Modify;97;Aucune valeur a modifier n'est specifiee
Modify;68;Aucune ligne trouvee a modifier
Modify;8;La condition de selection de la cle n est pas valide
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
Insert;97;Aucune valeur a inserer n'est specifiee
Insert;8;La condition de selection de cle n'est pas valide
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
Check;65;Non unicite de la clef

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages | Sort -r -s', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort -r -s'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort -r -s'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort -r -s'."> output <".q{generic;52...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort -r -s'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort -o Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Message'@@ROW='$Message'@@SIZE='80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY=''
Non unicite de la clef
Aucun Listener convenablement declare dans %s
Aucun Service TNS convenablement declare dans %s
La condition de selection de cle n'est pas valide
Aucune valeur a inserer n'est specifiee
Probleme a la creation du Synonyme %s
Probleme a la suppression du Synonyme %s
Echec du Load sqlldr de %s
Erreur lors de la restauration de la table %s
Impossible de recuperer la taille du tablespace %s
Impossible de recuperer la taille de la table %s
Erreur lors de la securisation de la table %s
Impossible de recuperer la taille de la sauvegarde
Probleme lors de la mise a jour de la table %s
Probleme de truncate sur %s (Contrainte type P referencee) 
La condition de selection de la cle n est pas valide
Aucune ligne trouvee a modifier
Aucune valeur a modifier n'est specifiee
Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
Probleme pour mettre le TBSPACE %s en END BACKUP
Probleme pour manipuler le TBSPACE %s
Aucune instance n'est associee a l'application %s
Impossible de trouver l'environnement de l'instance Sqlnet %s
La configuration SqlNet %s de %s est introuvable
Il manque la sequence d'archives %s pour la base %s
Il n'existe pas d'archives commençant a la sequence %s.
Impossible d'interroger les logfiles de %s
Impossible d'interroger les controlfiles de %s
Impossible de trouver la Base du user %s
Impossible de trouver le Noyau SqlNet du user %s
Le service TNS %s n'est pas decrit
Il n'y a pas de listener demarre servant le service TNS %s
Erreur de configuration de l'adresse du service TNS %s
Probleme lors du switch des logfiles de %s
Impossible d'interroger les logfiles pour %s
Aucune ligne trouvee a supprimer
La condition de selection de la cle n'est pas valide
Aucune ligne trouvee a remplacer
Aucune valeur a remplacer n'est specifiee
test sans quote
test avec ' des ' quote
test avec " des " double quote
test avec \" des \' quote echappees
test avec \\ echappements \n
test avec trop de 
test avec des $variables $TESTVAR
test avec des $variables $(echo "commande evaluee")
test avec des $variables `echo "commande evaluee"`
test avec des une clef contenant une variable
ECHEC ce l'Insert Arg de %s dans t_me_alma
Argument de la methode %s non declare dans me_alma
Rang de l'argument de la methode %s incoherent
ECHEC de l'insertion du mot cle %s dans t_me_ma
Le mot cle d'action %s n'existe pas
L'Insertion de la methode physique %s a echoue
L'Insertion de la variable interne %s a echoue
L'Insertion du type physique %s a echoue
Impossible de trouver l'executable %s
Impossible de trouver la table %s
Impossible de trouver ou d'ouvrir le fichier de definition %s
Impossible de trouver le fichier %s
Le fichier de definition %s n'est pas valide
La table %s est une table virtuelle
La colonne %s n'existe pas
La condition de selection n'est pas valide
La chaine de definition %s n'est pas valide ou est absente
Impossible d'ouvrir le fichier %s
Impossible d'ecrire dans le fichier %s
Impossible de supprimer le fichier %s
Impossible de changer les droits sur le fichier %s
Impossible de renommer/deplacer le fichier %s en %s
Impossible de copier le fichier %s
Erreur lors d'une ecriture dans le fichier %s
La commande <%s> a echoue
La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
L'evaluation de <%s> est incorrecte !
L'option %s n'est pas valide
Le nombre d'arguments est incorrect
L'argument %s n'est pas valide
Utilisation incorrecte de l'option -h
Ligne de commande incorrecte
Erreur lors d'une allocation de memoire %s
Erreur lors d'une re-allocation de memoire %s
Erreur lors du chargement de la librairie %s !
Impossible de retrouver le symbole %s en librairie !
Erreur lors de la fermeture de la librairie %s !
Votre licence d'utilisation %s a expire !
Le Hostid de la machine n'est pas valide !
La licence n'est pas valide !
Il n'y a pas de licence valide pour ce produit !
Le nombre de clients pour ce produit est depasse !
Le nom de fichier %s n'est pas valide
Le fichier %s est verouille
Impossible de poser un verrou sur le fichier %s
Le delai maximum d'attente de deverouillage a ete atteint
Le fichier %s n'est pas verouille
Impossible de retirer le verrou du fichier %s
Le nombre maximal de selections simultanees est depasse
Le Handle d'une requete n'est pas valide
Le nombre maximal de conditions est depasse
Impossible de retrouver la librairie %s !
Un Handle n'est pas valide
Le nombre maximal de fichiers ouverts est depasse
Le nombre maximal %s d'allocations de memoire est depasse
Impossible de retrouver le fichier de menu %s
Impossible de retrouver le dictionnaire graphique %s
Erreur lors de l'execution de la fonction de log
Erreur de type '%s' lors de la deconnexion Oracle !
Impossible d'ecrire dans le fichier log %s
Impossible de determiner le nom du traitement
Le numero d'erreur est manquant
Le message d'information est manquant
Le numero d'erreur %s n'a pas de message associe
Le numero d'erreur %s n'est pas correct
Le type de message de log n'est pas correct
Le nom de table %s n'est pas valide
La colonne %s doit absolument contenir une valeur
Il n'y a pas assez de valeurs par rapport au nombre de colonnes
Il y a trop de valeurs par rapport au nombre de colonnes
La valeur donnee pour la colonne %s n'est pas correcte.
Le nom de la table n'est pas specifie
Non unicite de la clef de la ligne a inserer
Le groupe d'utilisateurs %s n'existe pas
Impossible de remplacer une ligne sur une table sans clef
Aucune ligne trouvee
Entete de definition invalide !
Variables d'environnement SEP ou FORMAT absente !
Il n'y a pas de lignes en entree stdin !
Impossible d'ouvrir le fichier %s en ecriture !
Impossible d'ouvrir le fichier %s en lecture !
Impossible d'ouvrir le fichier %s en lecture et ecriture !
Erreur generique Oracle : %s
Erreur de syntaxe dans la requete SQL generee : %s
Une valeur a inserer est trop large pour sa colonne !
Impossible de se connecter a Oracle avec l'utilisateur %s
Impossible de locker la table %s. Ressource deja occupee !
La requete interne SQL s'est terminee en erreur !
Le nouveau separateur n'est pas specifie !
Le nombre maximal de colonnes %s du dictionnaire est depasse !
La colonne %s apparait plusieurs fois dans le dictionnaire !
La source de donnees %s du dictionnaire est invalide !
La table %s ne peut-etre verouillee ou deverouillee !
Vous ne pouvez pas remplacer une cle !
Impossible de creer un nouveau processus %s !
Le nombre maximal de tables %s est depasse
Option ou suffixe de recherche invalide !
Pas de librairie chargee pour acceder a la base de donnees !
Variable d'environnement %s manquante ou non exportee !
Parametre <+ recent que> inferieur au parametre <+ vieux que>.
Le type de la colonne %s est invalide !
Impossible de retrouver le formulaire %s
Impossible de retrouver le panneau de commandes %s.
L'operateur de selection est incorrect !
Aucune valeur donnee
La taille maximale %s d'une ligne est depassee !
Le champ %s est mal decrit dans la table %s
%s
Le parametre %s n'est pas un chiffre
L'utilisateur %s n'existe pas
La cle de reference de la contrainte sur %s est incorrecte.
Erreur lors du delete sur %s
La variable %s n'est pas du bon type
Probleme lors du chargement de l'environnement %s
Environnement %s non accessible
Probleme pour acceder a la table %s
La table %s n'existe pas ou n'est pas accessible
Impossible de retrouver l'objet %s
La table %s existe sous plusieurs schemas
Probleme pour recuperer les contraintes de %s
Erreur lors du disable de contraintes de %s
Erreur lors de l'enable de contraintes de %s
Erreur lors du chargement de la table %s
Des enregistrements ont ete rejetes pour la table %s
La contrainte %s est invalide !
Le nombre maximal %s de cles etrangeres est depasse.
Le nombre maximal %s de contraintes est depasse.
Impossible de creer le fichier %s
La table %s n'est pas une table de reference.
La table %s existe sous plusieurs cles etrangères.
Les droits sur le fichier %s sont incorrects.
Probleme pour recuperer les informations '%s' de la Machine %s.
Le type de la licence est invalide.
L'utilisateur %s n'est pas administrateur du systeme.
Les colonnes %s doivent absolument contenir une valeur.
La table %s ne possede pas de cle primaire.
La valeur d'une cle primaire ne peut-etre nulle.
Options de commande %s incompatibles
Le tri de séléction '%s' est invalide.
Le format de la date '%s' est invalide.
Les eléments % de la date doivent être séparés par un caractère.
La date '%s' ne correspond pas au format %s.
Vous n'avez pas les droits %s.
Probleme d'environnement %s
Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
L'intance %s est invalide ou non demarrée.
Le module applicatif %s n'est pas ou mal declaré.
L'instance de service %s ne semble pas exister.
Le script fils <%s> a retourne un warning
Le script fils <%s> a retourne une erreur bloquante
Le script fils <%s> a retourne une erreur fatale
Le script fils <%s> a retourne un code d'erreur errone %s
Erreur a l'execution de %s
Le service %s '%s' n'existe pas.
Le service %s '%s' est deja demarre.
Le service %s '%s' est deja arrete.
Le service %s '%s' n'a pas demarre correctement.
Le service %s '%s' ne s'est pas arrete correctement.
Le service %s '%s' n'est pas ou mal declaré.
Le module applicatif %s ne possède aucune instance de service.
La ressource %s '%s' n'est pas ou mal declaré.
Impossible de choisir un type pour le Service %s '%s'.
Impossible de choisir un type de service pour le I-CLES %s.
La table %s n'est pas collectable.
Le type de ressource %s n'est pas ou mal déclaré.
Le Type de Service %s du I-CLES %s n'existe pas.
Le repertoire %s n'existe pas
Impossible de creer le repertoire %s
Impossible d'ecrire dans le repertoire %s
Impossible de lire le contenu du repertoire %s
Le fichier %s n'existe pas ou est vide
Le fichier %s existe deja
Le fichier %s n'est pas au format %s
Erreur lors de l'initialisation du fichier %s
Probleme lors de la restauration/decompression de %s
Probleme lors de la decompression de %s
Probleme lors de la compression de %s
Probleme lors de la securisation/compression de %s
Le Lecteur %s doit etre NO REWIND pour avancer/reculer
Le device %s n'existe pas ou est indisponible
Probleme lors de la creation du lien vers %s
Le lecteur %s est inaccessible
Impossible d'aller sous le répertoire '%s'.
L'instance Oracle %s n'est pas demarree
L'instance Oracle %s n'est pas arretee
%s n'est pas un mode d'arret Oracle valide
%s n'est pas un mode de demarrage Oracle valide
La base Oracle %s existe deja dans /etc/oratab
Impossible de retrouver l'environnement de l'instance Oracle %s
Impossible de retrouver l'init file de la base %s
Le fichier de config de %s n'est pas renseigne dans l'initfile
Les controlfiles de %s ne sont pas renseignes dans les initfiles
Les parametres d'archive %s n'existent pas dans les initfiles
Parametre log_archive_dest de %s non defini dans les initfiles
Parametre log_archive_format de %s non defini dans les initfiles
L'archivage de %s n'est pas demarre correctement
L'archivage de %s n'est pas arrete correctement
Script SQL %s non accessible
Le script SQL %s ne s'est pas execute correctement
Probleme lors de la suppression de la table %s 
Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages | Sort -o Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort -o Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort -o Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort -o Message'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort -o Message'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort -o Error,Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Error;Message'@@ROW='$Error;$Message'@@SIZE='4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Error'
65;Non unicite de la clef
346;Aucun Listener convenablement declare dans %s
346;Aucun Service TNS convenablement declare dans %s
8;La condition de selection de cle n'est pas valide
97;Aucune valeur a inserer n'est specifiee
0001;Probleme a la creation du Synonyme %s
0001;Probleme a la suppression du Synonyme %s
0001;Echec du Load sqlldr de %s
0001;Erreur lors de la restauration de la table %s
0001;Impossible de recuperer la taille du tablespace %s
0002;Impossible de recuperer la taille de la table %s
0003;Erreur lors de la securisation de la table %s
0004;Impossible de recuperer la taille de la sauvegarde
0365;Probleme lors de la mise a jour de la table %s
176;Probleme de truncate sur %s (Contrainte type P referencee) 
8;La condition de selection de la cle n est pas valide
68;Aucune ligne trouvee a modifier
97;Aucune valeur a modifier n'est specifiee
137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
138;Probleme pour mettre le TBSPACE %s en END BACKUP
139;Probleme pour manipuler le TBSPACE %s
0004;Aucune instance n'est associee a l'application %s
506;Impossible de trouver l'environnement de l'instance Sqlnet %s
004;La configuration SqlNet %s de %s est introuvable
0001;Il manque la sequence d'archives %s pour la base %s
0002;Il n'existe pas d'archives commençant a la sequence %s.
128;Impossible d'interroger les logfiles de %s
132;Impossible d'interroger les controlfiles de %s
182;Impossible de trouver la Base du user %s
182;Impossible de trouver le Noyau SqlNet du user %s
001;Le service TNS %s n'est pas decrit
002;Il n'y a pas de listener demarre servant le service TNS %s
003;Erreur de configuration de l'adresse du service TNS %s
127;Probleme lors du switch des logfiles de %s
128;Impossible d'interroger les logfiles pour %s
68;Aucune ligne trouvee a supprimer
8;La condition de selection de la cle n'est pas valide
68;Aucune ligne trouvee a remplacer
97;Aucune valeur a remplacer n'est specifiee
1;test sans quote
2;test avec ' des ' quote
3;test avec " des " double quote
4;test avec \" des \' quote echappees
5;test avec \\ echappements \n
6;test avec trop de 
7;test avec des $variables $TESTVAR
8;test avec des $variables $(echo "commande evaluee")
9;test avec des $variables `echo "commande evaluee"`
0;test avec des une clef contenant une variable
0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
0002;Argument de la methode %s non declare dans me_alma
0003;Rang de l'argument de la methode %s incoherent
0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
0001;Le mot cle d'action %s n'existe pas
0002;L'Insertion de la methode physique %s a echoue
0003;L'Insertion de la variable interne %s a echoue
0004;L'Insertion du type physique %s a echoue
1;Impossible de trouver l'executable %s
2;Impossible de trouver la table %s
3;Impossible de trouver ou d'ouvrir le fichier de definition %s
4;Impossible de trouver le fichier %s
5;Le fichier de definition %s n'est pas valide
6;La table %s est une table virtuelle
7;La colonne %s n'existe pas
8;La condition de selection n'est pas valide
9;La chaine de definition %s n'est pas valide ou est absente
10;Impossible d'ouvrir le fichier %s
11;Impossible d'ecrire dans le fichier %s
12;Impossible de supprimer le fichier %s
13;Impossible de changer les droits sur le fichier %s
14;Impossible de renommer/deplacer le fichier %s en %s
15;Impossible de copier le fichier %s
16;Erreur lors d'une ecriture dans le fichier %s
17;La commande <%s> a echoue
18;La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
19;L'evaluation de <%s> est incorrecte !
20;L'option %s n'est pas valide
21;Le nombre d'arguments est incorrect
22;L'argument %s n'est pas valide
23;Utilisation incorrecte de l'option -h
24;Ligne de commande incorrecte
25;Erreur lors d'une allocation de memoire %s
26;Erreur lors d'une re-allocation de memoire %s
27;Erreur lors du chargement de la librairie %s !
28;Impossible de retrouver le symbole %s en librairie !
29;Erreur lors de la fermeture de la librairie %s !
30;Votre licence d'utilisation %s a expire !
31;Le Hostid de la machine n'est pas valide !
32;La licence n'est pas valide !
33;Il n'y a pas de licence valide pour ce produit !
34;Le nombre de clients pour ce produit est depasse !
35;Le nom de fichier %s n'est pas valide
36;Le fichier %s est verouille
37;Impossible de poser un verrou sur le fichier %s
38;Le delai maximum d'attente de deverouillage a ete atteint
39;Le fichier %s n'est pas verouille
40;Impossible de retirer le verrou du fichier %s
41;Le nombre maximal de selections simultanees est depasse
42;Le Handle d'une requete n'est pas valide
43;Le nombre maximal de conditions est depasse
44;Impossible de retrouver la librairie %s !
45;Un Handle n'est pas valide
46;Le nombre maximal de fichiers ouverts est depasse
47;Le nombre maximal %s d'allocations de memoire est depasse
48;Impossible de retrouver le fichier de menu %s
49;Impossible de retrouver le dictionnaire graphique %s
50;Erreur lors de l'execution de la fonction de log
51;Erreur de type '%s' lors de la deconnexion Oracle !
52;Impossible d'ecrire dans le fichier log %s
53;Impossible de determiner le nom du traitement
54;Le numero d'erreur est manquant
55;Le message d'information est manquant
56;Le numero d'erreur %s n'a pas de message associe
57;Le numero d'erreur %s n'est pas correct
58;Le type de message de log n'est pas correct
59;Le nom de table %s n'est pas valide
60;La colonne %s doit absolument contenir une valeur
61;Il n'y a pas assez de valeurs par rapport au nombre de colonnes
62;Il y a trop de valeurs par rapport au nombre de colonnes
63;La valeur donnee pour la colonne %s n'est pas correcte.
64;Le nom de la table n'est pas specifie
65;Non unicite de la clef de la ligne a inserer
66;Le groupe d'utilisateurs %s n'existe pas
67;Impossible de remplacer une ligne sur une table sans clef
68;Aucune ligne trouvee
69;Entete de definition invalide !
70;Variables d'environnement SEP ou FORMAT absente !
71;Il n'y a pas de lignes en entree stdin !
72;Impossible d'ouvrir le fichier %s en ecriture !
73;Impossible d'ouvrir le fichier %s en lecture !
74;Impossible d'ouvrir le fichier %s en lecture et ecriture !
75;Erreur generique Oracle : %s
76;Erreur de syntaxe dans la requete SQL generee : %s
77;Une valeur a inserer est trop large pour sa colonne !
78;Impossible de se connecter a Oracle avec l'utilisateur %s
79;Impossible de locker la table %s. Ressource deja occupee !
80;La requete interne SQL s'est terminee en erreur !
81;Le nouveau separateur n'est pas specifie !
82;Le nombre maximal de colonnes %s du dictionnaire est depasse !
83;La colonne %s apparait plusieurs fois dans le dictionnaire !
84;La source de donnees %s du dictionnaire est invalide !
85;La table %s ne peut-etre verouillee ou deverouillee !
86;Vous ne pouvez pas remplacer une cle !
87;Impossible de creer un nouveau processus %s !
88;Le nombre maximal de tables %s est depasse
89;Option ou suffixe de recherche invalide !
90;Pas de librairie chargee pour acceder a la base de donnees !
91;Variable d'environnement %s manquante ou non exportee !
92;Parametre <+ recent que> inferieur au parametre <+ vieux que>.
93;Le type de la colonne %s est invalide !
94;Impossible de retrouver le formulaire %s
95;Impossible de retrouver le panneau de commandes %s.
96;L'operateur de selection est incorrect !
97;Aucune valeur donnee
98;La taille maximale %s d'une ligne est depassee !
99;Le champ %s est mal decrit dans la table %s
100;%s
101;Le parametre %s n'est pas un chiffre
102;L'utilisateur %s n'existe pas
103;La cle de reference de la contrainte sur %s est incorrecte.
104;Erreur lors du delete sur %s
105;La variable %s n'est pas du bon type
106;Probleme lors du chargement de l'environnement %s
107;Environnement %s non accessible
108;Probleme pour acceder a la table %s
109;La table %s n'existe pas ou n'est pas accessible
110;Impossible de retrouver l'objet %s
111;La table %s existe sous plusieurs schemas
112;Probleme pour recuperer les contraintes de %s
113;Erreur lors du disable de contraintes de %s
114;Erreur lors de l'enable de contraintes de %s
115;Erreur lors du chargement de la table %s
116;Des enregistrements ont ete rejetes pour la table %s
117;La contrainte %s est invalide !
118;Le nombre maximal %s de cles etrangeres est depasse.
119;Le nombre maximal %s de contraintes est depasse.
120;Impossible de creer le fichier %s
121;La table %s n'est pas une table de reference.
122;La table %s existe sous plusieurs cles etrangères.
123;Les droits sur le fichier %s sont incorrects.
124;Probleme pour recuperer les informations '%s' de la Machine %s.
125;Le type de la licence est invalide.
126;L'utilisateur %s n'est pas administrateur du systeme.
127;Les colonnes %s doivent absolument contenir une valeur.
128;La table %s ne possede pas de cle primaire.
129;La valeur d'une cle primaire ne peut-etre nulle.
130;Options de commande %s incompatibles
131;Le tri de séléction '%s' est invalide.
132;Le format de la date '%s' est invalide.
133;Les eléments % de la date doivent être séparés par un caractère.
134;La date '%s' ne correspond pas au format %s.
148;Vous n'avez pas les droits %s.
149;Probleme d'environnement %s
150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
152;L'intance %s est invalide ou non demarrée.
301;Le module applicatif %s n'est pas ou mal declaré.
302;L'instance de service %s ne semble pas exister.
303;Le script fils <%s> a retourne un warning
304;Le script fils <%s> a retourne une erreur bloquante
305;Le script fils <%s> a retourne une erreur fatale
306;Le script fils <%s> a retourne un code d'erreur errone %s
308;Erreur a l'execution de %s
309;Le service %s '%s' n'existe pas.
310;Le service %s '%s' est deja demarre.
311;Le service %s '%s' est deja arrete.
312;Le service %s '%s' n'a pas demarre correctement.
313;Le service %s '%s' ne s'est pas arrete correctement.
314;Le service %s '%s' n'est pas ou mal declaré.
315;Le module applicatif %s ne possède aucune instance de service.
316;La ressource %s '%s' n'est pas ou mal declaré.
317;Impossible de choisir un type pour le Service %s '%s'.
318;Impossible de choisir un type de service pour le I-CLES %s.
319;La table %s n'est pas collectable.
320;Le type de ressource %s n'est pas ou mal déclaré.
321;Le Type de Service %s du I-CLES %s n'existe pas.
401;Le repertoire %s n'existe pas
402;Impossible de creer le repertoire %s
403;Impossible d'ecrire dans le repertoire %s
404;Impossible de lire le contenu du repertoire %s
405;Le fichier %s n'existe pas ou est vide
406;Le fichier %s existe deja
408;Le fichier %s n'est pas au format %s
409;Erreur lors de l'initialisation du fichier %s
410;Probleme lors de la restauration/decompression de %s
411;Probleme lors de la decompression de %s
412;Probleme lors de la compression de %s
413;Probleme lors de la securisation/compression de %s
414;Le Lecteur %s doit etre NO REWIND pour avancer/reculer
415;Le device %s n'existe pas ou est indisponible
416;Probleme lors de la creation du lien vers %s
417;Le lecteur %s est inaccessible
420;Impossible d'aller sous le répertoire '%s'.
501;L'instance Oracle %s n'est pas demarree
502;L'instance Oracle %s n'est pas arretee
503;%s n'est pas un mode d'arret Oracle valide
504;%s n'est pas un mode de demarrage Oracle valide
505;La base Oracle %s existe deja dans /etc/oratab
506;Impossible de retrouver l'environnement de l'instance Oracle %s
507;Impossible de retrouver l'init file de la base %s
508;Le fichier de config de %s n'est pas renseigne dans l'initfile
509;Les controlfiles de %s ne sont pas renseignes dans les initfiles
510;Les parametres d'archive %s n'existent pas dans les initfiles
511;Parametre log_archive_dest de %s non defini dans les initfiles
512;Parametre log_archive_format de %s non defini dans les initfiles
513;L'archivage de %s n'est pas demarre correctement
514;L'archivage de %s n'est pas arrete correctement
515;Script SQL %s non accessible
517;Le script SQL %s ne s'est pas execute correctement
518;Probleme lors de la suppression de la table %s 
519;Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
520;Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages | Sort -o Error,Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort -o Error,Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort -o Error,Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort -o Error,Message'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort -o Error,Message'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort BY Error,Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST_${TESTVAR};0;test avec des une clef contenant une variable
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;1;Impossible de trouver l'executable %s
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
TEST;1;test sans quote
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
generic;2;Impossible de trouver la table %s
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
TEST;2;test avec ' des ' quote
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
TEST;3;test avec " des " double quote
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
generic;4;Impossible de trouver le fichier %s
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
TEST;4;test avec \" des \' quote echappees
generic;5;Le fichier de definition %s n'est pas valide
TEST;5;test avec \\ echappements \n
generic;6;La table %s est une table virtuelle
TEST;6;test avec trop de ; separ;ateurs;
generic;7;La colonne %s n'existe pas
TEST;7;test avec des $variables $TESTVAR
Insert;8;La condition de selection de cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
generic;8;La condition de selection n'est pas valide
TEST;8;test avec des $variables $(echo "commande evaluee")
generic;9;La chaine de definition %s n'est pas valide ou est absente
TEST;9;test avec des $variables `echo "commande evaluee"`
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
generic;68;Aucune ligne trouvee
Modify;68;Aucune ligne trouvee a modifier
Replace;68;Aucune ligne trouvee a remplacer
Remove;68;Aucune ligne trouvee a supprimer
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
generic;127;Les colonnes %s doivent absolument contenir une valeur.
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
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
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
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

run3('Select from error_messages | Sort BY Error,Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort BY Error,Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort BY Error,Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort BY Error,Message'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort BY Error,Message'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort by Error,Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST_${TESTVAR};0;test avec des une clef contenant une variable
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
generic;1;Impossible de trouver l'executable %s
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
TEST;1;test sans quote
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
generic;2;Impossible de trouver la table %s
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
TEST;2;test avec ' des ' quote
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
TEST;3;test avec " des " double quote
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
generic;4;Impossible de trouver le fichier %s
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
TEST;4;test avec \" des \' quote echappees
generic;5;Le fichier de definition %s n'est pas valide
TEST;5;test avec \\ echappements \n
generic;6;La table %s est une table virtuelle
TEST;6;test avec trop de ; separ;ateurs;
generic;7;La colonne %s n'existe pas
TEST;7;test avec des $variables $TESTVAR
Insert;8;La condition de selection de cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Replace;8;La condition de selection de la cle n'est pas valide
generic;8;La condition de selection n'est pas valide
TEST;8;test avec des $variables $(echo "commande evaluee")
generic;9;La chaine de definition %s n'est pas valide ou est absente
TEST;9;test avec des $variables `echo "commande evaluee"`
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
generic;68;Aucune ligne trouvee
Modify;68;Aucune ligne trouvee a modifier
Replace;68;Aucune ligne trouvee a remplacer
Remove;68;Aucune ligne trouvee a supprimer
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
generic;127;Les colonnes %s doivent absolument contenir une valeur.
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
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
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
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

run3('Select from error_messages | Sort by Error,Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort by Error,Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort by Error,Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort by Error,Message'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort by Error,Message'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort -o Function BY Error,Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function'@@ROW='$Function'@@SIZE='20s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function'
TEST_${TESTVAR}
V1_alim_30_motcle
ME_LOAD_TABORA
ME_RESTORE_TABORA
PC_LISTBACK_ARCHORA
ME_SECURE_TABORA
generic
V1_alim_40_meth
PC_STAT_TNSNAME
ME_CREATE_SYNORA
ME_DROP_SYNORA
TEST
V1_alim_30_motcle
PC_LISTBACK_ARCHORA
PC_STAT_TNSNAME
ME_SECURE_TABORA
generic
V1_alim_40_meth
TEST
PC_STAT_TNSNAME
ME_SECURE_TABORA
generic
V1_alim_40_meth
V1_alim_30_motcle
TEST
PC_CHGSTAT_SERV
V1_alim_30_motcle
ME_SECURE_TABORA
generic
V1_alim_40_meth
PC_INITF_SQLNET
TEST
generic
TEST
generic
TEST
generic
TEST
Insert
Modify
Replace
generic
TEST
generic
TEST
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
Check
generic
generic
generic
generic
Modify
Replace
Remove
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
Insert
Modify
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
PC_SWITCH_LOGORA
PC_LISTBACK_CTRLORA
PC_SWITCH_LOGORA
generic
generic
generic
generic
PC_LISTBACK_CTRLORA
generic
generic
generic
PC_BACK_TBSORA
PC_BACK_TBSORA
PC_BACK_TBSORA
generic
generic
generic
generic
generic
ME_TRUNC_TABORA
PC_LISTID_INSORA
PC_LISTID_SQLNET
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
FT_LISTLST_SQLNET
FT_LIST_TNSNAME
ME_SECURE_TABORA
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
PC_ENV_SQLNET
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

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages | Sort -o Function BY Error,Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort -o Function BY Error,Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort -o Function BY Error,Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort -o Function BY Error,Message'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort -o Function BY Error,Message'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort by Error ASC, Function DESC
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function;Error'
TEST_${TESTVAR};0;test avec des une clef contenant une variable
generic;1;Impossible de trouver l'executable %s
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
TEST;1;test sans quote
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
generic;2;Impossible de trouver la table %s
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
TEST;2;test avec ' des ' quote
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
TEST;3;test avec " des " double quote
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
generic;4;Impossible de trouver le fichier %s
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
TEST;4;test avec \" des \' quote echappees
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
generic;5;Le fichier de definition %s n'est pas valide
TEST;5;test avec \\ echappements \n
generic;6;La table %s est une table virtuelle
TEST;6;test avec trop de ; separ;ateurs;
generic;7;La colonne %s n'existe pas
TEST;7;test avec des $variables $TESTVAR
generic;8;La condition de selection n'est pas valide
TEST;8;test avec des $variables $(echo "commande evaluee")
Replace;8;La condition de selection de la cle n'est pas valide
Modify;8;La condition de selection de la cle n est pas valide
Insert;8;La condition de selection de cle n'est pas valide
generic;9;La chaine de definition %s n'est pas valide ou est absente
TEST;9;test avec des $variables `echo "commande evaluee"`
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
Check;65;Non unicite de la clef
generic;66;Le groupe d'utilisateurs %s n'existe pas
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;68;Aucune ligne trouvee
Replace;68;Aucune ligne trouvee a remplacer
Remove;68;Aucune ligne trouvee a supprimer
Modify;68;Aucune ligne trouvee a modifier
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
Replace;97;Aucune valeur a remplacer n'est specifiee
Modify;97;Aucune valeur a modifier n'est specifiee
Insert;97;Aucune valeur a inserer n'est specifiee
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
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
generic;128;La table %s ne possede pas de cle primaire.
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;130;Options de commande %s incompatibles
generic;131;Le tri de séléction '%s' est invalide.
generic;132;Le format de la date '%s' est invalide.
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
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
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
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
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
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
generic;506;Impossible de retrouver l'environnement de l'instance Oracle %s
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
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

run3('Select from error_messages | Sort by Error ASC, Function DESC', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort by Error ASC, Function DESC'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort by Error ASC, Function DESC'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort by Error ASC, Function DESC'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort by Error ASC, Function DESC'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort -o Message by Error ASC, Function DESC
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Message'@@ROW='$Message'@@SIZE='80s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY=''
test avec des une clef contenant une variable
Impossible de trouver l'executable %s
Le mot cle d'action %s n'existe pas
ECHEC ce l'Insert Arg de %s dans t_me_alma
test sans quote
Le service TNS %s n'est pas decrit
Il manque la sequence d'archives %s pour la base %s
Impossible de recuperer la taille du tablespace %s
Erreur lors de la restauration de la table %s
Echec du Load sqlldr de %s
Probleme a la suppression du Synonyme %s
Probleme a la creation du Synonyme %s
Impossible de trouver la table %s
L'Insertion de la methode physique %s a echoue
Argument de la methode %s non declare dans me_alma
test avec ' des ' quote
Il n'y a pas de listener demarre servant le service TNS %s
Il n'existe pas d'archives commençant a la sequence %s.
Impossible de recuperer la taille de la table %s
Impossible de trouver ou d'ouvrir le fichier de definition %s
L'Insertion de la variable interne %s a echoue
Rang de l'argument de la methode %s incoherent
test avec " des " double quote
Erreur de configuration de l'adresse du service TNS %s
Erreur lors de la securisation de la table %s
Impossible de trouver le fichier %s
L'Insertion du type physique %s a echoue
ECHEC de l'insertion du mot cle %s dans t_me_ma
test avec \" des \' quote echappees
La configuration SqlNet %s de %s est introuvable
Aucune instance n'est associee a l'application %s
Impossible de recuperer la taille de la sauvegarde
Le fichier de definition %s n'est pas valide
test avec \\ echappements \n
La table %s est une table virtuelle
test avec trop de 
La colonne %s n'existe pas
test avec des $variables $TESTVAR
La condition de selection n'est pas valide
test avec des $variables $(echo "commande evaluee")
La condition de selection de la cle n'est pas valide
La condition de selection de la cle n est pas valide
La condition de selection de cle n'est pas valide
La chaine de definition %s n'est pas valide ou est absente
test avec des $variables `echo "commande evaluee"`
Impossible d'ouvrir le fichier %s
Impossible d'ecrire dans le fichier %s
Impossible de supprimer le fichier %s
Impossible de changer les droits sur le fichier %s
Impossible de renommer/deplacer le fichier %s en %s
Impossible de copier le fichier %s
Erreur lors d'une ecriture dans le fichier %s
La commande <%s> a echoue
La variable racine BV_HOME ou TOOLS_HOME n'est pas exportee !
L'evaluation de <%s> est incorrecte !
L'option %s n'est pas valide
Le nombre d'arguments est incorrect
L'argument %s n'est pas valide
Utilisation incorrecte de l'option -h
Ligne de commande incorrecte
Erreur lors d'une allocation de memoire %s
Erreur lors d'une re-allocation de memoire %s
Erreur lors du chargement de la librairie %s !
Impossible de retrouver le symbole %s en librairie !
Erreur lors de la fermeture de la librairie %s !
Votre licence d'utilisation %s a expire !
Le Hostid de la machine n'est pas valide !
La licence n'est pas valide !
Il n'y a pas de licence valide pour ce produit !
Le nombre de clients pour ce produit est depasse !
Le nom de fichier %s n'est pas valide
Le fichier %s est verouille
Impossible de poser un verrou sur le fichier %s
Le delai maximum d'attente de deverouillage a ete atteint
Le fichier %s n'est pas verouille
Impossible de retirer le verrou du fichier %s
Le nombre maximal de selections simultanees est depasse
Le Handle d'une requete n'est pas valide
Le nombre maximal de conditions est depasse
Impossible de retrouver la librairie %s !
Un Handle n'est pas valide
Le nombre maximal de fichiers ouverts est depasse
Le nombre maximal %s d'allocations de memoire est depasse
Impossible de retrouver le fichier de menu %s
Impossible de retrouver le dictionnaire graphique %s
Erreur lors de l'execution de la fonction de log
Erreur de type '%s' lors de la deconnexion Oracle !
Impossible d'ecrire dans le fichier log %s
Impossible de determiner le nom du traitement
Le numero d'erreur est manquant
Le message d'information est manquant
Le numero d'erreur %s n'a pas de message associe
Le numero d'erreur %s n'est pas correct
Le type de message de log n'est pas correct
Le nom de table %s n'est pas valide
La colonne %s doit absolument contenir une valeur
Il n'y a pas assez de valeurs par rapport au nombre de colonnes
Il y a trop de valeurs par rapport au nombre de colonnes
La valeur donnee pour la colonne %s n'est pas correcte.
Le nom de la table n'est pas specifie
Non unicite de la clef de la ligne a inserer
Non unicite de la clef
Le groupe d'utilisateurs %s n'existe pas
Impossible de remplacer une ligne sur une table sans clef
Aucune ligne trouvee
Aucune ligne trouvee a remplacer
Aucune ligne trouvee a supprimer
Aucune ligne trouvee a modifier
Entete de definition invalide !
Variables d'environnement SEP ou FORMAT absente !
Il n'y a pas de lignes en entree stdin !
Impossible d'ouvrir le fichier %s en ecriture !
Impossible d'ouvrir le fichier %s en lecture !
Impossible d'ouvrir le fichier %s en lecture et ecriture !
Erreur generique Oracle : %s
Erreur de syntaxe dans la requete SQL generee : %s
Une valeur a inserer est trop large pour sa colonne !
Impossible de se connecter a Oracle avec l'utilisateur %s
Impossible de locker la table %s. Ressource deja occupee !
La requete interne SQL s'est terminee en erreur !
Le nouveau separateur n'est pas specifie !
Le nombre maximal de colonnes %s du dictionnaire est depasse !
La colonne %s apparait plusieurs fois dans le dictionnaire !
La source de donnees %s du dictionnaire est invalide !
La table %s ne peut-etre verouillee ou deverouillee !
Vous ne pouvez pas remplacer une cle !
Impossible de creer un nouveau processus %s !
Le nombre maximal de tables %s est depasse
Option ou suffixe de recherche invalide !
Pas de librairie chargee pour acceder a la base de donnees !
Variable d'environnement %s manquante ou non exportee !
Parametre <+ recent que> inferieur au parametre <+ vieux que>.
Le type de la colonne %s est invalide !
Impossible de retrouver le formulaire %s
Impossible de retrouver le panneau de commandes %s.
L'operateur de selection est incorrect !
Aucune valeur donnee
Aucune valeur a remplacer n'est specifiee
Aucune valeur a modifier n'est specifiee
Aucune valeur a inserer n'est specifiee
La taille maximale %s d'une ligne est depassee !
Le champ %s est mal decrit dans la table %s
%s
Le parametre %s n'est pas un chiffre
L'utilisateur %s n'existe pas
La cle de reference de la contrainte sur %s est incorrecte.
Erreur lors du delete sur %s
La variable %s n'est pas du bon type
Probleme lors du chargement de l'environnement %s
Environnement %s non accessible
Probleme pour acceder a la table %s
La table %s n'existe pas ou n'est pas accessible
Impossible de retrouver l'objet %s
La table %s existe sous plusieurs schemas
Probleme pour recuperer les contraintes de %s
Erreur lors du disable de contraintes de %s
Erreur lors de l'enable de contraintes de %s
Erreur lors du chargement de la table %s
Des enregistrements ont ete rejetes pour la table %s
La contrainte %s est invalide !
Le nombre maximal %s de cles etrangeres est depasse.
Le nombre maximal %s de contraintes est depasse.
Impossible de creer le fichier %s
La table %s n'est pas une table de reference.
La table %s existe sous plusieurs cles etrangères.
Les droits sur le fichier %s sont incorrects.
Probleme pour recuperer les informations '%s' de la Machine %s.
Le type de la licence est invalide.
L'utilisateur %s n'est pas administrateur du systeme.
Les colonnes %s doivent absolument contenir une valeur.
Probleme lors du switch des logfiles de %s
La table %s ne possede pas de cle primaire.
Impossible d'interroger les logfiles pour %s
Impossible d'interroger les logfiles de %s
La valeur d'une cle primaire ne peut-etre nulle.
Options de commande %s incompatibles
Le tri de séléction '%s' est invalide.
Le format de la date '%s' est invalide.
Impossible d'interroger les controlfiles de %s
Les eléments % de la date doivent être séparés par un caractère.
La date '%s' ne correspond pas au format %s.
Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
Probleme pour mettre le TBSPACE %s en END BACKUP
Probleme pour manipuler le TBSPACE %s
Vous n'avez pas les droits %s.
Probleme d'environnement %s
Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
L'intance %s est invalide ou non demarrée.
Probleme de truncate sur %s (Contrainte type P referencee) 
Impossible de trouver le Noyau SqlNet du user %s
Impossible de trouver la Base du user %s
Le module applicatif %s n'est pas ou mal declaré.
L'instance de service %s ne semble pas exister.
Le script fils <%s> a retourne un warning
Le script fils <%s> a retourne une erreur bloquante
Le script fils <%s> a retourne une erreur fatale
Le script fils <%s> a retourne un code d'erreur errone %s
Erreur a l'execution de %s
Le service %s '%s' n'existe pas.
Le service %s '%s' est deja demarre.
Le service %s '%s' est deja arrete.
Le service %s '%s' n'a pas demarre correctement.
Le service %s '%s' ne s'est pas arrete correctement.
Le service %s '%s' n'est pas ou mal declaré.
Le module applicatif %s ne possède aucune instance de service.
La ressource %s '%s' n'est pas ou mal declaré.
Impossible de choisir un type pour le Service %s '%s'.
Impossible de choisir un type de service pour le I-CLES %s.
La table %s n'est pas collectable.
Le type de ressource %s n'est pas ou mal déclaré.
Le Type de Service %s du I-CLES %s n'existe pas.
Aucun Service TNS convenablement declare dans %s
Aucun Listener convenablement declare dans %s
Probleme lors de la mise a jour de la table %s
Le repertoire %s n'existe pas
Impossible de creer le repertoire %s
Impossible d'ecrire dans le repertoire %s
Impossible de lire le contenu du repertoire %s
Le fichier %s n'existe pas ou est vide
Le fichier %s existe deja
Le fichier %s n'est pas au format %s
Erreur lors de l'initialisation du fichier %s
Probleme lors de la restauration/decompression de %s
Probleme lors de la decompression de %s
Probleme lors de la compression de %s
Probleme lors de la securisation/compression de %s
Le Lecteur %s doit etre NO REWIND pour avancer/reculer
Le device %s n'existe pas ou est indisponible
Probleme lors de la creation du lien vers %s
Le lecteur %s est inaccessible
Impossible d'aller sous le répertoire '%s'.
L'instance Oracle %s n'est pas demarree
L'instance Oracle %s n'est pas arretee
%s n'est pas un mode d'arret Oracle valide
%s n'est pas un mode de demarrage Oracle valide
La base Oracle %s existe deja dans /etc/oratab
Impossible de retrouver l'environnement de l'instance Oracle %s
Impossible de trouver l'environnement de l'instance Sqlnet %s
Impossible de retrouver l'init file de la base %s
Le fichier de config de %s n'est pas renseigne dans l'initfile
Les controlfiles de %s ne sont pas renseignes dans les initfiles
Les parametres d'archive %s n'existent pas dans les initfiles
Parametre log_archive_dest de %s non defini dans les initfiles
Parametre log_archive_format de %s non defini dans les initfiles
L'archivage de %s n'est pas demarre correctement
L'archivage de %s n'est pas arrete correctement
Script SQL %s non accessible
Le script SQL %s ne s'est pas execute correctement
Probleme lors de la suppression de la table %s 
Probleme a l'execution du delete ou truncate de %s sur $ORACLE_SID
Aucun Archive Oracle pour la Base %s

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages | Sort -o Message by Error ASC, Function DESC', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort -o Message by Error ASC, Function DESC'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort -o Message by Error ASC, Function DESC'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort -o Message by Error ASC, Function DESC'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort -o Message by Error ASC, Function DESC'."> errstd") or diag($return_error);


##################
# Select from error_messages | Sort -u -o Function BY Error,Message
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function'@@ROW='$Function'@@SIZE='20s'@@HEADER='Liste des messages d'erreur de variable evaluee'@@KEY='Function'
TEST_${TESTVAR}
V1_alim_30_motcle
ME_LOAD_TABORA
ME_RESTORE_TABORA
PC_LISTBACK_ARCHORA
ME_SECURE_TABORA
generic
V1_alim_40_meth
PC_STAT_TNSNAME
ME_CREATE_SYNORA
ME_DROP_SYNORA
TEST
PC_CHGSTAT_SERV
PC_INITF_SQLNET
Insert
Modify
Replace
Check
Remove
PC_SWITCH_LOGORA
PC_LISTBACK_CTRLORA
PC_BACK_TBSORA
ME_TRUNC_TABORA
PC_LISTID_INSORA
PC_LISTID_SQLNET
FT_LISTLST_SQLNET
FT_LIST_TNSNAME
PC_ENV_SQLNET

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages | Sort -u -o Function BY Error,Message', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages | Sort -u -o Function BY Error,Message'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages | Sort -u -o Function BY Error,Message'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages | Sort -u -o Function BY Error,Message'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages | Sort -u -o Function BY Error,Message'."> errstd") or diag($return_error);


##################
# Select from error_messages_dup | Sort -u
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test'@@KEY='Function;Error'
Check;65;Non unicite de la clef
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

run3('Select from error_messages_dup | Sort -u', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_dup | Sort -u'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_dup | Sort -u'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_dup | Sort -u'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_dup | Sort -u'."> errstd") or diag($return_error);


##################
# Select from error_messages_dup | Sort -r -u
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur de test'@@KEY='Function;Error'
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
generic;152;L'intance %s est invalide ou non demarrée.
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;149;Probleme d'environnement %s
generic;148;Vous n'avez pas les droits %s.
generic;134;La date '%s' ne correspond pas au format %s.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;132;Le format de la date '%s' est invalide.
generic;131;Le tri de séléction '%s' est invalide.
generic;130;Options de commande %s incompatibles
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;128;La table %s ne possede pas de cle primaire.
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
generic;68;Aucune ligne trouvee
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;66;Le groupe d'utilisateurs %s n'existe pas
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
generic;8;La condition de selection n'est pas valide
generic;7;La colonne %s n'existe pas
generic;6;La table %s est une table virtuelle
generic;5;Le fichier de definition %s n'est pas valide
generic;4;Impossible de trouver le fichier %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;2;Impossible de trouver la table %s
generic;1;Impossible de trouver l'executable %s
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
Replace;97;Aucune valeur a remplacer n'est specifiee
Replace;68;Aucune ligne trouvee a remplacer
Replace;8;La condition de selection de la cle n'est pas valide
Remove;68;Aucune ligne trouvee a supprimer
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
Modify;97;Aucune valeur a modifier n'est specifiee
Modify;68;Aucune ligne trouvee a modifier
Modify;8;La condition de selection de la cle n est pas valide
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
Insert;97;Aucune valeur a inserer n'est specifiee
Insert;8;La condition de selection de la cle n'est pas valide
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
Check;65;Non unicite de la clef

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_dup | Sort -r -u', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_dup | Sort -r -u'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_dup | Sort -r -u'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_dup | Sort -r -u'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_dup | Sort -r -u'."> errstd") or diag($return_error);


##################
# Select from error_messages_dup | Sort -s -u
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Check;65;Non unicite de la clef
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

run3('Select from error_messages_dup | Sort -s -u', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_dup | Sort -s -u'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_dup | Sort -s -u'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_dup | Sort -s -u'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_dup | Sort -s -u'."> errstd") or diag($return_error);


##################
# Select from error_messages_dup | Sort -r -s -u
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
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
generic;152;L'intance %s est invalide ou non demarrée.
generic;151;Variables inconnues BV_ORAUSER et/ou BV_ORAPASS
generic;150;Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID
generic;149;Probleme d'environnement %s
generic;148;Vous n'avez pas les droits %s.
generic;134;La date '%s' ne correspond pas au format %s.
generic;133;Les eléments % de la date doivent être séparés par un caractère.
generic;132;Le format de la date '%s' est invalide.
generic;131;Le tri de séléction '%s' est invalide.
generic;130;Options de commande %s incompatibles
generic;129;La valeur d'une cle primaire ne peut-etre nulle.
generic;128;La table %s ne possede pas de cle primaire.
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
generic;68;Aucune ligne trouvee
generic;67;Impossible de remplacer une ligne sur une table sans clef
generic;66;Le groupe d'utilisateurs %s n'existe pas
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
generic;8;La condition de selection n'est pas valide
generic;7;La colonne %s n'existe pas
generic;6;La table %s est une table virtuelle
generic;5;Le fichier de definition %s n'est pas valide
generic;4;Impossible de trouver le fichier %s
generic;3;Impossible de trouver ou d'ouvrir le fichier de definition %s
generic;2;Impossible de trouver la table %s
generic;1;Impossible de trouver l'executable %s
V1_alim_40_meth;0004;L'Insertion du type physique %s a echoue
V1_alim_40_meth;0003;L'Insertion de la variable interne %s a echoue
V1_alim_40_meth;0002;L'Insertion de la methode physique %s a echoue
V1_alim_40_meth;0001;Le mot cle d'action %s n'existe pas
V1_alim_30_motcle;0004;ECHEC de l'insertion du mot cle %s dans t_me_ma
V1_alim_30_motcle;0003;Rang de l'argument de la methode %s incoherent
V1_alim_30_motcle;0002;Argument de la methode %s non declare dans me_alma
V1_alim_30_motcle;0001;ECHEC ce l'Insert Arg de %s dans t_me_alma
Replace;97;Aucune valeur a remplacer n'est specifiee
Replace;68;Aucune ligne trouvee a remplacer
Replace;8;La condition de selection de la cle n'est pas valide
Remove;68;Aucune ligne trouvee a supprimer
PC_SWITCH_LOGORA;128;Impossible d'interroger les logfiles pour %s
PC_SWITCH_LOGORA;127;Probleme lors du switch des logfiles de %s
PC_STAT_TNSNAME;003;Erreur de configuration de l'adresse du service TNS %s
PC_STAT_TNSNAME;002;Il n'y a pas de listener demarre servant le service TNS %s
PC_STAT_TNSNAME;001;Le service TNS %s n'est pas decrit
PC_LISTID_SQLNET;182;Impossible de trouver le Noyau SqlNet du user %s
PC_LISTID_INSORA;182;Impossible de trouver la Base du user %s
PC_LISTBACK_CTRLORA;132;Impossible d'interroger les controlfiles de %s
PC_LISTBACK_CTRLORA;128;Impossible d'interroger les logfiles de %s
PC_LISTBACK_ARCHORA;0002;Il n'existe pas d'archives commençant a la sequence %s.
PC_LISTBACK_ARCHORA;0001;Il manque la sequence d'archives %s pour la base %s
PC_INITF_SQLNET;004;La configuration SqlNet %s de %s est introuvable
PC_ENV_SQLNET;506;Impossible de trouver l'environnement de l'instance Sqlnet %s
PC_CHGSTAT_SERV;0004;Aucune instance n'est associee a l'application %s
PC_BACK_TBSORA;139;Probleme pour manipuler le TBSPACE %s
PC_BACK_TBSORA;138;Probleme pour mettre le TBSPACE %s en END BACKUP
PC_BACK_TBSORA;137;Probleme pour mettre le TBSPACE %s en BEGIN BACKUP
Modify;97;Aucune valeur a modifier n'est specifiee
Modify;68;Aucune ligne trouvee a modifier
Modify;8;La condition de selection de la cle n est pas valide
ME_TRUNC_TABORA;176;Probleme de truncate sur %s (Contrainte type P referencee) 
ME_SECURE_TABORA;0365;Probleme lors de la mise a jour de la table %s
ME_SECURE_TABORA;0004;Impossible de recuperer la taille de la sauvegarde
ME_SECURE_TABORA;0003;Erreur lors de la securisation de la table %s
ME_SECURE_TABORA;0002;Impossible de recuperer la taille de la table %s
ME_SECURE_TABORA;0001;Impossible de recuperer la taille du tablespace %s
ME_RESTORE_TABORA;0001;Erreur lors de la restauration de la table %s
ME_LOAD_TABORA;0001;Echec du Load sqlldr de %s
ME_DROP_SYNORA;0001;Probleme a la suppression du Synonyme %s
ME_CREATE_SYNORA;0001;Probleme a la creation du Synonyme %s
Insert;97;Aucune valeur a inserer n'est specifiee
Insert;8;La condition de selection de la cle n'est pas valide
FT_LIST_TNSNAME;346;Aucun Service TNS convenablement declare dans %s
FT_LISTLST_SQLNET;346;Aucun Listener convenablement declare dans %s
Check;65;Non unicite de la clef

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select from error_messages_dup | Sort -r -s -u', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select from error_messages_dup | Sort -r -s -u'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select from error_messages_dup | Sort -r -s -u'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select from error_messages_dup | Sort -r -s -u'."> output <".q{generic;52...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select from error_messages_dup | Sort -r -s -u'."> errstd") or diag($return_error);

source_profile('t/sample/Define_Table_error_messages.sh');

##################
# Select -s from error_messages | Sort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'@@FORMAT='Function;Error;Message'@@ROW='$Function;$Error;$Message'@@SIZE='20s;4n;80s'@@HEADER='Liste des messages d erreur'@@KEY='Function;Error'
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

run3('Select -s from error_messages | Sort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages | Sort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages | Sort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages | Sort'."> output <".q{SEP=';'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages | Sort'."> errstd") or diag($return_error);


##################
# Select -s from error_messages | Sort -s
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

run3('Select -s from error_messages | Sort -s', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages | Sort -s'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages | Sort -s'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages | Sort -s'."> output <".q{Check;65;N...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages | Sort -s'."> errstd") or diag($return_error);

