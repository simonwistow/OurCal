package OurCal::View;

use strict;
use UNIVERSAL::require;
use Module::Pluggable sub_name    => '_views',
                      search_path => 'OurCal::View';



sub new {
    my $class = shift;
    my %what  = @_;
    return bless \%what, $class;
}


sub views {
    my $self  = shift;
    my $class = (ref $self)? ref($self) : $self;

    my %views;
    foreach my $view ($self->_views) {
        my $name = $view;
        $name =~ s!^${class}::!!;
        $views{lc($name)} = $view;
    }
    return %views;
}

sub load_view {
    my $self  = shift;
    my $name  = shift;
    my %opts  = @_;
    my %views = $self->views;
    my $class = $views{lc($name)}    || die "Couldn't get a class for view of type $name\n";
    $class->require || die "Couldn't require class $class: $@\n";
    return $class->new(%opts);
}

1;

