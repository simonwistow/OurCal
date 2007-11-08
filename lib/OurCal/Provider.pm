package OurCal::Provider;

use strict;
use UNIVERSAL::require;

sub new {
    my $class = shift;
    my %what  = @_;
    my $conf  = $what{config}->config('providers');
    my %providers;
    foreach my $name (keys %$conf) {
        my $what     = $conf->{$name};
        my $provider = $class."::".ucfirst(lc($what));
        $provider->require || die "Couldn't require class $provider: $@\n";
        $providers{$name} = $provider->new( config => $what{config}->config($name) );
    }
    die "You must provide a provider named 'default'\n" unless defined $providers{'default'};
    $what{_providers} = { %providers };
    return bless \%what, $class;
}

sub providers {
    my $self = shift;
    return values %{$self->{_providers}};
}

sub todos {
    my $self = shift;
    return $self->_gather('todos', @_);
}

sub has_events {
    my $self = shift;
    my %opts = @_;
    foreach my $provider ($self->providers) {
        return 1 if $provider->has_events(%opts);
    }
    return 0;
}

sub events {
    my $self = shift;
    return $self->_gather('events', @_);
}

sub users {
    my $self = shift;
    return $self->_gather('users', @_);
}


sub _gather {
    my $self = shift;
    my $sub  = shift;
    my %opts = @_;

    my @vals;
    foreach my $provider ($self->providers) {
        push @vals, $provider->$sub(%opts);
    }
    return @vals;

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
    $self->{_providers}->{default}->$sub($thing);
}

1;

