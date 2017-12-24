use 5.014;

package test {
    use Test::More;
    push @INC, '.';

    require_ok "./kdesrc-build";
    done_testing();
};
