#!/usr/local/bin/perl  -w

use lib 'lib';

use strict;
use OurCal;
use Data::ICal::DateTime;
use Data::ICal::Entry::Event;
use Digest::MD5 qw(md5_hex);
use HTTP::Date;
use DateTime;
use Text::Chump;
use CGI qw(:standard);
use URI::Find::Simple qw(list_uris);

my $tc = Text::Chump->new;
my $ourcal  = OurCal->new();
my $cal = Data::ICal->new();
my @events = $ourcal->get_raw_events(param('limit'));

$tc->install('link', sub { return "$_[2] ($_[1])" });

foreach my $item (@events) {
       my $event = Data::ICal::Entry::Event->new;
       my $date  = _make_date($item->{date});
       my $uid   = md5_hex($date.$item->{description});
       my $desc  = $tc->chump($item->{description});
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

sub _make_date {
    my $date = shift;
    my ($y, $m, $d) = split /-/, $date;
    return DateTime->new( year => $y, month => $m, day => $d);
}

print header( -type => 'text/calendar');
print $cal->as_string;
