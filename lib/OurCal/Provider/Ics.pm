package OurCal::Provider::Ics;

use strict;
use LWP::Simple;
use Data::ICal::DateTime;
use DateTime;
use DateTime::Span;
use File::Spec;
use OurCal::Event;

sub new {
    my $class = shift;
    my %what  = @_;
    my $conf  = $what{config}->config($what{name});
    my $file  = $conf->{file};
    if ($file !~ m!^http://!) {
        $file = File::Spec->rel2abs($file);
        $file = "file://$file";
    }
    $what{file} = $file;
    return bless \%what, $class;
}

sub users {
    return ();
}

sub todos {
    return ();
}

sub events {
    my $self  = shift;
    my %opts  = @_;
    my $data  = get($self->{file});
    return () unless $data;
    my $cal   = Data::ICal->new( data => $data );
    return () unless $cal;
    my @vals;
    if (defined $opts{date}) {
        my @names = qw(year month day);
        my @bits  = split /-/, $opts{date};
        my %conf;
        foreach my $bit (@bits) {
            my $name = shift @names;
            last unless $name;
            $conf{$name} = $bit;
        }
        my $s    = DateTime->new(%conf)->truncate( to => 'day');
        my $e    = $s->clone->add( days => 1)->subtract( seconds => 1 );
        my $span = DateTime::Span->from_datetimes( start => $s, end => $e );
        push @vals, $span, 'day';
    }
    
    my @events  = $cal->events(@vals);
    @events     = map { $_->explode(@vals) } @events if @vals;
    @events     = sort { $a->start->epoch <=> $b->start->epoch } @events;
    @events     = splice @events, 0, $opts{limit} if defined $opts{limit};
    return map { $self->to_event($_) } @events;
}

sub to_event {
    my $self  = shift;
    my $event = shift;
    my %what;
    $what{date}        = $event->start->strftime("%Y-%m-%d");
    $what{description} = $event->summary;    
    $what{recurring}   = $event->property('rrule') or $event->property('rdate'); 
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

sub save_todo {
    return 0;
}

sub del_todo {
    return 0;
}


1;

