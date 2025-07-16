pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	game_over=false
	make_cave()
	make_player()
end

function _update()
	if (not game_over) then
		update_cave()
		move_player()
		check_hit()
	end
end

function _draw()
	cls()
	draw_cave()
	draw_player()
	
	if (game_over) then
		print("game over!",44,44,7)
		print("your score: "..player.score,34,54,7)
	else
		print("score: "..player.score,2,2,7)
	end
end

-->8
function make_player()
	player={}
	player.x=24    --position
	player.y=60
	player.dy=0    --fallspeed
	player.rise=1  --sprites
	player.fall=2
	player.dead=3
	player.speed=2 --fly speed
	player.score=0
end

function move_player()
	gravity=0.2 --bigger means more gravity
	player.dy+=gravity --add gravity
	
	--jump
	if (btnp(2)) then
		player.dy-=4
	end
	
	--move to new position
	player.y+=player.dy
	
	--update score
	player.score+=player.speed
end

function check_hit()
	for i=player.x,player.x+7 do
		if (cave[i+1].top>player.y
			or cave[i+1].btm<player.y+7) then
			game_over=true
		end
	end
end

function draw_player()
	if (game_over) then
		spr(player.dead, player.x, player.y)
	elseif (player.dy < 0) then
		spr(player.rise, player.x, player.y)
	else
		spr(player.fall, player.x, player.y)
	end
end

-->8
function make_cave()
	cave={{["top"]=5,["btm"]=119}}
	top=45 --how low can the ceiling go?
	btm=85 --how high can the floor get?
end

function update_cave()
	--remove the back of the cave
	if (#cave > player.speed) then
		for i=1, player.speed do
			del(cave, cave[1])
		end
	end
	
	--add more curve
	while (#cave<128) do
		local col={}
		local up = flr(rnd(7)-3)
		local dwn = flr(rnd(7)-3)
		col.top=mid(3,cave[#cave].top+up,top)
		col.btm=mid(btm,cave[#cave].btm+dwn,124)
		add(cave,col)
	end
end

function draw_cave()
	local top_colors=11
	local btm_colors=11
	for i=1, #cave do
		line(i-1,0,i-1,cave[i].top,top_colors)
		line(i-1,127,i-1,cave[i].btm,btm_colors)
	end
end
__gfx__
0000000000aaaa0000aaaa0000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaaa00aaaaaa008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aa1aa1aaaa1aa1aa88988988000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaaaaaaaaaa88888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aa1111aaaaa11aaa88899888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaa11aaaaaa11aaa88988988000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaa8aa00aaaaaa008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaaa0000aaaa0000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400000b0500d050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002f05000000270500000021050000000904009030090300903009020090200902009010090100901000000000000000000000000000000000000000000000000000000000000000000000000000000000
