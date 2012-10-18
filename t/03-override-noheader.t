#!/usr/bin/env perl

use Mojo::Base -strict;

# Disable IPv6 and libev
BEGIN {
  $ENV{MOJO_NO_IPV6} = 1;
  $ENV{MOJO_REACTOR} = 'Mojo::Reactor::Poll';
}

use Test::More;
 
use Mojolicious::Lite;
use Test::Mojo;

plugin 'MethodOverride', header => undef, param => 'x-tunneled-method';

get '/welcome' => sub {
  shift->render_data("GET the Mojolicious real-time web framework!\n");
};

post '/welcome' => sub {
  shift->render_data("POST the Mojolicious real-time web framework!\n");
};

put '/welcome' => sub {
  shift->render_data("PUT the Mojolicious real-time web framework!\n");
};

del '/welcome' => sub {
  shift->render_data("DELETE the Mojolicious real-time web framework!\n");
};

my $t = Test::Mojo->new;

$t->post_ok('/welcome', {'X-HTTP-Method-Override' => 'GET'})
  ->status_is(200)
  ->content_unlike(qr/GET the Mojolicious /)
  ->content_like(qr/POST the Mojolicious /);
$t->post_ok('/welcome', {'X-HTTP-Method-Override' => 'POST'})
  ->status_is(200)
  ->content_like(qr/POST the Mojolicious /);
$t->post_ok('/welcome', {'X-HTTP-Method-Override' => 'PUT'})
  ->status_is(200)
  ->content_unlike(qr/PUT the Mojolicious /)
  ->content_like(qr/POST the Mojolicious /);
$t->post_ok('/welcome', {'X-HTTP-Method-Override' => 'DELETE'})
  ->status_is(200)
  ->content_unlike(qr/DELETE the Mojolicious /)
  ->content_like(qr/POST the Mojolicious /);

$t->post_ok('/welcome?x-tunneled-method=GET')
  ->status_is(200)
  ->content_like(qr/GET the Mojolicious /);
$t->post_ok('/welcome?x-tunneled-method=POST')
  ->status_is(200)
  ->content_like(qr/POST the Mojolicious /);
$t->post_ok('/welcome?x-tunneled-method=PUT')
  ->status_is(200)
  ->content_like(qr/PUT the Mojolicious /);
$t->post_ok('/welcome?x-tunneled-method=DELETE')
  ->status_is(200)
  ->content_like(qr/DELETE the Mojolicious /);

$t->post_ok('/welcome?x-tunneled-thingy=GET')
  ->status_is(200)
  ->content_unlike(qr/GET the Mojolicious /)
  ->content_like(qr/POST the Mojolicious /);

done_testing;
