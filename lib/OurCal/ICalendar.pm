package OurCal::ICalendar;

use strict;

use Data::ICal::DateTime;
use Data::ICal::Entry::Event;
use Digest::MD5 qw(md5_hex);
use HTTP::Date;
use DateTime;
use Text::Chump;
use CGI qw(:standard);
use URI::Find::Simple qw(list_uris);

sub new {
    my ($class, %what) = @_;
    return bless \%what, $class;
}

sub mime_type {
    return "text/calendar";
}

sub events {
    my $self   = shift;
    my %opts   = @_;
    $opts{limit} ||= 50;

    my $tc     = Text::Chump->new;
    $tc->install('link', sub { return "$_[2] ($_[1])" });

    my @events = $self->{calendar}->events(%opts);
    my $cal    = Data::ICal->new();


    foreach my $item (@events) {
       my $event = Data::ICal::Entry::Event->new;
       my $date  = $self->_make_date($item->date);
       my $uid   = md5_hex($date.$item->description);
       my $desc  = $tc->chump($item->description);
       my ($url) = list_uris($desc);

       # uid
       $event->uid( $uid );
       # start
       $event->start($date);
       # summary
       $event->summary($desc);
       # description
       $event->description($desc);
       # url
       $event->add_property( url => $url ) if defined $url;

       $cal->add_entry($event);
    }
    return $cal->as_string;

}

sub _make_date {
    my $self = shift;
    my $date = shift;
    my ($y, $m, $d) = split /-/, $date;
    return DateTime->new( year => $y, month => $m, day => $d);
}




sub _get_raw_events {
    my $self = shift;
    my %opts = @_;
    my $dbh  = $self->SUPER::get_dbh();
    my @vals;
    my $sql  = "SELECT * FROM events";
    if (defined $self->{user}) {
        $sql .= " WHERE (user IS NULL OR user=?)";
        push @vals, $self->{user};
    } else {
        $sql .= " WHERE user IS NULL";
    }
    $sql .= " ORDER BY date DESC LIMIT ?";

    my $sth = $dbh->prepare($sql);
    $sth->execute(@vals, $opts{limit});
    return @{$sth->fetchall_arrayref({})};
}

1;
