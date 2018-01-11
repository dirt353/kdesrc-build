use 5.018;
use strict;
use warnings;

use Test::More;

use ksb::Application;

my $app = ksb::Application->new(qw(--pretend --rc-file t/data/gen-module-list/kdesrc-buildrc));
my @moduleList = $app->generateModuleList();

ok(@moduleList > 0, 'Multiple modules to build');

done_testing();
