package OurCal::Config;

use strict;
use Config::INI::Reader;

sub new {
	my $class = shift;
	my %what = @_;
	
	die "You must pass in a 'file' option\n" unless defined $what{file};
	$what{_config} = Config::INI::Reader->read_file($what{file});
	return bless \%what, $class;
}

sub config {
	my $self    = shift;
	my $section = shift || "_";
	return $self->{_config}->{$section}; 
}

1;
