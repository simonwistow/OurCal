package OurCal::View::RSS;

use strict;
use XML::RSS;
use Text::Chump;
use OurCal::Month;
use OurCal::Day;

=head2 mime_type

Returns the mime type of this view - 'application/rss+xml'

=cut

sub mime_type {
	"application/rss+xml";
}

=head2 new <param[s]>

=cut

sub new {
    my $class = shift;
    my %what  = @_;
    return bless \%what, $class;
}

=head2 handle <param[s]>

Returns a string of RSS representing events.

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


	my $rss    = XML::RSS->new( version => '1.0' );
    my $h      = $self->{handler};

    $rss->channel(
   		link         => $h->full_link(OurCal::Month->new(date => $h->date)),
	);

    foreach my $item ($self->{calendar}->events(%opts)) {
		$rss->add_item(
   			title       => $item->date." - ".$tc1->chump($item->description),
   			link        => $h->full_link(OurCal::Day->new(date => $item->date)),
   			description => $tc2->chump($item->description),
 		);
	}
	
    return $rss->as_string;

}

1;
