#!/usr/bin/perl
use strict;
use warnings;
use JSON::XS qw{encode_json};
use Plack::Builder qw{builder enable};
use Plack::Request;
use Net::MQTT::Simple;

our $MQTT_TOPIC              = $ENV{'MQTT_TOPIC'}               || 'service/http-to-mqtt/request';
our $MQTT_HOST               = $ENV{'MQTT_HOST'}                || '127.0.0.1';
our $MQTT_PAYLOAD_LENGTH_MAX = $ENV{'MQTT_PAYLOAD_LENGTH_MAX'}  || 4096;
our $DEBUG                   = $ENV{'DEBUG'}                     ? 1 : 0;
our $mqtt                    = Net::MQTT::Simple->new($MQTT_HOST);

print "MQTT_TOPIC: $MQTT_TOPIC\n";
print "MQTT_HOST: $MQTT_HOST\n";

my $app = sub {
  my $env         = shift;
  my $req         = Plack::Request->new($env);
  my $params      = $req->query_parameters->as_hashref; #isa Hash::MultiValue to isa HASH
  my %payload     = (
                     query_parameters => $params,
                     map {lc($_) => $env->{$_}} qw{PATH_INFO REMOTE_ADDR REQUEST_METHOD}
                    );

  my $json        = encode_json(\%payload);
  my $json_length = length($json);
  if ($json_length > $MQTT_PAYLOAD_LENGTH_MAX) { #max payload size for IoT MQTT
    return [400 => ['Content-Type' => 'text/plain'] => ["Bad Request: MQTT_PAYLOAD_LENGTH_MAX exceeded (actual: $json_length)"]];
  } else {
    $mqtt->publish($MQTT_TOPIC => $json);


    my $content = 'OK';
    if ($DEBUG) {
      print "$MQTT_TOPIC $json\n"; #STDOUT logging
      require Data::Dumper;
      $Data::Dumper::Indent  = 1; #smaller index
      $Data::Dumper::Terse   = 1; #remove $VAR1 header
      $content = "MQTT_HOST: $MQTT_HOST\n".
                 "MQTT_TOPIC: $MQTT_TOPIC\n".
                 "MQTT_PAYLOAD_LENGTH_MAX: $MQTT_PAYLOAD_LENGTH_MAX (actual: $json_length)\n".
                 "MQTT_PAYLOAD: $json\n".
                 "PSGI_ENV: ". Data::Dumper::Dumper($env);
    }
    return [200 => ['Content-Type' => 'text/plain'] => [$content]];

  }
};

builder {
  enable "Plack::Middleware::Favicon_Simple";
  enable "Plack::Middleware::Method_Allow", allow=>['GET'];
  $app;
};
