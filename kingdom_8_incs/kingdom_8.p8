pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include bg.p8
#include events_75.lua

function _init()
    scenes={}
    init_scenes()
    scene = scenes["game_play"]

    advisors={}
    sel_advisor={}
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
        [0] = { name = "cleric", row = 0, col = 0 },
        [1] = { name = "general", row = 0, col = 1 },
        [2] = { name = "sage", row = 1, col = 0 },
        [3] = { name = "merchant", row = 1, col = 1 }
    }

    sel_advisor = { row = 0, col = 0 }
end

-->8
function _update()
    update_scenes()
    update_advisors()
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

function update_advisors()
    if scene == scenes["game_play"] then
        if btnp(0) then sel_advisor.col = 0 end
        if btnp(1) then sel_advisor.col = 1 end
        if btnp(2) then sel_advisor.row = 0 end
        if btnp(3) then sel_advisor.row = 1 end
    end
end

-->8
function _draw()
    cls()
    draw_scene()
    draw_advisors()
    draw_score()
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
    if scene == scenes["game_play"] then
        local bg_col = 0
        local text_col = 7

        if (sel_advisor.row == 0 and sel_advisor.col == 0) then
            rectfill(4, 44, 28, 50, bg_col)
            print(advisors[0]["name"], 5, 45, text_col)
        end

        if (sel_advisor.row == 0 and sel_advisor.col == 1) then
            rectfill(95, 44, 123, 50, bg_col)
            print(advisors[1]["name"], 96, 45, text_col)
        end

        if (sel_advisor.row == 01 and sel_advisor.col == 0) then
            rectfill(4, 116, 20, 122, bg_col)
            print(advisors[2]["name"], 5, 117, text_col)
        end

        if (sel_advisor.row == 1 and sel_advisor.col == 1) then
            rectfill(91, 116, 123, 122, bg_col)
            print(advisors[3]["name"], 92, 117, text_col)
        end

        palt(0, false)
        palt(3, true)
        if (sel_advisor.row == 0 and sel_advisor.col == 0) then
            map(2, 0, 56, 73, 2, 2)
        end

        if (sel_advisor.row == 0 and sel_advisor.col == 1) then
            map(0, 0, 56, 73, 2, 2)   
        end

        if (sel_advisor.row == 01 and sel_advisor.col == 0) then
            map(2, 0, 56, 95, 2, 2)    
        end

        if (sel_advisor.row == 1 and sel_advisor.col == 1) then
            map(0, 0, 56, 95, 2, 2)
        end
        palt()
    end
end

function draw_score()
    local bg_col = 7
    local text_col = 0

    local points = 18
    local bar_size = calc_score_bar_size(5, points)
    rectfill(4, 4, 40, 12, bg_col)
    rectfill(5, 5, bar_size, 11, get_bar_color(points))
    print("popular.", 6, 6, text_col)

    points = 1
    bar_size = calc_score_bar_size(47, points)
    rectfill(46, 4, 82, 12, bg_col)
    rectfill(47, 5, bar_size, 11, get_bar_color(points))
    print("might", 48, 6, text_col)

    points = 89
    local bar_size = calc_score_bar_size(89, points)
    rectfill(88, 4, 124, 12, bg_col)
    rectfill(89, 5, bar_size, 11, get_bar_color(points))
    print("loyalty", 90, 6, text_col)
end

function calc_score_bar_size(init, points)
    return init + ceil(34 * points / 100)
end

function get_bar_color(points)
    if points < 40 then
        return 8
    elseif points > 60 then
        return 3
    else
        return 9
    end
end

__gfx__
0000000033333333033333330ffffffffffffff00ffffffffffffff0333333303333333300000000000000000000000000000000000000000000000000000000
0000000033333333003333330fffffffffffff0330fffffffffffff0333333003333333300000000000000000000000000000000000000000000000000000000
00700700333333330f0333330ffffffffffff033330ffffffffffff0333330f03333333300000000000000000000000000000000000000000000000000000000
00077000333333330ff03333000000000fff03333330fff00000000033330ff03333333300000000000000000000000000000000000000000000000000000000
00077000000000000fff0333333333330ff0333333330ff0333333333330fff00000000000000000000000000000000000000000000000000000000000000000
007007000ffffffffffff033333333330f033333333330f033333333330ffffffffffff000000000000000000000000000000000000000000000000000000000
000000000fffffffffffff033333333300333333333333003333333330fffffffffffff000000000000000000000000000000000000000000000000000000000
000000000ffffffffffffff0333333330333333333333330333333330ffffffffffffff000000000000000000000000000000000000000000000000000000000
__map__
0102070800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0304050600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
