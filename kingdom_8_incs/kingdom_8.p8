pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include bg.p8
#include events_75.lua

function _init()
    init_scenes()
    scene = scenes["game_play"] -- DEBUG

    init_advisors()
end

function init_scenes()
    scenes = {
        start_screen = "start_screen",
        tutorial = "tutorial",
        game_play = "game_play",
        game_over = "game_over"
    }
end

function init_advisors()
    advisors = {
        [0]={name="cleric"},
        [1]={name="general"},
        [2]={name="sage"},
        [3]={name="merchant"}
    }
end

-->8
function _update()
    update_scenes()
end

function update_scenes()
    if scene == scenes["start_screen"] then
        if btnp(4) then
            scene = scenes["tutorial"]
        end
    elseif scene == scenes["tutorial"] then
        if btnp(4) then
            scene = scenes["game_play"]
        end
    elseif scene == scenes["game_play"] then
    elseif scene == scenes["game_over"] then
    end
end

-->8
function _draw()
    cls()
    draw_scene()
    draw_advisors()
end

function draw_scene()
    if scene == scenes["start_screen"] then
        print("start screen", 10, 10, 7)
    elseif scene == scenes["tutorial"] then
        print("tutorial", 10, 10, 7)
    elseif scene == scenes["game_play"] then
        draw_img(img)
    elseif scene == scenes["game_over"] then
        print("game_over", 10, 10, 7)
    end
end

function draw_advisors()
    local bg_col=0
    local text_col=7

    rectfill(4,44,28,50,bg_col)
    print(advisors[0]["name"], 5, 45, text_col)

    rectfill(95,44,123,50,bg_col)
    print(advisors[1]["name"], 96, 45, text_col)

    rectfill(4,116,20,122,bg_col)
    print(advisors[2]["name"], 5, 117, text_col)

    rectfill(91,116,123,122,bg_col)
    print(advisors[3]["name"], 92, 117, text_col)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
