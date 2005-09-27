package OurCal;

use strict;
use Date::Simple;
use OurCal::Day;
use OurCal::Month;
use base 'OurCal::Dbi';
use Data::Dumper;

sub new {
	my $class     = shift;
	my $date      = shift || "";

	my $self      = {};

		



	if (length $date == 10) {
		$self->{mode} = 'day';
	} else {
		$self->{mode} = 'month';
		$date        .= "-01" 

	}

	eval {
		$self->{date} = Date::Simple->new($date);
	}; 

	if ($@) {
		$date = _get_default_date();
		$self->{date} = Date::Simple->new($date."-01");
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
	
	return OurCal::Day->new($self->{date});

}


sub month {
	my $self = shift;
	
	return OurCal::Month->new($self->{date});

}


sub _get_default_date {

	my ($mon, $year) = (localtime)[4,5];
	my $default      = ($year+1900)."-";
   	$default        .= '0' if ($mon<9);
   	$default        .= ($mon+1);

	return $default;
}



sub get_todos {
         my ($self) = @_;
         my $date = $self->{date};
         my $dbh  = $self->SUPER::get_dbh();
        
         my $sql  = "select * from todos";
        
         my $sth  =  $dbh->prepare($sql);
         $sth->execute();

         my @todos;
 
         while (my $d = $sth->fetchrow_hashref()) {
		
                my $t = OurCal::Todo->new($d->{description});
                push @todos, $t;
        
         }

         return \@todos;
			
}



1;
