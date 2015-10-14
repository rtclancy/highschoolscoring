#!/cygdrive/c/tcl/bin/tclsh86.exe

package require sqlite3;

#create database
sqlite3 db ../data/database.db;

set Varsity_roster {
"Andrea Basilicato         "
"Bronagh Lonergan	   "
"Camryn McGuire		   "
"Catherine Lawrence	   "
"Chloe Shaw		   "
"Chrystina Bonelli	   "
"Deirdre Hackett	   "
"Emma Rusconi		   "
"Erin Lamberton		   "
"Faren Roth		   "
"Grace Clancy		   "
"Isabella Nerney	   "
"Jacque Guerra		   "
"Jia Spiggle		   "
"Kayley McLaughlin	   "
"Lindsey Hiltz		   "
"Maddie Panagoulias	   "
"Molly Kosh		   "
"Nicolette de Repentigny   "
"Paige White		   "
"Taylor Shutak		   "
"Taylor Weischet           "
};

set JV_roster {
"Abigail Yerkes            "
"Ainsley Mackenzie	   "
"Caroline Basil		   "
"Catherine Miller	   "
"Charlotte Young	   "
"Devyn Luden		   "
"Elissa Strand		   "
"Emma Bosenberg		   "
"Emma Lim		   "
"Gabby Palumbo		   "
"Jody Smith		   "
"Laura Markle		   "
"Lauren Hilgert		   "
"Lindsey Hiltz		   "
"Mabel Bartlett		   "
"Maddie Monte		   "
"Molly Linell		   "
"Olivia Mirek		   "
"Sadie Slade               "
};

set Freshmen_roster {
"Abbey Vilaseca            "
"Allie Stankewich	   "
"Brielle Kendrioski	   "
"Caroline Fitzgerald	   "
"Chloe Shoff		   "
"Haley Albert		   "
"Jacquie Violette	   "
"Maeve Grattan		   "
"Meagan Cousins		   "
"Meghan Landon		   "
"Meghan Landon		   "
"Nell Kinney		   "
"Nicole Tepley		   "
"Priscilla Rodriguez	   "
"Summer Heckler		   "
"Tatum Meder		   "
"Taylor Burkle		   "
"Yanenash Ayele            "
};

proc table_spacer {lines} {
    puts $::html_out "<br>";
}

proc html_header {{image 1}} {
    puts $::html_out "<html>"
    if {$image == 1} {
	puts $::html_out "<body background=\"https://www.eteamz.com/guilfordhighschoolsoccer/files/G.gif\">";
#	puts $::html_out "<body background=\"files/G.gif\">";
    } else {
    puts $::html_out "<body background=\"https://www.eteamz.com/guilfordhighschoolsoccer/files/hs.jpg\">";
#    puts $::html_out "<body background=\"files/hs.jpg\">";
    }

}
proc html_trailer {} {
    puts $::html_out "</body>";
    puts $::html_out "</html>";
}

#style=\"
#    position: fixed;
#    top: 0;
#    left: 0;
#    width: 300px;\"

proc table_header {title {alignment left}} {
    puts $::html_out "<table 
bgcolor=\"#42c020\" border=\"5\"
align=\"$alignment\"
>";
    puts $::html_out "<tbody>"
    puts $::html_out "<tr>";
    puts $::html_out "<td style=\"color:white\"><b>$title</td>";
    puts $::html_out "</tr>";

}

proc table_trailer {} {
    puts $::html_out "</tbody>";
    puts $::html_out "</table>";
}

#width:200px;
proc table_data {data {bold 0}} {
    if {$bold} {
	puts $::html_out "<td style=\"color:white\"><b>$data</td>";
    } else {
	puts $::html_out "<td style=\"color:white\">$data</td>";
    }
}
proc table_row_start {} {
    puts $::html_out "<tr>";
}
proc table_row_end {} {
    puts $::html_out "<tr>";
}



#create table
db eval {CREATE TABLE game_table(team text, date text, opponent text, venue text, win_loss text , score text)};
db eval {CREATE TABLE player_table(name text, goals int, assists int, points int, date text , team text)};
#db eval "INSERT INTO game_table VALUES(\"Varsity\",\"9/11/2015\",\"Branford\",\"Away\",\"W\",\"4-1\")";


#read game data from csv and populate tables
#set fin [open "../data/games.csv"];
set fin [open "../data/database.xls\ -\ games.csv"];
set header_line 1;
gets $fin line_in;
set last_line 0;
while {1} {
    if {$header_line} {
	set header_line 0;
    } else {
	#puts $line_in;
	set line_list [split $line_in {,}];
	#puts $line_list;
	set db_values "";
	for {set i 0} {$i < 6} {incr i} {
	    if {$i !=0 } {set db_values "$db_values,";}
	    set db_values "$db_values\"[lindex $line_list $i]\"";
	}
	#puts $db_values;
#	exit;
	db eval "INSERT INTO game_table VALUES($db_values)";
    }
    if {$last_line} break;
    gets $fin line_in;
    if [eof $fin] {set last_line 1;}
}
#check if final line is valid game


#read player data from csv and populate tables
#set fin [open "../data/players.csv"];
set fin [open "../data/database.xls\ -\ players.csv"];
set header_line 1;
gets $fin line_in;
set last_line 0;
while {1} {
    if {$header_line} {
	set header_line 0;
    } else {
	#puts $line_in;
	set line_list [split $line_in {,}];
	#puts $line_list;
	set db_values "";
	for {set i 0} {$i < 6} {incr i} {
	    if {$i !=0 } {set db_values "$db_values,";}
	    set db_values "$db_values\"[lindex $line_list $i]\"";
	}
	#puts $db_values;
#	exit;
	db eval "INSERT INTO player_table VALUES($db_values)";
    }
    if {$last_line} break;
    gets $fin line_in;
    if [eof $fin] {set last_line 1;}
}

#build game data, (draws data from both tables)

set html_out [open girls_games_2015.html w];
html_header 2;
foreach team {Varsity JV Freshmen} {
set game_list [db eval "SELECT date FROM game_table WHERE team=\"$team\""]; 

#wins, losses, ties
foreach result {W L T} {
    set number_of_$result [llength [db eval "SELECT win_loss FROM game_table WHERE team=\"$team\" AND win_loss=\"$result\""]];
    puts [subst $[subst number_of_$result]];
			   
}

table_header "$team Results 2015 ($number_of_W-$number_of_L-$number_of_T)" top;
table_row_start;

foreach item {Date Opponent Home/Away Result Score Goals Assists} {table_data $item 1;}
table_row_end;
foreach game $game_list {
    table_row_start;
 #   puts $game;
    #puts "+++++++++++++++++++++++++++++++++++++++++++++++";
    set game_data [db eval "SELECT date,opponent,venue,win_loss,score FROM game_table WHERE date=\"$game\" and team=\"$team\""];
    set goals [db eval "SELECT name,goals FROM player_table WHERE team=\"$team\" AND date=\"$game\" and team=\"$team\" AND goals!=0"];
    set assists [db eval "SELECT name,assists FROM player_table WHERE team=\"$team\" AND date=\"$game\" and team=\"$team\" AND assists!=0"];
    #puts Game:$game_data;
    #puts Goals:$goals;
    #puts Assists:$assists;
    foreach item $game_data  {table_data $item;} 
    table_data $goals;
    table_data $assists;
}
table_trailer;
table_spacer 3;
}
html_trailer;
close $html_out;


#Player Stats Table
set html_out [open girls_stats_2015.html w];
html_header 2;
unset goals;
unset assists;
foreach team {Varsity JV Freshmen} {
    set player_list_tmp [db eval "SELECT name FROM player_table WHERE team=\"$team\""]; 
    #puts $player_list_tmp;
    set player_list {};
    foreach player $player_list_tmp {
	if {![regexp $player $player_list]} {
	    lappend player_list $player;
	}
    }
    #puts $player_list;
    
    foreach player $player_list {
	set goals($player) 0;
	set assists($player) 0;
	set points($player) 0;

	set goal_list [db eval "SELECT goals FROM player_table WHERE name=\"$player\""];
	foreach game_goals $goal_list {
	    incr goals($player) $game_goals;
	    incr points($player) [expr $game_goals * 2];

	}
	set assist_list [db eval "SELECT assists FROM player_table WHERE name=\"$player\""];
	foreach game_assists $assist_list {
	    incr assists($player) $game_assists;
	    incr points($player) [expr $game_assists * 1];
	}
    }

    #CREATE STATS Table
    table_header "$team Statistics 2015" top;
    table_row_start;
    foreach item {Name Goals Assists Points} {table_data $item 1;}
    table_row_end;
    
    foreach player [lsort $player_list] {
	table_row_start;
	foreach item "$player $goals($player) $assists($player) $points($player)" {table_data $item;};
	table_row_end;
    }
    table_trailer;
    table_spacer 3;
}
html_trailer;
close $html_out;

set html_out [open girls_rosters_2015.html w];
foreach roster {Varsity JV Freshmen} {
    html_header 2;
    table_header "$roster Roster 2015" "left";
    foreach player [subst $[subst $roster\_roster]] {
	table_row_start;
	table_data $player;
	table_row_end;
    }
    html_trailer;
    table_spacer 3;
}
close $html_out








db close;
close $fin;


