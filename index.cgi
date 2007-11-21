#!/usr/local/bin/perl  -w

use lib 'lib';
use CGI::Carp qw(fatalsToBrowser);
use strict;
use OurCal;
use OurCal::Config;
use OurCal::Handler;
use OurCal::Provider;
use OurCal::View;

$|++;

my $config    = OurCal::Config->new( file => 'ourcal.conf' );
my $provider  = OurCal::Provider->new( config => $config );
my $handler   = OurCal::Handler->new;
my $cal       = OurCal->new( date => $handler->date, user => $handler->user, provider => $provider );
my $view      = OurCal::View->load_view($handler->view, config => $config->config, calendar => $cal); 


print $handler->header($view->mime_type);
print $view->handle($handler->mode);

