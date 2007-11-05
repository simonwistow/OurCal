package OurCal;

use strict;
use OurCal::Day;
use OurCal::Month;
use base 'OurCal::Dbi';
use Data::Dumper;
use Date::Simple ();
#use Date::Simple::NoXS;

sub new {
    my $class     = shift;
    my $date      = shift || "";
    my $user      = shift;
    my $self      = {};

        
    $self->{user} = $user;

    if (length $date == 10) {
        $self->{mode} = 'day';
    } elsif (length $date == 7)  {
        $self->{mode} = 'month';
        $date        .= "-01" 
    } elsif (length $date == 4) {
        $self->{mode} = 'year';
        $date        .= "-01-01";
    } else {
        $self->{mode} = 'month';
        $date         = _get_default_date()."-01";
    }


    eval {
        $self->{date} = Date::Simple->new("$date");
    }; 

    
    if ($@) {
        $date = _get_default_date();
        $self->{date} = Date::Simple->new("$date-01");
    }

    bless $self, $class;
    
}

sub mode {
    my $self = shift;
    return $self->{mode};
}


sub date {
    my $self = shift;
    return $self->{date};
}


sub day {
    my $self = shift;
    my %what = ( date => $self->{date} );
    $what{user} = $self->{user} if defined $self->{user};
    return OurCal::Day->new(%what);

}


sub month {
    my $self = shift;
    my %what = ( date => $self->{date} );
    $what{user} = $self->{user} if defined $self->{user};    
    return OurCal::Month->new(%what);

}


sub _get_default_date {

    my ($mon, $year) = (localtime)[4,5];
    my $default      = ($year+1900)."-";
       $default     .= '0' if ($mon<9);
       $default     .= ($mon+1);
    return $default;
}



sub get_todos {
         my ($self) = @_;
         my $date = $self->{date};
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


sub get_raw_events {
         my $self  = shift;
         my $limit = shift || 50; 
         my $dbh   = $self->SUPER::get_dbh();
    

         my $sth;      
         if (defined $self->{user}) {
             my $sql  = "SELECT * FROM events WHERE user IS NULL OR user=? ORDER BY date LIMIT ?";
             $sth  =  $dbh->prepare($sql);
             $sth->execute($self->{user}, $limit);
        } else {
             my $sql  = "SELECT * FROM events WHERE user IS NULL ORDER BY date LIMIT ?";
             $sth  =  $dbh->prepare($sql);
             $sth->execute($limit);
        }

         my @events;

         while (my $d = $sth->fetchrow_hashref()) {
                push @events, $d;
         }

         return @events;


}

1;
