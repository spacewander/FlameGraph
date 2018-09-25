#!/usr/bin/perl -w
#
# stackcolllapse-simple.pl	collapse multiline stack
#				into single lines without any additional modification.
#
# USAGE: ./stackcollapse-simple.pl infile > outfile
#
# Example input:
#
#  native_safe_halt
#  default_idle
#  cpu_idle
#  rest_init
#  start_kernel
#	2404
#
# Example output:
#
#  start_kernel;rest_init;cpu_idle;default_idle;native_safe_halt 2404
#

use strict;

my %collapsed;

sub remember_stack {
	my ($stack, $count) = @_;
	$collapsed{$stack} += $count;
}

my @stack;

foreach (<>) {
	chomp;

	if (m/^\s*(\d+)+$/) {
		remember_stack(join(";", @stack), $1);
		@stack = ();
		next;
	}

	next if (m/^\s*$/);

	my $frame = $_;
	$frame =~ s/^\s*//;
	$frame =~ s/\s*$//;
	$frame = "-" if $frame eq "";
	unshift @stack, $frame;
}

foreach my $k (sort { $a cmp $b } keys %collapsed) {
	printf "$k $collapsed{$k}\n";
}
