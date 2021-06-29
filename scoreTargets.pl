#!/local/bin/perl 


##############################################################################
# Syntax  : perl scoreTargets.pl -i input from targetScan -o out 
#
# 
###############################################################################

use Getopt::Std;

%nmerCounts = ();

getopt ('io');

open (FD_IN, "$opt_i") || die "Error opening $opt_i";

open(FD_OUT, ">$opt_o") || die("could not write new file");

while($line = <FD_IN>) 
{
	chomp $line;
    if ($line =~ /^a_Gene_ID/) {next;}
    
	
	@w = split (/\t/, $line);
    if ($w[8] eq "8mer-1a")
    {
        $nmerCounts{"$w[0];$w[1]"}[0]++;
    }
    
    if ($w[8] eq "7mer-m8")
    {
        $nmerCounts{"$w[0];$w[1]"}[1]++;
    }
	
    if ($w[8] eq "7mer-1a")
    {
        $nmerCounts{"$w[0];$w[1]"}[2]++;
    }
    
    if ($w[8] eq "6mer")
    {
        $nmerCounts{"$w[0];$w[1]"}[3]++;
    }
}
close(FD_IN);

print FD_OUT "lncRNA\tmiRNA\t8mer-1a\t7mer-m8\t7mer-1a\t6mer\tscore\n";
foreach $key (sort {$a cmp $b} keys %nmerCounts)
{
    $score = $nmerCounts{$key}[0]*0.43 + $nmerCounts{$key}[1]*0.25 + $nmerCounts{$key}[2]*0.19 + $nmerCounts{$key}[3]*0.07;
	if ($score < 1) {next;}
    
    @w = split (/;/, $key);
	
	
	$ID = $w[0]; 
	
	
    print FD_OUT "$ID\t$w[1]\t$nmerCounts{$key}[0]\t$nmerCounts{$key}[1]\t$nmerCounts{$key}[2]\t$nmerCounts{$key}[3]\t$score\n";
}