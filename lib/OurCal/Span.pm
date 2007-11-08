package OurCal::Span;

use strict;
use Carp qw(confess);
use DateTime;

sub new {
    my ($class, %what)  = @_;
    my $self = bless \%what, $class;
    confess "No date set" unless defined $self->date;
    my @names = qw(year month day);
    my @bits  = split /-/, $self->date;
    my %opts;
    foreach my $name (@names) {
        my $val = shift @bits;
        last unless defined $val;
        $opts{$name} = $val;
    }
    $self->{_dt} = DateTime->new( %opts );
    return $self;
}

sub date {
    my $self = shift;
    return $self->{date};
}
sub calendar {
    my $self = shift;
    return $self->{calendar};
}


sub _span {
    my $self  = shift;
    my $class = shift;
    my $date  = shift;
    # TODO this needs to be abstracted
    my %what = ( date => $date, calendar => $self->calendar );
    return $class->new(%what);
}

sub _shift {
    my $self = shift;
    my $date = shift;
    my $prev = ref($self)->new( date => $date, calendar => $self->calendar );
}



1;
