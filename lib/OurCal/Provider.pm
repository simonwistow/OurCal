package OurCal::Provider;

use strict;
use UNIVERSAL::require;
use Module::Pluggable sub_name    => '_providers',
                      search_path => 'OurCal::Provider';

=head1 NAME

OurCal::Provider - class for getting events and TODOs from the system

=head1 CONFIGURATION

The default provider is a Multi provider named C<providers>. This means 
that you can do

    [providers]
    providers=default birthday 

    [default]
    dsn=dbi:SQLite:ourcal
    type=dbi

    [birthday]
    file=birthday.ics
    type=icalendar

Alternatively you can specify another default provider using the 
provider config option

    provider=cache_everything

    [cache_everything]
    child=providers
    type=cache

    [providers]
    providers=default birthday 
    type=multi

    [default]
    dsn=dbi:SQLite:ourcal
    type=dbi

    [birthday]
    file=birthday.ics
    type=icalendar


Read individual providers for config options.

=head1 METHODS

=cut

=head2 get_provider <param[s]>

Requires an C<OurCal::Config> object as config param.

Automatically instantiates the default provider.

=cut


# TODO if the child of a cache is an icalendar provider 
# and the icalendar provider has the same cache a sa cache then there'll be
# a deep recursion. We should fix this somehow.
sub get_provider {
    my $class = shift;
    my %what  = @_;

    # first work out what provider we're using
    my $conf     = $what{config};
    my @args ;
    my $name     = $conf->{_}->{provider};
    if (defined $name) {
        push @args, $name;
    } else {
        push @args, ("providers", $conf, type => "multi");
    }
    # then load it
    return $class->load_provider(@args); 
}

=head2 providers

Returns a hash of all providers installed on the system as key-value 
pairs of the name of the provider and class it represents.

=cut

sub providers {
    my $self  = shift;
    my $class = (ref $self)? ref($self) : $self;

    my %providers;
    foreach my $provider ($self->_providers) {
        my $name = $provider;
        $name =~ s!^${class}::!!;
        $providers{lc($name)} = $provider;
    }
    return %providers;
}

=head2 load_provider <name> <config> [option[s]]

Load a provider with a given name as defined in the config and returns 
it as an object.

=cut

sub load_provider {
    my $self  = shift;
    my $name  = shift;
    my $conf  = shift;  
    my %opts  = @_;
    my $pconf = $conf->config($name) || die "Don't know about provider $name\n";
    my $type  = $pconf->{type}       || $opts{type}  || die "Couldn't work out type for provider $name - you must provide a 'type' config\n"; 
    my %provs = $self->providers;
    my $class = $provs{lc($type)}    || die "Couldn't get a class for provider $name of type $type\n";
    $class->require || die "Couldn't require class $class: $@\n";
    return $class->new(config => $conf, name => $name);
}

1;

