trees = 3

function fuelCheck() 
    if turtle.getFuelLevel() < 10 then
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
    
    changeDirection(0)
    turtle.dig()
    
    changeDirection(0)
    turtle.dig()
    
    changeDirection(0)
    turtle.dig()
    
    changeDirection(0)
    turtle.dig()
end

function changeDirection(lr)
    local f = fs.open("state", "r")
    local state = tonumber(f.readLine())
    if lr == 0 then -- turn right
        turtle.turnRight()
        state = (state+1)%4
    else -- turn left
        turtle.turnLeft()
        if state == 0 then
            state = 3
        else
            state = state - 1
        end
    end
    print(state)
    f.close()
    local f = fs.open("state", "w")
    f.write(state)
    f.close()
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
    
    changeDirection(0)
    local _, ischest = turtle.inspect()
    if turtle.getFuelLevel() < trees*10*4 then
        if _ and ischest then
            turtle.suck((trees*10*4/80)+trees*3+5)
        else
            print("NO CHEST DETECTED ABOVE")
        end
    end
    
    changeDirection(1)
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
                
                changeDirection(1)
                turtle.forward()
                turtle.forward()
                turtle.forward()
                
                changeDirection(0)
            end
        end
        
        changeDirection(0)
        for i=1,(trees-1)*3 do turtle.forward() end
        
        changeDirection(1)
        deposit()
        os.sleep(10)
    end
end

function returnBase() 
    goBack()
    local f = fs.open("state", "r")
    local dir = tonumber(f.readLine())
    print("beginning: "..dir)
    if dir == 1 then
        
        changeDirection(0)
        changeDirection(0)
    elseif dir == 2 then
        
        changeDirection(0)
    elseif dir == 0 then
        
        changeDirection(1)
    end
    while turtle.back() do
        
    end
    
    changeDirection(0)
    while turtle.forward() do end
    
    changeDirection(1)
end

function onBoot() 
    returnBase()
    begin()
end
onBoot()