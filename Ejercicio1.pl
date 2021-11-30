#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.11";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

#Consultas al SGBD
my $id = 5;

my $sth = $dbh->prepare("SELECT Name FROM Actor WHERE ActorId=?");
$sth->execute($id);

my $resp;
if(my @row = $sth->fetchrow_array) {
  print STDERR "@row\n";
} else {
  print "No hay un Actor con el ID $id!\n"; #Vacío!
}

$sth->finish;
$dbh->disconnect;

print $q->header('text/html;charset=UTF-8');

