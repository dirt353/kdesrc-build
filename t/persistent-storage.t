use 5.014;
use strict;
use warnings;

# https://bugs.kde.org/show_bug.cgi?id=388180

use Test::More;
use Scalar::Util qw(openhandle);
use File::Temp;
use JSON::PP;

use ksb::BuildContext;

my $ctx = new_ok( 'ksb::BuildContext' );

$ctx->setRcFile('/dev/null');
ok(openhandle($ctx->loadRcFile()), 'loadRcFile gives a filehandle');
is($ctx->rcFile(), '/dev/null', 'Roundtrip setRcFile');

is($ctx->persistentOptionFileName(), '/dev/.kdesrc-build-data', 'Default persistent data path');

my $tmp = File::Temp->new (TEMPLATE => 'kdesrc-build-XXXXXX');

$ctx->setOption('persistent-data-file', "$tmp");
is($ctx->persistentOptionFileName(), "$tmp", 'Setting persistent-data-file filename');
unlink("$tmp"); # Simulate missing persistent opts file

$ctx->loadPersistentOptions();

ok(exists $ctx->{persistent_options}, 'loadPersistentOpts sets build context');
is_deeply($ctx->{persistent_options}, {}, 'Persistent opts empty');

$ctx->setPersistentOption('global', 'key', 'value');

is_deeply($ctx->{persistent_options},
    { global => { key => 'value' } },
    'Persistent opts set');

$ctx->storePersistentOptions();

SKIP: {
    skip 'JSON did not save' unless open my $fh, '<', "$tmp";

    my $json_data = do { local $/ = undef; <$fh> }; # slurp mode
    ok(defined $json_data, "Read something of JSON data back");

    my $persistent_data = decode_json($json_data);
    is_deeply($ctx->{persistent_options},
        { global => { key => 'value' } },
        'Persistent opts saved');
};

done_testing();
