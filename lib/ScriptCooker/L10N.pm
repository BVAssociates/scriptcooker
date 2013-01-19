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
