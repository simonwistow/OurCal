package OurCal::Day;

use strict;
use OurCal::Event;
use Lingua::EN::Numbers::Ordinate;
use base qw(OurCal::Dbi);
use Date::Simple ();



sub new {
    my ($class, $date)  = @_;
    
    my $self = {};
    $self->{date} = $date;


    bless $self, $class;

}

sub day_of_week {
    my $self = shift;
    return $self->{date}->format("%u");
}

sub day_of_month {
        my $self = shift;
        return $self->{date}->day();
}

sub is_today {
    my $self =shift;
        my $d = $self->{date}->day();
        my $m = $self->{date}->month();
        my $y = $self->{date}->year();

        my ($td,$tm,$ty) = (localtime)[3,4,5];
            $tm+=1;
            $ty+=1900;

        return 1 if ($td==$d && $tm==$m && $ty==$y);

        return 0;
}

sub make_link {
    my $self = shift;
    my $date = $self->{date};

    return sprintf "?date=%d-%.2d-%.2d", $date->year(), $date->month(), $date->day();

}

sub has_events {

     my ($self) = @_;
         my $date = $self->{date};
     my $dbh  = $self->SUPER::get_dbh();

         my $sql  = "select count(*) from events where date='?'";

         my $sth  =  $dbh->prepare($sql);
         $sth->execute($date);
         my ($events) = $sth->fetchrow_array();

         return $events;
}

   
sub get_events {
         my ($self) = @_;
         my $date = $self->{date};
         my $dbh  = $self->SUPER::get_dbh();
        
         my $sql  = "select * from events where date='?'";
        
         my $sth  =  $dbh->prepare($sql);
         $sth->execute($date);

         my @events;
 
         while (my $d = $sth->fetchrow_hashref()) {
             $d->{date} = $date;
                my $e = OurCal::Event->new($d);
                push @events, $e;
        
         }

         return @events;
        

}


sub next_link {
        my $self=shift;
    my $day=$self->{date}+1;
       
        return sprintf "?date=%s", $day;
}

sub next_string {
        my $self=shift;
        my $day=$self->{date}+1;

        return $day->format("%d/%m");


}

sub prev_link {
        my $self=shift;
    my $day=$self->{date}-1;
       
        return sprintf "?date=%s", $day;
}


sub prev_string {
        my $self=shift;
        my $day=$self->{date}-1;

        return $day->format("%d/%m");


}

    





sub month_string {
    my $self = shift;
    return $self->{date}->format("%b, %Y");
}

sub month_link {
    my $self = shift;
    return sprintf "?date=%d-%.2d",  $self->{date}->year(),  $self->{date}->month();
}

sub as_string {
    my $self = shift;
        
        my $day = ordinate($self->{date}->day());
                
        return $self->{date}->format("%A the $day of %B, %Y");
                
}
           
           

1;
