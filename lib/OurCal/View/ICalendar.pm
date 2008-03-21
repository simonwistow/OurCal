package OurCal::View::ICalendar;

use strict;

use Data::ICal::DateTime;
use Data::ICal::Entry::Event;
use Data::ICal::Entry::Todo;
use Digest::MD5 qw(md5_hex);
use HTTP::Date;
use DateTime;
use Text::Chump;
use CGI qw(:standard);
use URI::Find::Simple qw(list_uris);


=head1 NAME

OurCal::View::ICalendar - an ICalendar view

=head1 METHODS

=cut


=head2 new <param[s]>

=cut

sub new {
    my ($class, %what) = @_;
    return bless \%what, $class;
}

=head2 mime_type 

Returns the mime type of this view - 'text/calendar'

=cut

sub mime_type {
    return "text/calendar";
}

=head2 handle <param[s]>

Returns a string of ICalendar representing events and todo items.

Can optionally take a limit param which describes the number of events 
to have. Defaults to 50.

=cut

sub handle {
    my $self   = shift;
    my %opts   = @_;
    $opts{limit} ||= 50;

    my $tc     = Text::Chump->new;
    $tc->install('link', sub { return "$_[2] ($_[1])" });
    my $tc2     = Text::Chump->new;
    $tc2->install('link', sub { return "$_[2]" });

    my $cal    = Data::ICal->new();


    foreach my $item ($self->{calendar}->events(%opts)) {
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
       $event->summary($tc2->chump($item->description));
       # description
       $event->description($desc);
       # url
       $event->add_property( url => $url ) if defined $url;

       $cal->add_entry($event);
    }

    foreach my $todo ($self->{calendar}->todos) {
        my $entry = Data::ICal::Entry::Todo->new;
        $entry->add_properties(
            summary => $todo->description,
            status  => 'INCOMPLETE',
        );
        my $who = $todo->for; 
        if (defined $who && $who ne "") {
            $entry->add_property(organizer => "MAILTO:$who");
        }
        $cal->add_entry($entry);
    }

    return $cal->as_string;

}

sub _make_date {
    my $self = shift;
    my $date = shift;
    my ($y, $m, $d) = split /-/, $date;
    return DateTime->new( year => $y, month => $m, day => $d);
}

1;
