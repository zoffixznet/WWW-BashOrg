use Test::More tests => 5;

BEGIN {
    use_ok('Class::Data::Accessor');
    use_ok('LWP::UserAgent');
    use_ok('HTML::TokeParser::Simple');
    use_ok('HTML::Entities');
	use_ok( 'WWW::BashOrg' );
}

diag( "Testing WWW::BashOrg $WWW::BashOrg::VERSION, Perl $], $^X" );
