package WWW::BashOrg;

use warnings;
use strict;

our $VERSION = '0.0104';
use LWP::UserAgent;
use HTML::TokeParser::Simple;
use HTML::Entities;
use overload q|""| => sub { shift->quote };
use base 'Class::Data::Accessor';

__PACKAGE__->mk_classaccessors(qw/
    ua
    error
    quote
/);

sub new {
    my $class = shift;
    my %args = @_;

    $args{ua} = LWP::UserAgent->new(
        agent   => 'Opera 9.5',
        timeout => 30,
    ) unless defined $args{ua};

    my $self = bless {}, $class;

    $self->$_( $args{ $_ } ) for keys %args;

    return $self;
}

sub get_quote {
    my ( $self, $num ) = @_;

    $self->quote( undef );
    $self->error( undef );

    unless ( length $num and $num =~ /^\d+$/ ) {
        $self->error('Invalid quote number');
        return;
    }

    my $res = $self->{ua}->get("http://bash.org/?quote=$num");
    unless ( $res->is_success ) {
        $self->error("Network error: " . $res->status_line );
        return;
    }

    my $quote = $self->_parse_quote( $res->decoded_content );
    unless ( defined $quote ) {
        $self->error('Quote not found');
        return;
    }

    return $self->quote( $quote );
}

sub random {
    my $self = shift;

    $self->quote( undef );
    $self->error( undef );

    my $res = $self->{ua}->get("http://bash.org/?random1");
    unless ( $res->is_success ) {
        $self->error("Network error: " . $res->status_line );
        return;
    }

    my $quote = $self->_parse_quote( $res->decoded_content );
    unless ( defined $quote ) {
        $self->error('Quote not found');
        return;
    }

    return $self->quote( $quote );
}

sub _parse_quote {
    my ( $self, $content ) = @_;

    my $p = HTML::TokeParser::Simple->new( \$content );

    my $get_quote;
    my $quote;
    while ( my $t = $p->get_token ) {
        if ( $t->is_start_tag('p')
            and defined $t->get_attr('class')
            and $t->get_attr('class') eq 'qt'
        ) {
            $get_quote = 1;
        }

        if ( $get_quote and $t->is_text ) {
            $quote .= $t->as_is;
        }

        if ( $get_quote and $t->is_end_tag('p') ) {
            $quote =~ s/&nbsp;/ /g;
            return decode_entities $quote;
        }
    }

    return undef;
}

1;
__END__

=head1 NAME

WWW::BashOrg - simple module to obtain quotes from http://bash.org/

=head1 SYNOPSIS

    #!/usr/bin/env perl

    use strict;
    use warnings;
    use WWW::BashOrg;

    die "Usage: perl $0 quote_number\n"
        unless @ARGV;

    my $b = WWW::BashOrg->new;

    $b->get_quote(shift)
        or die $b->error . "\n";

    print "$b\n";

=head1 DESCRIPTION

A simple a module to obtain either a random quote or a quote by number from
L<http://bash.org/>.

=head1 CONSTRUCTOR

=head2 C<new>

    my $b = WWW::BashOrg->new;

    my $b = WWW::BashOrg->new(
        ua  => LWP::UserAgent->new(
            agent   => 'Opera 9.5',
            timeout => 30,
        )
    );

Returns a newly baked C<WWW::BashOrg> object. All arguments are options, so far only
one argument is available:

=head3 C<ua>

    my $b = WWW::BashOrg->new(
        ua  => LWP::UserAgent->new(
            agent   => 'Opera 9.5',
            timeout => 30,
        )
    );

B<Optional>. Takes an L<LWP::UserAgent> object as a value. This object will be used for
fetching quotes from L<http://bash.org/>. B<Defaults to:>

    LWP::UserAgent->new(
        agent   => 'Opera 9.5',
        timeout => 30,
    )

=head1 METHODS

=head2 C<get_quote>

    my $quote = $b->get_quote('202477')
        or die $b->error;

Takes one mandatory argument - the number of the quote to fetch. Returns a string with the
quote that was requested. If an error occurs, returns
C<undef> and the reason for failure can be obtained using C<error()> method.

=head2 C<random>

    my $quote = $b->random
        or die $b->error;

Takes no argumnets. Returns a random quote. If an error occurs, returns
C<undef> and the reason for failure can be obtained using C<error()> method.

=head2 C<error>

    my $quote = $b->random
        or die $b->error;

If an error occurs during execution of C<random()> or C<get_quote()> method will return
the reason for failure.

=head2 C<quote>

    my $last_quote = $b->quote;

    my $last_quote = "$b";

Takes no arguments. Must be called after a successfull call to either C<random()> or
C<get_quote()>. Returns the same return value as last C<random()> or C<get_quote()> returned.
B<This method is overloaded> thus you can interpolate C<WWW::Bashorg> in a string to obtain
the quote.

=head2 C<ua>

    my $old_ua = $b->ua;

    $b->ua(
        LWP::UserAgent->new( timeout => 20 ),
    );

Returns current L<LWP::UserAgent> object that is used for fetching quotes. Takes one
option argument that must be an L<LWP::UserAgent> object (or compatible) - this object
will be used for any future requests.

=head1 AUTHOR

'Zoffix, C<< <'zoffix at cpan.org'> >>
(L<http://haslayout.net/>, L<http://zoffix.com/>, L<http://zofdesign.com/>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-bashorg at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-BashOrg>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::BashOrg

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-BashOrg>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-BashOrg>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-BashOrg>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-BashOrg/>

=back



=head1 COPYRIGHT & LICENSE

Copyright 2009 'Zoffix, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

