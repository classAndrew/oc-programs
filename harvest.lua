moves = 4 --side length of farmland
function tryHarvest()
    if component.geolyzer.analyze(0).growth == 1 then
        robot.swingDown()
    end
    robot.placeDown()
end

function depositChest()
    for i=2,16 do
        robot.select(i)
        robot.dropDown()
    end
    robot.select(1)
end

function farm ()
    for i = 0, moves-1 do
        local j = 0
        while j <= moves-1 do
            local res = robot.forward()
            if not res then
                robot.up()
                robot.forward()
                robot.forward()
                robot.down()
                j = j + 1
            end
            tryHarvest()
            j = j + 1
        end
        if i ~= moves-1 then
            if i%2==0 then     
                robot.turnRight()
                robot.forward()
                robot.turnRight()
            else
                robot.turnLeft()
                robot.forward()
                robot.turnLeft()
            end
        end
        tryHarvest()
    end
    if moves%2==0 then
        robot.turnRight()
        for i=0, moves-2 do robot.forward() end

    else
        robot.turnRight()
        robot.turnRight()
        for i=0, moves-1 do robot.forward() end
        robot.turnRight()
        for i=0, moves-2 do robot.forward() end
    end
    robot.turnRight()
    depositChest()
end

farm()