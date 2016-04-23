package ksb::WebAPI::KDEProjects 0.10
{

# This class consolidates the code handling the new-style REST API to be used to support
# obtaining information about the various KDE git repositories (something previously done
# by downloading a large XML file and breaking it apart).
#
# The intent is that this would be used by the $ctx (or something similar) and would be a simple
# wrapper around the API defined at https://community.kde.org/Sysadmin/Project_Metadata_API
#
# TODO: Needless to say, there's much more to do to get this finished.

use 5.14.0;
use warnings;

use HTTP::Tiny;
use JSON::PP;

use ksb::Debug;
use ksb::BuildException;
use ksb::Util;

my $api_url = 'https://apps.kde.org/api/v1';

sub new
{
    my ($class) = @_;
    my $self = {
        ua => construct_http_ua(),
    };

    assert_isa($self->{ua}, 'HTTP::Tiny');

    return bless $self, $class;
}

# Makes API call to KDE Projects API web service, and:
#   if successful, returns list of current KDE project components
#   if an error occurs, throws an exception
sub components
{
    my $self = shift;
    my $resp = $self->{ua}->get("$api_url/components");

    if (!$resp->{success}) {
        croak_runtime("Unable to load list of KDE software ".
            "components from KDE web servers! " . $resp->{reason});
    }

    return @{decode_json ($resp->{content})};
}

} # end package

1;
