#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header('text/html;charset=UTF-8');

my $titulo = "Perl y MariaDB: Consulta de Películas";
my $body = renderBody($titulo);

print renderHTMLpage('Consulta de Películas', 'css/mystyle.css', $body);

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

sub renderBody {
  my $titulo = $_[0];

  my $body = <<"BODY";
    <h1 class='titulo'>$titulo</h1>
    <div class='centrar'>
      <form action='queryByYear.pl' method=POST>
        <label for='year'>Año:</label>
        <input type='number' name='year' min='1895' max='3600' required>
        <input type='submit' value='Ver Resultados'>
      </form>
    </div>
BODY
  return $body;
}
