
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Data::Dump' => '0',
    'English' => '0',
    'FindBin' => '0',
    'Module::Build' => '0.3601',
    'Test::More' => '0',
    'YAML::Tiny' => '0'
  },
  'configure_requires' => {
    'ExtUtils::MakeMaker' => '6.31',
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Determine Web browser, version, and platform from an HTTP user agent string',
  'dist_author' => [
    'Olaf Alders <olaf@wundercounter.com> (current maintainer)'
  ],
  'dist_name' => 'HTTP-BrowserDetect',
  'dist_version' => '1.13',
  'license' => 'perl',
  'module_name' => 'HTTP::BrowserDetect',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Exporter' => '0',
    'vars' => '0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
