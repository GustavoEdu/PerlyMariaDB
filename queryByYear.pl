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

my $table = renderTable(@titles, @years, @scores, @votes);
my $body = renderBody("Resultados de la Consulta", $table);

print renderHTMLpage("Películas de $year", 'css/mystyle.css', $body);

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
  my @data = @_;
  my @titles;
  my @years;
  my @scores;
  my @votes;

  #Repartimos @data en @titles, @years, @scores y @votes
  my $longitud = scalar(@data)/4;
  for(my $i = 0; $i < $longitud; $i++) {
    push(@titles, shift(@data));
  }
  for(my $i = 0; $i < $longitud; $i++) {
    push(@years, shift(@data));
  }
  for(my $i = 0; $i < $longitud; $i++) {
    push(@scores, shift(@data));
  }
  for(my $i = 0; $i < $longitud; $i++) {
    push(@votes, shift(@data));
  }

  #Se comienza a construir la Tabla
  my $table = "<table>\n";
  $table .= "<tr><th>Películas Encontradas</th>\n";
  $table .= "<th>Year</th>\n";
  $table .= "<th>Score</th>\n";
  $table .= "<th>Votes</th></tr>\n";

  for(my $i = 0; $i < $longitud; $i++) {
    $table .= "<tr><td>$titles[$i]</td>\n";
    $table .= "<td>$years[$i]</td>\n";
    $table .= "<td>$scores[$i]</td>\n";
    $table .= "<td>$votes[$i]</td></tr>\n";
  }

  return $table."</table>\n";
}

sub renderBody {
  my $titulo = $_[0];
  my $table = $_[1];

  my $body = <<"BODY";
  <h1 class='titulo'>$titulo</h1>
$table
  <br>
  Ingrese <a href="Ejercicio4.pl">aquí</a> para realizar otra consulta.
BODY
  return $body;
}

