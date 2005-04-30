#!/usr/bin/perl
#
# ical2tex.pl
# konvertiert 21C3-Ical-Fahrplan in ein ConTeXt-File
# (c) Alexander Klink (21c3@alech.de)
# GPL v2 or later (at your option)
# $Id: ical2tex.pl,v 1.4 2004/12/25 21:29:36 klink Exp alech $

sub dumpdata() {
    if ($uid ne '') {
#        print STDERR "$uid: Tag $day, H $hour, M $minute, Dauer: $duration, Ort: $location\ntitle: $title\nsubtitle: $subtitle\nspeaker: $speaker\n$shortdesc\n\n";
	$layer++;
	if ($subtitle ne '') {
	    $subtitle = "-- $subtitle";
	}
	if ($speaker ne '') {
	    $speaker = "($speaker)";
	}
	$height = $duration * 2;
	$height .= "cm";
	$xpos = .85 + ($location-1)*3.5;
	$xpos .= "cm";
	
	if (($day == 1) || (($day == 2) && $hm <= 3)) { # DAY 1
		# compute coordinates
		if (($day == 1)	&& ($hm < 18)) {
		    $ypos = 3 + ($hm-10)*2;
		    $ypos .= "cm";
		    if ($day1list1 ne '') {
			$day1list1 .= ",$layer";
		    }
		    else {
			$day1list1 = "$layer";
		    }
		}
		elsif (($day == 1) && ($hm >= 18) || ($day == 2) && ($hm <= 3)) { # day 1 page 2
		    if ($day == 1) {
			$ypos = 1 + ($hm-18)*2;
		    }
		    else {
			$ypos = $hm*2 + 13;
		    }
		    $ypos .= "cm";
		    if ($day1list2 ne '') {
			$day1list2 .= ",$layer";
		    }
		    else {
			$day1list2 = "$layer";
		    }
    
		}
		print DAYONE "\\definelayer[$layer]\n\\setlayer[$layer][preset=lefttop,x=$xpos,y=$ypos]{%\n\\framed[height=$height]{%\n$uid: {\\bf{}$title} $subtitle {\\it{}$speaker} \$\\cdot\$ $shortdesc%\n}}\n";
        }
        if (($day == 2) || (($day == 3) && $hm <= 3)) { # DAY 2
		# compute coordinates
		if (($day == 2)	&& ($hm < 18)) {
		    $ypos = 3 + ($hm-10)*2;
		    $ypos .= "cm";
		    if ($day2list1 ne '') {
			$day2list1 .= ",$layer";
		    }
		    else {
			$day2list1 = "$layer";
		    }
		}
		elsif (($day == 2) && ($hm >= 18) || ($day == 3) && ($hm <= 3)) { # day 2 page 2
		    if ($day == 2) {
			$ypos = 1 + ($hm-18)*2;
		    }
		    else {
			$ypos = $hm*2 + 13;
		    }
		    $ypos .= "cm";
		    if ($day2list2 ne '') {
			$day2list2 .= ",$layer";
		    }
		    else {
			$day2list2 = "$layer";
		    }
    
		}
		print DAYTWO "\\definelayer[$layer]\n\\setlayer[$layer][preset=lefttop,x=$xpos,y=$ypos]{%\n\\framed[height=$height]{%\n$uid: {\\bf{}$title} $subtitle {\\it{}$speaker} \$\\cdot\$ $shortdesc%\n}}\n";
	    }
            if ($day == 3) { # DAY 3
		# compute coordinates
		if (($day == 3)	&& ($hm < 18)) {
		    $ypos = 3 + ($hm-10)*2;
		    $ypos .= "cm";
		    if ($day3list1 ne '') {
			$day3list1 .= ",$layer";
		    }
		    else {
			$day3list1 = "$layer";
		    }
		}
		elsif (($day == 3) && ($hm >= 18)) { # day 3 page 2
		    $ypos = 1 + ($hm-18)*2;
		    $ypos .= "cm";
		    if ($day3list2 ne '') {
			$day3list2 .= ",$layer";
		    }
		    else {
			$day3list2 = "$layer";
		    }
    
		}
		print DAYTHREE "\\definelayer[$layer]\n\\setlayer[$layer][preset=lefttop,x=$xpos,y=$ypos]{%\n\\framed[height=$height]{%\n$uid: {\\bf{}$title} $subtitle {\\it{}$speaker} \$\\cdot\$ $shortdesc%\n}}\n";
	    }
	$uid = "";
	$day = "";
	$hour = "";
	$minute = "";
	$duration = "";
	$location = "";
	$title = "";
	$subtitle = "";
	$speaker = "";
	$description = "";
    }
}


open(FAHRPLAN, "<:utf8", "fahrplan.ics");
open(DAYONE, ">day1data.tex");
open(DAYTWO, ">day2data.tex");
open(DAYTHREE, ">day3data.tex");
while (<FAHRPLAN>) {
    chomp;
    
    if (/^X-WR-CALDESC;VALUE=TEXT/) {
	/X-WR-CALDESC;VALUE=TEXT:21C3 Fahrplan Release (.*)/;
	$version = $1;
    }
    if (/^END:VEVENT/) { # neuer event, altes Zeug ausgeben
	dumpdata(); # hier auch Variablen leeren
    }
    elsif (/^UID/) {
	/UID:([0-9]*)\@21C3\@pentabarf.org/;
	$uid = $1;
    }
    elsif (/^DTSTART/) { # nimmt mal an, dass die Sekunde immer auf 0 gesetzt ist
	/DTSTART;TZID=Europe\/Berlin:2004122([7-9])T([0-9]{2})([0-9]{2})00/;
	$day = $1 - 6;
	$hour = $2;
	$minute = $3;
	$hm = $hour + $minute/60;
    }
    elsif (/^DURATION/) {
	if (/H/) { # longer or equal 1h
	    /DURATION:PT([0-9])H([0-9]{0,2})M*/;
	    $duration = $1 + $2/60;
	}
	else {
	    /DURATION:PT([0-9]{2})M/;
	    $duration = $1/60;
	}
    }
    elsif (/^DESCRIPTION/) {
	/DESCRIPTION:(.*)/;
	$desc = $1;
	
	$more = 1;
	while ($more) {
	    $line = <FAHRPLAN>;
	    chomp($line);
	    if ($line =~ /^ /) { # more description lines
		$line =~ /^ (.*)/;
		$desc .= $1;
	    }
	    else { # stop
		$more = 0;
	    }
	}
	$desc =~ /(.*?)\\n(.*?)\\n\\n(.*)/;
	$title = $1;
	$subtitle = $2;
	$rest = $3;
	if ($subtitle =~ /^\\n/) {
	    $subtitle =~ /^\\n(.*)/;
	    $subtitle = "";
	    $speaker = $1;
	    $description = $rest;
	}
	else {
	    $rest =~ /(.*?)\\n\\n(.*)/;
	    $speaker = $1;
	    $description = $2;
	}
	# CLEAN ME UP
	# lots of things done twice or more times
	# lots of ugly workarounds :-(
	$title =~ s/\\,/,/g;
	$title =~ s/(\w)-(\w)/$1\|\|$2/g; # Bindestriche in || umwandeln
	$title =~ s/\$/\\\$/g;
	$title =~ s/\^/\\char94{}/g; # not particularly portable
	$title =~ s/\&/\\\&/g;
	$title =~ s/\"/\\char34{}/g; # see above
	$title =~ s/\�\�/�/g; # actually bugs in input of uid 99
	$title =~ s/\�\�/�/g;
	$title =~ s/Gro�projekten/Gro�\\-pro\\-jek\\-ten/g;
	$title =~ s/John DeKron:videokonferenz/John DeKron : videokonferenz/; # 298	
	$speaker =~ s/\\,/,/g;
	$speaker =~ s/(\w)-(\w)/$1\|\|$2/g; # Bindestriche in || umwandeln
	$speaker =~ s/\$/\\\$/g;
	$speaker =~ s/\^/\\char94{}/g; # not particularly portable
	$speaker =~ s/\&/\\\&/g;
	$speaker =~ s/\"/\\char34{}/g; # see above
	if ($speaker =~ /Marko Magli/) { # 310
	    $speaker = "Marko Magli\\'{c}";
	}
	
	$subtitle =~ s/\\,/,/g;
	$subtitle =~ s/(\w)-(\w)/$1\|\|$2/g; # Bindestriche in || umwandeln
	$subtitle =~ s/\$/\\\$/g;
	$subtitle =~ s/\^/\\char94{}/g; # not particularly portable
	$subtitle =~ s/\&/\\\&/g;
	$subtitle =~ s/\"/\\char34{}/g; # see above
	$subtitle =~ s/\�\�/�/g; # actually bugs in input of uid 99, 211
	$subtitle =~ s/\�\�/�/g;
	
	$subtitle =~ s/headache continues.*/headache continues.../g; # 77
	
	$description =~ s/\|/\\type{\|}/g; 
	$description =~ s/\\,/,/g;
	$description =~ s/(\w)-(\w)/$1\|\|$2/; # Bindestriche in || umwandeln
	$description =~ s/\\n/ /g;
	$description =~ s/\$/\\\$/g;
	$description =~ s/\^/\\char94{}/g; # not particularly portable
	$description =~ s/\&/\\\&/g;
	$description =~ s/\"/\\char34{}/g; # see above
	$description =~ s/\�\�/�/g; # actually bugs in input of uid 99
	$description =~ s/\�\�/�/g;
	$description =~ s/\�\�/�/g;
	$description =~ s/_/\\_/g;
	$description =~ s/\[/\\type{\[}/g;
	$description =~ s/\]/\\type{\]}/g;
	$description =~ s/to permit what can.*t be prevented/to permit what can't be prevented/; # 315
	$description =~ s/€/\\char001{}/g; # 274 
	$description =~ s/Joux and Wang.*s multicollision attack/Joux and Wang's multicollision attack/; # 308
	$description =~ s/the European Directive .*on the Enforcement of Intellectual Property Rights.* is to/the European Directive \\char34{}on the Enforcement of Intellectual Property Rights\\char34{} is to/; # 122

	# shorten description
	$length = 365*$duration - length($title) - length($subtitle) - length($speaker); # educated guess as how long the text can be
	if ($duration == 0.5) { # kleine Bl�cke sind mit obiger Berechnung zu lang
	    $length = 150 - length($title) - length($subtitle) - length($speaker)
	}
	if ($uid == 278) { # enth�lt viele �s, so dass die Zeilen zu gross sind
	    $length = 320*$duration - length($title) - length($subtitle) - length($speaker);
	}
	$shortdesc = substr($description, 0, $length);
	if ($length < length($description)) {
		$shortdesc =~ s/(.*) .*/$1 \.\.\./;
	}
    }
    elsif (/^LOCATION/) {
	/LOCATION:(.*)/;
	$location = $1;
	if ($location eq 'Saal 1') {
	    $location = 1;
	}
	elsif ($location eq 'Saal 2') {
	    $location = 2;
	}
	elsif ($location eq 'Saal 3') {
	    $location = 3;
	}
	elsif ($location eq 'Saal 4') {
	    $location = 4;
	}
	elsif ($location eq 'Workshop') {
	    $location = 5;
	}
	elsif ($location eq 'Haecksen') {
	    $location = 6;
	}
	elsif ($location eq 'AVIT') {
	    $location = 7;
	}
	elsif ($location eq 'Lockpicking') {
	    $location = 8;
	}
    }
}
$day1list1 = "$day1list1,21C3,fahrplan,saaleins,saalzwo,saaldrei,saalvier,workshop,haecksen,avit,lockpicking,100h,105h,110h,115h,120h,125h,130h,135h,140h,145h,150h,155h,160h,165h,170h,175h";
$day1list2 = "$day1list2,21C32,fahrplan2,saaleins2,saalzwo2,saaldrei2,saalvier2,workshop2,haecksen2,avit2,lockpicking2,180h,185h,190h,195h,200h,205h,210h,215h,220h,225h,230h,235h,240h,245h,250h,255h,260h,265h,270h";
$day2list1 = "$day2list1,21C3,fahrplan,saaleins,saalzwo,saaldrei,saalvier,workshop,haecksen,avit,lockpicking,100h,105h,110h,115h,120h,125h,130h,135h,140h,145h,150h,155h,160h,165h,170h,175h";
$day2list2 = "$day2list2,21C32,fahrplan2,saaleins2,saalzwo2,saaldrei2,saalvier2,workshop2,haecksen2,avit2,lockpicking2,180h,185h,190h,195h,200h,205h,210h,215h,220h,225h,230h,235h,240h,245h,250h,255h,260h,265h,270h";
$day3list1 = "$day3list1,21C3,fahrplan,saaleins,saalzwo,saaldrei,saalvier,workshop,haecksen,avit,lockpicking,100h,105h,110h,115h,120h,125h,130h,135h,140h,145h,150h,155h,160h,165h,170h,175h";
$day3list2 = "$day3list2,21C32,fahrplan2,saaleins2,saalzwo2,saaldrei2,saalvier2,workshop2,haecksen2,avit2,lockpicking2,180h,185h,190h,195h,200h,205h,210h,215h,220h,225h,230h,235h,240h,245h,250h,255h,260h,265h,270h";

print DAYONE << "XEOF";
\\definelayer[fahrplan]
\\setlayer[fahrplan][preset=lefttop,x=15cm,y=1cm]{\\framed[width=13.85cm,align=left,frame=off,height=1cm]{\\MillenniaBig{}v$version}}
\\definelayer[fahrplan2]
\\setlayer[fahrplan2][preset=lefttop,x=15cm,y=19cm]{\\framed[width=13.85cm,align=left,frame=off,height=1cm]{\\MillenniaBig{}v$version}}
\\setupbackgrounds[page][background={$day1list1}]
\\starttext
\$\\,\$
\\page
\\setupbackgrounds[page][background={$day1list2}]
\$\\,\$
\\page
\\stoptext
XEOF
print DAYTWO << "XEOF";
\\definelayer[fahrplan]
\\setlayer[fahrplan][preset=lefttop,x=15cm,y=1cm]{\\framed[width=13.85cm,align=left,frame=off,height=1cm]{\\MillenniaBig{}v$version}}
\\definelayer[fahrplan2]
\\setlayer[fahrplan2][preset=lefttop,x=15cm,y=19cm]{\\framed[width=13.85cm,align=left,frame=off,height=1cm]{\\MillenniaBig{}v$version}}
\\setupbackgrounds[page][background={$day2list1}]
\\starttext
\$\\,\$
\\page
\\setupbackgrounds[page][background={$day2list2}]
\$\\,\$
\\page
\\stoptext
XEOF
print DAYTHREE << "XEOF";
\\definelayer[fahrplan]
\\setlayer[fahrplan][preset=lefttop,x=15cm,y=1cm]{\\framed[width=13.85cm,align=left,frame=off,height=1cm]{\\MillenniaBig{}v$version}}
\\definelayer[fahrplan2]
\\setlayer[fahrplan2][preset=lefttop,x=15cm,y=19cm]{\\framed[width=13.85cm,align=left,frame=off,height=1cm]{\\MillenniaBig{}v$version}}
\\setupbackgrounds[page][background={$day3list1}]
\\starttext
\$\\,\$
\\page
\\setupbackgrounds[page][background={$day3list2}]
\$\\,\$
\\page
\\stoptext
XEOF
close(FAHRPLAN);
close(DAYONE);
close(DAYTWO);
close(DAYTHREE);
