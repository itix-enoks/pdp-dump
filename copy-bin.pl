#!/usr/bin/env perl
use strict;
use warnings;

my $home = '/data/home/cese4040-08/pdp-project-08/';
my $dump = '/data/home/cese4040-08/pdp-dump/';
my $overlays = $dump . 'overlays/';

sub run {
    system(@_) == 0
        or die "Command failed (@_): $?";
}

run('mkdir', '-p', $dump);
run('mkdir', '-p', $overlays);

# Add memory files generated with C
run('cp', '-r',
    $home . 'hardware/src/sw/mem_files',
    $dump);

# Add bitstream and related files generated in Vivado
my $impl = $home . 'hardware/vivado/riscy/riscy.runs/impl_1/';
run('cp', $impl . 'riscv_wrapper.bit', $overlays . 'base_riscy.bit');
run('cp', $impl . 'riscv_wrapper.tcl', $overlays . 'base_riscy.tcl');

my $hwh = $home . 'hardware/vivado/riscy/riscy.gen/sources_1/bd/riscv/hw_handoff/riscv.hwh';
run('cp', $hwh, $overlays . 'base_riscy.hwh');

# Change to pdp-dump and push to repo
chdir($dump) or die "Cannot chdir to $dump: $!";
run('git', 'add', '.');
run('git', 'commit', '-m', 'New binaries');
run('git', 'push', '--force');

