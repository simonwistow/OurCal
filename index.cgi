#!/usr/local/bin/perl  -w

use lib 'lib';

use strict;
use CGI();
use CGI::Carp qw(fatalsToBrowser);

use Template;
use OurCal;
use OurCal::Todo;


# set up the vars and defaults
my $cgi          = CGI->new();

print $cgi->header();

my $template     = Template->new({ INCLUDE_PATH => 'templates', RELATIVE => 1});
my $vars         = {};

$vars->{sub} = sub { return sub { return uc $_[1] } };




# get the date
my $cal  = OurCal->new($cgi->param('date'), $cgi->param('user'));
my $mode = $cal->mode();

if ($cgi->param('new_todo')) {
    my %what = (description => $cgi->param('new_todo'));
    $what{user} = $cgi->param('user') if $cgi->param('user');
    my $t = OurCal::Todo->new(%what)->save();
} elsif ($cgi->param('del_todo')) {
    my $t = OurCal::Todo->new(id => $cgi->param('del_todo'))->del();
}


$vars->{testing} = sub { return 'foo' };

if ($mode eq 'day') {

    my $day = $cal->day();
    if ($cgi->param('new_event')) {
        my %what = (date => $cal->date(), description => $cgi->param('new_event'));
        $what{user} = $cgi->param('user') if $cgi->param('user'); 
        my $e = OurCal::Event->new(%what)->save();
    } elsif ($cgi->param('del_event')) {
        my $e = OurCal::Event->new(id => $cgi->param('del_event') )->del();
    }


    $vars->{day}    = $day;



} else {
    $vars->{month}  = $cal->month(); 
}


$vars->{IMAGES} = 'images';
$vars->{user}   = $cgi->param('user') if defined $cgi->param('user');
$vars->{todos}  = $cal->get_todos();


$template->process("$mode",$vars) 
    || die "Template process failed: ", $template->error(), "\n";

