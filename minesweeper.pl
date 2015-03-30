use List::Util;

#ゲームボードの大きさを決める。
&input_gameboard_size;
#ゲームボード内の爆弾の数を決める
&input_num_of_bomb;
#ゲーム開始が面の表示
&show_initialized_screen;
#ボード内に爆弾をセット
&romdom_bombset;
#ゲーム開始
&game_start;

sub game_start {
	while (1) {
	#開くパネルの指定
	&inout_open_panel;
	$bool = 0;

	if ( $open eq "o" ) {
		#指定したパネルが爆弾と同じ場所ならゲームオーバー
		if ( $bomb[$y][$x] eq "x" && $board[$y][$x] eq "?" ) {
			print "Gameover\n";
			exit(0);	
		} elsif ( $board[$y][$x] eq "?" ) {
			#指定したパネルの周りの爆弾の数を数える
			&bomb_count;		
		} else {
		}

		#指定したパネルの周囲の爆弾の数が0で無ければ、パネルに爆弾の数を入れる
		if ( $bomb_count !=0 && $bool == 1) {			
			$board[$y][$x] = $bomb_count;
		} elsif ( $bool == 1 ) {
			$board[$y][$x] = "0";
			#周りのパネルの場所を格納する
			&stack_around_opened_panel;
			#周りのパネルで爆弾の数が0のパネルを開ける
			&open_0_panel;
		} else {
		}
	} elsif ($open eq "x") {
		#ゲームパネルに爆弾のフラグを立てる（又は下ろす）
		&mark_x_as_bomb;		
	} else {
	}

	#現在のパネルの状態を表示
	&show_game_panel;
	#ゲームクリア判定
	&check_game_clear;	
	}
}
sub input_gameboard_size {
	#ゲームボードの縦幅を決める
	print "input a number of rows of panels (max 9)";
	$hight = <STDIN>;
	chomp( $hight );

	#ゲームボードの横幅を決める
	print "input a number of lines of panels (max 9)";
	$width = <STDIN>;
	chomp( $width );
}

sub input_num_of_bomb {
	#地雷の数を決める
	print "input a number of bombs of panels";
	$bomb_num = <STDIN>;
	chomp( $bomb_num );

	#指定した爆弾の数がパネルの数以上ならゲームを終了する。
	if ( $width * $hight <= $bomb_num ) {
		print "爆弾の数が多すぎます。ゲームを終了。\n";
		exit( 0 );
	}
}

sub show_initialized_screen {
	print " ";
	#パネルの横を表示
	for ( $i = 97; $i < ( 97 + $hight ); $i++ ) {
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

sub romdom_bombset {
	#ゲームパネルの全ての位置をランダムに並び替えて、指定した数爆弾を配置する。
	@coord_shuffle = List::Util::shuffle @coord;
	for ( $i = 0; $i < $bomb_num; $i++ ) {
		if ( $coord_shuffle[$i] =~ /([0-9]):([0-9])/ ) {
			$bomb[$1][$2] = "x";		
		}
	}
}

sub inout_open_panel {
	print "input a num of row and char of line\n";
	$coord = <STDIN>;
	chomp $coord;
	$y = chop( $coord );
	$char = chop( $coord );
	my $x = ( ord $char ) - 97 ;
	print "press o if you open the panel or x if you mark as a mine\n";
	$open = <STDIN>;
	chomp $open;
}

sub check_game_clear {
	if ( $panel_num == $bomb_num ) {
		print "clear!\n";
		exit( 0 );
	}
}

sub show_game_panel {
	print " ";
	$panel_num = 0;
	for ($i = 97; $i < ( 97 + $hight ); $i++ ) {
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
}

sub mark_x_as_bomb {
	#指定したパネルの状態を "?" <=> "x" に変える。
	if ( $board[$y][$x] eq "?" ) {
		$board[$y][$x] = "x";
	} else {
		$board[$y][$x] = "?";
	}
}

sub bomb_count {
	$panel_remain--;
	$bool = 1;
	$bomb_count = 0;
	@stack = ();
	for ( $i = $y - 1; $i < $y + 2 ; $i++ ) {
		for ( $j = $x - 1; $j < $x + 2; $j++ ) {
			if ( $i == $y && $j == $x || $i < 0 || $j < 0 || $i > $hight ||
				$j > $width ) {
				next;
			}
			if ( $bomb[$i][$j] eq "x" ) {
				$bomb_count++;
			}
		}
	}
}

sub stack_around_opened_panel {
	for ( $i = $y - 1; $i < $y + 2; $i++ ) {
		for ( $j = $x - 1; $j < $x + 2; $j++ ) {
			if ( $i == $y && $j == $x || $i < 0 || $j < 0 || $i > $hight ||
				$j > $width ) {
				next;
			}
			unless ( exists( $open{"$j$i"} ) ) {
				push(@stack,"$j$i");
			}
					
		}
	}
}

sub open_0_panel {
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
}