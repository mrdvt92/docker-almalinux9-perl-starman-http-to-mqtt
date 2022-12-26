#!/usr/bin/perl
use strict;
use warnings;
use JSON::XS qw{encode_json};
use Plack::Builder qw{builder enable};
use Plack::Request;
use Net::MQTT::Simple;

our $MQTT_TOPIC = $ENV{'MQTT_TOPIC'} || 'service/http-to-mqtt/request';
our $MQTT_HOST  = $ENV{'MQTT_HOST'}  || '127.0.0.1';
our $DEBUG      = $ENV{'DEBUG'}       ? 1 : 0;
our $mqtt       = Net::MQTT::Simple->new($MQTT_HOST);

print "MQTT_TOPIC: $MQTT_TOPIC\n";
print "MQTT_HOST: $MQTT_HOST\n";

my $app = sub {
  my $env     = shift;
  my $req     = Plack::Request->new($env);
  my $params  = $req->query_parameters->as_hashref; #isa Hash::MultiValue to isa HASH
  my %payload = (
                 query_parameters => $params,
                 map {lc($_) => $env->{$_}} qw{PATH_INFO REMOTE_ADDR REQUEST_METHOD}
                );

  my $json    = encode_json(\%payload);
  $mqtt->publish($MQTT_TOPIC => $json);

  my $content = 'OK';
  if ($DEBUG) {
    require Data::Dumper;
    print "$MQTT_TOPIC $json\n";
    $content = Data::Dumper::Dumper($env);
  }
  return [200 => ['Content-Type' => 'text/plain'] => [$content]];
};

builder {
  enable "Plack::Middleware::Favicon_Simple";
  enable "Plack::Middleware::Method_Allow", allow=>['GET'];
  $app;
};
