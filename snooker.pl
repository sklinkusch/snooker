#!/usr/bin/perl -w

use strict;
use warnings;
no warnings 'experimental';
use diagnostics;
use Scalar::Util qw(looks_like_number);

if($#ARGV != 9) {
	print "Usage: ./snooker.pl scoreA scoreB next red yellow green brown blue pink black\n";
	print "next: r/R for red ball or c/C for color\n";
	exit;
}

my $PlayerA = join("", $ARGV[0]);
my $PlayerB = join("", $ARGV[1]);
my $next = lc(join("", $ARGV[2]));
if (!$next ~~ ["r", "c"]) {
	print "Argument must be either r/R for red ball or c/C for color\n";
	exit;
}

my @colors = ("yellow", "green", "brown", "blue", "pink", "black");
my %balls = (
	"red" => join("", $ARGV[3]),
	"yellow" => join("", $ARGV[4]),
	"green" => join("", $ARGV[5]),
	"brown" => join("", $ARGV[6]),
	"blue" => join("", $ARGV[7]),
	"pink" => join("", $ARGV[8]),
	"black" => join("", $ARGV[9])
);
my %minimum;
my %maximum;
my @keys = keys %balls;

foreach my $zz (0..$#keys) {
	$minimum{$keys[$zz]} = 0;
	$maximum{$keys[$zz]} = $keys[$zz] eq "red" ? 15 : 1;
}
my %points = (
	"red" => 1,
	"yellow" => 2,
	"green" => 3,
	"brown" => 4,
	"blue" => 5,
	"pink" => 6,
	"black" => 7
);
foreach my $zy (0..$#keys) {
	if(!looks_like_number($balls{$keys[$zy]})) {
		print "Arguments must be numeric\n";
		exit;
	}
	if($balls{$keys[$zy]} < $minimum{$keys[$zy]} or $balls{$keys[$zy]} > $maximum{$keys[$zy]}) {
		print "Wrong number of balls\n";
		exit;
	}
}

my $lead = getLead($PlayerA, $PlayerB);
my $remaining = getRemaining($balls{red}, $balls{yellow}, $balls{green}, $balls{brown}, $balls{blue}, $balls{pink}, $balls{black});
my $aExtra = 0;
my $currentLead;
my $currentRemaining;
my $ifsnooker;

print "PlayerA  PlayerB  Lead  Rem. Sn. Col.\n";
$ifsnooker = getSnooker($lead, $remaining);
printResult($PlayerA, $PlayerB, $lead, $remaining, $ifsnooker, " ");

if ($next eq "c") {
	$aExtra += 7;
	$currentLead = getLead($PlayerA+$aExtra,$PlayerB);
	$currentRemaining = getRemaining($balls{red}, $balls{yellow}, $balls{green}, $balls{brown}, $balls{blue}, $balls{pink}, $balls{black});
	$ifsnooker = getSnooker($currentLead, $currentRemaining);
	printResult($PlayerA+$aExtra, $PlayerB, $currentLead, $currentRemaining, $ifsnooker, "black");
}

if ($balls{red} > 0) {
	foreach my $x (1..$balls{red}) {
		$aExtra++;
		$currentLead = getLead($PlayerA+$aExtra, $PlayerB);
		$currentRemaining = getRemaining($balls{red}-$x, $balls{yellow}, $balls{green}, $balls{brown}, $balls{blue}, $balls{pink}, $balls{black});
		$ifsnooker = getSnooker($currentLead, $currentRemaining);
		printResult($PlayerA+$aExtra, $PlayerB, $currentLead, $currentRemaining, $ifsnooker, "red");
		$aExtra += 7;
		$currentLead = getLead($PlayerA+$aExtra, $PlayerB);
		$ifsnooker = getSnooker($currentLead, $currentRemaining);
		printResult($PlayerA+$aExtra, $PlayerB, $currentLead, $currentRemaining, $ifsnooker, "black");
	}
}

foreach my $y (0..$#colors){
	if($balls{$colors[$y]} == 1){
		$aExtra += $points{$colors[$y]};
		$balls{$colors[$y]} = 0;
		$currentLead = getLead($PlayerA+$aExtra, $PlayerB);
		$currentRemaining = getRemaining(0, $balls{yellow}, $balls{green}, $balls{brown}, $balls{blue}, $balls{pink}, $balls{black});
		$ifsnooker = getSnooker($currentLead, $currentRemaining);
		printResult($PlayerA+$aExtra, $PlayerB, $currentLead, $currentRemaining, $ifsnooker, $colors[$y]);
	} else {
		next;
	}
}


sub getLead {
	my ($aPoints, $bPoints) = @_;
	return ($aPoints - $bPoints);
}


sub getRemaining {
	my ($red, $yellow, $green, $brown, $blue, $pink, $black) = @_;
	my $res = ($red * ($points{red} + $points{black}));
	$res += $yellow * $points{yellow};
	$res += $green * $points{green};
	$res += $brown * $points{brown};
	$res += $blue * $points{blue};
	$res += $pink * $points{pink};
	$res += $black * $points{black};
	return $res;
}

sub getSnooker {
	my ($ld, $rm) = @_;
	my $res;
	my $diff = $ld - $rm;
	if($diff > 0){
		$res = "S";
	} elsif($diff == 0){
		$res = "B";
	} else {
		$res = " ";
	}
	return $res;
}

sub printResult {
	my ($A, $B, $ld, $rm, $sn, $col) = @_;
	printf "    %3i      %3i  %+4i  %3i  %s   %s\n", $A, $B, $ld, $rm, $sn, $col;
}
