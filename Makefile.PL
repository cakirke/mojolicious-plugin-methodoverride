use inc::Module::Install;

name            'Mojolicious-Plugin-MethodOverride';
all_from        'lib/Mojolicious/Plugin/MethodOverride.pm';
author          q{Bernhard Graf <graf@cpan.org>};
license         'perl';
repository      'git://github.com/augensalat/mojolicious-plugin-methodoverride.git';

build_requires  'Test::More';
build_requires  'Test::Mojo';

requires        'Mojolicious' => '3.21';

perl_version    '5.10';

auto_install;

makemaker_args(
    dist => { TAR => 'gtar' },
);

WriteAll;

