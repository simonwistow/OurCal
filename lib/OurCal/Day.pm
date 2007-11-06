package OurCal::Day;

use strict;
use OurCal::Event;
use Lingua::EN::Numbers::Ordinate;
use base qw(OurCal::Span);


sub day_of_week {
    my $self = shift;
    return $self->{_dt}->strftime("%u");
}

sub day_of_month {
    my $self = shift;
    return $self->{_dt}->strftime("%d");
}

sub is_first_day_of_month {
    my $self = shift;
    return $self->{_dt}->month != 
           $self->{_dt}->clone->subtract( days => 1)->month;
}

sub is_last_day_of_month {
    my $self = shift;
    return $self->{_dt}->month != 
           $self->{_dt}->clone->add( days => 1)->month;
}

sub is_today {
    my $self = shift;
    my $now  = DateTime->now->truncate( to => 'day' );
    return $now == $self->{_dt};
}

sub has_events {
    my $self = shift;
    my $sth  = $self->_events(1);     
    my ($events) = $sth->fetchrow_array();
    return $events;
}

sub month {
    my $self = shift;
    my $date = $self->{_dt}->clone->truncate( to => 'month')->strftime("%Y-%m");
    return $self->_span("OurCal::Month", $date);
}

sub events {
    my $self = shift;
    my $sth  = $self->_events(0);
    my @events;
    while (my $d = $sth->fetchrow_hashref()) {
        $d->{date} = $self->date;
        my $e = OurCal::Event->new(%$d);
        push @events, $e;
    }
    return @events;
}
   
sub _events {
    my ($self, $count) = @_;
    my $date = $self->date;
    my $dbh  = $self->SUPER::get_dbh();
    my $what = ($count)? "COUNT(*)" : "*";           

    my @vals; 
    my $sql  = "SELECT $what FROM events WHERE date=?";
    if (defined $self->{user}) {
        $sql .= " AND (user IS NULL OR user=?)";
        push @vals, $self->{user};
    }
    my $sth  =  $dbh->prepare($sql);
    $sth->execute($date, @vals);
    return $sth;
}



sub as_string {
    my $self = shift;
    my $day = ordinate($self->{_dt}->day());
    return $self->{_dt}->strftime("%d/%m");
}

sub as_long_string {
    my $self = shift;
    my $day = ordinate($self->{_dt}->day());
    return $self->{_dt}->strftime("%A the $day of %B, %Y");
}

sub prev {
    my $self = shift;
    return $self->_shift($self->{_dt}->clone->subtract( days => 1 )->strftime("%Y-%m-%d"));
}

sub next {
    my $self = shift;
    return $self->_shift($self->{_dt}->clone->add( days => 1 )->strftime("%Y-%m-%d"));
}

           
           

1;
