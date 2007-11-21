package OurCal;

use strict;
use OurCal::Day;
use OurCal::Month;
use Data::Dumper;

sub new {
    my $class     = shift;
    my %opts      = @_;
    return bless \%opts, $class;
}

sub date {
    return $_[0]->{date};
}

sub user {
    return $_[0]->{user};
}


sub span_name {
    my $self = shift;
    my $date = $self->date;
    if (10 == length($date)) {
        return 'day';
    } elsif (7 == length($date)) {
        return 'month';
    } elsif (4 == length($date)) {
        return 'year';
    } else {
        die "Unknown date type for $date\n";
    }
}



sub span {
    my $self = shift;
    my $name = $self->span_name;
    my $date = $self->date;
    my %what = ( date => $date, calendar => $self );
    $what{user} = $self->{user} if defined $self->user;
    if ('month' eq $name) {
        return OurCal::Month->new(%what);
    } elsif ('day' eq $name) {
        return OurCal::Day->new(%what);
    } 

    die "Don't have a handler for $name\n";
}


sub events {
    my $self = shift;
    my %opts = @_;
    use Carp qw(confess);
    use Data::Dumper;
    #confess(Dumper(\%opts));
    $opts{user} = $self->user if defined $self->user; 
    return $self->{provider}->events(%opts);
}

sub has_events {
    my $self = shift;
    my %opts = @_;
    $opts{user} = $self->user if defined $self->user; 
    return $self->{provider}->has_events(%opts);
}

sub todos {
    my $self = shift;
    my %opts = @_;
    $opts{user} = $self->user if defined $self->user; 
    return $self->{provider}->todos(%opts);
}

sub users {
    my $self = shift;
    return $self->{provider}->users;
}


sub save_todo {
    my $self = shift;
    my $todo = shift;
    $self->{provider}->save_todo($todo)
}

sub del_todo {
    my $self = shift;
    my $todo = shift;
    $self->{provider}->del_todo($todo);
}

sub save_event {
    my $self  = shift;
    my $event = shift;
    $self->{provider}->save_event($event);
}    

sub del_event {
    my $self  = shift;
    my $event = shift;
    $self->{provider}->del_event($event);
}

=head1 DESIGN

designed by http://www.chimpfactory.com/

=cut

1;
