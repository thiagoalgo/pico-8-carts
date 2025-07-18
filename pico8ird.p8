pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
    game_over = false
    gravity = 0.3
    jump_force = 4
    tubes_speed = 1
    tube_height = 36
    tube_width = 13
    frequence_base = 50
    frequency = frequence_base
    frequency_var = 50
    frequency_count = 0
    highscore = 0
    is_highscore = false
    is_highscore_notified = false
    lvl_speed_inc_trigger = 50
    lvl_speed_inc = 1
    lvl_freq_var_inc_trigger = 20
    lvl_freq_var_inc = 5
    lvl_freq_var_min = 0
    lvl_score_inc_trigger = 10
    lvl_score_inc = 2
    lvl_score_max = 46
    shake_frames = 0
    shake_intensity = 2
    init_tubes()
    init_player()
end

function _update()
    if not game_over then
        update_tubes()
        update_player()
        check_tubes_collisions()
        update_score()
    else
        if (btnp(4) or btnp(5)) then
            _init()
        end
    end
end

function _draw()
    cls(-4)
    load_highscore()
    draw_tubes()
    draw_map()
    draw_player()
    draw_hud()
    draw_game_over()
end

-->8
function init_player()
    p = {}
    p.x = 16
    p.y = 61
    p.dy = 0
    --delta y
    p.score = 0
end

function update_player()
    p.dy += gravity
    if btnp(2) then
        p.dy -= jump_force
        sfx(0)
    end
    p.y += p.dy
    check_limits()
end

function check_limits()
    if (p.y <= 4 or p.y > 116) then
        set_game_over()
    end
end

function check_tubes_collisions()
    player_rect = { x = p.x, y = p.y, w = 8, h = 8 }
    for i = 1, #tubes do
        local tube = tubes[i].top
        local w = tube.x1 - tube.x0
        local h = tube.y1 - tube.y0
        tube_rect = { x = tube.x0, y = tube.y0, w = w, h = h }

        if check_tube_collision(player_rect, tube_rect) then
            set_game_over()
            break
        end

        tube = tubes[i].btm
        w = tube.x1 - tube.x0
        h = tube.y1 - tube.y0
        tube_rect = { x = tube.x0, y = tube.y0, w = w, h = h }

        if check_tube_collision(player_rect, tube_rect) then
            set_game_over()
            break
        end
    end
end

function check_tube_collision(player_rect, tube_rect)
    if (player_rect.x < tube_rect.x + tube_rect.w
                and player_rect.x + player_rect.w > tube_rect.x
                and player_rect.y < tube_rect.y + tube_rect.h
                and player_rect.y + player_rect.h > tube_rect.y) then
        return true
    end
    return false
end

function set_game_over()
    game_over = true
    sfx(1)
    save_highscore()
    shake_frames = 10
end

function draw_player()
    if game_over then
        spr(3, p.x, p.y)
    elseif (p.dy > 0) then
        spr(1, p.x, p.y)
    else
        spr(2, p.x, p.y)
    end
end

-->8
function init_tubes()
    tubes = {
        make_tubes()
    }
end

function make_tubes()
    -- delta heighT
    dh = flr(rnd(tube_height * 2)) - tube_height

    return {
        top = { x0 = 128, x1 = 128 + tube_width, y0 = 0, y1 = 0 + dh + tube_height, scored = false }, -- Origin top left
        btm = { x0 = 128, x1 = 128 + tube_width, y0 = 128 - tube_height + dh, y1 = 128, scored = false } -- Origin top left
    }
end

function update_tubes()
    if not game_over then
        for i = 1, #tubes do
            tubes[i].top.x0 -= tubes_speed
            tubes[i].top.x1 -= tubes_speed
            tubes[i].btm.x0 -= tubes_speed
            tubes[i].btm.x1 -= tubes_speed
        end

        -- remove
        if tubes[1].top.x1 < 0 then
            del(tubes, tubes[1])
        end

        -- Add tube
        if (frequency_count >= frequency) then
            add(tubes, make_tubes())
            frequency_count = 0
            frequency = frequence_base + flr(rnd(frequency_var))
        else
            frequency_count += tubes_speed
        end
    end
end

function draw_tubes()
    for i = 1, #tubes do
        draw_tube(tubes[i].top)
        draw_tube(tubes[i].btm)
    end
end

function draw_tube(tube)
    rectfill(tube.x0, tube.y0, tube.x1, tube.y1, 3)
    rect(tube.x0 - 1, tube.y0 - 1, tube.x1 + 1, tube.y1 + 1, 0)
    rectfill(tube.x0 + 2, tube.y0 + 2, tube.x0 + 4, tube.y1 - 2, 11)
end

-->8
function draw_game_over()
    if game_over then
        print("game over!", 44, 44, 7)
        print("your score: " .. p.score, 34, 54, 7)
        print("press " .. chr(151) .. " to play again", 18, 72, 10)
        shake()
    end
end

function shake()
    if (shake_frames > 0) then
        local sx = rnd(shake_intensity) - (shake_intensity / 2)
        local sy = rnd(shake_intensity) - (shake_intensity / 2)
        camera(sx, sy)
        shake_frames -= 1
    else
        camera(0, 0)
    end
end

-->8
function draw_map()
    map(0, 0, 0, 0, 16, 1)
    map(0, 1, 0, 120, 16, 1)
end

function draw_hud()
    print("score: " .. p.score, 2, 6, 7)

    local color = 7
    if (is_highscore) color = 8
    print("highscore: " .. highscore, 2, 118, color)
end

-->8
cartdata("highscore")

function save_highscore()
    if (p.score > highscore) then
        dset(0, p.score)
        is_highscore = true
    end
end

function load_highscore()
    if (dget(0) == nil) then
        dset(0, 0)
    end
    highscore = dget(0)
end

function update_score()
    for i = 1, #tubes do
        if (p.x > tubes[i].top.x1 and not tubes[i].top.scored) then
            tubes[i].top.scored = true
            tubes[i].btm.scored = true
            p.score += 1
            update_level()
            save_highscore()
            if is_highscore and not is_highscore_notified then
                is_highscore_notified = true
                sfx(2)
            end
        end
    end
end

function update_level()
    -- Increase tube speed every 50 points
    if (p.score % lvl_speed_inc_trigger == 0) then
        tubes_speed += lvl_speed_inc
    end

    -- Every 20 points, decrease frequency variation by 5 until it reaches zero
    if (p.score % lvl_freq_var_inc_trigger == 0 and frequency_var > lvl_freq_var_min) then
        frequency_var = max(lvl_freq_var_min, frequency_var - lvl_freq_var_inc)
    end

    -- Every 10 points, increase tube height by 2 up to a maximum of 46
    if (p.score % lvl_score_inc_trigger == 0 and tube_height < lvl_score_max) then
        tube_height = min(lvl_score_max, tube_height + lvl_score_inc)
    end
end

__gfx__
00000000000aaa00000aa00000000800000000007767777700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aafa7000aff77000008870000000001777767700000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000afff7170af771700008f717000000000177777100000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a77aaa70a777fa7900877870000000000011771000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a7aaa999a77ff99900878999000000100000110000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000aaa99a90aaa99a900088989001001410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaff9900aaff99000000990114119440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aaa0000aaa00000000800449444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400000000001070010500205006050081000f20000000000000e3000000000000000000e4000000000000000000e5000000000000000000c6000000000000000000d700000000000000000000000000000000
00100000000002f63023630116202b160201601a1601610012160000000d160000000915005140051300511007100071000000000000000000000000000000000000000000000000000000000000000000000000
000a0000271202c130391403514033130301203101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
