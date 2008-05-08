package OurCal::Todo;

use strict;

=head1 NAME 

OurCal::Todo -  a TODO class for OurCal

=head1 METHODS


=cut 


=head2 new

Requires a description param and optionally a for and an id param.
                
=cut


sub new {
    my ($class, %todo) = @_;
    my $desc = $class->_trim($todo{description});
    if ($desc =~ s!^\(([^)]+)\)\s*!!) {
        $todo{description} = $desc;
        $todo{for}         = $1;
    }
    return bless \%todo, $class;   
}

=head2 id

The id of the TODO

=cut

sub id {
    my $self = shift;
    return $self->{id};
}   

=head2 description

The description of the TODO

=cut             
        
sub description {
    my $self = shift;
    return $self->_trim($self->{description});
}
    
=head2 for

Who the TODO is for

=cut
    
sub for {
    my $self = shift;
    return $self->_trim($self->{for});
}
    
=head2 full_description

The Description plus the for if it's present

=cut     
                
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

=head2 editable

Is this todo editable.

=cut

sub editable {
    my $self = shift;
    return $self->{editable} || 0;
}


sub _trim {
    my($self, $text) = @_;
	return unless defined $text;
    $text =~ s/^\s*(.+=?)\$/$1/;

    return $text;
}


1;

