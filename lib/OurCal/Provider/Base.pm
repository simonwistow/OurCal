package OurCal::Provider::Base;

use strict;
use Data::Dumper;
use OurCal;

=head1 NAME

OurCal::Provider::Base - a base class for providers


=head1 METHODS

=head2 new [opt[s]]

=cut

sub new {
    my $class = shift;
    my %opts  = @_;
    return bless {%opts}, $class;
}

=head2 name 

Get the name of this provider

=cut

sub name {
    my $self = shift;
    return $self->{name};
}

=head2 todos

Returns all the todos on the system.

=cut 

sub todos {
    my $self = shift;
    return $self->_do_default('todos', @_);
}

=head2 has_events <param[s]>

Returns whether there are events given the params.

=cut

sub has_events {
    my $self = shift;
    return $self->_do_default('has_events', @_);
}

=head2 events <param[s]>

Returns all the events for the given params.

=cut

sub events {
    my $self   = shift;
    my %opts   = @_;
    my @events = sort { $b->date cmp $a->date } $self->_do_default('events', %opts);
    @events    = splice @events, 0, $opts{limit} if defined $opts{limit};
    return @events;
}

=head2 users

Returns the name of all the users on the system.

=cut

sub users {
    my $self = shift;
    return $self->_do_default('users', @_);
}

=head2 save_todo <OurCal::Todo>

Save a todo.

=cut

sub save_todo {
    my $self = shift;
    return $self->_do_default('save_todo', @_);
}

=head2 del_todo <OurCal::Todo>

Delete a todo.

=cut

sub del_todo {
    my $self = shift;
    return $self->_do_default('del_todo', @_);
}

=head2 save_event <OurCal::Event>

Save an event.

=cut

sub save_event {
    my $self = shift;
    return $self->_do_default('save_event', @_);
}

=head2 del_event <OurCal::Event>

Delete an event..

=cut

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

sub debug {
    my $self  = shift;
    my $mess  = shift;
    my $class = ref($self)? ref($self) : $self; 
    return unless $OurCal::DEBUG;
    print "$class :: $mess<br />\n";
}
1;

