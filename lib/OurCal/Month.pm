package OurCal::Month;

use strict;
use Carp qw(confess);
use base qw(OurCal::Span);
use OurCal::Day;
use OurCal::Month;


sub prev {
    my $self = shift;
    return $self->_shift($self->{_dt}->clone->subtract( months => 1 )->strftime("%Y-%m"));
}

sub next {
    my $self = shift;
    return $self->_shift($self->{_dt}->clone->add( months => 1 )->strftime("%Y-%m"));
}

sub as_string {
    my $self = shift;
    return $self->{_dt}->strftime("%b, %Y");
}


sub is_this_span {
    my $self = shift;
    return $self->is_this_month;
}

sub is_this_month {
	my $self = shift;
    my $now  = DateTime->now->truncate( to => 'month' );
    return $now == $self->{_dt};
}

sub days {
    my $self = shift;
    my $dt   = $self->{_dt}->clone;

    my @days;
    my $month = $dt->month;
    while ($dt->month == $month) {
        push @days, $self->_span("OurCal::Day", $dt->strftime("%Y-%m-%d")); 
        $dt->add( days => 1);
    }
    return @days;
}

sub number_of_weeks {
    my $self = shift;
    
    # get the last day of the month
    my $dt   = $self->{_dt}->clone;
    my $last = DateTime->last_day_of_month( year => $dt->year, month => $dt->month );

      my $start_of_week = shift || 1;

      # Work out what day the first of the month falls on
      my $first = $dt->clone();
      $first->set(day => 1);
      my $wday  = $first->day_of_week();

      # And adjust the day to the start of the week
      $wday = ($wday - $start_of_week + 7) % 7;

      # Then do the calculation to work out the week
      my $mday  = $last->day_of_month_0();

      return int ( ($mday + $wday) / 7 ) + 1;
}

1;
