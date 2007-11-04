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
my $cal  = OurCal->new($cgi->param('date'));
my $mode = $cal->mode();

if ($cgi->param('new_todo')) {
	my $t = OurCal::Todo->new($cgi->param('new_todo'))->save();
} elsif ($cgi->param('del_todo')) {
	my $t = OurCal::Todo->new($cgi->param('del_todo'))->del();
}


$vars->{testing} = sub { return 'foo' };

if ($mode eq 'day') {

	my $day = $cal->day();
	

	if ($cgi->param('new_event')) {
		my $e = OurCal::Event->new({date => $cal->date(), description=>$cgi->param('new_event')})->save();
	} elsif ($cgi->param('del_event')) {
		my $e = OurCal::Event->new({date => $cal->date(), description=>$cgi->param('del_event')})->del();
	}


	$vars->{day}    = $day;



} else {
	$vars->{month}  = $cal->month(); 
}


$vars->{IMAGES} = 'images';

$vars->{todos}  = $cal->get_todos();


$template->process("$mode",$vars) 
	|| die "Template process failed: ", $template->error(), "\n";

