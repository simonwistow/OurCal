package OurCal::Provider;

use strict;
use UNIVERSAL::require;
use Module::Pluggable sub_name    => '_providers',
                      search_path => 'OurCal::Provider';



sub new {
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
    $what{_provider} = $class->load_provider(@args); 
    return bless \%what, $class;
}


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


sub todos {
    my $self = shift;
    return $self->_do_default('todos', @_);
}

sub has_events {
    my $self = shift;
    return $self->_do_default('has_events', @_);
}

sub events {
    my $self   = shift;
    my %opts   = @_;
    my @events = sort { $b->date cmp $a->date } $self->_do_default('events', %opts);
    @events    = splice @events, 0, $opts{limit} if defined $opts{limit};
    return @events;
}

sub users {
    my $self = shift;
    return $self->_do_default('users', @_);
}

sub save_todo {
    my $self = shift;
    return $self->_do_default('save_todo', @_);
}

sub del_todo {
    my $self = shift;
    return $self->_do_default('del_todo', @_);
}


sub save_event {
    my $self = shift;
    return $self->_do_default('save_event', @_);
}

sub del_event {
    my $self = shift;
    return $self->_do_default('del_event', @_);
}

sub _do_default {
    my $self  = shift;
    my $sub   = shift;
    my $thing = shift;
    $self->{_provider}->$sub($thing, @_);
}
1;

