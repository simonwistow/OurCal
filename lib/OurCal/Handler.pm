package OurCal::Handler;

use strict;
use UNIVERSAL::require;
use Module::Pluggable sub_name    => '_handlers',
                      search_path => 'OurCal::Handler';


=head2 NAME

OurCal::Handler- base class for all OurCal handlers

=head1 METHODS

=cut

=head2 new <param[s]>

=cut

sub new {
    my $class = shift;
    my %what  = @_;
    return bless \%what, $class;
}


=head2 handlers

Returns a hash with key-value pairs representing the shortname and 
equivalent class for all handlers installed.

=cut

sub handlers {
    my $self  = shift;
    my $class = (ref $self)? ref($self) : $self;

    my %handlers;
    foreach my $handler ($self->_handlers) {
        my $name = $handler;
        $name =~ s!^${class}::!!;
        $handlers{lc($name)} = $handler;
    }
    return %handlers;
}

1;

