#!/usr/local/bin/perl

use vars qw(@tests $loaded);

BEGIN { $| = 1 }
END {print "not ok 1\n" unless $loaded;}

use HTTP::BrowserDetect;
$loaded = 1;

@tests = (
      ['Mozilla/1.1 (Windows 3.0; I)','1.1','Netscape','Win3x',qw(netscape windows win3x win16)],
      ['Mozilla/1.1 (Windows 3.1; I)','1.1','Netscape','Win3x',qw(netscape windows win31 win3x win16)],
      ['Mozilla/2.0 (Win95; I)','2.0','Netscape','Win95',qw(netscape nav2 windows win32 win95)],
      ['Mozilla/2.0 (compatible; MSIE 3.01; Windows 95)','3.01','MSIE','Win95',qw(ie ie3 windows win32 win95)],
      ['Mozilla/2.0 (compatible; MSIE 3.01; Windows NT)','3.01','MSIE','WinNT',qw(ie ie3 windows win32 winnt)],
      ['Mozilla/2.0 (compatible; MSIE 3.0; AOL 3.0; Windows 95)','3.0','AOL Browser','Win95',qw(ie ie3 windows win32 win95 aol aol3)],
      ['Mozilla/2.0 (compatible; MSIE 4.0; Windows 95)','4.0','MSIE','Win95',qw(ie ie4 ie4up windows win32 win95)],
      ['Mozilla/3.0 (compatible; MSIE 4.0; Windows 95)','4.0','MSIE','Win95',qw(ie ie4 ie4up windows win32 win95)],
      ['Mozilla/4.0 (compatible; MSIE 4.01; Windows 95)','4.01','MSIE','Win95',qw(ie ie4 ie4up windows win32 win95)],
      ['Mozilla/4.0 (compatible; MSIE 5.0b2; Windows NT)','5.0','MSIE','WinNT',qw(ie ie5 ie4up windows win32 winnt)],
      ['Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)','5.5','MSIE','WinNT',qw(ie ie5 ie55 ie4up windows win32 winnt)],
      ['Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0) via proxy gateway Something/1.23','5.5','MSIE','WinNT',qw(ie ie5 ie55 ie4up windows win32 winnt win2k)],
      ['Mozilla/3.0 (Macintosh; I; PPC)','3.0','Netscape','Mac',qw(netscape nav3 mac macppc)],
      ['Mozilla/4.0 (compatible; MSIE 5.0; Win32)','5.0','MSIE',undef,qw(ie ie4up ie5 windows win32)],
      ['Mozilla/4.0 (compatible; Opera/3.0; Windows 4.10) 3.50','3.0','Opera',undef,qw(opera windows)],
      ['Mozilla/4.0 (compatible; MSIE 5.0b1; Windows NT 5.0)','5.0','MSIE','WinNT',qw(ie ie4up ie5 windows win32 winnt win2k)],
      ['Mozilla/4.06 [en] (Win98; I ;Nav)','4.06','Netscape','Win98',qw(netscape nav4 nav4up windows win32 win98)],
      ['Mozilla/4.5 [en] (X11; I; FreeBSD 2.2.7-RELEASE i386)','4.5','Netscape','Unix',qw(netscape nav4 nav4up nav45 bsd freebsd unix x11)],
      ['Mozilla/3.03Gold (Win95; I)','3.03','Netscape','Win95', qw(netscape nav3 navgold windows win32 win95)],
      ['Wget/1.4.5','1.4',undef,undef,qw(wget robot)],
      ['libwww-perl/5.11','5.11',undef,undef,qw(lwp robot)],
      ['GetRight/3.2.1','3.2',undef,undef,qw(getright robot)],
      ['Mozilla/3.0 (compatible; StarOffice/5.1; Linux)','5.1',undef,'Linux',qw(linux unix staroffice)],
      ['Mozilla/3.0 (compatible; StarOffice/5.1; Win32)','5.1',undef,undef,qw(win32 windows staroffice)],
      ['iCab/Pre2.0 (Macintosh; I; PPC)','2.0',undef,'Mac',qw(mac macppc icab)],
      ['Konqueror/1.1.2','1.1',undef,undef,qw(konqueror)],
      ['Lotus-Notes/4.5 ( OS/2 )','4.5',undef,'OS2',qw(lotusnotes os2)],
      ['Java1.0.2','0.0',undef,undef,qw(java)],
      ['Googlebot/1.0 (googlebot@googlebot.com http://googlebot.com/)','1.0',undef,undef,qw(google robot)],
      ['Nothing','0.0',undef,undef,qw()],
      [undef,'0.0',undef,undef,qw()],
     );

print STDERR $HTTP::BrowserDetect::VERSION, "\n";
print "1..".(1+scalar(@tests))."\n"; 
print "ok 1\n";

my $browser = new HTTP::BrowserDetect();
my $test_number = 2;

foreach (@tests) {
    my $fail = 0;
    my @reason = ();
    my ($user_agent, $version, $browser_string, $os_string, @test_names) = @{$_};

    foreach my $obj ('$browser->', 'HTTP::BrowserDetect::') {
	eval("${obj}user_agent(\$user_agent)");
	unless (eval("${obj}os_string()") eq $os_string) {
	    $fail = 1;
	    push @reason, 'os_string';
	}
	unless (eval("${obj}browser_string()") eq $browser_string) {
	    $fail = 1;
	    push @reason, 'browser_string';
	}

	my ($major, $minor) = ($version =~ /([\d]*)\.([\d]*)/);
	unless (eval("${obj}version(\$version)")) {
	    $fail = 1;
	    push @reason, 'version';
	}
	unless (eval("${obj}major(\$major)")) {
	    $fail = 1;
	    push @reason, 'major';
	}

	my %tests = map{$_=>1} @test_names;
	foreach (@HTTP::BrowserDetect::ALL_TESTS, keys %tests) {
	    unless (eval("${obj}$_()") == $tests{$_}) {
		$fail = 1;
		push @reason, $_;
	    }
	}
    }
    if ($fail) {
      print "not ok " , $test_number;
      print STDERR ' ' , $user_agent, ": ";
      print STDERR join ", ", @reason;
    } else {
      print "ok ", $test_number;
    }
    print "\n";
    $test_number++;
}





