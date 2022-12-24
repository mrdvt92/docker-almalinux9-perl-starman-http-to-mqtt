#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper qw{Dumper};
use JSON::XS qw{encode_json};
use Plack::Builder qw{builder mount};
use Plack::Request;
use Net::MQTT::Simple;

our $MQTT_TOPIC = $ENV{'MQTT_TOPIC'} || 'service/http-to-mqtt/request';
our $MQTT_HOST  = $ENV{'MQTT_HOST'}  || '127.0.0.1';
our $DEBUG      = $ENV{'DEBUG'} ? 1 : 0;
our $mqtt       = Net::MQTT::Simple->new($MQTT_HOST);

print "MQTT_TOPIC: $MQTT_TOPIC\n";
print "MQTT_HOST: $MQTT_HOST\n";

my $app = sub {
  my $env              = shift;
  my $req              = Plack::Request->new($env);
  my $query_parameters = $req->query_parameters->as_hashref; #isa Hash::MultiValue to isa HASH
  my %payload          = (
                          query_parameters => $query_parameters,
                          map {lc($_) => $env->{$_}} qw{PATH_INFO REMOTE_ADDR REQUEST_METHOD}
                         );

  my $json             = encode_json(\%payload);
  $mqtt->publish($MQTT_TOPIC => $json);

  my $content          = 'OK';
  if ($DEBUG) {
    print "$MQTT_TOPIC $json\n";
    $content = Dumper($env);
  }
  return [200 => ['Content-Type' => 'text/plain'] => [$content]];
};

my $wrap = sub {
  my $env = shift;
  if ($env->{'REQUEST_METHOD'} eq 'GET') {
    return $app->($env);
  } else {
    return [405 => ['Content-Type' => 'text/plain'] => ['Method Not Allowed']]
  }
};

builder {
  mount '/favicon.ico' => sub {[200, ['Content-Type' => 'image/x-icon'], [favicon()]]};
  mount '/' => $wrap;
};

sub favicon {
  require MIME::Base64;
  return MIME::Base64::decode('
    AAABAAEAEBACAAEAAQCwAAAAFgAAACgAAAAQAAAAIAAAAAEAAQAAAAAAgAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAA////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//wAA//8AAP//AAD//w
    AA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA
  ');
}
