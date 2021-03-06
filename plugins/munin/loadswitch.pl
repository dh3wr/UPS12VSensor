#!/usr/bin/perl -w
# Munin Plugin for 12 V UPS made by RWTH Ham Radio Group
# Project Repository https://github.com/dh3wr/UPS12VSensor

# Author: Ralf Wilke DH3WR rwth-afu@online.de
# Last change: 5.7.2016


use IO::Socket::INET;

my $server_host = "localhost";
my $server_port = "50033";

if ($ARGV[0] and $ARGV[0] eq "config") {
	print "graph_title Voltage and Current on 12 V UPS\n";
	print "graph_args --base 1000 --lower-limit 0\n";
	print "graph_vlabel Value in Volt or Ampere\n";
	print "graph_category ups\n";
	print "graph_info This graph shows the voltage and current on the 12 V UPS board.\n";
	print "UBat.label Voltage Bat in Volts\n";
	print "UBat.type GAUGE\n";
	print "UNT.label Voltage Power Supply in Volts\n";
	print "UNT.type GAUGE\n";
	print "IBat.label Current Bat in Amperes\n";
	print "IBat.type GAUGE\n";
	print "INT.label Current Power Supply in Amperes\n";
	print "INT.type GAUGE\n";
	exit 0;
} else {

	# Open ServerPort
	# flush after every write
	$| = 1;

	my $socket;

	# creating object interface of IO::Socket::INET modules which internally creates 
	# socket, binds and connects to the TCP server running on the specific port.
	$socket = new IO::Socket::INET (
	PeerHost => $server_host,
	PeerPort => $server_port,
	Proto => 'tcp',
	) or die "ERROR in Socket Creation : $!\n";

#	print "TCP Connection Success.\n";

	# read the socket data sent by server.
	$data = <$socket>;

#	print "Received from Server : $data\n";
	
	# Extract data separated by ";"
	my ($ubat,$ibat,$unt,$int) = split /;/, $data;

	# Give out on STDOUT in format
	#  UBat.value 12.234
	#  IBat.value 1.234
	#  UNT.value 12.234
	#  INT.value 1.234

	print "UBat.value $ubat\n";
	print "IBat.value $ibat\n";
	print "UNT.value $unt\n";
	print "INT.value $int\n";
	exit 0;
}
