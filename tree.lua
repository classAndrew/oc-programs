trees = 5

function fuelCheck() 
    if turtle.getFuelLevel() < 5 then
        for i=1, 16 do 
            turtle.select(i)
            local detail = turtle.getItemDetail()
            if detail and detail.name == "minecraft:coal" then
                turtle.refuel()
                return 1
            end
        end
    end
    return turtle.getFuelLevel()
end

function mineAround()
    turtle.turnRight()
    turtle.dig()
    turtle.turnRight()
    turtle.dig()
    turtle.turnRight()
    turtle.dig()
    turtle.turnRight()
    turtle.dig()
end

function harvestTree() 
    local _, res = turtle.inspectUp()
    while _  and res and fuelCheck() do
        turtle.digUp()
        turtle.up()
        mineAround()
        turtle.forward()
        mineAround()
        turtle.back()
        turtle.back()
        mineAround()
        turtle.forward()

        _, res = turtle.inspectUp()
    end
end

function goBack()
    while not turtle.detectDown() and fuelCheck() do
        turtle.down()
    end
end

function replant()
    for i=1, 16 do
        turtle.select(i)
        local detail = turtle.getItemDetail()
        if detail and detail.name == "minecraft:sapling" then
            return turtle.place()
        end
    end
    print("OUT OF SAPLINGS")
    return 0
end

function deposit()
    local _, ischest = turtle.inspectDown()
    if _ and ischest.name == "minecraft:chest" then
        for i=1, 16 do
            turtle.select(i)
            local detail = turtle.getItemDetail()
            if detail and detail.name == "minecraft:log" then
                turtle.dropDown()
            elseif detail and detail.name == "minecraft:sapling" and detail.count > trees+10 then
                turtle.dropDown(10)
            end
        end
    else
        print("NO CHEST DETECTED AT BOTTOM")
    end
end

function grabfuel()
    turtle.turnRight()
    local _, ischest = turtle.inspect()
    if turtle.getFuelLevel() < trees*10*4 then
        if _ and ischest then
            turtle.suck((trees*10*4/80)+trees*3+5)
        else
            print("NO CHEST DETECTED ABOVE")
        end
    end
    turtle.turnLeft()
end

function begin()
    while true do
        for i=1, trees do
            local _, islog = turtle.inspect()
            if _ and islog.name == "minecraft:log" then
                grabfuel()
                fuelCheck()
                turtle.dig()
                turtle.forward()
                harvestTree()
                goBack()
                turtle.back()
                replant()
            end
            if i ~= trees then
                turtle.turnLeft()
                turtle.forward()
                turtle.forward()
                turtle.forward()
                turtle.turnRight()
            end
        end
        turtle.turnRight()
        for i=1,(trees-1)*3 do turtle.forward() end
        turtle.turnLeft()
        deposit()
        os.sleep(10)
    end
end
begin()