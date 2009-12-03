package OurCal::Provider::Facebook;

use strict;
use WWW::Facebook::API;
use Data::ICal::DateTime;
use DateTime;
use DateTime::Span;
use OurCal::Event;
use OurCal::Provider;
use Carp qw(cluck);
use Digest::MD5 qw(md5_hex);
use Data::Dumper;

=head1 NAME

OurCal::Provider::Facebook - an Facebook event provider for OurCal

=head1 SYNOPSIS

    [facebook]
    type           = facebook
    api_key        = <api_key>
    session_key    = <session key>
    session_secret = <session_secret>

=head1 CONFIG OPTIONS

=over 4 


=item api_key

=item session_key

=item session_secret

=item cache

The name of a cache provider. This will cache fetching the file.

=back

=head1 METHODS

=cut

=head2 new <param[s]>

Requires an C<OurCal::Config> object as config param and a name param. 

=cut


sub new {
    my $class = shift;
    my %what  = @_;
    my $conf  = $what{config}->config($what{name});

    my $user        = $conf->{username};
    my $key         = $conf->{api_key};
    my $sess_key    = $conf->{session_key}; 
    my $sess_secret = $conf->{session_secret};
    my $client = WWW::Facebook::API->new(
        desktop      => 1,
        parse        => 1,
        throw_errors => 1,        
#        debug => 1,
    );
    #$secret = $sess_secret if defined $sess_secret.
    $client->api_key($key);
    $client->session_key($sess_key);
    $client->secret($sess_secret);
    $client->desktop(1);


    $what{client}   = $client;
    if ($conf->{cache}) {
        $what{_cache} = OurCal::Provider->load_provider($conf->{cache}, $what{config}); 
    }

    my $info = $what{client}->users->get_info( uids => [ $what{client}->users->get_logged_in_user ], fields => ['timezone'] );
    $what{timezone} = $info->[0]->{timezone};
    return bless \%what, $class;
}

sub users {
    return ();
}

sub todos {
    return ();
}

sub events {
    my $self   = shift;
    my %opts   = @_;



    my %p;
    if (defined $opts{date}) {
        my @names = qw(year month day);
        my @bits  = split /-/, $opts{date};
        my %conf;
        foreach my $bit (@bits) {
            my $name = shift @names;
            last unless $name;
            $conf{$name} = $bit;
        }
        my $s    = DateTime->new(%conf)->subtract( seconds => $self->{timezone} * 60 * 60 ); # ->truncate( to => 'day'); # 
        my $e    = $s->clone->add( days => 1)->subtract( seconds => 1 );
        $p{start_time} = $s->epoch;
        $p{end_time}   = $e->epoch;
    }

    my ($events) = $self->_fetch_data(%p);
    $events ||= [];
    die Dumper($events) unless ref($events) eq 'ARRAY';
    return grep { defined } map { $self->_to_event($_) } @$events;
}

sub _fetch_data {
    my $self = shift;
    my %p    = @_;
    my $client = $self->{client};
    return $client->events->get(%p) unless defined $self->{_cache};


    my $des  = $p{start_time} || "all";
    my $file = $self->{name} . '@' . md5_hex($des);

    return ($self->{_cache}->cache( $file, sub { $client->events->get(%p)  }))[0];    
}

sub _to_event {
    my $self  = shift;
    my $event = shift;

    # TODO multi day events
    my %what;
    my $url            = "http://www.facebook.com/event.php?eid=".$event->{eid};
    $what{id}          = $event->{eid};
    if ($event->{start_time}) {
        my $t          = $event->{start_time} + ($self->{timezone} * 60 * 60);
        $what{date}    = DateTime->from_epoch( epoch => $t )->strftime("%Y-%m-%d");
    } else {
        return;
        die Dumper($event);
    }
    $what{description} = "[".$event->{name}."|${url}]";    
    $what{recurring}   = 0;
    $what{editable}    = 0;
    return OurCal::Event->new(%what);
}

sub has_events {
    my $self  = shift;
    return scalar($self->events(@_));
}

sub save_event {
    return 0;
}

sub del_event {
    return 0;
}

1;
