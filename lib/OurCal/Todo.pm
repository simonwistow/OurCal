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
    my $sql    = sprintf "insert into todos  ('description') values (?)";
    my $sth  =  $dbh->prepare($sql);
    
    $sth->execute($self->description);
}

sub del {
        my ($self) = @_;
        my $dbh    = $self->SUPER::get_dbh();
        my $sql    = sprintf "delete from todos where description=?";
        my $sth    =  $dbh->prepare($sql);
        $sth->execute($self->description);
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

