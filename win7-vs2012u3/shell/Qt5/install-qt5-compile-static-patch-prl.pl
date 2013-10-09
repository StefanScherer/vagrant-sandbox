#!/usr/bin/perl
# patches *.prl files in Qt5 static build after installation
use strict;
use File::Find;

my @prlFiles;

main();

sub main
    {
    my $QtDir = $ARGV[0];
    my $platform = $ARGV[1];

    print "Patching all *.prl files in $QtDir:  Src\\\\qtbase\\\\lib -> $platform\\\\lib\n";

    findPrlFiles($QtDir);

    patchPrlFiles($QtDir, $platform, \@prlFiles);
    }

sub wanted
    {
    if ($File::Find::name =~ /\.prl$/i)
        {
        push @prlFiles, $File::Find::name;
        } 
    }

sub findPrlFiles
    {
    my ($QtDir) = @_;
    find(\&wanted, "$QtDir\\lib");
    find(\&wanted, "$QtDir\\plugins");
    }

sub patchPrlFiles
    {
    my ($QtDir, $platform, $prlFiles) = @_;
    foreach (@$prlFiles)
        {
        patchFile($_, "Src\\\\qtbase\\\\lib", "$platform\\\\lib");
        }
    }

sub patchFile
    {
    my ($fileName, $searchstring, $replacement) = @_;

    my $patched = 0;


    open my $file, "<$fileName" or return -1;
    my @inputLines = (<$file>);
    close $file;

    my @outputLines;
    foreach (@inputLines)
        {
        my $inputLine = $_;
        my $outputLine = $inputLine;
        $outputLine =~ s/\Q$searchstring\E/$replacement/g;
        if ($outputLine ne $inputLine)
            {
            unless ($patched)
                {
                print "Patching file $fileName\n";
                }
            $patched = 1;
            }
        push @outputLines, $outputLine;
        }

    open $file, ">$fileName" or return -2;
    print $file @outputLines;
    close $file;
    }


