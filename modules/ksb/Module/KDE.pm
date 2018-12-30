package ksb::Module::KDE 0.10;

# Class: Module::KDE
#
# A subclass of Module for modules that are generated from a kde-projects
# ModuleSet.  (NOTE: I mean this literally: if you manually declare a module
# with an override-url or something to kde:foo.git then you'll get a regular
# ksb::Module!)

use 5.014;
use warnings;
no if $] >= 5.018, 'warnings', 'experimental::smartmatch';

use parent qw(ksb::Module);

use ksb::Debug;
use ksb::Util;

use ksb::BuildException 0.20;
use ksb::BuildSystem 0.30;
use ksb::BuildSystem::KDE4;

# Returns the "full kde-projects path" for the module, e.g.
# extragear/utils/kdesrc-build.
sub fullProjectPath
{
    my $self = shift;
    return $self->getOption('#xml-full-path', 'module');
}

# Override
sub isKDEProject
{
    return 1;
}

# Subroutine to return the name of the destination
# directory for the checkout and build routines.
#
# Overridden from super class to allow a hierarchial
# directory structure for KDE-based modules.
sub destDir
{
    my ($self, $basePath) = @_;

    my $defaultBase = $self->getOption('ignore-kde-structure')
        ? $self->name()
        : $self->fullProjectPath();

    return $self->SUPER::destDir($basePath || $defaultBase);
}

1;
