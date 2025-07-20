pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include bg.p8
#include events_75.lua

function _init()
    scenes = {}
    init_scenes()
    scene = scenes["start_screen"]

    advisors = {}
    init_advisors()

    message = {}
    recent_closed_message = false
    btm_message = {}
    sel_event = {}

    score = {}
    init_score()
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
        [0] = { name = "cleric", row = 0, col = 0, pop_wght = 6, mig_wght = 3, loy_wght = 4 },
        [1] = { name = "general", row = 0, col = 1, pop_wght = 3, mig_wght = 6, loy_wght = 5 },
        [2] = { name = "sage", row = 1, col = 0, pop_wght = 4, mig_wght = 4, loy_wght = 4 },
        [3] = { name = "merchant", row = 1, col = 1, pop_wght = 6, mig_wght = 3, loy_wght = 4 }
    }

    sel_advisor = { row = 0, col = 0 }
end

function init_score()
    score = {
        pop = 50,
        mig = 50,
        loy = 50
    }
end

-->8
function _update()
    update_score()
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
            btm_message.text = "select an advisor and press 🅾️"
            btm_message.show = true
        end
    elseif scene == scenes["game_play"] then
        if not message.show then
            if btnp(4) and not recent_closed_message then
                i = ceil(rnd(#events))
                sel_event = events[i]
                message.show = true
                btm_message.show = false
            end
            recent_closed_message = false
        end
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

function get_sel_advisor()
    for i = 0, #advisors do
        if sel_advisor.row == advisors[i].row and sel_advisor.col == advisors[i].col then
            return advisors[i]
        end
    end
end

function update_score()
    if scene == scenes["game_play"] then
        if message.show then
            local adv = get_sel_advisor()
            local effect = { 0, 0, 0 }

            if btnp(4) then
                effect = sel_event.effect_a
            elseif btnp(5) then
                effect = sel_event.effect_b
            end

            if btnp(4) or btnp(5) then
                score.pop = max(min(score.pop + (adv.pop_wght * effect[1]), 100), 0)
                score.mig = max(min(score.mig + (adv.mig_wght * effect[2]), 100), 0)
                score.loy = max(min(score.loy + (adv.loy_wght * effect[3]), 100), 0)

                if score.pop < 1 or score.mig < 1 or score.loy < 1 then
                    scene = scenes["game_over"]
                    btm_message.show = false
                else
                    btm_message.text = "select an advisor and press 🅾️"
                    btm_message.show = true
                end

                message.show = false
                recent_closed_message = true
            end
        end
    end
end

-->8
function _draw()
    cls()
    draw_scene()
    draw_advisors()
    draw_message()
    draw_btm_message()
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
            rectfill(4, 100, 20, 106, bg_col)
            print(advisors[2]["name"], 5, 101, text_col)
        end

        if (sel_advisor.row == 1 and sel_advisor.col == 1) then
            rectfill(91, 100, 123, 106, bg_col)
            print(advisors[3]["name"], 92, 101, text_col)
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
    if scene == scenes["game_play"] then
        print(score.pop .. " - " .. score.mig .. " - " .. score.loy, 3, 14, 4)
        local bg_col = 7
        local text_col = 0

        local bar_size = calc_score_bar_size(5, score.pop)
        rectfill(4, 4, 40, 12, bg_col)
        rectfill(5, 5, bar_size, 11, get_bar_color(score.pop))
        print("popular.", 6, 6, text_col)

        bar_size = calc_score_bar_size(47, score.mig)
        rectfill(46, 4, 82, 12, bg_col)
        rectfill(47, 5, bar_size, 11, get_bar_color(score.mig))
        print("might", 48, 6, text_col)

        local bar_size = calc_score_bar_size(89, score.loy)
        rectfill(88, 4, 124, 12, bg_col)
        rectfill(89, 5, bar_size, 11, get_bar_color(score.loy))
        print("loyalty", 90, 6, text_col)
    end
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

function draw_message()
    if message.show then
        local bg_col = 0
        local line_col = 5
        local title_col = 10
        local text_col = 7

        rectfill(0, 0, 128, 128, bg_col)
        rectfill(0, 19, 128, 19, line_col)

        print(sel_event.text, 1, 25, title_col)

        for i = 1, #sel_event.counsel do
            y = 29 + (i * 9)
            print(sel_event.counsel[i], 1, y, text_col)
        end

        rectfill(0, 94, 128, 94, line_col)

        local opt_a = "🅾️ " .. sel_event.opt_a
        local opt_b = "❎ " .. sel_event.opt_b
        print(opt_a, 1, 99, text_col)
        print(opt_b, 1, 109, text_col)

        --counsel
    end
end

function draw_btm_message()
    if btm_message.show then
        local bg_col = 0
        local line_col = 5
        local text_col = 7

        rectfill(0, 117, 128, 118, line_col)
        rectfill(0, 118, 128, 128, bg_col)
        print(btm_message.text, 1, 121, text_col)
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
