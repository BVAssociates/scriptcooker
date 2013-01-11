package ScriptCooker::ITable::ITools_interface;

our $VERSION=2.1.0;

# code import
use strict;
use warnings;
use Scalar::Util qw(blessed);

use Carp;
my $package=__PACKAGE__;
$Carp::Internal{$package} = 1;

# logger singleton
use ScriptCooker::Log 2.1.0 qw{$logger _t};
use ScriptCooker::Utils 2.1.0;

##################################################
##  constructor  ##
##################################################

use fields qw {
        define_obj
        pci_obj

        query_field
        query_condition
        query_sort
        query_distinct
        query_reverse
        output_separator

        custom_select_query
        dynamic_field
        modified_query_field

        force_insert
};

# open(table_name)
sub open {
    my $self = shift;

    # creer nouvel objet si non-hérité
    $self = fields::new($self) if ! ref $self;
    
    my $options;
    
    # mandatory parameter
    if (@_ < 1) {
        croak ('Usage: ${class}->open(ScriptCooker::Define $obj)')
    }

    my $define_obj = shift;
    if ( ! blessed($define_obj) || ! $define_obj->isa("ScriptCooker::Define") ) {
        croak ('Usage: '.ref($self).'->open(ScriptCooker::Define $obj)')
    }
    $self->{define_obj} = $define_obj;

    ############
    # Data members
    ############
    
    # internal description
    #$self->{key} = [];
    #$self->{field}= [];
    #$self->{field_txt}= {};
    #$self->{field_desc}= {};
    #$self->{size}= {};
    #$self->{not_null}= [];
    
    # default query
    $self->{query_field}        = [ $self->{define_obj}->field() ];
    $self->{output_separator}   = $self->{define_obj}->separator();
    $self->{query_sort}         = [ $self->{define_obj}->sort() ];
    $self->{query_condition}    = [];
    $self->{query_distinct}     = 0;
    $self->{query_reverse}      = 0;
    $self->{custom_select_query}= undef;
    $self->{dynamic_field}      = {};

    # contient 1 si les champs de la requete ont été modifiés
    $self->{modified_query_field} = 0;

    $self->{force_insert}       = 0;
    
    return $self;
}


##############################################
## accessor methods         ##
##############################################

sub definition {
    my $self = shift;
    if (@_) { croak("'definition' member is read-only") }
    return $self->{define_obj};
}

sub table_name {
    my $self = shift;
    if (@_) { croak("'table_name' member is read-only") }
    return $self->{define_obj}->{name};
}

sub field {
    my $self = shift;
    if (@_) { croak("'field' member is read-only") }
    return @{ $self->{define_obj}->{field} };
}

sub key {
    my $self = shift;
    if (@_) { croak("'key' member is read-only") }
    return @{ $self->{define_obj}->{key} };
}

sub field_size {
    my $self = shift;
    my $field = shift;

    if ( ! $field ) {
        croak(_t("usage: [_1]", 'field_size($field)'));
    }

    return $self->{define_obj}->{size}->{$field};
}

sub pci {
    my $self = shift;
    if (@_) { $self->{pci_obj}=shift @_ };
    return $self->{pci_obj};
}

##Query Values

sub output_separator {
    my $self = shift;
    if (@_) { $self->{output_separator} = shift }
    return $self->{output_separator};
}

sub query_field {
    my $self = shift;

    my @fields=@_;
    if (@fields) {
        my @field_found=$self->has_fields(@fields);
        
        my %seen_field;
        foreach (@field_found, @fields) {
            $seen_field{$_}++;
        }
        
        my @error_fields;
        foreach (keys %seen_field) {
            push @error_fields, $_ if $seen_field{$_} < 2;
        }
        
        if (@error_fields) {
            croak("error querying fields <@error_fields>");
        } else {
            @{ $self->{query_field} } =  @fields;
            $self->{modified_query_field} = 1;
        }
    }
    
    return @{ $self->{query_field} }
}

sub query_condition {
    my $self = shift;
    if (@_) {
        @{ $self->{query_condition} } = grep {$_} @_;
    }
    
    return @{ $self->{query_condition} };
}

sub query_sort {
    my $self = shift;
    
    if (@_) {
        @{ $self->{query_sort} } = grep {$_} @_;
    }

    if (@{ $self->{query_sort} }) {

        # verification
        my @fields = @{ $self->{query_sort} };
        my @temp_fields = @fields;
        map { s/\s+(ASC|DESC)$//i } @temp_fields;

        if ( $self->has_fields(@temp_fields) != @fields) {
            $self->{query_sort}=[];
            croak("error with sort fields <@fields>");
        }
    }
    
    return @{ $self->{query_sort} };
}

sub query_distinct {
    my $self = shift;
    
    if (@_) {
        my $enable=shift;
        if ( $enable ) {
            $self->{query_distinct}=1;
        }
        else {
            $self->{query_distinct}=0;
        }
    }
    
    return $self->{query_distinct};
}

sub query_reverse {
    my $self = shift;
    
    if (@_) {
        my $enable=shift;
        if ( $enable ) {
            $self->{query_reverse}=1;
        }
        else {
            $self->{query_reverse}=0;
        }
    }
    
    return $self->{query_reverse};
}

sub dynamic_field {
    my $self = shift;
    if (@_) {
        $self->{dynamic_field}={};
        foreach my $field (@_) {
            $self->{dynamic_field}->{$field} = undef;
        }   
    }   
    return %{ $self->{dynamic_field} };
}


# active le mode "insert or replace"
sub force_insert {
    my $self = shift;

    if (@_) {
        my $enable=shift;
        if ( $enable ) {
            $self->{force_insert}=1;
        }
        else {
            $self->{force_insert}=0;
        }
    }
    
    return $self->{force_insert};
}

##############################################
##  private methods        ##
##############################################



##############################################
##  public methods        ##
##############################################

# quote and escape special char
sub quote {
    my $self=shift;
    my $string=shift;
    
    $string =~ s/\'/\\'/;
    return "'".$string."'";
}

# set custom SQL query
sub custom_select_query {
    my $self = shift;
    
    
    
    # return the user's SQL query
    $self->{custom_select_query} = shift;
}

# Create an SQL query
sub get_query {
    my $self = shift;
    
    # return the user's SQL query
    return $self->{custom_select_query} if $self->{custom_select_query};
    
    my $distinct="";
    $distinct="DISTINCT" if $self->query_distinct;
    
    # construct SQL from "query_*" members
    my $query;
    $query = "SELECT ".$distinct." ".join(', ',$self->query_field()).
    $query .= " FROM ".$self->table_name();

    if ( $self->query_condition() != 0 ) {
        $query .= " WHERE ".join(' AND ',$self->query_condition());
    }

    if ( $self->query_sort() != 0 ) {
        $query .= " ORDER BY ".join(', ',$self->query_sort());
    }
    
    return $query;
}


# explicitly reset the current statement
sub finish {
    my $self = shift;
    
    croak "finish() not implemented";
}

# force the current statement to stop and disconnecte from database
sub close {
    my $self = shift;
    
    croak "close() not implemented";
}

# get row  by one based on query
sub fetch_row_array {
    my $self = shift;

    croak "fetch_row_array() not implemented";
}

#get hash of row by one based on query
sub fetch_row {
    my $self = shift;

    my @row=$self->fetch_row_array();
    my %row_object;
    
    return () if not @row;
    
    foreach my $temp_field (@{ $self->{query_field} }) {
        if ( exists $self->{dynamic_field}->{$temp_field} ) {
            $row_object{$temp_field}="";
        }
        else {
            croak "fetch_row_array returned wrong number of values (need more field)" if not @row;
            $row_object{$temp_field}=shift @row;
        }
    }
    
    # internal test
    croak "fetch_row_array returned wrong number of values (too much field)" if  @row;

    #for (my $i=0; $i < @real_fields; $i++) {
    #    $row_object{$real_fields[$i]}=$row[$i];
    #}
    #for (@dyna_fields) {
    #    $row_object{$_}="";
    #}
        
    return %row_object;
}

# simple procedure to display a table
sub display_table {
    my $self=shift;
    
    while (my %row=$self->fetch_row()) {
        my @print_row;
        foreach my $field ($self->query_field) {
            my $sep=$self->output_separator();
            if (defined $row{$field}) {

                if ( ! $ENV{IT20_COMPLIANT} ) {
                    $row{$field} =~ s/\Q$sep\E/\\$sep/g;
                }
                push @print_row,$row{$field};
            }
            else {
                push @print_row,"";
            }
        }
        print(join($self->output_separator,@print_row),"\n");
    }

}

# renvoie la ligne d'entete d'un Select
sub get_select_header {
    my $self=shift;

    my @var_list=@_;

    my @allowed_var = qw(
            SEP
            FORMAT
            ROW
            SIZE
            HEADER
            KEY
        );

    if (@var_list) {
        foreach my $var ( @var_list ) {
            if ( ! grep {$_ eq $var} @allowed_var ) {
                croak(_t("Usage : [_1]",'select_header(@var_list)'));
            }
        }
    }
    else {
        @var_list=@allowed_var;
    }

    my %value_for_var = (
            SEP     => $self->output_separator(),
            FORMAT  => join( $self->output_separator(), $self->query_field()),
            HEADER  => $self->definition()->header(),
        );

    # filtrage des clefs primaires
    my @query_key;
    foreach my $key ( $self->key() ) {
        if ( grep {$_ eq $key} $self->query_field() ){
            push @query_key , $key;
        }
    }
    $value_for_var{KEY} = join( $self->output_separator(), @query_key);

    # construction des ROW
    my %row = $self->definition()->row();
    my @query_row = @row { $self->query_field() };
    $value_for_var{ROW} = join( $self->output_separator(), @query_row);

    # construction des SIZE
    my %size = $self->definition()->size();
    my @query_size = @size { $self->query_field() };
    $value_for_var{SIZE} = join( $self->output_separator(), @query_size);

    my @desc_list;
    foreach my $var ( @var_list ) {
        push @desc_list, sprintf("%s='%s'", $var, $value_for_var{$var});
    }

    return join('@@', @desc_list);
}

sub execute {
    my $self = shift;
    
    croak "execute() not implemented";
}

# ------------------------------------------
# Nom : Ft::eval_trigger
#
# Description :
# Execute les triggers déclarés dans le pci de la table
#
# Arguments :
#   - action : action en cours (Remove, Replace, Insert)
#   - type : type de trigger (PreAction, PostAction)
# ------------------------------------------
sub eval_trigger {
    my $self=shift;
    
    my $action=shift;
    my $type=shift;
    
    my @valid_actions = (
            "Remove",
            "Replace",
            "Insert",
        );
        
    my @valid_types = (
        "PreAction",
        "PostAction",
    );
    
    if ( ! grep {$_ eq $action} @valid_actions 
        or ! grep {$_ eq $type} @valid_types ) {
        
        croak(_t("usage: [_1]", 'eval_trigger(action,type)'));
    }

    # ouverture du PCI
    my $itable_pci = $self->pci();
    
    # preparation du resultat
    $itable_pci->query_sort("");
    $itable_pci->eval_env_vars(1);
    $itable_pci->eval_condition(1);

    my $condition = join( ' and ',
                            "Group='$action'",
                            "Label='$type'",
                            "Processor='ExecuteProcedure'",
                        );
    $itable_pci->query_condition($condition); 
    
    my $trigger_error=0;
    while (my %trigger = $itable_pci->fetch_row() ) {

        # traite le Preprocessing
        # doit être des variables au format VAR='VALUE' ou bien {VAR='VALUE'}{VAR='VALUE'}
        my %vars;
        if ( $trigger{PreProcessing} ) {
        
            if ( $trigger{PreProcessing} =~ /^\{.*\}$/ ) {
                %vars= ( $trigger{PreProcessing} =~ /\{([^}]*)=([^}]*)\}/g);
                
            }
            elsif ( $trigger{PreProcessing} =~ /^(.+)=(.+)$/ ) {
                %vars= ($1 => $2);
            }
            else {
                $trigger{PreProcessing}=~s/([\[\]])/~$1/g;
                die(_t("Impossible de reconnaitre le format de PreProcessor : [_1]",$trigger{PreProcessing}));
            }
            
            # retire les eventuelles '"
            foreach (values %vars) {
                s/^(['"])(.*)\1$/$2/
            }
        }
        # met à jour l'environnement temporairement avec local
        local %ENV=(%ENV, %vars);
        
        # reevalue les arguments
        $trigger{Arguments} = evaluate_variables($trigger{Arguments}, {leave_unknown => 1});
        
         # verifie les conditions
        if ( $trigger{Condition} eq 'true' ) {
        
            # execution du trigger
            $logger->info(_t("Declenchement du trigger : [_1]", $trigger{Arguments}));
            system($trigger{Arguments});
            if ( $? != 0 ) {
                $trigger_error++;
                warn(_t("Erreur à l'execution du trigger [_1]",$trigger{Arguments}));
            }
        }
        
    }
    
    if ( $trigger_error ) {
        die(_t("Au moins un trigger de [_1] ([_2]) a renvoyé une erreur",$action,$type));
    }
    
    return;
}


sub check_row {
    my $self=shift;

    my %row=@_;
    
    my @messages;

    # colonnes existent?
    foreach my $set_field ( keys %row ) {
    
        if ( exists $self->{dynamic_field}->{$set_field} ) {
            # colonne dynamique
            # TODO que fait-on?
        }
        elsif ( ! grep { /^$set_field$/ } $self->field() ) {
            push @messages, _t("La colonne [_1] toto n'existe pas",$set_field);
        }
        elsif ( defined $row{$set_field} && $row{$set_field} ne '' ) {

            my %size = $self->{define_obj}->size();

            if (   $size{$set_field} =~ /[dn]$/
                && $row{$set_field} !~ /^\d+([.,]\d+)?$/ )
            {
                push @messages, _t("La valeur donnee pour la colonne [_1] n'est pas correcte.",$set_field);
            }
            elsif (   $size{$set_field} =~ /p$/
                   && $row{$set_field} !~ /^\d+([.,]\d+)?%?$/ )
            {
                push @messages, _t("La valeur donnee pour la colonne [_1] n'est pas correcte.",$set_field);
            }
            elsif (   $size{$set_field} =~ /b$/
                   && $row{$set_field} !~ /^[YNOyno01]$/ )
            {
                push @messages, _t("La valeur donnee pour la colonne [_1] n'est pas correcte.",$set_field);
            }
        }
    }

    # colonnes KEY ont des valeurs?
    foreach my $field ( $self->{define_obj}->key() ) {

        # En I-TOOLS, NULL==""
        if ( ! defined $row{$field} || $row{$field} eq '' ) {
            push @messages, _t("La valeur d'une cle primaire ne peut-etre nulle.");
        }
    }

    # colonnes NOTNULL ont des valeurs?
    foreach my $field ( $self->{define_obj}->not_null() ) {

        # En I-TOOLS, NULL==""
        if ( ! defined $row{$field} || $row{$field} eq '' ) {
            push @messages, _t("La colonne [_1] doit absolument contenir une valeur.",$field);
        }
    }

    return @messages;
}

# convert an array to hash following query_field() fields
sub array_to_hash {
    my $self = shift;
    
    my @row = @_;
    my @query_field=@{ $self->{query_field} };
    croak "Wrong number of fields (has: ".@row.", expected: ".@query_field.")" if @row != @query_field ;
    
    # convert array into hash
    my %row_hash;
    @row_hash{ @query_field} = @row;
    return %row_hash;
}

# convert a hash to array following query_field() fields
sub hash_to_array {
    my $self = shift;
    
    my %row = @_;
    croak "Wrong number of fields (has: ".scalar(keys %row).", expected: ".$self->query_field().")" if (keys %row) < $self->query_field() ;
    
    # convert array into hash
    my @row_array;
    foreach my $field ($self->query_field()) {
        push @row_array, $row{$field} ;
    }
    
    return @row_array;
}

# Insert list  as a row
sub insert_row_array {
    my $self = shift;

    my %row_hash = $self->array_to_hash(@_);
    
    $self->insert_row(%row_hash);
}

# Insert hash  as a row
sub insert_row {
    my $self = shift;
    
    croak("insert_row() not implemented in ".ref($self));
}

# add new field
sub add_field {
    my $self = shift;
    
    croak("add_field() not implemented in ".ref($self));
}

sub remove_field {
    my $self = shift;
    
    croak("remove_field() not implemented in ".ref($self));
}

# update a row on a primary key
sub update_row_array {
    my $self = shift;
    
    my @row = @_;
    croak "Wrong number of fields (has: ".@row.", expected: ".$self->field().")" if @row != $self->field() ;
    
    # convert array into hash
    my %row_hash;
    foreach my $field ($self->field()) {
        $row_hash{$field} = shift @row ;
    }
    
    $self->update_row(%row_hash);
}
# update a row on a primary key
sub update_row {
    my $self = shift;
    
    croak("update_row() not implemented in ".ref($self));
}

# update a row on a primary key
sub delete_row {
    my $self = shift;
    
    croak("delete_row() not implemented in ".ref($self));
}

sub has_fields {
    my $self = shift;
    my @fields_requested = @_;
    my @field_found;
    
    my @field_avaiable=($self->field, $self->dynamic_field);
        
    foreach my $field (@fields_requested) {
        push (@field_found, grep {$field eq $_} @field_avaiable) ;
    }
    #$logger->debug("has fields : ",join(',',@field_found));
    return @field_found;
}

sub equals_struct {
    my $self=shift;
    
    my $data_ref=shift;
    
    croak("argument must be a DATA_interface object") if not (blessed($data_ref) and $data_ref->isa("DATA_interface"));
    
    if ($self->table_name() ne $data_ref->table_name()) {
        $logger->debug("different table_name : ".$data_ref->table_name()." , ".$self->table_name());
    }
    elsif (join(',',$self->key()) ne join(',',$data_ref->key()) ) {
        $logger->error("different keys");
        return 0;
    }
    ## not necessary!
    #elsif (not $self->has_fields($data_ref->field()) ) {
    #    $logger->debug("different fields");
    #    return 0;
    #}
    else {
        $logger->debug("Table are similar");
        return 1;
    }
}


##############################################
## Destructor        ##
##############################################

#sub DESTROY () {
#    my $self = shift;
#    
#}

1;  # so the require or use succeeds



=head1 NAME

 ITable::DATA_Interface - Abstract Interface to access data of IKOS SIP 

=head1 SYNOPSIS

This Class cannnot be instancied as is.
You must use one of the derived Class which implement the open() method and some
method to access data like fetch_row() or insert_row().

As Class sample, you can study the ITable::Sqlite or ITable::ODBC Classes.

 use ITable::Sqlite;
 use ITable::ODBC;

 #################
 # class methods #
 #################
 
 $obj = Sqlite->open($database_specification, "tablename"[ ,{ debug => $num, timeout => $sec } ]);

 #######################
 # object data methods #
 #######################

 # data from table
 my @field = $obj->field();
 my @key = $obj->key();
 my %size = $obj->size();
 my @not_null = $obj->not_null();
 
 # set the query
 $obj->query_field("field1","field2");
 $obj->query_sort("field1","field2");
 $obj->query_condition("field1 = 'VALUE'","field2 = 'VALUE'");
 
 # get one line from the results as an array
 my @line=$obj->fetch_row_array();
 
 #reinitialize the result of the query
 $obj->finish();

 # get all the results as objects
 while (my %line=$obj->fetch_row()) {
    print $line{field1};
 }

 # insert row as object
 $obj->insert_row(field1 => "VALUE2", field2 => "VALUE2");
 
 # insert row as array
 $obj->insert_row("VALUE2", "VALUE2");

=head1 DERIVED CLASSES

=over 4

=item ITable::Sqlite

Access Data from a Sqlite database.

 $obj = Sqlite->open($database_name, $table_name);

=item ITable::ODBC

Access Data from an ODBC database.

 $obj = ODBC->open($DSN, $table_name);

=item ITable::ODBC_TXT

Access Data from a database using the ODBC Text Driver.

 $obj = ODBC_TXT->open($DSN, $table_name);
 
=item ITable::ITools

Access Data from an ITools table.
The table name must be in $BV_TABPATH.

 $obj = ITools->open($table_name);

=item Isip::ITable::Histo

Access Data from a special Sqlite database.

In this special table, the fields are versionned and commented.

 $obj = Histo->open($table_name);

=back 

=head1 DESCRIPTION

Please note the following behaviors :

=over 4

=item *

The class opens the database at object creation to get information about columns, and close it immediatly after this.

=item *

The class opens the database at the first call of a "fetch_row*()" method.

=item *

The class closes the database after the last line of query is retrieved.

=item *

The class closes the database with the "finish()" method.

=back

=head1 AUTHOR

Copyright (c) 2008 BV Associates. Tous droits réservés.

=cut
 
