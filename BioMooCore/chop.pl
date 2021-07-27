#!//opt/perl5/bin/perl

$tFile = "begin.tmp";
open(tOut, ">>$tFile");

while (<>) {
    if (/^\>\@dump/) {
        close(tOut);
        @tLine = split(' ');
	$tLine[1] =~ s/#//;
	$tFile = "core$tLine[1].moo";
        open(tOut, ">>$tFile");
        print "Creating: ", $tFile, "\n";
	print tOut "\$Header\$\n\n";
    }

    print tOut;
}

close(tOut);
