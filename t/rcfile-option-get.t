use 5.014;
use strict;
use warnings;

use Test::More import => ['!note'];
use File::Temp qw(tempdir);

use ksb::Application;
use ksb::BuildContext;

my $tmpDir = tempdir(TEMPLATE => 'kdesrc-build-rcXXXXXX', TMPDIR => 1, CLEANUP => 1);
my $rcFile = "$tmpDir/kdesrc-buildrc";

open my $tmp, '>', $rcFile or BAIL_OUT("Can't save to temp file");

print $tmp <<'EOF';
global
    git-repository-base qt kde://anongit.kde.org/qt/
    my-opt-1 FOO
    my-opt-2 BAR
end global

module-set test
    repository qt
    use-modules 1.git 2.git
    make-options MAKE_FOO=${my-opt-1} MAKE_BAR=${my-opt-2}
end module-set
EOF

close $tmp;

my $app = ksb::Application->new('--pretend', '--rc-file', $rcFile);
isa_ok($app, 'ksb::Application');

my $ctx = $app->context();
isa_ok($ctx, 'ksb::BuildContext');

# options already read, ensure we used the rc-file we asked for
is($ctx->rcFile(), $rcFile, "used rc-file $rcFile");

# module sets won't have been expanded yet, read options directly from
# ctx hash
is(ref $app->{rc_mods_sets}, 'ARRAY', 'rc-file read properly into $app');
ok(scalar @{$app->{rc_mods_sets}}, 'list of read modules is not empty');

is($ctx->getOption('my-opt-1', 'module'), 'FOO', 'Global user-defined option imbedded into $ctx');
is($ctx->getOption('my-opt-2', 'module'), 'BAR', 'Global user-defined option imbedded into $ctx');

# grep requires parens around testSet to force list context, otherwise it just
# counts matches
my ($testSet) = grep { $_->name() eq 'test' } (@{$app->{rc_mods_sets}});

isa_ok($testSet, 'ksb::ModuleSet', 'test module is already a ModuleSet');
is($testSet->getOption('make-options', 'module'), 'MAKE_FOO=FOO MAKE_BAR=BAR',
        'make-options included previous options');
ok(!$testSet->isa('ksb::ModuleSet::KDEProjects'), 'test set should be a plain module set');

done_testing();
