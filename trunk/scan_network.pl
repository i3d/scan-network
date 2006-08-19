#!/usr/bin/perl -w
#===============================================================================
#
#         FILE:  scan_network.pl
#
#        USAGE:  ./scan_network.pl 
#
#  DESCRIPTION:  scan network is a framework tool to dynamically adjust interfaces file 
#                This is the daemon tool for scan_network. Its optional.
#                The scan_network startup script will adjust the network
#                settings as needed on boot time.
#                If you also want to have it running as a daemon
#                to watch the network changes during the up time,
#                enable the setting on /etc/default/scan_network.
#                The goal is to always keep a correct interfaces file.
#
#      OPTIONS:  ---
# REQUIREMENTS:  This is a daemon tool. 
#                The startup script scan_network is 
#                required to invoke this daemon
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:   yongjian xu, <i3dmaster@gmail.com>
#      COMPANY:  
#      VERSION:  0.2
#      CREATED:  08/12/2006 03:38:04 PM MDT
#     REVISION:  1 
#===============================================================================

use strict;
use warnings;
$| = 1;

use FileHandle;

my $runtime = sub {
        my $time = localtime;
        return \$time;
};

my $chkState = sub {
        my $file = shift;
        my $found = 0;
        (open(FH,"<$file")) && do {
                while (<FH>){
                        (!/lo=lo/) && do { $found = 1; last; };
                }; 
                close(FH); 
                return $found;
                } || warn "can't open the $file: $!\n";
};

sub waitState {
        while(1){
                if(!$chkState->($ENV{IFSTATE})){
                        sleep 20;
                } else { last; }
        }
}

my $Log = sub {
        local *FO = shift;
        my $msg = $_[0];
        print FO sprintf("%s\t%s\n", ${&$runtime},$msg);
}

#read($file);
sub read {
        my $file = shift;
        my $fh = new FileHandle;
        open($fh,$file);
        my @contant = $fh->getlines;
        $fh->close;
        return \@contant;
}

my $check = sub {

};

#save(@contant,$file);
sub save {
       my $output = shift;
       my $file = $_[0];
       my $fh = new FileHandle;
       open($fh,">$file");
       print $fh "@$output\n";  
       $fh->close;
}
