pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include bg.p8
#include events_75.lua

function _init()
    init_scenes()
    scene = scenes["start_screen"]
end

function init_scenes()
    scenes = {
        start_screen = "start_screen",
        tutorial = "tutorial",
        game_play = "game_play",
        game_over = "game_over"
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

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
