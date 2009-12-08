#!/usr/bin/perl
#
# Investigate and report information on all figures used in the 
# technical architecture
#
# Jens Stavnstrup/DDRE <js@ddre.dk> - Sep 1, 2002
# Updated Sep 15, 2004 - Added Vol 2 supl 1 and 2
# Updated Nov 17, 2005 - Added IHB
# Copyright (C) 2002, 2004 DDRE.

use XML::Parser;
use Data::Dumper;

# Root of the NC3TA source distribution
my $source_root = '/home/js/work/noswg/xml-nc3ta/tools/src';


die "The directory $source_root does not exists"
  unless 1;


@eSstack = (); # keep track of all parents

$figname = '';
$figtitle = '';

my $docBook_start = <<'End_of_DocBookStart;';
<?xml version="1.0"?>

<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
                      "../src/schema/dtd/docbkx42/docbookx.dtd">
<book>
  <bookinfo>
     <author>
       <firstname>Jens</firstname>
       <surname>Stavnstrup</surname>
     </author>
     <title>Figures in the TA</title>
     <date></date>
  </bookinfo>

  <chapter><title>Introduction</title>
    <para></para>
  </chapter>
End_of_DocBookStart;
 



$pl = new XML::Parser(ParseParamEnt => 'yes');

$pl->setHandlers(Start => \&startDocTag, 
                 End => \&endDocTag,
                 Char => \&charDocTag );        


@voldirs = qw /volume1 volume2 volume3 volume4 volume5 rationale vol2-sup1 vol2-sup2 ihb /;

$vol = 1; $pl->parsefile($source_root . '/volume1/vol1.xml');
$vol = 2; $pl->parsefile($source_root . '/volume2/vol2.xml');
$vol = 3; $pl->parsefile($source_root . '/volume3/vol3.xml');
$vol = 4; $pl->parsefile($source_root . '/volume4/vol4.xml');
$vol = 5; $pl->parsefile($source_root . '/volume5/vol5.xml');
$vol = 6; $pl->parsefile($source_root . '/rationale/rationale.xml');
$vol = 7; $pl->parsefile($source_root . '/vol2-sup1/vol2-sup1.xml');
$vol = 8; $pl->parsefile($source_root . '/vol2-sup2/vol2-sup2.xml');
$vol = 9; $pl->parsefile($source_root . '/ihb/ihb.xml');

undef $pl;

# print Dumper([\%figs]);

$sum = 0;
foreach (sort keys %fcount) { printf STDERR "Volume (%s) cotains %d figures\n", $_, $fcount{$_}; $sum += $fcount{$_}; }

print STDERR "\nTotal of $sum figures\n";


# Process all SVG files for all volumes

# We don't want to parse the SVG DTD

$pl = new XML::Parser;

$pl->setHandlers(Start => \&startSVGTag, 
                 End => \&endSVGTag,
                 Char => \&charSVGTag,
                 Final => \&finalSVG );        

foreach $v (sort keys %figs) {
    print STDERR "\nProcessing figures in Volume $v : \n";

    $figarrref = $figs{$v};

    foreach $href ( @ { $figarrref } ) {
        my $fname = $href->{imgFile};
       
	printf STDERR "Parsing %s\n", $source_root . $fname;

        $svgWidth = 0; $svgHeight = 0; $svgHaveTitle = 0;

        $pl->parsefile($source_root . $fname);

        $href->{svgWidth} = $svgWidth;
        $href->{svgHeigth} = $svgHeight;
        $href->{svgTitle} = $svgTitle || '';

        unless ($svgHaveTitle) {
            push @ {$href->{svgWarn} }, 'noSVGTitle';
        }

    }
}


# ----------------------------------------------------------
# Print DocBook Book
# ----------------------------------------------------------



print "$docBook_start";

foreach $vol (sort keys %fcount ) {
    print "<chapter><title>Volume $vol</title>\n";

    printf "<para>There are currently %d figures in volume %d.</para>", $fcount{$vol}, $vol;
    

    my $garef = $figs{$vol};

    foreach $href (@ { $garef }) {
        
	print "<informalfigure>\n  <mediaobject>\n    <imageobject>\n";
        print ' ' x 6;
        printf "<imagedata align=\"center\" fileref=\"%s\"/>\n", '../build' . $href->{imgFile};
        print "    </imageobject>\n  </mediaobject>\n</informalfigure>\n"; 
    }    

    print "</chapter>\n\n";   

}

print "</book>\n";



# ----------------------------------------------------------
# Handlers for the Technical Architecture documents
# ----------------------------------------------------------

sub startDocTag {
    my ($xp, $el, %att ) = @_;

    push @eStack, $el;

    if ($el eq 'title') {
	my $parent = $eStack[-2];
        if ($parent eq 'figure') {
            $figtitle = '';
        }
    }

    if ($el eq 'imagedata') {
	$figname = $att{'fileref'};
    }

}


sub endDocTag {

    my ($xp, $el) = @_;

    pop @eStack;

    if ($el =~ /^(figure|informalfigure|mediaobject)$/) {

        # We are not interested in the mediaobject if embededed inside a figure or 
        # informal figure object
        
        if ( ($el eq 'mediaobject') && ($eStack[-1] =~ /figure/) ) { 
            # Do nothing
        } else {
            $figtitle =~ s/\n/ /g;
            $figtitle =~ s/^\s+//;
            $figtitle =~ s/\s+$//;
            $figtitle =~ s/  / /g;
	    
            $fcount{$vol}++;
            push @ {$figs{$vol} }, {'imgFile' => '/' .$voldirs[$vol-1] . "/$figname", 
                                    'element' => $el ,
                                    'doctitle' => $figtitle,
                                    'svgWarn' => [] };

            $figtitle = ''; $figname = '';
	}
    }
}

# We only collect data here (The contents of the title element may be in multiple text nodes)

sub charDocTag {
    my ($xp, $text) = @_;

    if ($eStack[-1] eq 'title') {
        if ($eStack[-2] eq 'figure') {
            $figtitle = $figtitle . $text;
        }   
    }
} 


# ----------------------------------------------------------
# Handlers for the SVG documents
# ----------------------------------------------------------




sub startSVGTag {
    my ($xp, $el, %att) = @_;

    push @eStack, $el;

    if ($el eq 'svg') {
	$svgWidth = $att{'width'};
        $svgHeight = $att{'height'};
    }

    if ($el eq 'title') {
	if ($eStack[-2] eq 'svg') {
              $svgTitle = '';
	      $svgHaveTitle = 1;
	  }
    }

    if ($el eq 'g') {

    }

    # the attribute font-family id used in the parametric 
    # % PresentationAttributes-FontSpecificacion. This is directly used in
    # 
    if ($el eq 'text') {


    }
}

sub endSVGTag {
    my ($xp, $el) = @_;
 
    pop @eStack;

    if ($el = 'svg') { 
       $svgTitle =~ s/\n/ /g;
       $svgTitle =~ s/^\s+//;
       $svgTitle =~ s/\s+$//;
       $svgTitle =~ s/  / /g;
    }
}


sub charSVGTag {
    my ($xp, $text) = @_;

    if ($eStack[-1] eq 'title') {
        if ($eStack[-2] eq 'svg') {
            $svgTitle = $svgTitle . $text;
        }   
    }

}



sub finalSVG {
    my $xp = shift;


} 


# ----------------------------------------------------------

# ----------------------------------------------------------

