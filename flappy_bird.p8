pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
    game_over=false
    gravity=0.3
    jump_force=4
    tubes_speed=1
    tube_height=42
    tube_width=13
    frequency=35
    frequency_count=0
    init_tubes()
    init_player()
end

function _update()
    if (not game_over) then
        update_tubes()
        update_player()
        check_all_collision()
    else
        if (btnp(4) or btnp(5)) then
            _init()
        end
    end
end

function _draw()
    cls(-4)
    draw_tubes()
    draw_player()
    draw_game_over()
end

-->8
function init_player()
    p = {}
    p.x = 16
    p.y = 61
    p.dy = 0 --delta y
end

function update_player()
    p.dy+=gravity
    if (btnp(2)) p.dy-=jump_force
    p.y+=p.dy
end

function check_all_collision()
    player_rect={x=p.x,y=p.y,w=8,h=8}
    for i=1,#tubes do
        local tube=tubes[i].top
        local w = tube.x1-tube.x0
        local h = tube.y0+tube.y1
        tube_rect={x=tube.x0,y=tube.y0,w=w,h=h}
        
        if (check_colision(player_rect,tube_rect)) then
            game_over=true
            break
        end

        tube=tubes[i].btm
        w = tube.x1-tube.x0
        h = tube.y1-tube.y0
        tube_rect={x=tube.x0,y=tube.y0,w=w,h=h}
        
        if (check_colision(player_rect,tube_rect)) then
            game_over=true
        end
    end
end

function check_colision(player_rect, tube_rect)
    if (player_rect.x < tube_rect.x+tube_rect.w and
        player_rect.x+player_rect.w > tube_rect.x and
        player_rect.y < tube_rect.y+tube_rect.h and
        player_rect.y+player_rect.h > tube_rect.y) then
        return true
    end
    return false
end

function draw_player()
    if (game_over) then
        spr(3,p.x,p.y)
    elseif (p.dy>0) then
        spr(1,p.x,p.y)
    else
        spr(2,p.x,p.y)
    end
end

-->8
function init_tubes()
    tubes={
        make_tubes()
    }
end

function make_tubes()
    dh = flr(rnd(tube_height*2))-tube_height -- delta heighT
    return {
        top={x0=128,x1=128+tube_width,y0=0,y1=0+dh+tube_height}, -- Origin top left
        btm={x0=128,x1=128+tube_width,y0=128-tube_height+dh,y1=128} -- Origin top left
    }
end

function update_tubes()
    if (not game_over) then
        for i=1,#tubes do
            tubes[i].top.x0-=tubes_speed
            tubes[i].top.x1-=tubes_speed
            tubes[i].btm.x0-=tubes_speed
            tubes[i].btm.x1-=tubes_speed
        end

        -- remove
        if tubes[1].top.x1 < 0 then
            del(tubes,tubes[1])
        end

        -- Add tube
        if (frequency_count-tube_width==frequency) then
            add(tubes,make_tubes())
            frequency_count=0
        else
            frequency_count+=tubes_speed
        end
    end
end

function draw_tubes()
    print(frequency_count)
    for i=1,#tubes do
        local tube=tubes[i].top
        rectfill(tube.x0,tube.y0,tube.x1,tube.y1,3)

        tube=tubes[i].btm
        rectfill(tube.x0,tube.y0,tube.x1,tube.y1,3)
    end
end

-->8
function draw_game_over()
    if (game_over) then
		print("game over!",44,44,7)
		--print("your score: "..player.score,34,54,7)
		print("PRESS ❎ to play again",18,72,6)
    end
end

__gfx__
00000000000aaa00000aa00000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aafa7000aff77000008870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000afff7170af771700008f717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a77aaa70a777fa7900877870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a7aaa999a77ff99900878999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000aaa99a90aaa99a900088989000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaff9900aaff99000000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aaa0000aaa00000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
