package OurCal::Todo;
                
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
    return $self->trim($self->{description});
}
        
sub for {
    my $self = shift;
    return $self->{for};
        
}
         
                
sub full_description {
    my ($self) = @_;
    my $for    = $self->{for};

    my $description;
    if (defined $for) {
        $description = sprintf "(%s) %s", $for, $self->description;
    } else {
        $description = sprintf "%s", $self->description;
    }
    return $description;
}

sub trim {
    my($self, $text) = @_;

    $text =~ s/^\s*(.+=?)\$/$1/;

    return $text;
}


1;

