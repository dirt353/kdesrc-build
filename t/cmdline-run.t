use 5.014;

use Test::More;

use ksb::Application;

my @args = qw(-p --run printenv a b);
my $app = new_ok('ksb::Application', \@args);

ok(exists $app->{shell_to_cmd}, '--run shell cmd/args exist');
ok(ref $app->{shell_to_cmd} eq 'ARRAY', '--run shell cmd/args are listref');
is_deeply($app->{shell_to_cmd}, [qw(printenv a b)]);

done_testing();
