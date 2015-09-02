#!/usr/bin/perl

use strict;
#use warnings;
use PerlIO::gzip;
use DBI;
use Getopt::Long;
use Term::ReadPassword;
use FindBin qw/$Bin/;
#use Data::Dumper;

my ($dbhost, $dbuser, $dbpass, $dbname, $quiet);
usage() if scalar @ARGV < 1;
GetOptions(
    'dbhost:s' => \$dbhost,
    'dbuser:s' => \$dbuser,
    'dbpass!' => \$dbpass,
    'dbname:s' => \$dbname,
    'quiet!' => \$quiet,
) or die("Error in command line arguments\n");

$dbhost ||= 'localhost';
unless ($dbuser) {
    print STDERR "You need MySQL username\n";
    exit -1;
}
unless ($dbname) {
    print STDERR "You need MySQL database name\n";
    exit -1;
}

if ($dbpass) {
    $dbpass = read_password('Enter MySQL password: ');
} else {
    $dbpass = '';
}

my $bytes_str =<< 'EOS';
   1-  6  I06    ---    VarNum    Numeric designation, made from constellation and star names (codes in file "constel.txt")
       7  A1     ---    m_VarNum  Component identification (1)
   9- 18  A10    ---    GCVS      Variable star designation (G1)
      19  A1     ---    n_GCVS    [*] indicates a remark in "gcvs_rem.dat" file
  21- 22  I2     h      RAh       ? Hours RA, equinox J2000.0 (2)
  23- 24  I2     min    RAm       ? Minutes RA, equinox J2000.0 (2)
  25- 28  F4.1   s      RAs       ? Seconds RA, equinox J2000.0 (2)
      29  A1     ---    DE-       ? Sign Dec, equinox J2000.0 (2)
  30- 31  I2     deg    DEd       ? Degrees Dec, equinox J2000.0 (2)
  32- 33  I2     arcmin DEm       ? Minutes Dec, equinox J2000.0 (2)
  34- 35  I2     arcsec DEs       ? Seconds Dec, equinox J2000.0 (2)
      36  A1     ---    u_DEs     [:*] position accuracy flags (3)
  38- 47  A10    ---    VarType   Type of variability (see file "vartype.txt")
      49  A1     ---    l_magMax  [<>(] Limit or amplitude symbol on magMax (G3)
  50- 55  F6.3   mag    magMax    ? Magnitude at maximum brightness
      56  A1     ---    u_magMax  Uncertainty flag (:) on magMax
      57  A1     ---    ---       [)] ")" if magMax is an amplitude
      59  A1     ---    l_Min1    [<(] Limit or amplitude symbol on Min1 (G3)
  60- 65  F6.3   mag    Min1      ? Minimum magnitude or amplitude
      66  A1     ---    u_Min1    Uncertainty flag (:) on Min1
  67- 68  A2     ---    n_Min1    Alternative photometric system for Min1 (G4)
      69  A1     ---    ---       [)] ")" if Min1 is an amplitude
      71  A1     ---    l_Min2    [<(] Limit or amplitude symbol on Min2 (G3)
  72- 77  F6.3   mag    Min2      ? Secondary minimum magnitude or amplitude
      78  A1     ---    u_Min2    Uncertainty flag (:) on Min2
  79- 80  A2     ---    n_Min2    Alternative photometric system for Min2 (G4)
      81  A1     ---    ---       [)] ")" if Min2 is an amplitude
  83- 84  A2     ---    flt       The photometric system for magnitudes (G4)
  86- 98  F13.5  d      Epoch     ? Epoch for maximum light, Julian days (G5)
      99  A1     ---    u_Epoch   [:±] Uncertainty flag on Epoch (4)
 101-104  A4     ---    Year      Year of outburst for nova or supernova
     105  A1     ---    u_Year    [:] Uncertainty flag on Year of outburst
     107  A1     ---    l_Period  [<>(] Code for upper or lower limits (5)
 108-123  F16.10 d      Period    ? Period of the variable star
 124-126  A3     ---    u_Period  [*/N)2: ] Uncertainties on Period (6)
 128-129  I2     %      M-m/D     ? Rising time or duration of eclipse (G6)
     130  A1     ---    u_M-m/D   Uncertainty flag (:) on M-m/D
     131  A1     ---    n_M-m/D   [*] Note for eclipsing variable (G6)
 134-150  A17    ---    SpType    MK Spectral type
 152-156  A5     ---    Ref1      Reference to a study of the star (G7)
 158-162  A5     ---    Ref2      Reference to a chart or photograph (G7)
     164  A1     ---    f_GCVS    [=N+] "N" if the star does not exist (7)
 165-174  A10    ---    VarName   Alternative name of the variable (G8)
EOS

my @bytes;

while ($bytes_str =~ /^(.{8})  (.{4})/gms)
{
    my ($tmp_bytes, $tmp_format) = ($1, $2);
    my %tmp_elem;
    if ($tmp_bytes =~ /^\s*(\d+)\-\s*(\d+)$/)
    {
        @tmp_elem{'first_byte', 'last_byte'} = ($1, $2);
    }
    elsif ($tmp_bytes =~ /^\s*(\d+)$/)
    {
        @tmp_elem{'first_byte', 'last_byte'} = ($1, $1);
    }
    $tmp_elem{'length'} = $tmp_elem{'last_byte'} - $tmp_elem{'first_byte'} + 1;
    #print Dumper (\%tmp_elem);die;
    push @bytes, \%tmp_elem;
}
#print Dumper (@bytes);die;

our $db = get_connect ($dbhost, $dbuser, $dbpass, $dbname);
#if ( ! $db) {
#    print STDERR "Connection failed\n";
#    exit -1;
#}

my $db_fields = get_gcvs_fields ();
my @pattern = map { '?' } @$db_fields;
#print Dumper (@pattern);die;
my $sql = 'INSERT INTO gcvs (' . join (', ', @$db_fields) . ') VALUES (' . join (', ', @pattern) . ');';
#print "$sql\n";die;
my $sth = $db->prepare ($sql);

open my $F, '<:gzip', $FindBin::Bin . '/gcvs_cat.dat.gz' or die "open() error: $!\n";


while (my $line = <$F>)
{
    my @item = ('DEFAULT');
    print $line unless $quiet;
    chomp $line;
    #print;die;
    for (@bytes)
    {
        #print Dumper ($_);die;
        push @item, substr ($line, $_->{'first_byte'} - 1, $_->{'length'});
    }
    #print Dumper (@item);
    $sth->execute (@item);
    #die;
}
close $F;
1;

sub get_connect
{
    my ($host, $user, $pass, $dbname) = @_;
    my $db = DBI->connect ('DBI:mysql:' . $dbname, $user, $pass, {'RaiseError' => 0});
    if (!$db and DBI->err) {
        print STDERR "Connection failed: ", DBI->errstr, "\n";
        exit -1;
    }
    return $db;
}

# извлечем из таблицы список полей
sub get_gcvs_fields
{
    my $res = $db->selectcol_arrayref (q/SELECT column_name FROM information_schema.columns WHERE table_name = 'gcvs' ORDER BY ordinal_position/);
    if ($db->err) {
        print STDERR 'Error: get_gcvs_fields(): ' . $db->errstr, "\n";
        exit -1;
    }
    return $res;
}

sub usage
{
    print STDOUT qq/
Usage: $0 [[--dbhost=db.myserver.org] --dbuser=username [--dbpasswd] --dbname=databasename [--quiet]]
    --dbhost Database host (default - localhost)
    --dbuser Username for database (required option)
    --dbpass Database password will be prompted (default - empty password)
    --dbname Database name (required option)
    --quiet  Do not print anything (quiet mode)
/;
    exit 0;
}
