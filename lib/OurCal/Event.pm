package OurCal::Event;

                
        
sub new {
    my ($class, %event) = @_;
    return bless \%event, $class;   
}
                
sub description {
    my $self = shift;
    return $self->trim($self->{description});
}
         
sub date {
	my $self = shift;
	return $self->{date};
}
                
sub id {
    my $self = shift;
    return $self->{id};
}

sub recurring {
    my $self = shift;
    return $self->{recurring};
}

sub editable {
    my $self = shift;
    return $self->{editable} || 0;
}

sub trim {
    my($self, $text) = @_;
    $text =~ s/^\s*(.+=?)\$/$1/;
    return $text;
}

1;

