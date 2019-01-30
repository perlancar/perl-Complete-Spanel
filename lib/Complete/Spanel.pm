package Complete::Spanel;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::Common qw(:all);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_spanel_site
                );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Completion routines related to Spanel',
};

$SPEC{complete_spanel_site} = {
    v => 1.1,
    summary => 'Complete from a list of sites in /home/spanel/site (/s)',
    description => <<'_',

Root will be able to read the content of this directory. Thus, when run as root,
this routine will return complete from list of sites on the system. Normal users
cannot; thus, when run as normal user, this routine will return empty answer.

_
    args => {
        %arg_word,
        wildcard => {
            schema => ['int*', in=>[0,1,2]],
            default => 0,
            summary => 'How to treat wildcard subdomain',
            description => <<'_',

0 means to skip it. 1 means to return it as-is (e.g. `_.example.com`) while 2
means to return it converting `_` to `*`, e.g. `*.example.com`.

_
        },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_spanel_site {
    require Complete::Util;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $wildcard = $args{wildcard} // 0;

    my @sites;
    {
        opendir my $dh, "/home/sloki/site" or last;
        while (defined(my $e = readdir $dh)) {
            next if $e eq '.' || $e eq '..';
            if ($e =~ /^_/) {
                next if !$wildcard;
                s/^_/*/ if $wildcard == 2;
            }
            push @sites, $e;
        }
    }
    Complete::Util::complete_array_elem(
        word => $word,
        array => \@sites,
    );
}

1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO
