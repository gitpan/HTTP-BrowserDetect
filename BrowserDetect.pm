package HTTP::BrowserDetect;

use strict;
use vars qw($VERSION $REVISION @ISA @EXPORT @EXPORT_OK $AUTOLOAD @ALL_TESTS);
require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw();
$REVISION = '$Id: BrowserDetect.pm,v 1.1 1999/03/17 04:38:06 lee Exp lee $';
$VERSION = '0.93';

#######################################################################################################
# CONSTANTS
# These strings are declared as variables so we can take advantage of 'use strict' when checking
# hash elements

# Operating Systems
use vars qw($WIN16 $WIN3X $WIN31 $WIN95 $WIN98 $WINNT $WINDOWS $WIN32 $MAC $MAC68K $MACPPC $OS2 $UNIX $SUN $SUN4 $SUN5 $SUNI86 $IRIX $IRIX5 $IRIX6 $HPUX $HPUX9 $HPUX10 $AIX $AIX1 $AIX2 $AIX3 $AIX4 $LINUX $SCO $UNIXWARE $MPRAS $RELIANT $DEC $SINIX $FREEBSD $BSD $VMS $X11);
constants(qw($WIN16 $WIN3X $WIN31 $WIN95 $WIN98 $WINNT $WINDOWS $WIN32 $MAC $MAC68K $MACPPC $OS2 $UNIX $SUN $SUN4 $SUN5 $SUNI86 $IRIX $IRIX5 $IRIX6 $HPUX $HPUX9 $HPUX10 $AIX $AIX1 $AIX2 $AIX3 $AIX4 $LINUX $SCO $UNIXWARE $MPRAS $RELIANT $DEC $SINIX $FREEBSD $BSD $VMS $X11));

# Browser names
use vars qw($MOSAIC $NETSCAPE $NAV2 $NAV3 $NAV4 $NAV4UP $NAV45 $NAV5 $NAVGOLD $IE $IE3 $IE4 $IE4UP $IE5 $OPERA $LYNX $IE $AOL $AOL3 $NEOPLANET $NEOPLANET2 $WGET $GETRIGHT $ROBOT $YAHOO $ALTAVISTA $LYCOS $INFOSEEK $LWP $WEBCRAWLER $LINKEXCHANGE $SLURP $WEBTV);
constants(qw($MOSAIC $NETSCAPE $NAV2 $NAV3 $NAV4 $NAV4UP $NAV45 $NAV5 $NAVGOLD $IE $IE3 $IE4 $IE4UP $IE5 $OPERA $LYNX $IE $AOL $AOL3 $NEOPLANET $NEOPLANET2 $WGET $GETRIGHT $ROBOT $YAHOO $ALTAVISTA $LYCOS $INFOSEEK $LWP $WEBCRAWLER $LINKEXCHANGE $SLURP $WEBTV));

sub constants {
   my (@vars) = @_;
   no strict 'refs';
   foreach my $var (@vars) {
      $var =~ s/^\$//;
      ${$var} = lc $var;
      push @ALL_TESTS, lc $var;
   }
}

#######################################################################################################
# BROWSER OBJECT

my $default = undef;
   
sub new {
   my ($class) = shift;
   
   my $self = {};
   bless $self, $class;

 
   $self->init(@_);
   $self->test() if $self->{user_agent};
    
   return $self;
}

sub init {
   my ($self, $user_agent) = @_;
   $user_agent ||= $ENV{'HTTP_USER_AGENT'};
   
   foreach (keys %${self}) {
      delete $self->{$_};
   }
  
   $self->{user_agent} =  $user_agent;
   $self->{major} = undef;
   $self->{minor} = undef;
   $self->{beta} = undef;
}

sub self_or_default {
   my ($self) = $_[0];
   return @_ if (defined $self && ref $self && (ref $self eq 'HTTP::BrowserDetect') || UNIVERSAL::isa($self,'HTTP::BrowserDetect'));
   $default = new HTTP::BrowserDetect unless ($default);
   unshift (@_, $default);
   return @_;
}

# Private method -- test the UA string
sub test {
   my ($self) = @_;
   my $ua = lc $self->{user_agent};
      
   # Browser 
   
   my ($major, $minor, $beta) = ($ua =~ /\/([^\.]*)\.([\d]*)[\d\.]*([^\s]*)/);
   
   $self->{$NETSCAPE}=1     if index($ua,"mozilla")!=-1 && index($ua,"spoofer")==-1 && index($ua,"compatible")==-1;
   $self->{$NAV2}=1         if ($self->{$NETSCAPE}) && $major == 2;
   $self->{$NAV3}=1         if ($self->{$NETSCAPE}) && $major == 3;
   $self->{$NAV4}=1         if ($self->{$NETSCAPE}) && $major == 4;
   $self->{$NAV45}=1        if ($self->{$NETSCAPE}) && $major == 4 && $minor == 5;
   $self->{$NAV5}=1         if ($self->{$NETSCAPE}) && $major == 5;
   $self->{$NAV4UP}=1       if ($self->{$NETSCAPE}) && $major >= 4;   
   $self->{$NAVGOLD}=1      if index($beta,"gold")!=-1;
   
   $self->{$IE}=1           if index($ua,"msie")!=-1;
   if ($self->{$IE}) {
      ($major, $minor, $beta) = ($ua =~ /msie ([^\.]*)\.([\d]*)[\d\.]*([^;]*);/);     
   }
   $self->{$IE3}=1          if ($self->{$IE}) && $major == 3;
   $self->{$IE4}=1          if ($self->{$IE}) && $major == 4;
   $self->{$IE5}=1          if ($self->{$IE}) && $major == 5;
   $self->{$IE4UP}=1        if ($self->{$IE}) && $major >= 4;


   $self->{$OPERA}=1        if index($ua,"opera")!=-1;
   if ($self->{$OPERA}) {
      ($major, $minor, $beta) = ($ua =~ /opera\/([^\.]*)\.([\d]*)[\d\.]*([^;]*);/);     
   }

   $self->{$LYNX}=1         if index($ua,"lynx")!=-1;
   $self->{$AOL}=1          if index($ua,"aol")!=-1;
   $self->{$AOL3}=1         if index($ua,"aol 3.0")!=-1;
   $self->{$NEOPLANET}=1    if index($ua,"neoplanet")!=-1;
   $self->{$NEOPLANET2}=1   if ($self->{$NEOPLANET}) && index($ua,"2.")!=-1;      
   $self->{$WEBTV}=1        if index($ua,"webtv")!=-1;
   $self->{$MOSAIC}=1       if index($ua,"mosaic")!=-1;

   $self->{$WGET}=1        if index($ua,"wget")!=-1;
   $self->{$GETRIGHT}=1    if index($ua,"getright")!=-1;
   $self->{$LWP}=1         if index($ua,"libwww-perl")!=-1;
   $self->{$YAHOO}=1       if index($ua,"yahoo")!=-1;
   $self->{$ALTAVISTA}=1   if index($ua,"altavista")!=-1;
   $self->{$ALTAVISTA}=1   if index($ua,"scooter")!=-1;
   $self->{$LYCOS}=1       if index($ua,"lycos")!=-1;
   $self->{$INFOSEEK}=1    if index($ua,"infoseek")!=-1;
   $self->{$WEBCRAWLER}=1  if index($ua,"webcrawler")!=-1;
   $self->{$LINKEXCHANGE}=1 if index($ua,"lecodechecker")!=-1;
   $self->{$SLURP}=1       if index($ua,"slurp")!=-1;
   $self->{$ROBOT}=1       if ($self->{$WGET} || $self->{$GETRIGHT} || $self->{$LWP} || 
                               $self->{$YAHOO} || $self->{$ALTAVISTA} || $self->{$LYCOS} || 
                               $self->{$INFOSEEK} || $self->{$WEBCRAWLER} || $self->{$LINKEXCHANGE} ||
                               $self->{$SLURP});
   
   
   # Operating System
   
   $self->{$WIN16}=1       if index($ua,"win16")!=-1 || index($ua,"16bit")!=-1 || index($ua,"windows 3")!=-1 || index($ua,"windows 16-bit")!=-1;
   $self->{$WIN3X}=1       if index($ua,"win16")!=-1 || index($ua,"windows 3")!=-1 || index($ua,"windows 16-bit")!=-1;
   $self->{$WIN31}=1       if index($ua,"win16")!=-1 || index($ua,"windows 3.1")!=-1 || index($ua,"windows 16-bit")!=-1;
   $self->{$WIN95}=1       if index($ua,"win95")!=-1 || index($ua,"windows 95")!=-1;
   $self->{$WIN98}=1       if index($ua,"win98")!=-1 || index($ua,"windows 98")!=-1;
   $self->{$WINNT}=1       if index($ua,"winnt")!=-1 || index($ua,"windows nt")!=-1;
   $self->{$WIN32}=1       if ($self->{$WIN95} || $self->{$WIN98} || $self->{$WINNT}) || index($ua,"win32")!=-1;
   $self->{$WINDOWS}=1     if ($self->{$WIN16} || $self->{$WIN31} || $self->{$WIN95} || $self->{$WIN98} || $self->{$WINNT} || $self->{$WIN32}) || index($ua,"win")!=-1;
   
   $self->{$MAC}=1         if index($ua,"mac")!=-1;
   $self->{$MAC68K}=1      if ($self->{$MAC}) && (index($ua,"68k")!=-1 || index($ua,"68000")!=-1);
   $self->{$MACPPC}=1      if ($self->{$MAC}) && (index($ua,"ppc")!=-1 || index($ua,"powerpc")!=-1);
   
   $self->{$OS2}=1         if index($ua,'os/2')!=-1;

   $self->{$SUN}=1         if index($ua,"sunos")!=-1;
   $self->{$SUN4}=1        if index($ua,"sunos 4")!=-1;
   $self->{$SUN5}=1        if index($ua,"sunos 5")!=-1;
   $self->{$SUNI86}=1      if ($self->{$SUN}) && index($ua,"i86")!=-1;
   
   $self->{$IRIX}=1        if index($ua,"irix")!=-1;
   $self->{$IRIX5}=1       if index($ua,"irix5")!=-1;
   $self->{$IRIX6}=1       if index($ua,"irix6")!=-1;

   $self->{$HPUX}=1        if index($ua,"hp-ux")!=-1;
   $self->{$HPUX9}=1       if ($self->{$HPUX}) && index($ua,"09.")!=-1;
   $self->{$HPUX10}=1      if ($self->{$HPUX}) && index($ua,"10.")!=-1;

   $self->{$AIX}=1         if index($ua,"aix")!=-1;
   $self->{$AIX1}=1        if index($ua,"aix 1")!=-1;
   $self->{$AIX2}=1        if index($ua,"aix 2")!=-1;
   $self->{$AIX3}=1        if index($ua,"aix 3")!=-1;
   $self->{$AIX4}=1        if index($ua,"aix 4")!=-1;
   
   $self->{$LINUX}=1       if index($ua,"inux")!=-1;
   $self->{$SCO}=1         if index($ua,"sco")!=-1 || index($ua,"unix_sv")!=-1;
   $self->{$UNIXWARE}=1    if index($ua,"unix_system_v")!=-1;
   $self->{$MPRAS}=1       if index($ua,"ncr")!=-1;
   $self->{$RELIANT}=1     if index($ua,"reliantunix")!=-1;
   $self->{$DEC}=1         if index($ua,"dec")!=-1 || index($ua,"osf1")!=-1 || index($ua,"declpha")!=-1 || 
                              index($ua,"alphaserver")!=-1 || index($ua,"ultrix")!=-1 ||
                              index($ua,"alphastation")!=-1;
   $self->{$SINIX}=1       if index($ua,"sinix")!=-1;
   $self->{$FREEBSD}=1     if index($ua,"freebsd")!=-1;
   $self->{$BSD}=1         if index($ua,"bsd")!=-1;
   $self->{$X11}=1         if index($ua,"x11")!=-1;
   $self->{$UNIX}=1        if ($self->{$X11} || $self->{$SUN} || $self->{$IRIX} || $self->{$HPUX} ||
                                                $self->{$SCO} || $self->{$UNIXWARE} || $self->{$MPRAS} ||
                                                $self->{$RELIANT} || $self->{$DEC} || $self->{$LINUX} ||
                                                $self->{$BSD});                                                   
   $self->{$VMS}=1        if index($ua,"vax")!=-1 || index($ua,"openvms")!=-1;
                                                               
   $self->{major} = $major;
   $self->{minor} = $minor;
   $self->{beta}  = $beta;
}

sub user_agent {
   my ($self, $user_agent) = self_or_default(@_);
   if (defined $user_agent) {
      $self->init($user_agent);
      $self->test();
   }
   return $self->{user_agent};
}

sub browser_string {
    my ($self) = self_or_default(@_);
    my $browser_string = undef;
    my $user_agent = $self->user_agent;
    if (defined $user_agent) {
	$browser_string = 'Netscape' if $self->netscape;
	$browser_string = 'MSIE' if $self->ie;	
	$browser_string = 'WebTV' if $self->webtv;
	$browser_string = 'AOL Browser' if $self->aol;
	$browser_string = 'Opera' if $self->opera;
	$browser_string = 'Mosaic' if $self->mosaic;
	$browser_string = 'Lynx' if $self->lynx;
    }
    return $browser_string;
}

sub os_string {
    my ($self) = self_or_default(@_);
    my $os_string = undef;
    my $user_agent = $self->user_agent;
    if (defined $user_agent) {
	$os_string = 'Win95' if $self->win95;
	$os_string = 'Win98' if $self->win98;
	$os_string = 'WinNT' if $self->winnt;
	$os_string = 'Mac' if $self->mac;
	$os_string = 'Win3x' if $self->win3x;
	$os_string = 'OS2' if $self->os2;
	$os_string = 'Unix' if $self->unix && !$self->linux;
	$os_string = 'Linux' if $self->linux;
    }
    return $os_string;
}

sub version {
   my ($self, $check) = self_or_default(@_);
   my $version;
   if (defined $self->{major} && defined $self->{minor}) {
       $version = join '.' , $self->{major}, $self->{minor};
       $version += 0;
   } else {
       $version = $self->{major};
   }
   if (defined $check) { 
      return $check == $version;
   } else {
      return $version;
   }
}


sub major {
   my ($self, $check) = self_or_default(@_);
   my ($version) = $self->{major};
   if (defined $check) { 
      return $check == $version;
   } else {
      return $version;
   }
}
 
sub minor {
   my ($self, $check) = self_or_default(@_);
   my ($version) = $self->{minor};
   if (defined $check) { 
      return ".$check" == ".$version";
   } else {
      return $version;
   }
}

sub beta {
   my ($self, $check) = self_or_default(@_);
   my ($version) = $self->{beta};
   if ($check) { 
      return $check eq $version;
   } else {
      return $version;
   }
}
    
sub AUTOLOAD {
   my ($self) = self_or_default(@_);
   my ($package, $name);
   
   ($package, $name) = ($AUTOLOAD =~ /(.*)::(.*)$/);
   
   no strict 'refs';
   
   if (defined ${uc $name} || defined $self->{lc $name}) {
      return ($self->{lc $name});
   } else {
      die "'$name' is not a property of $package object";
   }   
}


1;

__END__

=head1 NAME

HTTP::BrowserDetect - Determine the Web browser, version, and platform from a HTTP user agent string

=head1 SYNOPSIS

  use HTTP::BrowserDetect;
  
  my $browser = new HTTP::BrowserDetect($user_agent_string);
  if ($browser->windows) {
      if ($browser->winnt) print "WinNT";
      if ($brorwser->win95) print "Win95";
  }
  print $browser->netscape;
  if (browser->major(4)) { ... }
  if (browser->minor(5)) { ... }
  
  $browser->user_agent($another_user_agent_string);
  print $browser->mac;
  print $browser->ie;
  if ($browser->version() > 4) { ... }

=head1 DESCRIPTION

The HTTP::BrowserDetect object does a number of tests on an HTTP user agent string.  The results
of these tests are available via methods of the object.

This module is based upon the JavaScript browser detection code available at B<http://developer.netscape.com/docs/examples/javascript/browser_type.html>.

=head2 CREATING A NEW BROWSER DETECT OBJECT AND SETTING THE USER AGENT STRING

=over 4

=item new HTTP::BrowserDetect($user_agent_string)

The constructor may be called with a user agent string specified.  Otherwise, it will use the 
value specified by $ENV{'HTTP_USER_AGENT'}, which is set by the web server when calling a CGI script.

You may also use a non-object-oriented interface.  For each method, you may call HTTP::BrowserDetect::method_name().
You will then be working with a default HTTP::BrowserDetect object that is created behind the scenes.

=item user_agent($user_agent_string)

Returns the value of the user agent string.  When called with a parameter, it resets the user agent 
and reperforms all tests on the string.  This way you can process a series of user agent strings 
(from a log file, perhaps) without creating a new HTTP::BrowserDetect object each time.  

=back

=head2 DETECTING BROWSER VERSION

=over 4

=item major($major)

Returns the portion of the browser version up to the first decimal point as a string.  If passed a parameter, 
returns true if it equals the major version specified by the user agent string.

=item minor($minor)

Returns the numeric portion of the browser after first decimal point as a string.  If passed a parameter, 
returns true if it equals the minor version specified by the user agent string.
On occasion a version may have more than one decimal point, such as 'Wget/1.4.5'.  The minor version
does not include the second decimal point or any further digits or decimals.

=item version($version)

Returns the version as a floating-point number. 
If passed a parameter, returns true if it equals the browser version specified by the user agent string.

=item beta($beta)

Returns any non-numeric characters after the version.  For instance, if the user agent string is 
'Mozilla/4.0 (compatible; MSIE 5.0b2; Windows NT)', returns 'b2'.

=back

=head2 DETECTING OS PLATFORM AND VERSION

The following methods are available, each returning a true or false value.  Some methods also
test for the operating system version.

  windows
     win16 win3x win31 win95 win98 winnt win32
  mac
     mac68k macppc 
  os2 
  unix 
     sun sun4 sun5 suni86 irix irix5 irix6 hpux hpux9 hpux10 
     aix aix1 aix2 aix3 aix4 linux sco unixware mpras reliant 
     dec sinix freebsd bsd
  vms

=over 

=item os_string()

Returns one of the following strings, or undef.  These are the same set of strings returned by the
B<HTTP::Headers::UserAgent> module.

  Win95, Win98, WinNT, Mac, Win3x, OS2, Unix, Linux

=back

=head2 DETECTING BROWSER VENDOR

The following methods are available, each returning a true or false value.  Some methods also
test for the browser version, saving you from checking the version separately.

  mosaic
  netscape
     nav2 nav3 nav4 nav4up nav45 nav5 navgold
  ie
     ie3 ie4 ie4up ie5
  aol 
     aol3 
  neoplanet 
     neoplanet2 
  webtv
  opera
  lynx

=over

=item browser_string()

Returns one of the following strings, or undef.

Netscape, MSIE, WebTV, AOL Browser, Opera, Mosaic, Lynx

=back

=head2 DETECTING ROBOTS

The following methods are available, each returning a true or false value.  This is by no means
a complete list of robots that exist on the Web.

  robot 
  wget
  getright
  yahoo 
  altavista 
  lycos 
  infoseek 
  lwp
  webcrawler 
  linkexchange 
  slurp 

=head1 AUTHOR

Lee Semel, lee@semel.net


=head1 SEE ALSO

perl(1).

=head1 COPYRIGHT

Copyright 1999-2000 Lee Semel. All rights reserved.


=cut


     



