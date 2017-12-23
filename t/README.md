# Running Tests

These tests require the normal Perl testing harness.  It's probably already
included though.

Run from the kdesrc-build base directory (i.e. not in *this* directory), using
the Perl command `prove`, which should be installed along with the
Test::Harness module, if I remember right.

So that kdesrc-build's own modules can be found properly, you need to use the
`-I` flag.  So if you're running from the right directory, this command should
work: `prove -Imodules`.
