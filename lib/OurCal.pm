package OurCal;

use strict;
use OurCal::Day;
use OurCal::Month;
use base 'OurCal::Dbi';
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
    if ('month' eq $name) {
        return OurCal::Month->new(%what);
    } elsif ('day' eq $name) {
        return OurCal::Day->new(%what);
    } 

    die "Don't have a handler for $name\n";
}


sub get_todos {
         my ($self) = @_;

         my $dbh  = $self->SUPER::get_dbh();

         my @vals;
         my $sql  = "SELECT * FROM todos";        
         if (defined $self->{user}) {
            $sql .= " WHERE user IS NULL OR user=?";
            push @vals, $self->{user};
         }
         my $sth  =  $dbh->prepare($sql);
         $sth->execute(@vals);

         my @todos;
         while (my $d = $sth->fetchrow_hashref()) {
                my $t = OurCal::Todo->new(%$d);
                push @todos, $t;
         }
         return \@todos;
            
}


sub new_todo {
    my $self = shift;
    my $desc = shift;
    my %what = ( description => $desc );
    $what{user} = $self->user if defined $self->user;
    OurCal::Todo->new(%what)->save(); 
}

sub del_todo {
    my $self = shift;
    my $id   = shift;
    OurCal::Todo->new( id => $id )->del();
}

sub new_event {
    my $self = shift;
    my $desc = shift;
    die "Can't add an event to anything but a day\n" 
        unless $self->span_name eq 'day';
    my %what = ( description => $desc, date => $self->date );
    $what{user} = $self->user if defined $self->user;
    OurCal::Event->new(%what)->save();
}    

sub del_event {
    my $self = shift;
    my $id   = shift;
    OurCal::Event->new( id => $id )->del();
}

1;
