
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Determine Web browser, version, and platform from an HTTP user agent string",
  "dist_author" => [
    "Lee Semel <lee\@semel.net>",
    "Peter Walsham",
    "Olaf Alders <olaf\@wundercounter.com> (current maintainer)"
  ],
  "dist_name" => "HTTP-BrowserDetect",
  "dist_version" => "1.64",
  "license" => "perl",
  "module_name" => "HTTP::BrowserDetect",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "strict" => 0,
    "vars" => 0,
    "warnings" => 0
  },
  "script_files" => [],
  "test_requires" => {
    "File::Slurp" => 0,
    "FindBin" => 0,
    "JSON::PP" => 0,
    "Test::FailWarnings" => 0,
    "Test::More" => 0,
    "Test::Most" => 0,
    "Test::NoWarnings" => 0
  }
);


my %fallback_build_requires = (
  "File::Slurp" => 0,
  "FindBin" => 0,
  "JSON::PP" => 0,
  "Module::Build" => "0.3601",
  "Test::FailWarnings" => 0,
  "Test::More" => 0,
  "Test::Most" => 0,
  "Test::NoWarnings" => 0
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  delete $module_build_args{test_requires};
  $module_build_args{build_requires} = \%fallback_build_requires;
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
