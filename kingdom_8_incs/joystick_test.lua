local bnames = {
    [0] = "left",
    [1] = "right",
    [2] = "up",
    [3] = "down",
    [4] = "button o",
    [5] = "button x"
}

for i = 0, 5 do
    if btn(i) then
        print("p1: " .. bnames[i] .. " pressed", 8, 8 + i * 8, 7)
    end
end