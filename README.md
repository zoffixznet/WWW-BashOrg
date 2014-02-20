# NAME

WWW::BashOrg - simple module to obtain quotes from http://bash.org/ and http://www.qdb.us/

# SYNOPSIS

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

# DESCRIPTION

A simple a module to obtain either a random quote or a quote by number from
either [http://bash.org/](http://bash.org/) or [http://qdb.us/](http://qdb.us/).

# CONSTRUCTOR

## `new`

    my $b = WWW::BashOrg->new;

    my $b = WWW::BashOrg->new(
        ua  => LWP::UserAgent->new(
            agent   => 'Opera 9.5',
            timeout => 30,
        )
    );

Returns a newly baked `WWW::BashOrg` object. All arguments are options, so far there
are only two arguments are available:

### `ua`

    my $b = WWW::BashOrg->new(
        ua  => LWP::UserAgent->new(
            agent   => 'Opera 9.5',
            timeout => 30,
        ),
    );

__Optional__. Takes an [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) object as a value. This object will be used for
fetching quotes from [http://bash.org/](http://bash.org/) or [http://qdb.us/](http://qdb.us/). __Defaults to:__

    LWP::UserAgent->new(
        agent   => 'Opera 9.5',
        timeout => 30,
    )

### `default_site`

    my $b = WWW::BashOrg->new(
        default_site  => 'qdb'
    );

__Optional__. Which site to retrieve quotes from by default when not
specified in the method
parameters, `'qdb'` or `'bash'`. Default is `'bash'`.

# METHODS

## `get_quote`

    my $quote = $b->get_quote('202477')
        or die $b->error;

    $quote = $b->get_quote('1622', 'qdb')
        or die $b->error;

The first argument, the number of the quote to fetch, is mandatory.
You may also optionally specify
which site to retrieve the quote from
(`'qdb'` or `'bash'`). If an error occurs, returns
`undef` and the reason for failure can be obtained using `error()` method.

## `random`

    my $quote = $b->random('bash')
        or die $b->error;

Has one optional argument, which site to return quote from
(`'qdb'` or `'bash'`). Returns a random quote.
If an error occurs, returns `undef` and the reason for failure can be obtained using
`error()` method.

## `error`

    my $quote = $b->random
        or die $b->error;

If an error occurs during execution of `random()` or `get_quote()` method will return
the reason for failure.

## `quote`

    my $last_quote = $b->quote;

    my $last_quote = "$b";

Takes no arguments. Must be called after a successful call to either `random()` or
`get_quote()`. Returns the same return value as last `random()` or `get_quote()` returned.
__This method is overloaded__ thus you can interpolate `WWW::Bashorg` in a string to obtain
the quote.

## `ua`

    my $old_ua = $b->ua;

    $b->ua(
        LWP::UserAgent->new( timeout => 20 ),
    );

Returns current [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) object that is used for fetching quotes. Takes one
option argument that must be an [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) object (or compatible) - this object
will be used for any future requests.

## `default_site`

    if ( $b->default_site eq 'qdb' ) {
        $b->default_site('bash');
    }

Returns current default site to retrieve quotes from. Takes an optional argument to change this setting (`'qdb'` or `'bash'`).

# REPOSITORY

Fork this module on GitHub:
[https://github.com/zoffixznet/WWW-BashOrg](https://github.com/zoffixznet/WWW-BashOrg)

# BUGS

To report bugs or request features, please use
[https://github.com/zoffixznet/WWW-BashOrg/issues](https://github.com/zoffixznet/WWW-BashOrg/issues)

If you can't access GitHub, you can email your request
to `bug-WWW-BashOrg at rt.cpan.org`

# AUTHOR

# CONTRIBUTORS

# LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the `LICENSE` file included in this distribution for complete
details.
