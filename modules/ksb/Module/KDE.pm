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
use ksb::OSSupport;

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

# override
sub preUpdate
{
    my $self = assert_isa(shift, 'ksb::Module::KDE');

    my $deps = $self->_localOSDependencies();

    if (@{$deps}) {
        my $str = join(', ', @{$deps});
        debug ("\tAdding dependencies g[b[$str] for $self");
    }

    return $self->SUPER::preUpdate();
}

# Returns a list of package names that must be installed as *direct*
# dependencies of this KDE repository, applicable for installation by the local
# OS package manager.
# This is all dependent upon suitable metadata being available. See
# dependencies_local_distro.yaml in the kdesrc-build repository.
# If the local OS is not recognized then an empty list is returned without
# further error.
sub _localOSDependencies
{
    my $self = shift;
    my $ctx  = $self->buildContext();
    my $os   = $ctx->getOSSupport();

    my %deps = %{$ctx->getKDEDistroDependencies($self)};
    return unless %deps;

    my $vendor = $os->bestDistroMatch(keys %deps);
    return unless $deps{$vendor};

    return $deps{$vendor}->{$os->vendorVersion()} // {};
}

1;
