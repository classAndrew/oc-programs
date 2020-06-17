names = peripheral.getNames()
chests = {}
for i,v in ipairs(names) do 
    if v:sub(1, 9) == "minecraft" then
        table.insert(chests, peripheral.wrap(v))
    end
end
while true do
    turtle.select(2)
    chest[0].suck(1)
    turtle.select(5)
    chest[1].suck(1)
    turtle.craft()
    turtle.select(2)
    turtle.dropUp()
end