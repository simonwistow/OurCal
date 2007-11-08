#!/usr/local/bin/perl  -w

use lib 'lib';

use strict;
use CGI();
use CGI::Carp qw(fatalsToBrowser);

use Template;
use OurCal;
use OurCal::Config;
use OurCal::Event;
use OurCal::Todo;
use OurCal::Handler;
use OurCal::ICalendar;
use OurCal::Provider;

my $conf_file = OurCal::Config->new( file => 'ourcal.conf' );
my $config    = $conf_file->config;
my $provider  = OurCal::Provider->new( config => $conf_file );

my $handler = OurCal::Handler->new;
my $mode    = $handler->mode;
my $cal     = OurCal->new( date => $handler->date, user => $handler->user, provider => $provider );

if ("ics" eq $mode) {
    my $ical = OurCal::ICalendar->new( calendar => $cal, user => $handler->user );
    print $handler->header($ical->mime_type);
    print $ical->events($handler->param('limit'));
    exit 0;
}

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

print $handler->header;
$template->process($span,$vars) 
    || die "Template process failed: ".$template->error()."\n";

