package OurCal::View::Atom;

use strict;
use XML::Atom::Feed;
use XML::Atom::Entry;
use XML::Atom::Link;
use Text::Chump;
use OurCal::Month;
use OurCal::Day;

=head2 mime_type

Returns the mime type of this view - 'application/atom+xml'

=cut

sub mime_type {
	"application/atom+xml";
}

=head2 new <param[s]>

=cut

sub new {
    my $class = shift;
    my %what  = @_;
    return bless \%what, $class;
}

=head2 handle <param[s]>

Returns a string of Atom representing events.

Can optionally take a limit param which describes the number of events
to have. Defaults to 50.

=cut


sub handle {
    my $self   = shift;
    my %opts   = @_;
    $opts{limit} ||= 50;
    my $tc1     = Text::Chump->new;
    $tc1->install('link', sub { return $_[2] });

    my $tc2     = Text::Chump->new;
	my $feed    = XML::Atom::Feed->new;
	my $h       = $self->{handler};

   	$feed->link(_make_link($h->full_link(OurCal::Month->new(date => $h->date))));

    foreach my $item ($self->{calendar}->events(%opts)) {
		my $entry = XML::Atom::Entry->new;
    	$entry->title($item->date." - ".$tc1->chump($item->description));
    	$entry->link(_make_link($h->full_link(OurCal::Day->new(date => $item->date))));
    	$entry->content($tc2->chump($item->description));
		$feed->add_entry($entry);
	}
	
    return $feed->as_xml;

}

sub _make_link {
	my $url = shift;
 	my $link = XML::Atom::Link->new;
    $link->type('text/html');
    $link->rel('alternate');
    $link->href($url);
	return $link;
}

1;
