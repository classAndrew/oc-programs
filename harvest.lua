moves = 9 --side length of farmland
function tryHarvest()
    local b, v = turtle.inspectDown()
    if b and v.metadata == 7 then
        turtle.digDown()
    end
    turtle.placeDown()
end

function depositChest()
    for i=2,16 do
        turtle.select(i)
        turtle.dropDown()
    end
    turtle.select(1)
end

function farm ()
    for i = 0, moves-1 do
        local j = 0
        while j <= moves-1 do
            local res = turtle.forward()
            if not res then
                turtle.up()
                turtle.forward()
                turtle.forward()
                turtle.down()
                j = j + 1
            end
            tryHarvest()
            j = j + 1
        end
        if i ~= moves-1 then
            if i%2==0 then     
                turtle.turnRight()
                turtle.forward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                turtle.forward()
                turtle.turnLeft()
            end
        end
        tryHarvest()
    end
    if moves%2==0 then
        turtle.turnRight()
        for i=0, moves-2 do 
            turtle.forward() 
        end

    else
        turtle.turnRight()
        turtle.turnRight()
        for i=0, moves-1 do 
            turtle.forward() 
        end
        turtle.turnRight()
        for i=0, moves-2 do 
            turtle.forward() 
        end
    end
    turtle.turnRight()
    depositChest()
end

farm()