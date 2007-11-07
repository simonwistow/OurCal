#!/usr/local/bin/perl  -w

use lib 'lib';

use strict;
use CGI();
use CGI::Carp qw(fatalsToBrowser);

use Template;
use OurCal;
use OurCal::Todo;
use OurCal::Handler;
use OurCal::ICalendar;

my $handler = OurCal::Handler->new;
my $mode    = $handler->mode;
my $cal     = OurCal->new( date => $handler->date, user => $handler->user );

if ("ics" eq $mode) {
    my $ical = OurCal::ICalendar->new( calendar => $cal, user => $handler->user );
    print $handler->header($ical->mime_type);
    print $ical->events($handler->param('limit'));
    exit 0;
}

if ("new_todo" eq $mode) {
    $cal->new_todo($handler->description);
} elsif ("del_todo" eq $mode) {
    $cal->del_todo($handler->id);
} elsif ("new_event" eq $mode) {
    $cal->new_event($handler->description);
} elsif ("del_event" eq $mode) {
    $cal->del_event($handler->id);
}


my $span = $cal->span_name;
my $vars = {
    image_url  => 'images',
    handler    => $handler,
    calendar   => $cal,
    $span      => $cal->span,
};
my $template = Template->new({ INCLUDE_PATH => 'templates', RELATIVE => 1}) || die "${Template::ERROR}\n";

print $handler->header;
$template->process($span,$vars) 
    || die "Template process failed: ".$template->error()."\n";

