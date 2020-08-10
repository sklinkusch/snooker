#!/usr/bin/perl -w

use strict;
use warnings;
use diagnostics;
use Scalar::Util qw(looks_like_number);

if($#ARGV != 8) {
	print "Usage: ./snooker.pl scoreA scoreB red yellow green brown blue pink black\n";
	exit;
}

my $PlayerA = join("", $ARGV[0]);
my $PlayerB = join("", $ARGV[1]);

my @colors = ("yellow", "green", "brown", "blue", "pink", "black");
my %balls = (
	"red" => join("", $ARGV[2]),
	"yellow" => join("", $ARGV[3]),
	"green" => join("", $ARGV[4]),
	"brown" => join("", $ARGV[5]),
	"blue" => join("", $ARGV[6]),
	"pink" => join("", $ARGV[7]),
	"black" => join("", $ARGV[8])
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

print "PlayerA  PlayerB  Lead  Rem. Sn. Col.\n";
printf "    %3i      %3i  %+4i  %3i\n", $PlayerA, $PlayerB, $lead, $remaining;

if ($balls{red} > 0) {
	foreach my $x (1..$balls{red}) {
		$aExtra++;
		my $currentLead = getLead($PlayerA+$aExtra, $PlayerB);
		my $currentRemaining = getRemaining($balls{red}-$x, $balls{yellow}, $balls{green}, $balls{brown}, $balls{blue}, $balls{pink}, $balls{black});
		my $ifsnooker = $currentLead > $currentRemaining ? "S" : " ";
		printf "    %3i      %3i  %+4i  %3i  %s   %s\n", $PlayerA+$aExtra, $PlayerB, $currentLead, $currentRemaining, $ifsnooker, "red";
		$aExtra += 7;
		$currentLead = getLead($PlayerA+$aExtra, $PlayerB);
		$ifsnooker = $currentLead > $currentRemaining ? "S" : " ";
		printf "    %3i      %3i  %+4i  %3i  %s   %s\n", $PlayerA+$aExtra, $PlayerB, $currentLead, $currentRemaining, $ifsnooker, "black";
	}
}

foreach my $y (0..$#colors){
	if($balls{$colors[$y]} == 1){
		$aExtra += $points{$colors[$y]};
		$balls{$colors[$y]} = 0;
		my $currentLead = getLead($PlayerA+$aExtra, $PlayerB);
		my $currentRemaining = getRemaining(0, $balls{yellow}, $balls{green}, $balls{brown}, $balls{blue}, $balls{pink}, $balls{black});
		my $ifsnooker = $currentLead > $currentRemaining ? "S" : " ";
		printf "    %3i      %3i  %+4i  %3i  %s   %s\n", $PlayerA+$aExtra, $PlayerB, $currentLead, $currentRemaining, $ifsnooker, $colors[$y];
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
