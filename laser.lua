rednet.open("left", 50)
laser = peripheral.wrap("right")
function begin()
    turtle.refuel()
    while true do
        id, msg = rednet.receive()
        if msg == "g" then
            laser.fire(-90, 0, 5)
            laser.fire(0, -90, 5)
            turtle.forward()
            laser.fire(0, -90, 5)
            turtle.forward()
            laser.fire(0, -90, 5)
            turtle.forward()
        else
            break
        end
    end
end
begin()