package OurCal::Todo;
use base 'OurCal::Dbi';
                
sub new {
    my ($class, %todo) = @_;

    return bless \%todo, $class;   
}

sub id {
	my $self = shift;
	return $self->{id};
}                
        
sub description {
    my $self = shift;
    return $self->SUPER::trim($self->{description});
}
        
sub for {
    my $self = shift;
    return $self->{for};
        
}
         
                
sub save  {
    my ($self) = @_;
    my $dbh    = $self->SUPER::get_dbh();
    my $sql    = "INSERT INTO todos (description) VALUES (?)";
    my $sth  =  $dbh->prepare($sql);
    
    $sth->execute($self->description);
}

sub del {
        my ($self) = @_;
        my $dbh    = $self->SUPER::get_dbh();
        my $sql    = "DELETE FROM todos WHERE id=?";
        my $sth    = $dbh->prepare($sql);
        $sth->execute($self->id);
}

sub full_description {
    my ($self) = @_;
    my $dbh    = $self->SUPER::get_dbh();      
    my $for    = $self->{for};

    my $description;
    if (defined $for) {
        $description = sprintf "(%s) %s", $for, $self->description;
    } else {
        $description = sprintf "%s", $self->description;
    }
    return $description;
}



1;

