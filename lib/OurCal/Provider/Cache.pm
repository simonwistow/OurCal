package OurCal::Provider::Cache;

use strict;
use File::Spec::Functions qw(catfile rel2abs);
use File::Path;
use Storable;
use OurCal::Provider;

sub new {
    my $class = shift;
    my %what  = @_;
    my $conf  = $what{config}->config($what{name});
    $what{_provider}      = OurCal::Provider->load_provider($conf->{child}, $what{config}); 
    $what{_provider_name} = $conf->{child}; 
    $what{_cache_dir}     = $conf->{dir};
    $what{_cache_expiry}  = 1000*60*30 unless defined $what{_cache_expiry};
    return bless \%what, $class;
}


sub todos {
    my $self = shift;
    return $self->_do_cached('todos', @_);
}

sub has_events {
    my $self = shift;
    return ($self->_do_cached('has_events', @_))[0];
}

sub events {
    my $self   = shift;
    my %opts   = @_;
    my @events = $self->_do_cached('events', %opts);
    @events    = splice @events, 0, $opts{limit} if defined $opts{limit};
    return @events;
}

sub users {
    my $self = shift;
    return $self->_do_cached('users', @_);
}

sub save_todo {
    my $self = shift;
    return $self->_do_default('save_todo', @_);
}

sub del_todo {
    my $self = shift;
    return $self->_do_default('del_todo', @_);
}


sub save_event {
    my $self = shift;
    return $self->_do_default('save_event', @_);
}

sub del_event {
    my $self = shift;
    return $self->_do_default('del_event', @_);
}

sub _do_cached {
    my $self  = shift;
    my $sub   = shift;
    my $thing = shift;
    my $dir   = rel2abs($self->{_cache_dir});
    -d $dir  || eval { mkpath($dir) } || die "Couldn't create cache directory $dir: $@\n";
    my $file  = $self->{_provider_name}."+".$sub."@".$self->_flatten_args($thing, @_);
    my $cache = catfile($dir, $file);    
    my $mtime = $self->{_cache_expiry};
    my @res   = ();
    if (-e $cache && (time-(stat($cache))[9] > $mtime)) {
        @res  = @{Storable::retrieve( $cache )};
    } else {
        @res = $self->{_provider}->$sub($thing, @_);
        Storable::store( [@res], $cache );
    }
    return @res;
}

sub _flatten_args {
    my $self = shift;
    my %opts = @_;
    use Data::Dumper;
#    die Dumper({%opts});
    my $flat = "";
    foreach my $key (keys %opts) {
        next if ref($opts{$key}) && !$opts{$key}->isa('DateTime');
        # TODO Spans and Sets?
        $flat .= "$key=$opts{$key};"
    }
    return $flat;
}

sub _do_default {
    my $self  = shift;
    my $sub   = shift;
    my $thing = shift;    
    return $self->{_provider}->$sub($thing, @_);
}

1;

