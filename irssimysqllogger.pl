use DBI;
use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
        authors     => "Mikael 'Elderx' Peltomaa",
        contact     => "elderx\@elderx.fi",
        name        => "mysqlurllogger",
        description => "logs everything from irssi to MySQL database",
        license     => "MIT",
        url         => "http://elderx.fi",
    );

$dsn = 'DBI:mysql:KANNAN_NIMI:DATABASE_HOST';
$db_user_name = 'USERNAME';
$db_password = 'PASSWORD';

my $dbh = DBI->connect($dsn, $db_user_name, $db_password);

sub cmd_logline {
        my ($server, $data, $nick, $mask, $target) = @_;
        $d = $data;
        if (($d =~ /.*/) or ($d =~ /(www\..+)/)) {
                db_insert($nick, $target, $1);
        }
        return 1;
}

sub cmd_own {
        my ($server, $data, $target) = @_;
        return cmd_logline($server, $data, $server->{nick}, "", $target);
}
sub cmd_topic {
        my ($server, $target, $data, $nick, $mask) = @_;
        return cmd_logline($server, $data, $nick, $mask, $target);
}

sub db_insert {
        my ($nick, $target, $line)=@_;
        unless ($dbh->ping) {
                $dbh = DBI->connect($dsn, $db_user_name, $db_password);
                Irssi::print("Connected again");
        }
        my $sql="insert into links (insertime, nick, target,line) values (NOW()".",". $dbh->quote($nick) ."," . $dbh->quote($target) ."," . $dbh->quote($d) .")";
        my $sth = $dbh->do($sql);
        }

Irssi::signal_add_last('message public', 'cmd_logline');
Irssi::signal_add_last('message own_public', 'cmd_own');
Irssi::signal_add_last('message topic', 'cmd_topic');

Irssi::print("Irssi MySQL logger loaded.");
