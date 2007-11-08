package OurCal::Handler;

use strict;
use CGI;

my $user_cookie_name = 'ourcal_user_cookie';

sub new {
    my ($class, %opts) = @_;
    $opts{_cgi} = CGI->new;
    return bless \%opts, $class;
}

sub _get_default_date {
    my ($mon, $year) = (localtime)[4,5];
    my $default      = ($year+1900)."-";
       $default     .= '0' if ($mon<9);
       $default     .= ($mon+1);
    return $default;
}


sub date {
    return $_[0]->_get_with_default('date', _get_default_date);
}

sub user {
    my $self = shift;
    return undef if 'del_cookie' eq $self->mode;
    return $self->{user} if defined $self->{user} && length($self->{user});

    

    $self->{_user_needed} = 0;

    my $user;
    my $tmp_user = $user = $self->param('user');

    # first try auth
    $user = $self->{_cgi}->remote_user;
    goto SKIP_USER if defined $user && length($user);
    #print STDERR "Didn't find remote user\n";
        
    # now cookie
    $user = $self->{_cgi}->cookie($user_cookie_name);
    goto SKIP_USER if defined $user && length($user);
    #print STDERR "Didn't find remote cookie\n";
    

    # lastly, set that user is needed
    SKIP_USER: 
    $user = undef unless defined $user && length($user);
    $self->{_user_needed} = (defined $tmp_user && (!defined $user || $user ne $tmp_user));
    # and get it from CGI params
    $user = $tmp_user if defined $tmp_user && length($tmp_user);

    #print STDERR "Didn't find cgi user\n" unless defined $user;
 
    $self->{user} = $user;
    return $user;
}

sub mode {
    return $_[0]->_get_with_default('mode', 'display');
}

sub _get_with_default {
    my ($self, $name, $default) = @_;
    if (not defined $self->{$name}) {
        $self->{$name} =  $self->param($name) || $default || undef;
    }
    return $self->{$name};
}


sub header {
    my $self = shift;
    my $type = shift;
    my $cgi  = $self->{_cgi};
    my %vars;
    $vars{"-type"} = $type if defined $type;

    if ('del_cookie' eq $self->mode) {
        my $cookie = $cgi->cookie(-name => $user_cookie_name, -value => '' );
        $vars{"-cookie"} = $cookie;
    } elsif (defined $self->user) {
        my $cookie = $cgi->cookie(-name => $user_cookie_name, -value => $self->user );
        $vars{"-cookie"} = $cookie;
    }
    return $cgi->header(%vars);
    
}

sub id {
    return $_[0]->_get_with_default('id');
}    

sub description {
    return $_[0]->_get_with_default('description');
}    

sub link {
    my $self = shift;
    my $span = shift;
    my $date = $span->date;
    my $user = $self->user;
    my $url  = "?";
	
    $url .= "date=${date}" unless $span->is_this_span && $span->isa("OurCal::Month");
    $url .= "&user=${user}" if $self->need_user;
	$url  = "." if $url eq "?";

    return $url;    
}

sub param {
    my $self = shift;
    my $name = shift;
    my $cgi  = $self->{_cgi};
    return $cgi->param($name);

}

sub next_link {
    my $self = shift;
    my $span = shift;
    return $self->link($span->next);
}

sub previous_link {
    my $self = shift;
    my $span = shift;
    return $self->link($span->previous);
}


sub need_user {
    my $self = shift;
    return $self->{_user_needed};
    #return defined $self->user;
}

1;
