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
my $score = 7;
my $votes = 5000;

my $sth = $dbh->prepare("SELECT Title FROM Movie WHERE Score>? AND Votes>?");
$sth->execute($score, $votes);

my @resp;
while(my @row = $sth->fetchrow_array) {
  print STDERR "registro: @row\n";
  my $title = $row[0];
  push(@resp, $title);
}

$sth->finish;
$dbh->disconnect;

print $q->header('text/html;charset=UTF-8');

my $body = renderTable(@resp);
print STDERR "@resp\n";

print renderHTMLpage('Películas de 1985', 'css/mystyle.css', $body);

sub renderHTMLpage {
  my $title = $_[0];
  my $css = $_[1];
  my $body = $_[2];

  my $html = <<"HTML";
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>$title</title>
      <link rel="stylesheet" href="$css">
    </head>
    <body>
$body
    </body>
  </html>
HTML
  return $html;
}

sub renderTable {
  my @table  = @_;

  my $body = "<h1 class='titulo'>Películas de 1985</h1>\n<table>\n";
  foreach my $reg (@table) {
    $body .= "<tr><td>$reg</td></tr>\n";
  }
  return $body."</table>\n";
}
