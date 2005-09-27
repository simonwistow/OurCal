package OurCal::Todo;
use base 'OurCal::Dbi';
                
sub new {
	my ($class, $description) = @_;


	$description =~ s!^\s*\(\s*(.+)\s*\)\s*!!;
	my $for = $1 || undef;

	my $stuff = {};
	$stuff->{description} = $description;
	$stuff->{for}         = $for || undef;


	return bless $stuff, $class;   
}
                
        
sub description {
	my $self = shift;
	return $self->{description};
}
        
sub for {
	my $self = shift;
	return $self->{for};
        
}
         
                
sub save  {
        my ($self) = @_;
	my $dbh = $self->SUPER::get_dbh();



        #my $sql  = sprintf "insert into todos ('description') values (%s)",
        #                                                                $dbh->quote($self->full_description());
        my $sql  = sprintf "insert into todos  values (%s)",
                                                                        $dbh->quote($self->full_description());

        my $sth  =  $dbh->prepare($sql);
        $sth->execute();
}

sub del {
        my ($self) = @_;
        my $dbh = $self->SUPER::get_dbh();




        my $sql  = sprintf "delete from todos where description=%s",
                                                                        $dbh->quote($self->full_description());


        my $sth  =  $dbh->prepare($sql);
        $sth->execute();
}

sub full_description {
	my ($self) = @_;
        my $dbh = $self->SUPER::get_dbh();      

        my $for = $self->{for};

	my $description;
        if (defined $for) {
                $description = sprintf "(%s) %s", $for, $self->{description};
        } else {
                $description = sprintf "%s", $self->{description};
        }

	return $self->SUPER::trim($description);

}



1;

