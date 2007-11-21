package OurCal::Provider::Multi;

use strict;
use OurCal::Provider;

sub new {
    my $class = shift;
    my %what  = @_;

    # get all the names of of our providers
    my $conf      = $what{config}->config($what{name});
    my $providers = $conf->{providers};
    my $default   = 0;
    foreach my $provider (split ' ', $providers) {
        $what{_providers}->{$provider} = OurCal::Provider->load_provider($provider, $what{config});        
        $default = 1 if $provider eq 'default';
    }
    return bless \%what, $class;
}

sub todos {
    my $self = shift;
    return $self->_gather('todos');
}

sub providers {
    my $self = shift;
    return values %{$self->{_providers}};
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
    my $self   = shift;
    my %opts   = @_;
    my @events = sort { $b->date cmp $a->date } $self->_gather('events', %opts);
    @events    = splice @events, 0, $opts{limit} if defined $opts{limit};
    return @events;
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
    die "You must specify at least one provider named 'default' if you want to save\n" 
        unless $self->{_providers}->{default};
    $self->{_providers}->{default}->$sub($thing);
}

1;

