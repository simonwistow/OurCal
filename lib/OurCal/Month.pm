package OurCal::Month;

use strict;
use Date::Simple;
use base qw(OurCal::Dbi);

sub new {
    my ($class, $date)  = @_;
    
    my $self = {};
    $self->{date} = $date;
    bless $self, $class;

    $self->{next} = $self->_get_next();
    $self->{prev} = $self->_get_prev();

    return $self;

}




sub _get_prev {
    my $self = shift;
    my $date = $self->{date};
    
    my $year  = $date->year();
    my $month = $date->month();

    if ($month == 1) {
        $month = 12;
        $year--;
    } else {
        $month--;
    }

    return Date::Simple->new(sprintf "%d-%.2d-01",$year, $month);
}

sub first_day_of_week {
    my $self = shift;

        my $year  = $self->{date}->year();
        my $month = sprintf "%.2d", $self->{date}->month();
        my $day   = sprintf "%.2d", $self->{date}->day();
        my $first = Date::Simple->new("$year-$month-01")->format("%u");

    return $first;
}

sub last_day {
    my $self = shift;

        my $year  = $self->{date}->year();
        my $month = sprintf "%.2d", $self->{date}->month();
        my $day   = sprintf "%.2d", $self->{date}->day();

    if ($month==2) {
        if (defined Date::Simple->new("$year-$month-29")) {
            return 29;
        } else {
            return 28;
        }
    } else {
               if (defined Date::Simple->new("$year-$month-31")) {
                        return 31;
               } else {
                        return 30;
               }
    }

}

sub last_day_of_week {
     my $self  = shift;

        my $year  = $self->{date}->year();
        my $month = sprintf "%.2d", $self->{date}->month();
        my $day   = sprintf "%.2d", $self->{date}->day();
        my $last  = Date::Simple->new("$year-$month-".$self->last_day())->format("%u");

        return $last;
}



sub weeks {
    my $self = shift;

    my $month = $self->{date}->month();
    my $first = $self->first_day_of_week();
    my $last  = $self->last_day();


    if ($month == 2) {
        if ($first == 1) {
            return 4;
        } else {
            return 5;
        }
    } 


    if ($first<7 && $last<31) {
        return 5;
    } elsif ($first<6) {
        return 5;
    } else {
        return 6;
    }

    


}


sub prev_link {
    my $self  = shift;

    return sprintf "?date=%s", $self->{prev}->format("%Y-%m");    
}

sub prev_string {
        my $self  = shift;
        
        return $self->{prev}->format("%b, %Y");
}



sub _get_next {
        my $self = shift;
        my $date = $self->{date};

        my $year  = $date->year();
        my $month = $date->month();

        if ($month == 12) {
                $month = 1;
                $year++;
        } else {
                $month++;
        }

        return Date::Simple->new(sprintf "%d-%.2d-01",$year, $month);

}



sub next_link {
    my $self=shift;
    
    return sprintf "?date=%s", $self->{next}->format("%Y-%m");
}

sub next_string {
        my $self  = shift;

        return $self->{next}->format("%b, %Y");
}

sub as_string {
    my $self=shift;

    return $self->{date}->format("%b, %Y");

}


sub as_link {
        my $self  = shift;

        return sprintf "?date=%d-%.2d", $self->{date}->year(),  $self->{date}->month();
}


sub days {
    my $self = shift;

        my $year  = $self->{date}->year();
        my $month = sprintf "%.2d", $self->{date}->month();


    my @days;

    for (my $day = 1; $day<=$self->last_day(); $day++) {
        my $date = sprintf "%d-%.2d-%.2d", $year, $month, $day;
        push @days, OurCal::Day->new(Date::Simple->new($date));        
    }

    return @days;
}

1;
