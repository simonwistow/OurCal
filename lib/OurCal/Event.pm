package OurCal::Event;
use base 'OurCal::Dbi';

                
        
sub new {
    my ($class, %event) = @_;
    return bless \%event, $class;   
}
                
sub description {
    my $self = shift;
    return $self->SUPER::trim($self->{description});
}
         
                
sub id {
    my $self = shift;
    return $self->{id};
}

sub save {
    my ($self) = @_;
    my $desc = $self->description;
    my $dbh  = $self->SUPER::get_dbh();
    my $date = $self->{date};
    my $sql;
    my @vals = ($date, $desc);
    if (defined $self->{user}) {
        $sql  = "INSERT INTO events (date, description, user) VALUES (?, ?, ?)";
        push @vals, $self->{user};
    } else {
        $sql  = "INSERT INTO events (date, description) VALUES (?, ?)";
    }

    my $sth  = $dbh->prepare($sql);

    $sth->execute(@vals);
}

sub del  {
    my ($self) = @_;
    my $dbh  = $self->SUPER::get_dbh();
    my $sql  = "DELETE FROM events WHERE id=?";
    my $sth  = $dbh->prepare($sql);

    $sth->execute($self->id);
}
1;

