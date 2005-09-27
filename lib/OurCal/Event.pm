package OurCal::Event;
use base 'OurCal::Dbi';

                
        sub new {
                my ($class, $stuff) = @_;
                return bless $stuff, $class;   
        }
                
        sub description {
                my $self = shift;
                
                return $self->{description};
                
        }
         
                

	sub save {
        	my ($self) = @_;
		    my $description = $self->SUPER::trim($self->{description});
        	my $dbh = $self->SUPER::get_dbh();
        	my $date = $self->{date};

        	#my $sql  = sprintf "insert into events ('date','description') values ('$date',%s)",
            #                                                            $dbh->quote($description);

        	my $sql  = sprintf "insert into events values ('$date',%s)",
                                                                        $dbh->quote($description);

        	my $sth  =  $dbh->prepare($sql);
        	
			# return unless defined  $sth; 

			$sth->execute();


	}

	sub del  {
        	my ($self) = @_;
		my $description = $self->SUPER::trim($self->{description});
        	my $dbh = $self->SUPER::get_dbh();
        	my $date = $self->{date};

        	my $sql  = sprintf "delete from events where date=%s and description=%s",
                                                                        $dbh->quote($date),
                                                                        $dbh->quote($description);

	        my $sth  =  $dbh->prepare($sql);
        	$sth->execute();
}
1;

