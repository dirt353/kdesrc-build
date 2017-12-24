use 5.014;

use Test::More;

use ksb::Application;

my @args = qw(-p --stop-on-failure --resume-from qt --stop-after qt2);
my $app = new_ok('ksb::Application', \@args);
my $ctx = $app->context();

ok($ctx->hasOption('stop-on-failure'), 'stop-on-failure set');
cmp_ok($ctx->getOption('stop-on-failure'), '==', 1, 'stop-on-failure set to 1');

ok($ctx->hasOption('resume-from'), 'resume-from set');
is($ctx->getOption('resume-from'), 'qt', 'resume-from set to qt');

ok($ctx->hasOption('stop-after'), 'stop-after set');
is($ctx->getOption('stop-after'), 'qt2', 'stop-after set to qt2');

done_testing();
