package OurCal::View::HTML;

use strict;
use Template;
use OurCal::Todo;
use OurCal::Event;

sub new {
    my ($class, %what) = @_;
    return bless \%what, $class;
}

sub mime_type {
    return "text/html";
}

sub handle {
    my $self    = shift;
    my $mode    = shift;
    my %opts    = @_;    
    my $handler = $self->{handler};
    my $config  = $self->{config};
    my $cal     = $self->{calendar};


    if ("save_todo" eq $mode) {
        my %what = ( description => $handler->param('description') );
        $what{user} = $handler->user if defined $handler->user;
        $cal->save_todo( OurCal::Todo->new(%what));
    } elsif ("del_todo" eq $mode) {
        $cal->del_todo( OurCal::Todo->new( id => $handler->param('id') ) );
    } elsif ("save_event" eq $mode) {
        die "Can't add an event to anything but a day\n"
        unless $cal->span_name eq 'day';
        my %what = ( description => $handler->param('description'), date => $cal->date );
        $what{user} = $handler->user if defined $handler->user;
        $cal->save_event( OurCal::Event->new(%what) );
    } elsif ("del_event" eq $mode) {
        $cal->del_event( OurCal::Event->new( id => $handler->param('id') ) );
    }


    my $span = $cal->span_name;
    my $vars = {
        image_url  => $config->{image_url},
        handler    => $handler,
        calendar   => $cal,
        $span      => $cal->span,
    };
    my $template = Template->new({ INCLUDE_PATH => $config->{template_path}, RELATIVE => 1}) || die "${Template::ERROR}\n";


    my $return;
    $template->process($span,$vars, \$return)
        || die "Template process failed: ".$template->error()."\n";
    return $return;


}


1;
