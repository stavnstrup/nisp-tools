#!/usr/bin/perl
#
# Create statistics for used elements
#
# Jens Stavnstrup/DDRE <js@ddre.dk> - Sep 9, 2001
# 
# Updated for TA Version 6 - Nov 16, 2003
# Updated for TA Version 5 - Dec 9, 2003
# Updated for TA Version 4 - Sep 24, 2002
# 
# Copyright (C) 2001, 2002, 2003, 2005 DDRE.

use XML::Parser;

my $root = '/home/js/work/noswg/xml-nc3ta/tools/';

die "The directory $source_root does not exists"
  unless 1;

$pl = new XML::Parser(Style => 'Stream');

# -----------------------------------------
#          Parse documents
# -----------------------------------------

$vol = 1; $pl->parsefile($root . 'build.src/vol1-resolved.xml');
$vol = 2; $pl->parsefile($root . 'build.src/vol2-resolved.xml');
$vol = 7; $pl->parsefile($root . 'build.src/vol2sup1-resolved.xml');
$vol = 8; $pl->parsefile($root . 'build.src/vol2sup2-resolved.xml');
$vol = 3; $pl->parsefile($root . 'build.src/vol3-resolved.xml');
$vol = 4; $pl->parsefile($root . 'build.src/vol4-resolved.xml');
$vol = 5; $pl->parsefile($root . 'build.src/vol5-resolved.xml');
$vol = 6; $pl->parsefile($root . 'build.src/rd-resolved.xml');
$vol = 9; $pl->parsefile($root . 'build.src/ihb-resolved.xml');




# -----------------------------------------
#          Group Elements
# -----------------------------------------

@groups = qw(book nav comp sec meta list block inline graphics tables unknown);

$ginf{'book'}{'head'} = 'Book';
$ginf{'book'}{'elements'} = [qw(book preface)];

$ginf{'nav'}{'head'} = 'Navigation';
$ginf{'nav'}{'elements'} = [qw(index indexterm primary secondary)];


$ginf{'comp'}{'head'} = 'Component';
$ginf{'comp'}{'elements'} = [qw(chapter appendix)];

$ginf{'sec'}{'head'} = 'Section';
$ginf{'sec'}{'elements'} = [qw(sect1 sect2 sect3 sect4 sect5 bridgehead)];

$ginf{'meta'}{'head'} = 'Meta-Information';
$ginf{'meta'}{'elements'} = 
   [qw(author beginpage biblioid bookinfo city country corpauthor 
       date email keyword keywordset postcode productname pubsnumber
       revhistory revision revnumber revremark subtitle title volumenum)];

$ginf{'list'}{'head'} = 'List';
$ginf{'list'}{'elements'} = 
   [qw(itemizedlist orderedlist listitem 
       term variablelist varlistentry)];

$ginf{'block'}{'head'} = 'Block';
$ginf{'block'}{'elements'} = 
   [qw(address para programlisting remark)];

$ginf{'inline'}{'head'} = 'Inline';
$ginf{'inline'}{'elements'} = [qw(citation command emphasis footnote footnoteref 
                               link literal superscript ulink xref)];

$ginf{'graphics'}{'head'} = 'Graphic';
$ginf{'graphics'}{'elements'} = [qw(caption figure imageobject imagedata 
                                 informalfigure 
                                 mediadata mediaobject)];

$ginf{'tables'}{'head'} = 'Table';
$ginf{'tables'}{'elements'} = [qw(colspec entry informaltable row table 
                               tbody tgroup thead)];

@unknown = ();

# ----------------------------------------------------------
#          Build lookup tables
# ----------------------------------------------------------

# An entry of $lookup{'figure'} is 'block';

foreach $gid (@groups) {
    my $garef = $ginf{"$gid"}{'elements'};
    foreach $eid ( @{ $garef } ) {
        $lookup{"$eid"} = "$gid";
    }
} 

# Put all unregistered elements in group unknown

foreach $t (sort keys %tag) {
    unless ($lookup{$t}) {
	push @unknown, $t;
    }
}

pop @groups; # Remove the "unknown" entry from groups

# Print statistics unless unknown elements

if (@unknown) {
    print "Unknown Elements:\n\n";

    foreach (@unknown) { print "$_\n"; }
} else {
    printstat();
}



sub printstat {
    my $now = gmtime(time);

    printf "<!-- Created with estat.pl on %s UCT\nSee the NC3TA tools distribution extra/perl/estat.pl -->\n\n", $now;
    print "<informaltable frame=\"all\">\n<tgroup cols=\"10\">\n";

    print "<colspec align=\"left\" colwidth=\"18*\" colname=\"cFirst\"/>\n";
    print "<colspec align=\"right\" colwidth=\"8*\"/>\n" x 8;
    print "<colspec align=\"right\" colwidth=\"8*\" colname=\"cLast\"/>\n";

    print "<thead>\n<row>\n  <entry>Element</entry>\n";
    h(1); h(2); h(7); h(8); h(3); h(4); h(5); h(6); h(9); 

    print "</row>\n</thead>\n";
    print "<tbody>\n";

    foreach $gid ( @groups ) {
        print "<row>\n";
	printf "  <entry namest=\"cFirst\" nameend=\"cLast\">" .
               "<emphasis>%s Elements</emphasis></entry>\n", 
              $ginf{$gid}{'head'};
        print "</row>\n";

        $garef = $ginf{$gid}{'elements'};
        foreach $t ( @{ $garef }  ) {
            print "<row>\n  <entry><emphasis role=\"bold\">";
            printf "%s</emphasis></entry>\n", $t;

            printf "  <entry>%d</entry>\n", $tag{$t}{1};
            printf "  <entry>%d</entry>\n", $tag{$t}{2};
            printf "  <entry>%d</entry>\n", $tag{$t}{7};
            printf "  <entry>%d</entry>\n", $tag{$t}{8};
            printf "  <entry>%d</entry>\n", $tag{$t}{3};
            printf "  <entry>%d</entry>\n", $tag{$t}{4};
            printf "  <entry>%d</entry>\n", $tag{$t}{5};
            printf "  <entry>%d</entry>\n", $tag{$t}{6};
            printf "  <entry>%d</entry>\n", $tag{$t}{9};

            print "</row>\n"
        }        
    }
    print "</tbody>\n</tgroup>\n</informaltable>\n";

}


sub h {
    ($vol) = @_;

    my @head = ('Vol. 1', 'Vol. 2', 'Vol. 3', 'Vol. 4', 'Vol. 5',
                'Rationale', 'V2 Sup1', 'V2 Sup2', 'IHB');

    printf "<entry>%s</entry>\n", $head[$vol-1];
    return 1;  

    if ($vol == 6) {
        print "  <entry>Rationale</entry>\n";
    } else {
        if ($vol == 7) {
            print "  <entry>V2 Sup1</entry>\n";
        } else {
            if ($vol == 8) {
                print "  <entry>V2 Sup2</entry>\n";
            } else {
                if ($vol == 9) {
                  print "  <entry>IHB</entry>\n";
                } else{
                    print "  <entry>Vol. $vol</entry>\n";
	        }
            }
        }
    }
}


# XML Parser event handlers

sub StartTag {
    my ($class, $elem) = @_;

    $tag{$elem}{$vol}++;
}

sub EndTag {
    my ($class, $elem) = @_;
}

sub Text {
    my ($class, $text) = @_;
}

sub Proc {
    my ($class, $Target, $proc) = @_;
}
