package  OurCal::Dbi;

use DBI;

my $dbh = undef; # Global DBH handler

my $db  = 'cal';
my $u   = 'username';
my $p   = 'pass';
sub get_dbh
{
       # if it's already defined return it
       return $dbh if (defined $dbh);

       # otherwise do a new connection to the DBH
       $dbh = DBI->connect("dbi:mysql:$db",$u,$p) || die "Erk  - couldn't connect to db $db\n";
       return $dbh;
}

sub trim {
    my($self, $text) = @_;

    $text =~ s/^\s*(.+=?)\$/$1/;

    return $text;


}

1;


