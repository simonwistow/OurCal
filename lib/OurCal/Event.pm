package OurCal::Event;
use base 'OurCal::Dbi';

                
        
sub new {
    my ($class, $stuff) = @_;
    return bless $stuff, $class;   
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
    my $sql  = "insert into events ('date','description') values (?,?)";
    my $sth  = $dbh->prepare($sql);

    $sth->execute($date, $desc);
}

sub del  {
    my ($self) = @_;
    my $desc = $self->description;
    my $dbh  = $self->SUPER::get_dbh();
    my $date = $self->{date};
    my $sql  = "delete from events where date=? and description=?";
    my $sth  = $dbh->prepare($sql);

    $sth->execute($date, $desc);
}
1;

