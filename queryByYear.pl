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
my $year = $q->param('year');

my $sth = $dbh->prepare("SELECT Title, Year, Score, Votes FROM Movie WHERE Year=?");
$sth->execute($year);

my @titles;
my @years;
my @scores;
my @votes;
while(my @row = $sth->fetchrow_array) {
  print STDERR "registro: @row\n";
  my $title = $row[0];
  my $anio = $row[1];
  my $score = $row[2];
  my $votes = $row[3];
  push(@titles, $title);
  push(@years, $anio);
  push(@scores, $score);
  push(@votes, $votes);
}
print STDERR "Titulos: @titles\n";
print STDERR "Años:  @years\n";
print STDERR "Puntajes: @scores\n";
print STDERR "Votos: @votes\n";

$sth->finish;
$dbh->disconnect;

print $q->header('text/html;charset=UTF-8');

#my $body = renderTable($year, @resp);

#print renderHTMLpage("Películas de $year", 'css/mystyle.css', $body);

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
  my $year = $_[0];
  my @table  = @_;
  shift(@table);

  my $body = "<h1 class='titulo'>Películas de $year</h1>\n<table>\n";
  $body .= "<tr><th>Titles</th></tr>\n";
  foreach my $reg (@table) {
    $body .= "<tr><td>$reg</td></tr>\n";
  }
  return $body."</table>\n";
}
