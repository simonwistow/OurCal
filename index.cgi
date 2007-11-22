#!/usr/local/bin/perl  -w

use lib 'lib';
use CGI::Carp qw(fatalsToBrowser);
use strict;
use OurCal;
use OurCal::Config;
use OurCal::Handler;
use OurCal::View;


$|++;

my $config    = OurCal::Config->new( file => 'ourcal.conf' );
my $handler   = OurCal::Handler->new( config => $config );
my $cal       = OurCal->new( date => $handler->date, user => $handler->user, config => $config );
my $view      = OurCal::View->load_view(config => $config->config, calendar => $cal); 


print $handler->header($view->mime_type);
print $view->handle($handler->mode);

