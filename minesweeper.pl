use List::Util;

&input_gameboard_size;
&input_num_of_bomb;
&show_initialized_screen;
&romdom_bombset;

while (1) {
	print "input a num of row and char of line\n";
	$coord = <STDIN>;
	chomp $coord;
	$y = chop( $coord );
	$char = chop( $coord );
	my $x = ( ord $char ) - 97 ;
	print "press o if you open the panel or x if you mark as a mine\n";
	$open = <STDIN>;
	chomp $open;
	$bool = 0;
	if ( $open eq "o" ) {
		if ( $bomb[$y][$x] eq "x" && $board[$y][$x] eq "?" ) {
			print "Gameover\n";
			exit(0);	
		} elsif ( $board[$y][$x] eq "?" ) {
			$panel_remain--;
			$bool = 1;
			$bomb_count = 0;
			@stack = ();
			for ( $i = $y - 1; $i < $y + 2 ; $i++ ) {
				for ( $j = $x - 1; $j < $x + 2; $j++ ) {
					if ( $i == $y && $j == $x || $i < 0 || $j < 0 || $i > $hight || $j > $width ) {
						next;
					}
					if ( $bomb[$i][$j] eq "x" ) {
						$bomb_count++;
					}
				}
			}
		} else {

		}

		if ( $bomb_count !=0 && $bool == 1) {
			$board[$y][$x] = $bomb_count;
		} elsif ( $bool == 1 ) {
			$board[$y][$x] = "0";
			for ( $i = $y - 1; $i < $y + 2; $i++ ) {
				for ( $j = $x - 1; $j < $x + 2; $j++ ) {
					if ( $i == $y && $j == $x || $i < 0 || $j < 0 || $i > $hight || $j > $width ) {
						next;
					}
					unless ( exists( $open{"$j$i"} ) ) {
						push(@stack,"$j$i");
					}
					
				}
			}
			while ( $#stack != -1) {
				$coord = shift( @stack );
				if ( exists( $open{"$coord"} ) ) {
					next;
				}
				$y = chop( $coord );
				$x = chop( $coord );
				$bomb_count = 0;
				@stack2 =();
				for ( $i = $y - 1; $i < $y + 2; $i++ ) {
					for ( $j = $x - 1; $j < $x + 2; $j++ ) {
						if ($i == $y && $j == $x || $i < 0 || $j < 0 || $i > $hight || $j > $width ) {
							next;
						}
						
						unless( exists( $open{"$j$i"} ) ) {
							$open{"$x$y"}++;
							if ( $board[$i][$j] eq "?") {
								push( @stack2,"$j$i" );
							}
							if ( $bomb[$i][$j] eq "x" ) {
								$bomb_count++;
							}
						}			
					}
				}
				
				$open{"$x$y"}++;
				if ( $bomb_count != 0 ) {
					$board[$y][$x] = $bomb_count;
				} else {
					$board[$y][$x] = 0;
					push @stack,@stack2;
				}				
			}

		} else {

		}
	} elsif ($open eq "x") {
		if ( $board[$y][$x] eq "?" ) {
			$board[$y][$x] = "x";
		} else {
			$board[$y][$x] = "?";
		}
	} else {

	}

	print " ";
	$panel_num = 0;
	for ($i = 97; $i < (97+$hight); $i++ ) {
		print chr($i) ;
	}
	print "\n";
	for ( $i = 0; $i < $hight; $i++ ) {
		print "$i";
		for ( $j = 0; $j < $width; $j++ ) {
			print "$board[$i][$j]";
			if ( $board[$i][$j] eq "?" || $board[$i][$j] eq "x" ) {
				$panel_num++;
			}
		}
		print "\n";
	} 
	if ( $panel_num == $bomb_num ) {
		print "clear!\n";
		exit(0);
	}
}

sub input_gameboard_size{
	#ゲームボードの縦幅を決める
	print "input a number of rows of panels (max 9)";
	$hight = <STDIN>;
	chomp( $hight );

	#ゲームボードの横幅を決める
	print "input a number of lines of panels (max 9)";
	$width = <STDIN>;
	chomp( $width );
}

sub input_num_of_bomb{
	#地雷の数を決める
	print "input a number of bombs of panels (max 81)";
	$bomb_num = <STDIN>;
	chomp( $bomb_num );
}

sub show_initialized_screen{
	print " ";
	#パネルの横を表示
	for ( $i = 97; $i < (97+$hight); $i++ ) {
		print chr($i) ;
	}
	print "\n";

	$bottom = 0;
	for ( $i = 0; $i < $hight; $i++ ) {
		print "$i";
		for ( $j = 0; $j < $width; $j++ ) {
			print "?";
			$board[$i][$j] = "?";
			$coord[$bottom] = "$i:$j";
			$bottom++;
		}
		print "\n";
	}
}

sub romdom_bombset{
	@coord_shuffle = List::Util::shuffle @coord;
	for ( $i = 0; $i < $bomb_num; $i++ ) {
		if ( $coord_shuffle[$i] =~ /([0-9]):([0-9])/ ) {
			$bomb[$1][$2] = "x";		
		}
	}
}