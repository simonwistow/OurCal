package Template::Plugin::OurCal;

use strict;
use vars qw($VERSION);
$VERSION = 0.03;

require Template::Plugin;
use base qw(Template::Plugin);

use vars qw($FILTER_NAME);
$FILTER_NAME = 'ourcal';

use URI::Find;
use Text::DelimMatch;

# standard set up stuff
sub new {
    my($class, $context, @args) = @_;
    my $name = $args[0] || $FILTER_NAME;
    $context->define_filter($name, $class->filter_factory());
    bless { }, $class;
}

# possibly extraneous cargo culting but it works so ...
sub filter_factory {
	my $class = shift;
	my $sub = \&munge();
	return \&munge;;

}


# the real work
sub munge {
	# get the text, remembering that we may not actually be passed anything
	my $text = shift || "";

	
	# we'll be matching stuff between '[' and ']'
	my $mc = Text::DelimMatch->new("\\+{0,1}\\[","\\]");


	# pre declare 
	my @tokens;

	# loop through all the matches
	# Why isn't this a standard method in Text::Delim?
	# And if it is then why is it badly documented?
	while (my $match = $mc->match($text))	
	{
		# if we've got anything from before the match then whack it in
        	my $pre = $mc->pre_matched() || "";
        	push @tokens, $pre;

		# push the match in
        	push @tokens, $match;

		# and reset $text so that we don't loop infinitely
        	$text = $mc->post_matched() || "";
	}
	# push anything left onto the tokens. This also catches the case
	# of there being no matches
	push @tokens, $text;


	# pre declare again
	my $return;


	# curse the tedious URI::Find interface
	my $finder = URI::Find->new(
                sub {
                    my($uri, $orig_uri) = @_;
                    return qq(<a href="$uri">$orig_uri</a>);
                },
	);


	# for each token we've got, decide ...
	foreach my $token (@tokens) {

		# is it a bracket match? and if so is it an image ...
                if ($token =~ s/^\+\[(.*)\]$/$1/) {
                        my @matches = split /\|/, $token;
                        my $url = pop @matches;
                        my $alt = (@matches)? " alt='".$matches[0]."'" : "";
                        $return .= "<img src='$url' $alt>";
		# ... or just a normal link?
                } elsif ($token =~ s/^\[(.*)\]$/$1/) {
			# yes? then split them apart and turn them into links
               	 	my ($one,$two) = split /\|/, $token;
                	$return .= "<a href='$two'>$one</a>";
			# this would be the place that you stick cleverness like
			# special urls or something

        	} else {
			# otherwise turn any urls into clickable links 
	                $finder->find(\$token);
                	$return .= "$token";
        	}
	}
 
	# return the whole caboodle
	return  $return;  
}

1;

