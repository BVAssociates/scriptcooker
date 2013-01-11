package ScriptCooker::L10N;

use strict;
use warnings;

our $VERSION=2.1.0;

use base qw(Locale::Maketext);

sub fallback_languages {
    my @fallback_languages=(
                "fr",
            );

    return @fallback_languages;
}

1;
