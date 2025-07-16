pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-->8

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
    update_tubes()
    update_player()
end

function _draw()
    cls(-4)
    draw_tubes()
    draw_player()
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

function draw_player()
    spr(1, p.x, p.y)
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

function draw_tubes()
    print(#tubes)
    print(frequency_count)
    for i=1,#tubes do
        local tube=tubes[i].top
        rectfill(tube.x0,tube.y0,tube.x1,tube.y1,3)

        tube=tubes[i].btm
        rectfill(tube.x0,tube.y0,tube.x1,tube.y1,3)
    end
end

__gfx__
00000000000aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aafa700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000afff7170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a77aaa700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a7aaa9990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000aaa99a90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaff9900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
